import 'dart:convert';

import 'package:drift/drift.dart';

import '../core/ids.dart';
import '../features/aportes/domain/aporte.dart';
import '../features/juntas/domain/calendario_turnos.dart';
import '../features/juntas/domain/frecuencia.dart';
import '../features/juntas/domain/junta.dart';
import '../features/participantes/domain/participante.dart';
import 'local/base_local.dart';
import 'remoto/fuente_remota.dart';
import 'sincronizacion/sincronizador.dart';

/// La única puerta de datos de la app.
///
/// **Se lee siempre de la base local y se escribe siempre en la base local.**
/// Cada escritura deja además una fila en la cola de cambios y dispara una
/// sincronización que puede fallar sin que a nadie le importe: si no hay señal,
/// el cambio ya está guardado y se subirá después.
///
/// Eso es lo que permite que una cabeza de junta marque doce pagos parada en el
/// Mercado 10 con el dato caído, y que al salir a la calle se suba todo solo.
class RepositorioJuntas {
  RepositorioJuntas(this._local, this._remoto, this._sync);

  final BaseLocal _local;
  final FuenteRemota _remoto;
  final Sincronizador _sync;

  String get _usuarioId => _remoto.usuarioId ?? '';

  /// Sincroniza sin bloquear a quien llamó ni romper si falla.
  ///
  /// Se llama después de cada escritura. Sin señal simplemente no pasa nada:
  /// el cambio se queda en la cola, que es exactamente lo que se quiere.
  void _sincronizarEnSegundoPlano() {
    unawaited(_sync.sincronizar());
  }

  Future<ResultadoSync> sincronizarAhora() => _sync.sincronizar();

  /// Cierra las juntas que ya terminaron pero quedaron marcadas como activas.
  ///
  /// Hace falta porque arreglar `completarTurno` no arregla los datos que ya
  /// estaban mal: una junta completada antes de la corrección se quedaba
  /// "activa" para siempre, diciendo "En curso" en la lista y "ya terminó"
  /// dentro. Corre al arrancar y es idempotente.
  Future<int> repararJuntasTerminadas() async {
    final ahora = DateTime.now();
    var reparadas = 0;

    for (final fila in await _local.verJuntas().first) {
      if (fila.estado == EstadoJunta.cerrada.valorEnBase) continue;

      final turnos = await _local.leerTurnos(fila.id);
      if (turnos.isEmpty) continue;
      if (turnos.any((t) => t.estado != 'completado')) continue;

      await _cambiarEstadoDeJunta(fila.id, EstadoJunta.cerrada, ahora);
      reparadas++;
    }

    if (reparadas > 0) _sincronizarEnSegundoPlano();
    return reparadas;
  }

  /// Cuántos cambios esperan señal. La pantalla lo muestra.
  Stream<int> verPendientes() => _local.verPendientes();

  // ---------------------------------------------------------------- lecturas

  Stream<List<Junta>> verJuntas() {
    return _local.verJuntas().map((filas) => filas.map(_aJunta).toList());
  }

  Stream<Junta?> verJunta(String juntaId) {
    return _local.verJunta(juntaId).map((f) => f == null ? null : _aJunta(f));
  }

  /// Cuándo termina cada junta, indexado por id.
  Stream<Map<String, DateTime>> verFinDeCadaJunta() =>
      _local.verFinDeCadaJunta();

  Stream<List<Participante>> verParticipantes(String juntaId) {
    return _local
        .verParticipantes(juntaId)
        .map((filas) => filas.map(_aParticipante).toList());
  }

  Stream<List<Turno>> verTurnos(String juntaId) {
    return _local
        .verTurnos(juntaId)
        .map((filas) => filas.map(_aTurno).toList());
  }

  Stream<List<Aporte>> verAportes(String juntaId) {
    return _local
        .verAportesDeJunta(juntaId)
        .map((filas) => filas.map(_aAporte).toList());
  }

  // --------------------------------------------------------------- escrituras

