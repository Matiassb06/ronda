import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/aportes/domain/aporte.dart';
import '../../features/juntas/domain/calendario_turnos.dart';
import '../../features/juntas/domain/frecuencia.dart';
import '../../features/juntas/domain/junta.dart';
import '../../features/participantes/domain/participante.dart';

/// Todo el acceso a Postgres vive aquí.
///
/// Ninguna pantalla habla con Supabase directamente. El RLS ya garantiza que
/// solo se ve lo propio, así que las consultas no filtran por `cabeza_id`: si
/// alguna vez el filtro faltara, la base sigue devolviendo vacío en vez de
/// datos ajenos. El cinturón está en la base; esto es solo el tirante.
class RepositorioJuntas {
  const RepositorioJuntas(this._cliente);

  final SupabaseClient _cliente;

  String get _usuarioId {
    final id = _cliente.auth.currentUser?.id;
    if (id == null) throw StateError('No hay sesión abierta');
    return id;
  }

  // ---------------------------------------------------------------- juntas

  Future<List<Junta>> listarJuntas() async {
    final filas = await _cliente
        .from('juntas')
        .select()
        .order('creado_en', ascending: false);
    return filas.map(Junta.desdeMapa).toList();
  }

  Future<Junta> obtenerJunta(String juntaId) async {
    final fila = await _cliente
        .from('juntas')
        .select()
        .eq('id', juntaId)
        .single();
    return Junta.desdeMapa(fila);
  }

  Future<Junta> crearJunta({
    required String nombre,
    required int montoAporteCentavos,
    required Frecuencia frecuencia,
    required DateTime fechaInicio,
  }) async {
    final fila = await _cliente
        .from('juntas')
        .insert(
          Junta.paraCrear(
            cabezaId: _usuarioId,
            nombre: nombre,
            montoAporteCentavos: montoAporteCentavos,
            frecuencia: frecuencia,
            fechaInicio: fechaInicio,
          ),
        )
        .select()
        .single();
    return Junta.desdeMapa(fila);
  }

  Future<void> borrarJunta(String juntaId) async {
    await _cliente.from('juntas').delete().eq('id', juntaId);
  }

  // --------------------------------------------------------- participantes

  Future<List<Participante>> listarParticipantes(String juntaId) async {
    final filas = await _cliente
        .from('participantes')
        .select()
        .eq('junta_id', juntaId)
        .order('orden_turno');
    return filas.map(Participante.desdeMapa).toList();
  }

  Future<Participante> agregarParticipante({
    required String juntaId,
    required String nombre,
    String? telefono,
  }) async {
    final existentes = await listarParticipantes(juntaId);
    final siguienteOrden = existentes.isEmpty
        ? 1
        : existentes.map((p) => p.ordenTurno).reduce((a, b) => a > b ? a : b) +
              1;

    final fila = await _cliente
        .from('participantes')
        .insert(
          Participante.paraCrear(
            juntaId: juntaId,
            nombre: nombre,
            telefono: telefono,
            ordenTurno: siguienteOrden,
          ),
        )
        .select()
        .single();
    return Participante.desdeMapa(fila);
  }

  Future<void> borrarParticipante(String participanteId) async {
    await _cliente.from('participantes').delete().eq('id', participanteId);
  }

  /// Reescribe el orden de toda la lista.
  ///
  /// La restricción `(junta_id, orden_turno)` es única y DEFERRABLE justamente
  /// para esto: dentro de una transacción los números pueden chocar a mitad de
  /// camino y solo se verifican al final. Sin eso, mover a alguien del puesto 3
  /// al 1 fallaría en el primer UPDATE.
  Future<void> reordenarParticipantes(List<Participante> enNuevoOrden) async {
    final filas = <Map<String, dynamic>>[];
    for (var i = 0; i < enNuevoOrden.length; i++) {
      final p = enNuevoOrden[i];
      filas.add({
        'id': p.id,
        'junta_id': p.juntaId,
        'nombre': p.nombre,
        'telefono': p.telefono,
        'orden_turno': i + 1,
      });
    }
    await _cliente.from('participantes').upsert(filas);
  }

  // ----------------------------------------------------- turnos y aportes

  Future<List<Turno>> listarTurnos(String juntaId) async {
    final filas = await _cliente
        .from('turnos')
        .select()
        .eq('junta_id', juntaId)
        .order('numero');
    return filas.map(Turno.desdeMapa).toList();
  }

  /// El turno en curso: el primero sin completar. Null si ya terminaron todos.
  Future<Turno?> turnoActual(String juntaId) async {
    final turnos = await listarTurnos(juntaId);
    for (final t in turnos) {
      if (!t.completado) return t;
    }
    return null;
  }

  Future<List<Aporte>> aportesDeTurno(String turnoId) async {
    final filas = await _cliente
        .from('aportes')
        .select()
        .eq('turno_id', turnoId);
    return filas.map(Aporte.desdeMapa).toList();
  }

  /// Crea el calendario completo y deja la junta activa.
  ///
  /// Genera un turno por participante y, en cada turno, un aporte por cada
  /// participante: todas ponen en cada vuelta, incluida la que cobra. Para doce
  /// personas son 12 turnos y 144 aportes, que se insertan en dos llamadas.
  Future<void> generarCalendario(String juntaId) async {
    final junta = await obtenerJunta(juntaId);
    final participantes = await listarParticipantes(juntaId);

    if (participantes.isEmpty) {
      throw StateError('No se puede generar el calendario sin participantes');
    }

    final yaHabia = await listarTurnos(juntaId);
    if (yaHabia.isNotEmpty) {
      throw StateError('Esta junta ya tiene calendario');
    }

    final planificados = CalendarioTurnos.generar(
      participantesIdsEnOrden: participantes.map((p) => p.id).toList(),
      frecuencia: junta.frecuencia,
      fechaInicio: junta.fechaInicio,
    );

    final turnosCreados = await _cliente.from('turnos').insert([
      for (final t in planificados)
        {
          'junta_id': juntaId,
          'participante_id': t.participanteId,
          'numero': t.numero,
          'fecha_programada': Junta.comoFechaCivil(t.fechaProgramada),
        },
    ]).select();

    await _cliente.from('aportes').insert([
      for (final turno in turnosCreados)
        for (final p in participantes)
          {
            'junta_id': juntaId,
            'turno_id': turno['id'],
            'participante_id': p.id,
            'monto_centavos': junta.montoAporteCentavos,
          },
    ]);

    await _cliente
        .from('juntas')
        .update({'estado': 'activa'})
        .eq('id', juntaId);
  }

  /// Marca un aporte como pagado o lo devuelve a pendiente.
  ///
  /// `pagado_en` acompaña al estado porque el CHECK del esquema exige que los
  /// dos vayan juntos: no existe un aporte pagado sin fecha ni una fecha sin
  /// pago.
  Future<void> marcarAporte({
    required String aporteId,
    required bool pagado,
  }) async {
    await _cliente
        .from('aportes')
        .update({
          'estado': pagado
              ? EstadoAporte.pagado.valorEnBase
              : EstadoAporte.pendiente.valorEnBase,
          'pagado_en': pagado ? DateTime.now().toUtc().toIso8601String() : null,
        })
        .eq('id', aporteId);
  }

  /// Cierra el turno: la participante ya cobró el pozo.
  Future<void> completarTurno(String turnoId) async {
    await _cliente
        .from('turnos')
        .update({
          'estado': 'completado',
          'fecha_entregado': Junta.comoFechaCivil(DateTime.now()),
        })
        .eq('id', turnoId);
  }
}
