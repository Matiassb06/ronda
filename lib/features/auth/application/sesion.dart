import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/supabase/cliente_supabase.dart';

part 'sesion.g.dart';

/// El cliente, expuesto como provider para poder sustituirlo en los tests.
@riverpod
SupabaseClient clienteSupabase(Ref ref) => ClienteSupabase.cliente;

/// Cambios de sesion que emite Supabase: entrar, salir, refrescar el token.
@riverpod
Stream<AuthState> cambiosDeSesion(Ref ref) {
  return ref.watch(clienteSupabaseProvider).auth.onAuthStateChange;
}

/// La sesion actual, o null si no hay nadie dentro.
///
/// Se escucha el stream para que el router reaccione, pero el valor se lee del
/// cliente: al arrancar, Supabase ya restauro la sesion guardada y el stream
/// todavia no emitio nada.
@riverpod
Session? sesionActual(Ref ref) {
  ref.watch(cambiosDeSesionProvider);
  return ref.watch(clienteSupabaseProvider).auth.currentSession;
}

/// Acciones de autenticacion.
///
/// El login abre el navegador (Chrome Custom Tab) y vuelve por deep link. No se
/// usa la hoja nativa de Google porque exigiria huellas SHA-1 distintas en
/// debug y en release; ver el CLAUDE.md.
@riverpod
class AccionesDeSesion extends _$AccionesDeSesion {
  @override
  void build() {}

  /// Esquema y host del deep link. Tienen que coincidir con el intent-filter
  /// del AndroidManifest y con las Redirect URLs del panel de Supabase.
  static const String urlDeRetorno = 'pe.leonardo.ronda://login-callback/';

  Future<void> entrarConGoogle() async {
    await ref
        .read(clienteSupabaseProvider)
        .auth
        .signInWithOAuth(
          OAuthProvider.google,
          redirectTo: urlDeRetorno,
          authScreenLaunchMode: LaunchMode.externalApplication,
        );
  }

  Future<void> salir() async {
    await ref.read(clienteSupabaseProvider).auth.signOut();
  }
}