  Future<Junta> crearJunta({
    required String nombre,
    required int montoAporteCentavos,
    required Frecuencia frecuencia,
    required DateTime fechaInicio,
  }) async {
    final ahora = DateTime.now();
    // El id y el código se generan aquí, no en Postgres: sin eso no se podría
    // crear una junta sin señal. Ver la decisión D19.
    final junta = Junta(
      id: Ids.uuid(),
      cabezaId: _usuarioId,
      nombre: nombre.trim(),
      codigo: Ids.codigoDeJunta(),
      montoAporteCentavos: montoAporteCentavos,
      frecuencia: frecuencia,
      fechaInicio: CalculoDeFechas.soloFecha(fechaInicio),
      estado: EstadoJunta.borrador,
    );

    await _local
        .into(_local.juntasLocales)
        .insert(
          JuntasLocalesCompanion.insert(
            id: junta.id,
            cabezaId: junta.cabezaId,
            nombre: junta.nombre,
            codigo: junta.codigo,
            montoAporteCentavos: junta.montoAporteCentavos,
            frecuencia: junta.frecuencia.valorEnBase,
            fechaInicio: junta.fechaInicio,
            estado: junta.estado.valorEnBase,
            actualizadoEn: ahora,
          ),
        );

    await _encolar('juntas', 'insertar', junta.id, {
      'id': junta.id,
      'cabeza_id': junta.cabezaId,
      'nombre': junta.nombre,
      'codigo': junta.codigo,
      'monto_aporte_centavos': junta.montoAporteCentavos,
      'frecuencia': junta.frecuencia.valorEnBase,
      'fecha_inicio': Junta.comoFechaCivil(junta.fechaInicio),
      'estado': junta.estado.valorEnBase,
    });

    _sincronizarEnSegundoPlano();
    return junta;
  }

  /// Borra una junta con todo lo suyo.
  ///
  /// En Postgres las claves foráneas de participantes, turnos y aportes son
  /// ON DELETE CASCADE, así que basta con borrar la junta. En SQLite no hay
  /// claves declaradas, así que aquí el cascade se hace a mano.
  Future<void> borrarJunta(String juntaId) async {
    await _local.transaction(() async {
      await (_local.delete(
        _local.aportesLocales,
      )..where((a) => a.juntaId.equals(juntaId))).go();
      await (_local.delete(
        _local.turnosLocales,
      )..where((t) => t.juntaId.equals(juntaId))).go();
      await (_local.delete(
        _local.participantesLocales,
      )..where((p) => p.juntaId.equals(juntaId))).go();
      await (_local.delete(
        _local.juntasLocales,
      )..where((j) => j.id.equals(juntaId))).go();
    });

    await _encolar('juntas', 'borrar', juntaId, {});
    _sincronizarEnSegundoPlano();
  }

  /// Corrige el nombre o el monto de una junta.
  ///
  /// El monto solo se puede cambiar mientras la junta no tenga calendario: una
  /// vez generado, los aportes ya llevan su monto y cambiarlo dejaría la cuenta
  /// del pozo distinta de la suma de lo que cada una tiene que poner.
  Future<void> editarJunta({
    required String juntaId,
    required String nombre,
    int? montoAporteCentavos,
  }) async {
    final ahora = DateTime.now();
    final puedeCambiarMonto = !await tieneCalendario(juntaId);

    await (_local.update(
      _local.juntasLocales,
    )..where((j) => j.id.equals(juntaId))).write(
      JuntasLocalesCompanion(
        nombre: Value(nombre.trim()),
        montoAporteCentavos: puedeCambiarMonto && montoAporteCentavos != null
            ? Value(montoAporteCentavos)
            : const Value.absent(),
        actualizadoEn: Value(ahora),
      ),
    );

    await _encolar('juntas', 'actualizar', juntaId, {
      'nombre': nombre.trim(),
      if (puedeCambiarMonto && montoAporteCentavos != null)
        'monto_aporte_centavos': montoAporteCentavos,
    });

    _sincronizarEnSegundoPlano();
  }

  /// Una junta con calendario ya no admite cambios en su lista de gente.
  Future<bool> tieneCalendario(String juntaId) async {
    return (await _local.leerTurnos(juntaId)).isNotEmpty;
  }

