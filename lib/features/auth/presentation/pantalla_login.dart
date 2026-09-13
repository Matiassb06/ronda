import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/textos.dart';
import '../application/sesion.dart';

/// Pantalla de entrada.
///
/// Un solo boton. La cabeza de junta no tiene que elegir nada aqui: no hay
/// correo, no hay contrasena, no hay "crear cuenta". Entra con Google y ya.
class PantallaLogin extends ConsumerStatefulWidget {
  const PantallaLogin({super.key});

  @override
  ConsumerState<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends ConsumerState<PantallaLogin> {
  bool _abriendo = false;

  Future<void> _entrar() async {
    setState(() => _abriendo = true);
    try {
      await ref.read(accionesDeSesionProvider.notifier).entrarConGoogle();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(Textos.errorLogin)));
    } finally {
      if (mounted) setState(() => _abriendo = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Text(Textos.nombreApp, style: tema.textTheme.displaySmall),
              const SizedBox(height: 8),
              Text(Textos.bienvenida, style: tema.textTheme.headlineSmall),
              const SizedBox(height: 24),
              Text(Textos.explicacionLogin, style: tema.textTheme.bodyLarge),
              const Spacer(flex: 3),
              FilledButton.icon(
                onPressed: _abriendo ? null : _entrar,
                icon: _abriendo
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : const Icon(Icons.login, size: 26),
                label: Text(
                  _abriendo ? Textos.entrando : Textos.entrarConGoogle,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
