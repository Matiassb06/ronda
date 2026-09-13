import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/avisos/avisos.dart';
import '../../../data/local/base_local.dart';
import '../../../data/remoto/fuente_remota.dart';
import '../../../data/repositorio_juntas.dart';
import '../../../data/sincronizacion/sincronizador.dart';
import '../../aportes/domain/aporte.dart';
import '../../auth/application/sesion.dart';
import '../../participantes/domain/participante.dart';
import '../domain/junta.dart';

part 'juntas.g.dart';

/// La base local vive tanto como la app: se abre una vez y no se cierra.
@Riverpod(keepAlive: true)
BaseLocal baseLocal(Ref ref) {
  final base = BaseLocal();
  ref.onDispose(base.close);
  return base;
}

@Riverpod(keepAlive: true)
FuenteRemota fuenteRemota(Ref ref) =>
    FuenteRemotaSupabase(ref.watch(clienteSupabaseProvider));

@Riverpod(keepAlive: true)
Sincronizador sincronizador(Ref ref) => Sincronizador(
  ref.watch(baseLocalProvider),
  ref.watch(fuenteRemotaProvider),
);

@Riverpod(keepAlive: true)
RepositorioJuntas repositorioJuntas(Ref ref) => RepositorioJuntas(
  ref.watch(baseLocalProvider),
  ref.watch(fuenteRemotaProvider),
  ref.watch(sincronizadorProvider),
);

/// Cuántos cambios esperan señal. Cero significa que todo está en Supabase.
@riverpod
Stream<int> cambiosPendientes(Ref ref) =>
    ref.watch(repositorioJuntasProvider).verPendientes();

/// Intenta sincronizar al arrancar y cada minuto.
///
/// No hay detección de conectividad en el stack a propósito: preguntar si hay
/// red y después usarla es una carrera perdida de antemano, porque la respuesta
/// puede cambiar entre la pregunta y la llamada. Se intenta y si falla, la cola
/// espera. Un minuto es suficiente para que, al salir del mercado a la calle,
/// lo marcado suba solo sin que nadie haga nada.
@Riverpod(keepAlive: true)
class LatidoDeSync extends _$LatidoDeSync {
  Timer? _reloj;

  @override
  void build() {
    final repo = ref.watch(repositorioJuntasProvider);

    // En este orden y no en paralelo. Lanzados a la vez, la descarga puede
    // llegar primero y pisar lo que la reparación acaba de escribir: se ve el
    // cambio pendiente en la nube y la pantalla sin cambiar. Ya pasó.
    unawaited(
      repo.repararJuntasTerminadas().then((_) => repo.sincronizarAhora()),
    );

    _reloj = Timer.periodic(
      const Duration(minutes: 1),
      (_) => unawaited(repo.sincronizarAhora()),
    );
    ref.onDispose(() => _reloj?.cancel());
  }
}

// Todas las lecturas salen de la base local, así que emiten al instante y sin
// red. La sincronización solo rellena esa base por detrás.

@riverpod
Stream<List<Junta>> listaDeJuntas(Ref ref) =>
    ref.watch(repositorioJuntasProvider).verJuntas();

/// Cuándo termina cada junta. La lista lo muestra sin pedir los turnos de cada
/// una por separado.
@riverpod
Stream<Map<String, DateTime>> finDeCadaJunta(Ref ref) =>
    ref.watch(repositorioJuntasProvider).verFinDeCadaJunta();

@riverpod
Stream<Junta?> junta(Ref ref, String juntaId) =>
    ref.watch(repositorioJuntasProvider).verJunta(juntaId);

@riverpod
Stream<List<Participante>> participantesDeJunta(Ref ref, String juntaId) =>
    ref.watch(repositorioJuntasProvider).verParticipantes(juntaId);

@riverpod
Stream<List<Turno>> turnosDeJunta(Ref ref, String juntaId) =>
    ref.watch(repositorioJuntasProvider).verTurnos(juntaId);

@riverpod
Stream<List<Aporte>> aportesDeJunta(Ref ref, String juntaId) =>
    ref.watch(repositorioJuntasProvider).verAportes(juntaId);

/// Todo lo que la pantalla del cuaderno necesita, ya combinado.
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

/// Combina los cuatro streams locales en la vista del cuaderno.
///
/// Devuelve null mientras falte alguno. No es un provider asíncrono a propósito:
/// las cuatro fuentes son locales y emiten de inmediato, así que la pantalla no
/// tiene que mostrar un spinner por cada una.
@riverpod
CuadernoDelTurno? cuaderno(Ref ref, String juntaId) {
  final junta = ref.watch(juntaProvider(juntaId)).value;
  final participantes = ref.watch(participantesDeJuntaProvider(juntaId)).value;
  final turnos = ref.watch(turnosDeJuntaProvider(juntaId)).value;
  final aportes = ref.watch(aportesDeJuntaProvider(juntaId)).value;

  if (junta == null ||
      participantes == null ||
      turnos == null ||
      aportes == null) {
    return null;
  }

  Turno? actual;
  for (final t in turnos) {
    if (!t.completado) {
      actual = t;
      break;
    }
  }

  final delTurno = <String, Aporte>{};
  if (actual != null) {
    for (final a in aportes) {
      if (a.turnoId == actual.id) delTurno[a.participanteId] = a;
    }
  }

  return CuadernoDelTurno(
    junta: junta,
    participantes: participantes,
    turnos: turnos,
    turnoActual: actual,
    aportes: delTurno,
  );
}

/// Pide el permiso de notificaciones una sola vez, al entrar por primera vez.
///
/// No se pide en el arranque a propósito: un cuadro de permiso antes de que la
/// persona haya visto nada de la app es un cuadro que se rechaza. Se pide
/// cuando ya está dentro y tiene contexto.
@Riverpod(keepAlive: true)
Future<bool> permisoDeAvisos(Ref ref) => Avisos.pedirPermiso();