  Future<Participante> agregarParticipante({
    required String juntaId,
    required String nombre,
    String? telefono,
  }) async {
    // Una participante agregada después del calendario no tendría turno ni
    // aportes: no aparecería en el cuaderno y nadie se enteraría de por qué.
    if (await tieneCalendario(juntaId)) {
      throw const JuntaYaEmpezada();
    }

    final existentes = await _local.leerParticipantes(juntaId);
    final orden = existentes.isEmpty
        ? 1
        : existentes.map((p) => p.ordenTurno).reduce((a, b) => a > b ? a : b) +
              1;

    final limpio = telefono?.replaceAll(RegExp(r'\D'), '');
    final participante = Participante(
      id: Ids.uuid(),
      juntaId: juntaId,
      nombre: nombre.trim(),
      telefono: (limpio == null || limpio.isEmpty) ? null : limpio,
      ordenTurno: orden,
      activo: true,
    );

    await _local
        .into(_local.participantesLocales)
        .insert(
          ParticipantesLocalesCompanion.insert(
            id: participante.id,
            juntaId: juntaId,
            nombre: participante.nombre,
            telefono: Value(participante.telefono),
            ordenTurno: orden,
            actualizadoEn: DateTime.now(),
          ),
        );

    await _encolar('participantes', 'insertar', participante.id, {
      'id': participante.id,
      'junta_id': juntaId,
      'nombre': participante.nombre,
      'orden_turno': orden,
      if (participante.telefono != null) 'telefono': participante.telefono,
    });

    _sincronizarEnSegundoPlano();
    return participante;
  }

  /// Quita a una participante, solo mientras la junta no haya empezado.
  ///
  /// Con el calendario generado esto rompería la sincronización sin avisar: en
  /// Postgres las claves de turnos y aportes son ON DELETE RESTRICT, así que el
  /// servidor rechazaría el borrado, la cola lo reintentaría cinco veces y
  /// acabaría descartándolo. Local y remoto quedarían distintos para siempre, y
  /// nadie se enteraría hasta contar el dinero.
  Future<void> borrarParticipante({
    required String participanteId,
    required String juntaId,
  }) async {
    if (await tieneCalendario(juntaId)) {
      throw const JuntaYaEmpezada();
    }

    await (_local.delete(
      _local.participantesLocales,
    )..where((p) => p.id.equals(participanteId))).go();
    await _encolar('participantes', 'borrar', participanteId, {});
    _sincronizarEnSegundoPlano();
  }

  /// Corrige el nombre o el teléfono de una participante.
  ///
  /// Esto sí se puede con la junta empezada: un número mal escrito se descubre
  /// justo cuando hace falta mandarle el recordatorio, y sería absurdo obligar
  /// a rehacer la junta entera por un dígito.
  Future<void> editarParticipante({
    required String participanteId,
    required String nombre,
    String? telefono,
  }) async {
    final limpio = telefono?.replaceAll(RegExp(r'\D'), '');
    final valor = (limpio == null || limpio.isEmpty) ? null : limpio;

    await (_local.update(
      _local.participantesLocales,
    )..where((p) => p.id.equals(participanteId))).write(
      ParticipantesLocalesCompanion(
        nombre: Value(nombre.trim()),
        telefono: Value(valor),
        actualizadoEn: Value(DateTime.now()),
      ),
    );

    await _encolar('participantes', 'actualizar', participanteId, {
      'nombre': nombre.trim(),
      'telefono': valor,
    });

    _sincronizarEnSegundoPlano();
  }

  /// Reescribe el orden de toda la lista.
  ///
  /// En Postgres la restricción `(junta_id, orden_turno)` es DEFERRABLE, así que
  /// los números pueden chocar a mitad de la transacción. En SQLite no hay tal
  /// restricción, así que local se puede actualizar de frente.
  Future<void> reordenarParticipantes(List<Participante> enNuevoOrden) async {
    final ahora = DateTime.now();

    await _local.transaction(() async {
      for (var i = 0; i < enNuevoOrden.length; i++) {
        await (_local.update(
          _local.participantesLocales,
        )..where((p) => p.id.equals(enNuevoOrden[i].id))).write(
          ParticipantesLocalesCompanion(
            ordenTurno: Value(i + 1),
            actualizadoEn: Value(ahora),
          ),
        );
      }
    });

    for (var i = 0; i < enNuevoOrden.length; i++) {
      await _encolar('participantes', 'actualizar', enNuevoOrden[i].id, {
        'orden_turno': i + 1,
      });
    }

    _sincronizarEnSegundoPlano();
  }

