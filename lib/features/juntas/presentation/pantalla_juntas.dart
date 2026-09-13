import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/formato/monto.dart';
import '../../../core/tema/tema_ronda.dart';
import '../../../l10n/textos.dart';
import '../../auth/application/sesion.dart';
import '../application/juntas.dart';
import '../domain/junta.dart';

/// Las juntas de la cabeza de junta.
///
/// Normalmente va a tener una o dos, así que la lista es corta a propósito y
/// cada fila es grande: se toca de pie y con el pulgar.
class PantallaJuntas extends ConsumerWidget {
  const PantallaJuntas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final juntas = ref.watch(listaDeJuntasProvider);

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
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(listaDeJuntasProvider),
        child: juntas.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => ListView(
            children: [
              const SizedBox(height: 120),
              Center(child: Text(Textos.errorGenerico)),
            ],
          ),
          data: (lista) {
            if (lista.isEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: 140),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      Textos.sinJuntas,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.only(bottom: 96),
              itemCount: lista.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) => _FilaJunta(junta: lista[i]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/junta/nueva'),
        icon: const Icon(Icons.add),
        label: const Text(Textos.crearJunta),
      ),
    );
  }
}

class _FilaJunta extends StatelessWidget {
  const _FilaJunta({required this.junta});
  final Junta junta;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final enBorrador = junta.estado == EstadoJunta.borrador;

    return InkWell(
      // Una junta sin calendario todavía no tiene cuaderno que mostrar:
      // el camino natural es seguir agregando gente.
      onTap: () => context.go(
        enBorrador ? '/junta/${junta.id}/participantes' : '/junta/${junta.id}',
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(junta.nombre, style: tema.textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    '${junta.frecuencia.etiqueta} · ${junta.estado.etiqueta}',
                    style: tema.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              Monto.formatear(junta.montoAporteCentavos),
              style: TemaRonda.estiloMonto(context, tamano: 24),
            ),
            const Icon(Icons.chevron_right, size: 30),
          ],
        ),
      ),
    );
  }
}
