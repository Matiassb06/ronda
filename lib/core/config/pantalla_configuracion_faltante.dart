import 'package:flutter/material.dart';

import '../../l10n/idiomas.dart';
import '../../l10n/textos.dart';
import '../tema/tema_ronda.dart';
import 'configuracion_supabase.dart';

/// Lo que se muestra cuando la app se compilo sin los `--dart-define`.
///
/// La alternativa era reventar en el arranque con una excepcion de Supabase.
/// Esto es mejor por dos razones: dice exactamente que falta, y deja claro que
/// el problema es de instalacion y no de la persona que abrio la app.
class AppConfiguracionFaltante extends StatelessWidget {
  const AppConfiguracionFaltante({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Textos.nombreApp,
      debugShowCheckedModeBanner: false,
      theme: TemaRonda.claro,
      darkTheme: TemaRonda.oscuro,
      localizationsDelegates: Idiomas.delegados,
      supportedLocales: Idiomas.soportados,
      locale: Idiomas.espanol,
      home: const _PantallaConfiguracionFaltante(),
    );
  }
}

class _PantallaConfiguracionFaltante extends StatelessWidget {
  const _PantallaConfiguracionFaltante();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.settings_outlined,
                size: 56,
                color: tema.colorScheme.error,
              ),
              const SizedBox(height: 20),
              Text(
                Textos.configuracionFaltante,
                style: tema.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                Textos.configuracionFaltanteDetalle,
                style: tema.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Text(
                Textos.configuracionFaltanteQueFalta,
                style: tema.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              for (final variable in ConfiguracionSupabase.faltantes)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    variable,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Text(
                Textos.configuracionFaltanteComoSeArregla,
                style: tema.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