  /// Genera turnos y aportes, y deja la junta activa.
  ///
  /// Se guarda entero en local de una vez y se encola como dos inserciones
  /// múltiples, no como doscientas filas sueltas: para doce participantes son
  /// 12 turnos y 144 aportes, y una cola con 156 entradas tardaría una eternidad
  /// en vaciarse fila por fila.
  Future<void> generarCalendario(String juntaId) async {
    final filaJunta = await _local.leerJunta(juntaId);
    if (filaJunta == null) throw StateError('Esa junta no está en el teléfono');
    final junta = _aJunta(filaJunta);

    final participantes = await _local.leerParticipantes(juntaId);
    if (participantes.isEmpty) {
      throw StateError('No se puede generar el calendario sin participantes');
    }
    if ((await _local.leerTurnos(juntaId)).isNotEmpty) {
      throw StateError('Esta junta ya tiene calendario');
    }

    final planificados = CalendarioTurnos.generar(
      participantesIdsEnOrden: participantes.map((p) => p.id).toList(),
      frecuencia: junta.frecuencia,
      fechaInicio: junta.fechaInicio,
    );

    final ahora = DateTime.now();
    final turnos = <Map<String, dynamic>>[];
    final aportes = <Map<String, dynamic>>[];

    for (final t in planificados) {
      final turnoId = Ids.uuid();
      turnos.add({
        'id': turnoId,
        'junta_id': juntaId,
        'participante_id': t.participanteId,
        'numero': t.numero,
        'fecha_programada': Junta.comoFechaCivil(t.fechaProgramada),
        'estado': 'pendiente',
      });
      for (final p in participantes) {
        aportes.add({
          'id': Ids.uuid(),
          'junta_id': juntaId,
          'turno_id': turnoId,
          'participante_id': p.id,
          'monto_centavos': junta.montoAporteCentavos,
          'estado': 'pendiente',
        });
      }
    }

    await _local.transaction(() async {
      await _local.batch((b) {
        b.insertAll(_local.turnosLocales, [
          for (var i = 0; i < turnos.length; i++)
            TurnosLocalesCompanion.insert(
              id: turnos[i]['id'] as String,
              juntaId: juntaId,
              participanteId: turnos[i]['participante_id'] as String,
              numero: turnos[i]['numero'] as int,
              fechaProgramada: planificados[i].fechaProgramada,
              estado: 'pendiente',
              actualizadoEn: ahora,
            ),
        ]);
        b.insertAll(_local.aportesLocales, [
          for (final a in aportes)
            AportesLocalesCompanion.insert(
              id: a['id'] as String,
              juntaId: juntaId,
              turnoId: a['turno_id'] as String,
              participanteId: a['participante_id'] as String,
              montoCentavos: a['monto_centavos'] as int,
              estado: 'pendiente',
              actualizadoEn: ahora,
            ),
        ]);
      });

      await (_local.update(
        _local.juntasLocales,
      )..where((j) => j.id.equals(juntaId))).write(
        JuntasLocalesCompanion(
          estado: const Value('activa'),
          actualizadoEn: Value(ahora),
        ),
      );
    });

    await _encolar('turnos', 'insertar_varias', juntaId, {'filas': turnos});
    await _encolar('aportes', 'insertar_varias', juntaId, {'filas': aportes});
    await _encolar('juntas', 'actualizar', juntaId, {'estado': 'activa'});

    _sincronizarEnSegundoPlano();
  }

