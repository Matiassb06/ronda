// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juntas.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// La base local vive tanto como la app: se abre una vez y no se cierra.

@ProviderFor(baseLocal)
final baseLocalProvider = BaseLocalProvider._();

/// La base local vive tanto como la app: se abre una vez y no se cierra.

final class BaseLocalProvider
    extends $FunctionalProvider<BaseLocal, BaseLocal, BaseLocal>
    with $Provider<BaseLocal> {
  /// La base local vive tanto como la app: se abre una vez y no se cierra.
  BaseLocalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'baseLocalProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$baseLocalHash();

  @$internal
  @override
  $ProviderElement<BaseLocal> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseLocal create(Ref ref) {
    return baseLocal(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseLocal value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseLocal>(value),
    );
  }
}

String _$baseLocalHash() => r'35b0b2898ced31994ece724f089646a78c06cf77';

@ProviderFor(fuenteRemota)
final fuenteRemotaProvider = FuenteRemotaProvider._();

final class FuenteRemotaProvider
    extends $FunctionalProvider<FuenteRemota, FuenteRemota, FuenteRemota>
    with $Provider<FuenteRemota> {
  FuenteRemotaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fuenteRemotaProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fuenteRemotaHash();

  @$internal
  @override
  $ProviderElement<FuenteRemota> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FuenteRemota create(Ref ref) {
    return fuenteRemota(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FuenteRemota value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FuenteRemota>(value),
    );
  }
}

String _$fuenteRemotaHash() => r'ee62bd3991972f4e0a823378082e04d0dd420ada';

@ProviderFor(sincronizador)
final sincronizadorProvider = SincronizadorProvider._();

final class SincronizadorProvider
    extends $FunctionalProvider<Sincronizador, Sincronizador, Sincronizador>
    with $Provider<Sincronizador> {
  SincronizadorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sincronizadorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sincronizadorHash();

  @$internal
  @override
  $ProviderElement<Sincronizador> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Sincronizador create(Ref ref) {
    return sincronizador(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Sincronizador value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Sincronizador>(value),
    );
  }
}

String _$sincronizadorHash() => r'cbb2083c83ba44dda90fdde20f654267c737788b';

@ProviderFor(repositorioJuntas)
final repositorioJuntasProvider = RepositorioJuntasProvider._();

final class RepositorioJuntasProvider
    extends
        $FunctionalProvider<
          RepositorioJuntas,
          RepositorioJuntas,
          RepositorioJuntas
        >
    with $Provider<RepositorioJuntas> {
  RepositorioJuntasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'repositorioJuntasProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$repositorioJuntasHash();

  @$internal
  @override
  $ProviderElement<RepositorioJuntas> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RepositorioJuntas create(Ref ref) {
    return repositorioJuntas(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RepositorioJuntas value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RepositorioJuntas>(value),
    );
  }
}

String _$repositorioJuntasHash() => r'28c2413bf35f376515705a1a42d1b792ced4cf16';

/// Cuántos cambios esperan señal. Cero significa que todo está en Supabase.

@ProviderFor(cambiosPendientes)
final cambiosPendientesProvider = CambiosPendientesProvider._();

/// Cuántos cambios esperan señal. Cero significa que todo está en Supabase.

final class CambiosPendientesProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Cuántos cambios esperan señal. Cero significa que todo está en Supabase.
  CambiosPendientesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cambiosPendientesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cambiosPendientesHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return cambiosPendientes(ref);
  }
}

String _$cambiosPendientesHash() => r'f401daa0debe2fe2a646a51c50aad70f44e4e7ad';

/// Intenta sincronizar al arrancar y cada minuto.
///
/// No hay detección de conectividad en el stack a propósito: preguntar si hay
/// red y después usarla es una carrera perdida de antemano, porque la respuesta
/// puede cambiar entre la pregunta y la llamada. Se intenta y si falla, la cola
/// espera. Un minuto es suficiente para que, al salir del mercado a la calle,
/// lo marcado suba solo sin que nadie haga nada.

