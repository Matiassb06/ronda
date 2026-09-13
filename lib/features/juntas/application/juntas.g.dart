// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juntas.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
        isAutoDispose: true,
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

String _$repositorioJuntasHash() => r'af5151292d68e1e5e66b9eae2e904e52b2ace099';

/// Las juntas de la cabeza de junta que tiene la sesión abierta.

@ProviderFor(listaDeJuntas)
final listaDeJuntasProvider = ListaDeJuntasProvider._();

/// Las juntas de la cabeza de junta que tiene la sesión abierta.

final class ListaDeJuntasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Junta>>,
          List<Junta>,
          FutureOr<List<Junta>>
        >
    with $FutureModifier<List<Junta>>, $FutureProvider<List<Junta>> {
  /// Las juntas de la cabeza de junta que tiene la sesión abierta.
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
  $FutureProviderElement<List<Junta>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Junta>> create(Ref ref) {
    return listaDeJuntas(ref);
  }
}

String _$listaDeJuntasHash() => r'0abf3656e70a0709baaa421638a41ce5483cb1b3';

@ProviderFor(junta)
final juntaProvider = JuntaFamily._();

final class JuntaProvider
    extends $FunctionalProvider<AsyncValue<Junta>, Junta, FutureOr<Junta>>
    with $FutureModifier<Junta>, $FutureProvider<Junta> {
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
  $FutureProviderElement<Junta> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Junta> create(Ref ref) {
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

String _$juntaHash() => r'd78962354b8bafc6c4e7bbe2f39782abaa816f39';

final class JuntaFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Junta>, String> {
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
          FutureOr<List<Participante>>
        >
    with
        $FutureModifier<List<Participante>>,
        $FutureProvider<List<Participante>> {
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
  $FutureProviderElement<List<Participante>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Participante>> create(Ref ref) {
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
    r'01ac1e23eea1c6fec7cf66f849ec4771cf7ad9b5';

final class ParticipantesDeJuntaFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Participante>>, String> {
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
          FutureOr<List<Turno>>
        >
    with $FutureModifier<List<Turno>>, $FutureProvider<List<Turno>> {
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
  $FutureProviderElement<List<Turno>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Turno>> create(Ref ref) {
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

String _$turnosDeJuntaHash() => r'e9bd5ce09e39695224b4b3c05e8d1f223f4fc593';

final class TurnosDeJuntaFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Turno>>, String> {
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

@ProviderFor(cuaderno)
final cuadernoProvider = CuadernoFamily._();

final class CuadernoProvider
    extends
        $FunctionalProvider<
          AsyncValue<CuadernoDelTurno>,
          CuadernoDelTurno,
          FutureOr<CuadernoDelTurno>
        >
    with $FutureModifier<CuadernoDelTurno>, $FutureProvider<CuadernoDelTurno> {
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
  $FutureProviderElement<CuadernoDelTurno> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CuadernoDelTurno> create(Ref ref) {
    final argument = this.argument as String;
    return cuaderno(ref, argument);
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

String _$cuadernoHash() => r'2b5b8872ceef93181ec74b8fff1921121d5ff71a';

final class CuadernoFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CuadernoDelTurno>, String> {
  CuadernoFamily._()
    : super(
        retry: null,
        name: r'cuadernoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CuadernoProvider call(String juntaId) =>
      CuadernoProvider._(argument: juntaId, from: this);

  @override
  String toString() => r'cuadernoProvider';
}