  /// Marcar un pago. Es la acción más usada de la app y tiene que ser instantánea.
  ///
  /// Se escribe en local y la pantalla se entera por el stream de Drift antes de
  /// que la red se entere de nada. Con o sin señal, el check se pinta igual de
  /// rápido.
  Future<void> marcarAporte({
    required String aporteId,
    required bool pagado,
  }) async {
    final ahora = DateTime.now();
    final pagadoEn = pagado ? ahora : null;

    await (_local.update(
      _local.aportesLocales,
    )..where((a) => a.id.equals(aporteId))).write(
      AportesLocalesCompanion(
        estado: Value(
          pagado
              ? EstadoAporte.pagado.valorEnBase
              : EstadoAporte.pendiente.valorEnBase,
        ),
        pagadoEn: Value(pagadoEn),
        actualizadoEn: Value(ahora),
      ),
    );

    await _encolar('aportes', 'actualizar', aporteId, {
      'estado': pagado
          ? EstadoAporte.pagado.valorEnBase
          : EstadoAporte.pendiente.valorEnBase,
      'pagado_en': pagadoEn?.toUtc().toIso8601String(),
    });

    _sincronizarEnSegundoPlano();
  }

  /// Marca un aporte como pagado con la foto del voucher.
  ///
  /// El monto y la fecha que llegan aquí son los que **ella confirmó**, no los
  /// que leyó el OCR. Lo que leyó el OCR se guarda aparte, en `ocr_*`, para
  /// poder comparar después qué tan bien funciona sin que eso toque nunca la
  /// cuenta real (regla 9 del CLAUDE.md).
  ///
  /// La foto se queda en el teléfono y el sincronizador la sube cuando haya
  /// señal. El pago cuenta desde ya.
  Future<void> registrarPagoConVoucher({
    required String aporteId,
    required int montoCentavos,
    required DateTime fechaDelPago,
    required String rutaLocalDeLaFoto,
    int? ocrMontoCentavos,
    DateTime? ocrFecha,
  }) async {
    final ahora = DateTime.now();

    await (_local.update(
      _local.aportesLocales,
    )..where((a) => a.id.equals(aporteId))).write(
      AportesLocalesCompanion(
        estado: Value(EstadoAporte.pagado.valorEnBase),
        montoCentavos: Value(montoCentavos),
        pagadoEn: Value(fechaDelPago),
        voucherLocal: Value(rutaLocalDeLaFoto),
        ocrMontoCentavos: Value(ocrMontoCentavos),
        ocrFecha: Value(ocrFecha),
        actualizadoEn: Value(ahora),
      ),
    );

    await _encolar('aportes', 'actualizar', aporteId, {
      'estado': EstadoAporte.pagado.valorEnBase,
      'monto_centavos': montoCentavos,
      'pagado_en': fechaDelPago.toUtc().toIso8601String(),
      'ocr_monto_centavos': ocrMontoCentavos,
      if (ocrFecha != null) 'ocr_fecha': Junta.comoFechaCivil(ocrFecha),
    });

    _sincronizarEnSegundoPlano();
  }

  /// Cierra el turno: la participante ya cobró el pozo.
  ///
  /// Si era el último, **la junta se cierra sola**. Antes no pasaba: la lista
  /// seguía diciendo "En curso" mientras el cuaderno decía "ya terminó", y la
  /// junta se quedaba activa para siempre.
  Future<void> completarTurno(String turnoId, {required String juntaId}) async {
    final ahora = DateTime.now();

    await (_local.update(
      _local.turnosLocales,
    )..where((t) => t.id.equals(turnoId))).write(
      TurnosLocalesCompanion(
        estado: const Value('completado'),
        actualizadoEn: Value(ahora),
      ),
    );

    await _encolar('turnos', 'actualizar', turnoId, {
      'estado': 'completado',
      'fecha_entregado': Junta.comoFechaCivil(ahora),
    });

    await _cerrarJuntaSiAcabaron(juntaId, ahora);
    _sincronizarEnSegundoPlano();
  }