@ProviderFor(LatidoDeSync)
final latidoDeSyncProvider = LatidoDeSyncProvider._();

/// Intenta sincronizar al arrancar y cada minuto.
///
/// No hay detección de conectividad en el stack a propósito: preguntar si hay
/// red y después usarla es una carrera perdida de antemano, porque la respuesta
/// puede cambiar entre la pregunta y la llamada. Se intenta y si falla, la cola
/// espera. Un minuto es suficiente para que, al salir del mercado a la calle,
/// lo marcado suba solo sin que nadie haga nada.
final class LatidoDeSyncProvider extends $NotifierProvider<LatidoDeSync, void> {
  /// Intenta sincronizar al arrancar y cada minuto.
  ///
  /// No hay detección de conectividad en el stack a propósito: preguntar si hay
  /// red y después usarla es una carrera perdida de antemano, porque la respuesta
  /// puede cambiar entre la pregunta y la llamada. Se intenta y si falla, la cola
  /// espera. Un minuto es suficiente para que, al salir del mercado a la calle,
  /// lo marcado suba solo sin que nadie haga nada.
  LatidoDeSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latidoDeSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latidoDeSyncHash();

  @$internal
  @override
  LatidoDeSync create() => LatidoDeSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$latidoDeSyncHash() => r'da6c44f6711c17a14d7797e50fe5a556f2a4717c';

/// Intenta sincronizar al arrancar y cada minuto.
///
/// No hay detección de conectividad en el stack a propósito: preguntar si hay
/// red y después usarla es una carrera perdida de antemano, porque la respuesta
/// puede cambiar entre la pregunta y la llamada. Se intenta y si falla, la cola
/// espera. Un minuto es suficiente para que, al salir del mercado a la calle,
/// lo marcado suba solo sin que nadie haga nada.

abstract class _$LatidoDeSync extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(listaDeJuntas)
final listaDeJuntasProvider = ListaDeJuntasProvider._();

final class ListaDeJuntasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Junta>>,
          List<Junta>,
          Stream<List<Junta>>
        >
    with $FutureModifier<List<Junta>>, $StreamProvider<List<Junta>> {
  ListaDeJuntasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listaDeJuntasProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listaDeJuntasHash();

  @$internal
  @override
  $StreamProviderElement<List<Junta>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Junta>> create(Ref ref) {
    return listaDeJuntas(ref);
  }
}

String _$listaDeJuntasHash() => r'52b4ffd05ea327f91b19daf19a1f317a7431320e';

/// Cuándo termina cada junta. La lista lo muestra sin pedir los turnos de cada
/// una por separado.

@ProviderFor(finDeCadaJunta)
final finDeCadaJuntaProvider = FinDeCadaJuntaProvider._();

/// Cuándo termina cada junta. La lista lo muestra sin pedir los turnos de cada
/// una por separado.

final class FinDeCadaJuntaProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, DateTime>>,
          Map<String, DateTime>,
          Stream<Map<String, DateTime>>
        >
    with
        $FutureModifier<Map<String, DateTime>>,
        $StreamProvider<Map<String, DateTime>> {
  /// Cuándo termina cada junta. La lista lo muestra sin pedir los turnos de cada
  /// una por separado.
  FinDeCadaJuntaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'finDeCadaJuntaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$finDeCadaJuntaHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, DateTime>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, DateTime>> create(Ref ref) {
    return finDeCadaJunta(ref);
  }
}

String _$finDeCadaJuntaHash() => r'304859aff4d2e20f8b7a6b4d25ea2cddc33164a5';

@ProviderFor(junta)
final juntaProvider = JuntaFamily._();

