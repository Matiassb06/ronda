import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/supabase/repositorio_juntas.dart';
import '../../aportes/domain/aporte.dart';
import '../../auth/application/sesion.dart';
import '../../participantes/domain/participante.dart';
import '../domain/junta.dart';

part 'juntas.g.dart';

@riverpod
RepositorioJuntas repositorioJuntas(Ref ref) =>
    RepositorioJuntas(ref.watch(clienteSupabaseProvider));

/// Las juntas de la cabeza de junta que tiene la sesión abierta.
@riverpod
Future<List<Junta>> listaDeJuntas(Ref ref) {
  return ref.watch(repositorioJuntasProvider).listarJuntas();
}

@riverpod
Future<Junta> junta(Ref ref, String juntaId) {
  return ref.watch(repositorioJuntasProvider).obtenerJunta(juntaId);
}

@riverpod
Future<List<Participante>> participantesDeJunta(Ref ref, String juntaId) {
  return ref.watch(repositorioJuntasProvider).listarParticipantes(juntaId);
}

@riverpod
Future<List<Turno>> turnosDeJunta(Ref ref, String juntaId) {
  return ref.watch(repositorioJuntasProvider).listarTurnos(juntaId);
}

/// Todo lo que la pantalla del cuaderno necesita, en una sola pasada.
///
/// Se agrupa a propósito: pedir junta, participantes, turno y aportes por
/// separado dejaría la pantalla parpadeando en cuatro tiempos distintos con la
/// señal del mercado.
class CuadernoDelTurno {
  const CuadernoDelTurno({
    required this.junta,
    required this.participantes,
    required this.turnos,
    required this.turnoActual,
    required this.aportes,
  });

  final Junta junta;
  final List<Participante> participantes;
  final List<Turno> turnos;

  /// Null cuando ya se completaron todos los turnos.
  final Turno? turnoActual;

  /// Aportes del turno actual, indexados por participante.
  final Map<String, Aporte> aportes;

  bool get tieneCalendario => turnos.isNotEmpty;
  bool get termino => tieneCalendario && turnoActual == null;

  Participante? get quienCobra {
    final turno = turnoActual;
    if (turno == null) return null;
    for (final p in participantes) {
      if (p.id == turno.participanteId) return p;
    }
    return null;
  }

  ResumenDeTurno get resumen {
    final turno = turnoActual;
    return ResumenDeTurno.calcular(
      aportes: aportes.values.toList(),
      montoAporteCentavos: junta.montoAporteCentavos,
      fechaProgramada: turno?.fechaProgramada ?? DateTime.now(),
      hoy: DateTime.now(),
    );
  }
}

@riverpod
Future<CuadernoDelTurno> cuaderno(Ref ref, String juntaId) async {
  final repo = ref.watch(repositorioJuntasProvider);

  final junta = await repo.obtenerJunta(juntaId);
  final participantes = await repo.listarParticipantes(juntaId);
  final turnos = await repo.listarTurnos(juntaId);

  Turno? actual;
  for (final t in turnos) {
    if (!t.completado) {
      actual = t;
      break;
    }
  }

  final aportes = <String, Aporte>{};
  if (actual != null) {
    for (final a in await repo.aportesDeTurno(actual.id)) {
      aportes[a.participanteId] = a;
    }
  }

  return CuadernoDelTurno(
    junta: junta,
    participantes: participantes,
    turnos: turnos,
    turnoActual: actual,
    aportes: aportes,
  );
}