  /// Devuelve un turno a pendiente, por si se tocó el botón sin querer.
  ///
  /// Entregar el pozo es irreversible en la vida real, pero tocar un botón no:
  /// sin esto, un dedo torpe adelanta la junta entera y no hay vuelta atrás.
  /// Si la junta estaba cerrada, se reabre.
  Future<void> deshacerTurno(String turnoId, {required String juntaId}) async {
    final ahora = DateTime.now();

    await (_local.update(
      _local.turnosLocales,
    )..where((t) => t.id.equals(turnoId))).write(
      TurnosLocalesCompanion(
        estado: const Value('pendiente'),
        actualizadoEn: Value(ahora),
      ),
    );

    await _encolar('turnos', 'actualizar', turnoId, {
      'estado': 'pendiente',
      'fecha_entregado': null,
    });

    await _cambiarEstadoDeJunta(juntaId, EstadoJunta.activa, ahora);
    _sincronizarEnSegundoPlano();
  }

  Future<void> _cerrarJuntaSiAcabaron(String juntaId, DateTime ahora) async {
    final turnos = await _local.leerTurnos(juntaId);
    if (turnos.isEmpty) return;
    if (turnos.any((t) => t.estado != 'completado')) return;

    await _cambiarEstadoDeJunta(juntaId, EstadoJunta.cerrada, ahora);
  }

  Future<void> _cambiarEstadoDeJunta(
    String juntaId,
    EstadoJunta estado,
    DateTime ahora,
  ) async {
    final actual = await _local.leerJunta(juntaId);
    if (actual == null || actual.estado == estado.valorEnBase) return;

    await (_local.update(
      _local.juntasLocales,
    )..where((j) => j.id.equals(juntaId))).write(
      JuntasLocalesCompanion(
        estado: Value(estado.valorEnBase),
        actualizadoEn: Value(ahora),
      ),
    );

    await _encolar('juntas', 'actualizar', juntaId, {
      'estado': estado.valorEnBase,
    });
  }

  /// Al cerrar sesión se borra el espejo local: el teléfono puede pasar a otra
  /// persona y estos son datos de plata ajena.
  Future<void> olvidarTodo() => _local.vaciar();

  // ---------------------------------------------------------------- interno

  Future<void> _encolar(
    String tabla,
    String operacion,
    String filaId,
    Map<String, dynamic> datos,
  ) {
    return _local.encolar(
      tabla: tabla,
      filaId: filaId,
      operacion: operacion,
      datos: jsonEncode(datos),
    );
  }

  static Junta _aJunta(JuntasLocale f) => Junta(
    id: f.id,
    cabezaId: f.cabezaId,
    nombre: f.nombre,
    codigo: f.codigo,
    montoAporteCentavos: f.montoAporteCentavos,
    frecuencia: Frecuencia.desdeBase(f.frecuencia),
    fechaInicio: f.fechaInicio,
    estado: EstadoJunta.desdeBase(f.estado),
  );

  static Participante _aParticipante(ParticipantesLocale f) => Participante(
    id: f.id,
    juntaId: f.juntaId,
    nombre: f.nombre,
    telefono: f.telefono,
    ordenTurno: f.ordenTurno,
    activo: f.activo,
  );

  static Turno _aTurno(TurnosLocale f) => Turno(
    id: f.id,
    juntaId: f.juntaId,
    participanteId: f.participanteId,
    numero: f.numero,
    fechaProgramada: f.fechaProgramada,
    completado: f.estado == 'completado',
  );

  static Aporte _aAporte(AportesLocale f) => Aporte(
    id: f.id,
    juntaId: f.juntaId,
    turnoId: f.turnoId,
    participanteId: f.participanteId,
    montoCentavos: f.montoCentavos,
    estado: EstadoAporte.desdeBase(f.estado),
    pagadoEn: f.pagadoEn,
    voucherPath: f.voucherPath,
  );
}

/// `unawaited` sin importar `dart:async` entero solo para esto.
void unawaited(Future<void> futuro) {
  futuro.catchError((_) {});
}

/// Se intentó cambiar la lista de participantes de una junta que ya empezó.
///
/// No es un error técnico sino una regla del producto: una vez repartidos los
/// turnos, agregar o quitar gente cambia a quién le toca cobrar y cuánto pone
/// cada una. Eso se conversa entre las participantes, no se resuelve con un
/// botón.
class JuntaYaEmpezada implements Exception {
  const JuntaYaEmpezada();

  @override
  String toString() => 'La junta ya tiene calendario de turnos';
}
