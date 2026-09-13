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

  /// Cuántos cambios esperan señal. La pantalla lo muestra.
  Stream<int> verPendientes() => _local.verPendientes();

  // ---------------------------------------------------------------- lecturas

  Stream<List<Junta>> verJuntas() {
    return _local.verJuntas().map((filas) => filas.map(_aJunta).toList());
  }

  Stream<Junta?> verJunta(String juntaId) {
    return _local.verJunta(juntaId).map((f) => f == null ? null : _aJunta(f));
  }

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

  Future<Participante> agregarParticipante({
    required String juntaId,
    required String nombre,
    String? telefono,
  }) async {
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

  Future<void> borrarParticipante(String participanteId) async {
    await (_local.delete(
      _local.participantesLocales,
    )..where((p) => p.id.equals(participanteId))).go();
    await _encolar('participantes', 'borrar', participanteId, {});
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

  Future<void> completarTurno(String turnoId) async {
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

    _sincronizarEnSegundoPlano();
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
