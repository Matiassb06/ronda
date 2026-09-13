import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/formato/fecha.dart';
import '../../../core/formato/monto.dart';
import '../../../core/tema/tema_ronda.dart';
import '../../../l10n/textos.dart';
import '../../auth/application/sesion.dart';
import '../application/juntas.dart';
import '../domain/junta.dart';
import 'hoja_editar_junta.dart';

/// Las juntas de la cabeza de junta.
///
/// Normalmente va a tener una o dos, así que la lista es corta a propósito y
/// cada fila es grande: se toca de pie y con el pulgar.
class PantallaJuntas extends ConsumerWidget {
  const PantallaJuntas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Enciende el latido de sincronización mientras haya una pantalla viva.
    ref.watch(latidoDeSyncProvider);
    ref.watch(permisoDeAvisosProvider);

    final juntas = ref.watch(listaDeJuntasProvider);
    final finales = ref.watch(finDeCadaJuntaProvider).value ?? const {};

    return Scaffold(
      appBar: AppBar(
        title: const Text(Textos.misJuntas),
        actions: [
          const _AvisoPendientes(),
          IconButton(
            tooltip: Textos.salir,
            icon: const Icon(Icons.logout, size: 26),
            onPressed: () async {
              // El espejo local guarda plata ajena y el teléfono puede pasar a
              // otra persona: al salir no queda nada en el dispositivo.
              await ref.read(repositorioJuntasProvider).olvidarTodo();
              await ref.read(accionesDeSesionProvider.notifier).salir();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            ref.read(repositorioJuntasProvider).sincronizarAhora(),
        child: juntas.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => ListView(
            children: const [
              SizedBox(height: 120),
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
              itemBuilder: (context, i) =>
                  _FilaJunta(junta: lista[i], termina: finales[lista[i].id]),
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

/// Cuántos cambios esperan señal, también aquí.
///
/// Antes solo estaba en el cuaderno, así que desde la lista no había manera de
/// saber si lo que se marcó ya subió.
class _AvisoPendientes extends ConsumerWidget {
  const _AvisoPendientes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendientes = ref.watch(cambiosPendientesProvider).value ?? 0;
    if (pendientes == 0) return const SizedBox.shrink();

    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Row(
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 24,
            color: tema.colorScheme.outline,
          ),
          const SizedBox(width: 6),
          Text(
            '$pendientes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: tema.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaJunta extends ConsumerWidget {
  const _FilaJunta({required this.junta, required this.termina});

  final Junta junta;

  /// Fecha del último turno. Null mientras la junta no tenga calendario.
  final DateTime? termina;

  Future<void> _borrar(BuildContext context, WidgetRef ref) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(Textos.borrarJuntaPregunta),
        content: Text('${junta.nombre}\n\n${Textos.borrarJuntaDetalle}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(Textos.cancelar),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(Textos.borrar),
          ),
        ],
      ),
    );
    if (confirmado != true) return;

    await ref.read(repositorioJuntasProvider).borrarJunta(junta.id);
  }

  Future<void> _editar(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => HojaEditarJunta(junta: junta),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final enBorrador = junta.estado == EstadoJunta.borrador;
    final cerrada = junta.estado == EstadoJunta.cerrada;

    return InkWell(
      // Una junta sin calendario todavía no tiene cuaderno que mostrar:
      // el camino natural es seguir agregando gente.
      onTap: () => context.go(
        enBorrador ? '/junta/${junta.id}/participantes' : '/junta/${junta.id}',
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 8, 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    junta.nombre,
                    style: tema.textTheme.titleLarge?.copyWith(
                      decoration: cerrada ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${junta.frecuencia.etiqueta} · ${junta.estado.etiqueta}',
                    style: tema.textTheme.bodyMedium,
                  ),
                  // Doce semanas se dicen rápido y se sienten largas. Nadie las
                  // cuenta de memoria, así que las cuenta la app.
                  if (termina != null && !cerrada)
                    Text(
                      '${Textos.hastaEl} ${FechaEnEspanol.completa(termina!)}',
                      style: tema.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              Monto.formatear(junta.montoAporteCentavos),
              style: TemaRonda.estiloMonto(context, tamano: 22),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 28),
              onSelected: (opcion) => opcion == 'editar'
                  ? _editar(context, ref)
                  : _borrar(context, ref),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'editar',
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text(Textos.editarJunta),
                  ),
                ),
                PopupMenuItem(
                  value: 'borrar',
                  child: ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                      color: tema.colorScheme.error,
                    ),
                    title: Text(
                      Textos.borrarJunta,
                      style: TextStyle(color: tema.colorScheme.error),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