final class JuntaProvider
    extends $FunctionalProvider<AsyncValue<Junta?>, Junta?, Stream<Junta?>>
    with $FutureModifier<Junta?>, $StreamProvider<Junta?> {
  JuntaProvider._({
    required JuntaFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'juntaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$juntaHash();

  @override
  String toString() {
    return r'juntaProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Junta?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Junta?> create(Ref ref) {
    final argument = this.argument as String;
    return junta(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is JuntaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$juntaHash() => r'8cc851c134d5d5709e21072914cf3b8a68ccf2c5';

final class JuntaFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Junta?>, String> {
  JuntaFamily._()
    : super(
        retry: null,
        name: r'juntaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  JuntaProvider call(String juntaId) =>
      JuntaProvider._(argument: juntaId, from: this);

  @override
  String toString() => r'juntaProvider';
}

@ProviderFor(participantesDeJunta)
final participantesDeJuntaProvider = ParticipantesDeJuntaFamily._();

final class ParticipantesDeJuntaProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Participante>>,
          List<Participante>,
          Stream<List<Participante>>
        >
    with
        $FutureModifier<List<Participante>>,
        $StreamProvider<List<Participante>> {
  ParticipantesDeJuntaProvider._({
    required ParticipantesDeJuntaFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'participantesDeJuntaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$participantesDeJuntaHash();

  @override
  String toString() {
    return r'participantesDeJuntaProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Participante>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Participante>> create(Ref ref) {
    final argument = this.argument as String;
    return participantesDeJunta(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ParticipantesDeJuntaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$participantesDeJuntaHash() =>
    r'3c2b4616bdfefb39f621cfdbe588ae4b29671f79';

final class ParticipantesDeJuntaFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Participante>>, String> {
  ParticipantesDeJuntaFamily._()
    : super(
        retry: null,
        name: r'participantesDeJuntaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ParticipantesDeJuntaProvider call(String juntaId) =>
      ParticipantesDeJuntaProvider._(argument: juntaId, from: this);

  @override
  String toString() => r'participantesDeJuntaProvider';
}

@ProviderFor(turnosDeJunta)
final turnosDeJuntaProvider = TurnosDeJuntaFamily._();

final class TurnosDeJuntaProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Turno>>,
          List<Turno>,
          Stream<List<Turno>>
        >
    with $FutureModifier<List<Turno>>, $StreamProvider<List<Turno>> {
  TurnosDeJuntaProvider._({
    required TurnosDeJuntaFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'turnosDeJuntaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$turnosDeJuntaHash();

  @override
  String toString() {
    return r'turnosDeJuntaProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Turno>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Turno>> create(Ref ref) {
    final argument = this.argument as String;
    return turnosDeJunta(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TurnosDeJuntaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$turnosDeJuntaHash() => r'a57acf296e496d4c92613c58def7bff2b65c386f';

final class TurnosDeJuntaFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Turno>>, String> {
  TurnosDeJuntaFamily._()
    : super(
        retry: null,
        name: r'turnosDeJuntaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TurnosDeJuntaProvider call(String juntaId) =>
      TurnosDeJuntaProvider._(argument: juntaId, from: this);

  @override
  String toString() => r'turnosDeJuntaProvider';
}

@ProviderFor(aportesDeJunta)
final aportesDeJuntaProvider = AportesDeJuntaFamily._();

final class AportesDeJuntaProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Aporte>>,
          List<Aporte>,
          Stream<List<Aporte>>
        >
    with $FutureModifier<List<Aporte>>, $StreamProvider<List<Aporte>> {
  AportesDeJuntaProvider._({
    required AportesDeJuntaFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'aportesDeJuntaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$aportesDeJuntaHash();

  @override
  String toString() {
    return r'aportesDeJuntaProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Aporte>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Aporte>> create(Ref ref) {
    final argument = this.argument as String;
    return aportesDeJunta(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AportesDeJuntaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$aportesDeJuntaHash() => r'5dce556fbd639a3b41aa35d23021bb9873116400';

final class AportesDeJuntaFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Aporte>>, String> {
  AportesDeJuntaFamily._()
    : super(
        retry: null,
        name: r'aportesDeJuntaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AportesDeJuntaProvider call(String juntaId) =>
      AportesDeJuntaProvider._(argument: juntaId, from: this);

  @override
  String toString() => r'aportesDeJuntaProvider';
}

/// Combina los cuatro streams locales en la vista del cuaderno.
///
/// Devuelve null mientras falte alguno. No es un provider asíncrono a propósito:
/// las cuatro fuentes son locales y emiten de inmediato, así que la pantalla no
/// tiene que mostrar un spinner por cada una.

@ProviderFor(cuaderno)
final cuadernoProvider = CuadernoFamily._();

/// Combina los cuatro streams locales en la vista del cuaderno.
///
/// Devuelve null mientras falte alguno. No es un provider asíncrono a propósito:
/// las cuatro fuentes son locales y emiten de inmediato, así que la pantalla no
/// tiene que mostrar un spinner por cada una.

final class CuadernoProvider
    extends
        $FunctionalProvider<
          CuadernoDelTurno?,
          CuadernoDelTurno?,
          CuadernoDelTurno?
        >
    with $Provider<CuadernoDelTurno?> {
  /// Combina los cuatro streams locales en la vista del cuaderno.
  ///
  /// Devuelve null mientras falte alguno. No es un provider asíncrono a propósito:
  /// las cuatro fuentes son locales y emiten de inmediato, así que la pantalla no
  /// tiene que mostrar un spinner por cada una.
  CuadernoProvider._({
    required CuadernoFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'cuadernoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cuadernoHash();

  @override
  String toString() {
    return r'cuadernoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<CuadernoDelTurno?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CuadernoDelTurno? create(Ref ref) {
    final argument = this.argument as String;
    return cuaderno(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CuadernoDelTurno? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CuadernoDelTurno?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CuadernoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cuadernoHash() => r'bc34527b7ad74d63568f13ee4481338cd4f494d6';

/// Combina los cuatro streams locales en la vista del cuaderno.
///
/// Devuelve null mientras falte alguno. No es un provider asíncrono a propósito:
/// las cuatro fuentes son locales y emiten de inmediato, así que la pantalla no
/// tiene que mostrar un spinner por cada una.

final class CuadernoFamily extends $Family
    with $FunctionalFamilyOverride<CuadernoDelTurno?, String> {
  CuadernoFamily._()
    : super(
        retry: null,
        name: r'cuadernoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Combina los cuatro streams locales en la vista del cuaderno.
  ///
  /// Devuelve null mientras falte alguno. No es un provider asíncrono a propósito:
  /// las cuatro fuentes son locales y emiten de inmediato, así que la pantalla no
  /// tiene que mostrar un spinner por cada una.

  CuadernoProvider call(String juntaId) =>
      CuadernoProvider._(argument: juntaId, from: this);

  @override
  String toString() => r'cuadernoProvider';
}

/// Pide el permiso de notificaciones una sola vez, al entrar por primera vez.
///
/// No se pide en el arranque a propósito: un cuadro de permiso antes de que la
/// persona haya visto nada de la app es un cuadro que se rechaza. Se pide
/// cuando ya está dentro y tiene contexto.

@ProviderFor(permisoDeAvisos)
final permisoDeAvisosProvider = PermisoDeAvisosProvider._();

/// Pide el permiso de notificaciones una sola vez, al entrar por primera vez.
///
/// No se pide en el arranque a propósito: un cuadro de permiso antes de que la
/// persona haya visto nada de la app es un cuadro que se rechaza. Se pide
/// cuando ya está dentro y tiene contexto.

final class PermisoDeAvisosProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Pide el permiso de notificaciones una sola vez, al entrar por primera vez.
  ///
  /// No se pide en el arranque a propósito: un cuadro de permiso antes de que la
  /// persona haya visto nada de la app es un cuadro que se rechaza. Se pide
  /// cuando ya está dentro y tiene contexto.
  PermisoDeAvisosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permisoDeAvisosProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permisoDeAvisosHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return permisoDeAvisos(ref);
  }
}

String _$permisoDeAvisosHash() => r'a9580496f597a4124aabc2375ed4701f7785ee95';
