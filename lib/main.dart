import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/configuracion_supabase.dart';
import 'core/config/pantalla_configuracion_faltante.dart';
import 'core/router/router_ronda.dart';
import 'core/tema/tema_ronda.dart';
import 'data/supabase/cliente_supabase.dart';
import 'l10n/textos.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sin claves no se inicializa nada: se muestra que falta y se termina ahi.
  // Ver ConfiguracionSupabase para como se pasan.
  if (!ConfiguracionSupabase.estaCompleta) {
    runApp(const AppConfiguracionFaltante());
    return;
  }

  await ClienteSupabase.inicializar();
  runApp(const ProviderScope(child: AppRonda()));
}

class AppRonda extends ConsumerWidget {
  const AppRonda({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: Textos.nombreApp,
      debugShowCheckedModeBanner: false,
      theme: TemaRonda.claro,
      darkTheme: TemaRonda.oscuro,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
