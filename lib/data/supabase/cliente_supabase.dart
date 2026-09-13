import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/configuracion_supabase.dart';

/// Arranque del cliente de Supabase.
///
/// Se llama una sola vez, desde `main`, y solo cuando la configuracion esta
/// completa. Si falta algo, la app no inicializa nada y muestra la pantalla de
/// configuracion faltante: es mejor una pantalla que explica el problema que
/// una excepcion en el arranque.
class ClienteSupabase {
  const ClienteSupabase._();

  static Future<void> inicializar() async {
    await Supabase.initialize(
      url: ConfiguracionSupabase.url,
      publishableKey: ConfiguracionSupabase.claveAnonima,
      authOptions: const FlutterAuthClientOptions(
        // La sesion sobrevive a cerrar la app. Ella no deberia volver a entrar
        // cada manana: abre y ve su cuaderno.
        autoRefreshToken: true,
      ),
    );
  }

  static SupabaseClient get cliente => Supabase.instance.client;
}
