import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/application/sesion.dart';
import '../../features/auth/presentation/pantalla_login.dart';
import '../../features/juntas/presentation/pantalla_juntas.dart';

/// Rutas de la app. Son pocas a proposito: la app tiene una pantalla que
/// importa y el resto es camino hacia ella.
class Rutas {
  const Rutas._();

  static const String login = '/login';
  static const String juntas = '/';
}

/// Escucha los cambios de sesion de Supabase y avisa a go_router.
///
/// Existe porque `refreshListenable` quiere un `Listenable`, no un Stream, y
/// porque recrear el `GoRouter` en cada cambio de sesion perderia el historial
/// de navegacion.
class _NotificadorDeSesion extends ChangeNotifier {
  _NotificadorDeSesion(Stream<AuthState> cambios) {
    _suscripcion = cambios.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _suscripcion;

  @override
  void dispose() {
    _suscripcion.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final cliente = ref.watch(clienteSupabaseProvider);
  final notificador = _NotificadorDeSesion(cliente.auth.onAuthStateChange);
  ref.onDispose(notificador.dispose);

  return GoRouter(
    initialLocation: Rutas.juntas,
    refreshListenable: notificador,
    redirect: (context, state) {
      // Se lee del cliente y no de un provider: al arrancar, Supabase ya
      // restauro la sesion guardada antes de que el stream emita nada.
      final haySesion = cliente.auth.currentSession != null;
      final estaEnLogin = state.matchedLocation == Rutas.login;

      if (!haySesion) return estaEnLogin ? null : Rutas.login;
      if (estaEnLogin) return Rutas.juntas;
      return null;
    },
    routes: [
      GoRoute(
        path: Rutas.login,
        builder: (context, state) => const PantallaLogin(),
      ),
      GoRoute(
        path: Rutas.juntas,
        builder: (context, state) => const PantallaJuntas(),
      ),
    ],
  );
});
