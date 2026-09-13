import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/formato/monto.dart';
import '../../../core/tema/tema_ronda.dart';
import '../../../l10n/textos.dart';
import '../../auth/application/sesion.dart';

/// Pantalla principal, todavia vacia.
///
/// En el paso 2 se llena con las juntas de la cabeza, y en el paso 3 se
/// convierte en el cuaderno: la lista de nombres con un check al costado. Por
/// ahora solo confirma que la sesion quedo abierta y ensena el estilo de monto,
/// que es lo que hay que mirar antes de construir encima.
class PantallaJuntas extends ConsumerWidget {
  const PantallaJuntas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sesion = ref.watch(sesionActualProvider);
    final correo = sesion?.user.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(Textos.misJuntas),
        actions: [
          IconButton(
            tooltip: Textos.salir,
            icon: const Icon(Icons.logout, size: 26),
            onPressed: () =>
                ref.read(accionesDeSesionProvider.notifier).salir(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (correo.isNotEmpty)
              Text(correo, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Text(
              Textos.sinJuntas,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            // Muestra del estilo de monto: asi se van a ver las cifras.
            Text(
              Monto.formatear(125000),
              style: TemaRonda.estiloMonto(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: null,
        icon: const Icon(Icons.add),
        label: const Text(Textos.crearJunta),
      ),
    );
  }
}
