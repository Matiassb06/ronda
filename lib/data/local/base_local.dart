import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'base_local.g.dart';

/// Espejo local de las cinco tablas de Postgres.
///
/// La app lee SIEMPRE de aquí, nunca directo de Supabase. Esa es la regla que
/// hace que abra y funcione en un puesto de mercado sin señal: la red solo
/// sirve para rellenar esta base y para vaciar la cola de cambios.
///
/// Los nombres de columna son los mismos que en Postgres, en camelCase, para
/// que el mapeo sea obvio al leer las dos cosas seguidas.
class JuntasLocales extends Table {
  TextColumn get id => text()();
  TextColumn get cabezaId => text()();
  TextColumn get nombre => text()();
  TextColumn get codigo => text()();
  IntColumn get montoAporteCentavos => integer()();
  TextColumn get frecuencia => text()();
  DateTimeColumn get fechaInicio => dateTime()();
  TextColumn get estado => text()();
  DateTimeColumn get actualizadoEn => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class ParticipantesLocales extends Table {
  TextColumn get id => text()();
  TextColumn get juntaId => text()();
  TextColumn get nombre => text()();
  TextColumn get telefono => text().nullable()();
  IntColumn get ordenTurno => integer()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get actualizadoEn => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class TurnosLocales extends Table {
  TextColumn get id => text()();
  TextColumn get juntaId => text()();
  TextColumn get participanteId => text()();
  IntColumn get numero => integer()();
  DateTimeColumn get fechaProgramada => dateTime()();
  TextColumn get estado => text()();
  DateTimeColumn get actualizadoEn => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class AportesLocales extends Table {
  TextColumn get id => text()();
  TextColumn get juntaId => text()();
  TextColumn get turnoId => text()();
  TextColumn get participanteId => text()();
  IntColumn get montoCentavos => integer()();
  TextColumn get estado => text()();
  DateTimeColumn get pagadoEn => dateTime().nullable()();

  /// Ruta en el bucket de Supabase. Null hasta que la foto se sube.
  TextColumn get voucherPath => text().nullable()();

  /// Ruta del archivo en el teléfono, mientras espera señal para subir.
  ///
  /// La foto se toma en el mercado, donde no hay datos. Se guarda en el
  /// dispositivo y el sincronizador la sube después; hasta entonces el aporte
  /// ya está marcado como pagado, que es lo que importa.
  TextColumn get voucherLocal => text().nullable()();

  IntColumn get ocrMontoCentavos => integer().nullable()();
  DateTimeColumn get ocrFecha => dateTime().nullable()();

  DateTimeColumn get actualizadoEn => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// La cola de cambios que todavía no llegaron a Supabase.
///
/// Cada escritura de la app deja una fila aquí. El sincronizador las aplica en
/// orden de llegada y las borra al confirmarlas. Si no hay señal se quedan, y
/// la app sigue funcionando como si nada.
///
/// El orden importa: crear una junta tiene que llegar antes que sus
/// participantes, y ellos antes que los turnos. Por eso se procesan por `id`
/// ascendente y **se corta al primer error**, en vez de saltarse la fallida y
/// seguir.
class CambiosPendientes extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Nombre de la tabla en Postgres: juntas, participantes, turnos, aportes.
  TextColumn get tabla => text()();

  TextColumn get filaId => text()();

  /// `insertar`, `actualizar` o `borrar`.
  TextColumn get operacion => text()();

  /// El cuerpo que se manda, ya en JSON con los nombres de Postgres.
  TextColumn get datos => text()();

  DateTimeColumn get creadoEn => dateTime()();
  IntColumn get intentos => integer().withDefault(const Constant(0))();
  TextColumn get ultimoError => text().nullable()();
}

@DriftDatabase(
  tables: [
    JuntasLocales,
    ParticipantesLocales,
    TurnosLocales,
    AportesLocales,
    CambiosPendientes,
  ],
)
class BaseLocal extends _$BaseLocal {
  BaseLocal() : super(_abrir());

  /// Constructor para los tests: base en memoria, sin tocar el disco.
  BaseLocal.enMemoria() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, desde, hasta) async {
      // 1 -> 2: llega el voucher del paso 5. Se agregan columnas nuevas en vez
      // de recrear la tabla: en el teléfono de la cabeza de junta puede haber
      // pagos marcados que todavía no subieron, y borrarlos sería perderlos.
      if (desde < 2) {
        await m.addColumn(aportesLocales, aportesLocales.voucherLocal);
        await m.addColumn(aportesLocales, aportesLocales.ocrMontoCentavos);
        await m.addColumn(aportesLocales, aportesLocales.ocrFecha);
      }
    },
  );

  /// Aportes con la foto todavía en el teléfono, esperando señal para subir.
  Future<List<AportesLocale>> leerVoucheresPendientes() {
    return (select(
      aportesLocales,
    )..where((a) => a.voucherLocal.isNotNull() & a.voucherPath.isNull())).get();
  }

  // --------------------------------------------------------------- lecturas
  // Todas devuelven streams: cuando la cola escribe en local, la pantalla se
  // entera sola. No hace falta invalidar providers a mano ni esperar la red.

  Stream<List<JuntasLocale>> verJuntas() {
    return (select(
      juntasLocales,
    )..orderBy([(j) => OrderingTerm.desc(j.actualizadoEn)])).watch();
  }

  Stream<JuntasLocale?> verJunta(String juntaId) {
    return (select(
      juntasLocales,
    )..where((j) => j.id.equals(juntaId))).watchSingleOrNull();
  }

  Stream<List<ParticipantesLocale>> verParticipantes(String juntaId) {
    return (select(participantesLocales)
          ..where((p) => p.juntaId.equals(juntaId))
          ..orderBy([(p) => OrderingTerm.asc(p.ordenTurno)]))
        .watch();
  }

  Stream<List<TurnosLocale>> verTurnos(String juntaId) {
    return (select(turnosLocales)
          ..where((t) => t.juntaId.equals(juntaId))
          ..orderBy([(t) => OrderingTerm.asc(t.numero)]))
        .watch();
  }

  Stream<List<AportesLocale>> verAportesDeJunta(String juntaId) {
    return (select(
      aportesLocales,
    )..where((a) => a.juntaId.equals(juntaId))).watch();
  }

  Future<List<ParticipantesLocale>> leerParticipantes(String juntaId) {
    return (select(participantesLocales)
          ..where((p) => p.juntaId.equals(juntaId))
          ..orderBy([(p) => OrderingTerm.asc(p.ordenTurno)]))
        .get();
  }

  Future<JuntasLocale?> leerJunta(String juntaId) {
    return (select(
      juntasLocales,
    )..where((j) => j.id.equals(juntaId))).getSingleOrNull();
  }

  Future<List<TurnosLocale>> leerTurnos(String juntaId) {
    return (select(turnosLocales)
          ..where((t) => t.juntaId.equals(juntaId))
          ..orderBy([(t) => OrderingTerm.asc(t.numero)]))
        .get();
  }

  // ------------------------------------------------------------------- cola

  Stream<int> verPendientes() {
    final consulta = selectOnly(cambiosPendientes)
      ..addColumns([cambiosPendientes.id.count()]);
    return consulta
        .map((f) => f.read(cambiosPendientes.id.count()) ?? 0)
        .watchSingle();
  }

  Future<List<CambiosPendiente>> leerCola({int limite = 200}) {
    return (select(cambiosPendientes)
          ..orderBy([(c) => OrderingTerm.asc(c.id)])
          ..limit(limite))
        .get();
  }

  Future<void> encolar({
    required String tabla,
    required String filaId,
    required String operacion,
    required String datos,
  }) {
    return into(cambiosPendientes).insert(
      CambiosPendientesCompanion.insert(
        tabla: tabla,
        filaId: filaId,
        operacion: operacion,
        datos: datos,
        creadoEn: DateTime.now(),
      ),
    );
  }

  Future<void> anotarVoucherSubido(String aporteId, String rutaEnElBucket) {
    return (update(aportesLocales)..where((a) => a.id.equals(aporteId))).write(
      AportesLocalesCompanion(
        voucherPath: Value(rutaEnElBucket),
        voucherLocal: const Value(null),
      ),
    );
  }

  /// La foto ya no está en el teléfono: se deja de intentar subirla.
  Future<void> olvidarVoucherLocal(String aporteId) {
    return (update(aportesLocales)..where((a) => a.id.equals(aporteId))).write(
      const AportesLocalesCompanion(voucherLocal: Value(null)),
    );
  }

  Future<void> quitarDeLaCola(int id) {
    return (delete(cambiosPendientes)..where((c) => c.id.equals(id))).go();
  }

  Future<void> anotarFallo(int id, String error, int intentos) {
    return (update(cambiosPendientes)..where((c) => c.id.equals(id))).write(
      CambiosPendientesCompanion(
        intentos: Value(intentos + 1),
        ultimoError: Value(error),
      ),
    );
  }

  /// Borra todo lo local. Se usa al cerrar sesión: la base guarda datos de una
  /// persona y el teléfono puede pasar a otra.
  Future<void> vaciar() async {
    await transaction(() async {
      await delete(aportesLocales).go();
      await delete(turnosLocales).go();
      await delete(participantesLocales).go();
      await delete(juntasLocales).go();
      await delete(cambiosPendientes).go();
    });
  }
}

LazyDatabase _abrir() {
  return LazyDatabase(() async {
    final carpeta = await getApplicationDocumentsDirectory();
    final archivo = File('${carpeta.path}/ronda.sqlite');
    return NativeDatabase.createInBackground(archivo);
  });
}
