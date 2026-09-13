// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sesion.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// El cliente, expuesto como provider para poder sustituirlo en los tests.

@ProviderFor(clienteSupabase)
final clienteSupabaseProvider = ClienteSupabaseProvider._();

/// El cliente, expuesto como provider para poder sustituirlo en los tests.

final class ClienteSupabaseProvider
    extends $FunctionalProvider<SupabaseClient, SupabaseClient, SupabaseClient>
    with $Provider<SupabaseClient> {
  /// El cliente, expuesto como provider para poder sustituirlo en los tests.
  ClienteSupabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clienteSupabaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clienteSupabaseHash();

  @$internal
  @override
  $ProviderElement<SupabaseClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SupabaseClient create(Ref ref) {
    return clienteSupabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseClient>(value),
    );
  }
}

String _$clienteSupabaseHash() => r'a4e5f458db222975f9383dd55d827266812e96bd';

/// Cambios de sesion que emite Supabase: entrar, salir, refrescar el token.

@ProviderFor(cambiosDeSesion)
final cambiosDeSesionProvider = CambiosDeSesionProvider._();

/// Cambios de sesion que emite Supabase: entrar, salir, refrescar el token.

final class CambiosDeSesionProvider
    extends
        $FunctionalProvider<AsyncValue<AuthState>, AuthState, Stream<AuthState>>
    with $FutureModifier<AuthState>, $StreamProvider<AuthState> {
  /// Cambios de sesion que emite Supabase: entrar, salir, refrescar el token.
  CambiosDeSesionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cambiosDeSesionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cambiosDeSesionHash();

  @$internal
  @override
  $StreamProviderElement<AuthState> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AuthState> create(Ref ref) {
    return cambiosDeSesion(ref);
  }
}

String _$cambiosDeSesionHash() => r'90b4a86c6b470a8fb696f68634f5c29de5c3af8c';

/// La sesion actual, o null si no hay nadie dentro.
///
/// Se escucha el stream para que el router reaccione, pero el valor se lee del
/// cliente: al arrancar, Supabase ya restauro la sesion guardada y el stream
/// todavia no emitio nada.

@ProviderFor(sesionActual)
final sesionActualProvider = SesionActualProvider._();

/// La sesion actual, o null si no hay nadie dentro.
///
/// Se escucha el stream para que el router reaccione, pero el valor se lee del
/// cliente: al arrancar, Supabase ya restauro la sesion guardada y el stream
/// todavia no emitio nada.

final class SesionActualProvider
    extends $FunctionalProvider<Session?, Session?, Session?>
    with $Provider<Session?> {
  /// La sesion actual, o null si no hay nadie dentro.
  ///
  /// Se escucha el stream para que el router reaccione, pero el valor se lee del
  /// cliente: al arrancar, Supabase ya restauro la sesion guardada y el stream
  /// todavia no emitio nada.
  SesionActualProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sesionActualProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sesionActualHash();

  @$internal
  @override
  $ProviderElement<Session?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Session? create(Ref ref) {
    return sesionActual(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Session? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Session?>(value),
    );
  }
}

String _$sesionActualHash() => r'c094ac1563728f25c7eb0829213edc6986b34e31';

/// Acciones de autenticacion.
///
/// El login abre el navegador (Chrome Custom Tab) y vuelve por deep link. No se
/// usa la hoja nativa de Google porque exigiria huellas SHA-1 distintas en
/// debug y en release; ver el CLAUDE.md.

@ProviderFor(AccionesDeSesion)
final accionesDeSesionProvider = AccionesDeSesionProvider._();

/// Acciones de autenticacion.
///
/// El login abre el navegador (Chrome Custom Tab) y vuelve por deep link. No se
/// usa la hoja nativa de Google porque exigiria huellas SHA-1 distintas en
/// debug y en release; ver el CLAUDE.md.
final class AccionesDeSesionProvider
    extends $NotifierProvider<AccionesDeSesion, void> {
  /// Acciones de autenticacion.
  ///
  /// El login abre el navegador (Chrome Custom Tab) y vuelve por deep link. No se
  /// usa la hoja nativa de Google porque exigiria huellas SHA-1 distintas en
  /// debug y en release; ver el CLAUDE.md.
  AccionesDeSesionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accionesDeSesionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accionesDeSesionHash();

  @$internal
  @override
  AccionesDeSesion create() => AccionesDeSesion();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$accionesDeSesionHash() => r'3e8020aec0720562fb4e40c3729eb5081eb7ca75';

/// Acciones de autenticacion.
///
/// El login abre el navegador (Chrome Custom Tab) y vuelve por deep link. No se
/// usa la hoja nativa de Google porque exigiria huellas SHA-1 distintas en
/// debug y en release; ver el CLAUDE.md.

abstract class _$AccionesDeSesion extends $Notifier<void> {
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
