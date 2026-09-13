import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/formato/fecha.dart';
import '../../../core/formato/monto.dart';
import '../../../core/tema/tema_ronda.dart';
import '../../../l10n/textos.dart';
import '../application/juntas.dart';

/// El calendario completo: cuándo cobra cada una y cuándo termina la junta.
///
/// Faltaba y era de las primeras preguntas que hace cualquiera al entrar a una
/// junta: **"¿cuándo me toca a mí?"**. El cuaderno solo muestra el turno en
/// curso, así que sin esta pantalla la respuesta había que llevarla en la
/// cabeza o en el papel que la app venía a reemplazar.
class PantallaCalendario extends ConsumerWidget {
  const PantallaCalendario({required this.juntaId, super.key});

  final String juntaId;

  Future<void> _deshacer(
    BuildContext context,
    WidgetRef ref,
    String turnoId,
  ) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(Textos.deshacerEntrega),
        content: const Text(Textos.deshacerEntregaDetalle),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(Textos.cancelar),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(Textos.deshacer),
          ),
        ],
      ),
    );
    if (confirmado != true) return;

    await ref
        .read(repositorioJuntasProvider)
        .deshacerTurno(turnoId, juntaId: juntaId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cuaderno = ref.watch(cuadernoProvider(juntaId));
    if (cuaderno == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final hoy = DateTime.now();
    final nombres = {for (final p in cuaderno.participantes) p.id: p.nombre};

    return Scaffold(
      appBar: AppBar(title: const Text(Textos.calendario)),
      body: cuaderno.turnos.isEmpty
          ? const Center(child: Text(Textos.sinCalendario))
          : ListView(
              children: [
                _Cierre(
                  primero: cuaderno.turnos.first.fechaProgramada,
                  ultimo: cuaderno.turnos.last.fechaProgramada,
                  pozoCentavos:
                      cuaderno.junta.montoAporteCentavos *
                      cuaderno.participantes.length,
                ),
                const Divider(height: 1),
                for (final turno in cuaderno.turnos)
                  _FilaDeTurno(
                    numero: turno.numero,
                    total: cuaderno.turnos.length,
                    nombre: nombres[turno.participanteId] ?? '',
                    fecha: turno.fechaProgramada,
                    completado: turno.completado,
                    esElActual: turno.id == cuaderno.turnoActual?.id,
                    atrasado: turno.estaAtrasado(hoy),
                    alDeshacer: turno.completado
                        ? () => _deshacer(context, ref, turno.id)
                        : null,
                  ),
              ],
            ),
    );
  }
}

/// Cuándo empieza, cuándo termina y cuánto se lleva cada una.
///
/// Lo de "cuándo termina" es lo que pedía a gritos una junta semanal: doce
/// semanas se dicen rápido y se sienten largas, y nadie las cuenta de memoria.
class _Cierre extends StatelessWidget {
  const _Cierre({
    required this.primero,
    required this.ultimo,
    required this.pozoCentavos,
  });

  final DateTime primero;
  final DateTime ultimo;
  final int pozoCentavos;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Container(
      width: double.infinity,
      color: tema.colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Textos.laJuntaTermina, style: tema.textTheme.bodyLarge),
          Text(
            FechaEnEspanol.completa(ultimo),
            style: tema.textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            '${Textos.empezo} ${FechaEnEspanol.completa(primero)}',
            style: tema.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(Textos.cadaUnaSeLleva, style: tema.textTheme.bodyMedium),
          Text(
            Monto.formatear(pozoCentavos),
            style: TemaRonda.estiloMonto(context, tamano: 32),
          ),
        ],
      ),
    );
  }
}

class _FilaDeTurno extends StatelessWidget {
  const _FilaDeTurno({
    required this.numero,
    required this.total,
    required this.nombre,
    required this.fecha,
    required this.completado,
    required this.esElActual,
    required this.atrasado,
    required this.alDeshacer,
  });

  final int numero;
  final int total;
  final String nombre;
  final DateTime fecha;
  final bool completado;
  final bool esElActual;
  final bool atrasado;
  final VoidCallback? alDeshacer;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Container(
      color: esElActual
          ? tema.colorScheme.primaryContainer.withValues(alpha: 0.35)
          : null,
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: completado
              ? tema.colorScheme.primary
              : atrasado
              ? tema.colorScheme.error
              : tema.colorScheme.surfaceContainerHighest,
          child: completado
              ? Icon(Icons.check, color: tema.colorScheme.onPrimary)
              : Text(
                  '$numero',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: atrasado
                        ? tema.colorScheme.onError
                        : tema.colorScheme.onSurface,
                  ),
                ),
        ),
        title: Text(nombre),
        subtitle: Text(
          FechaEnEspanol.conDiaDeLaSemana(fecha),
          style: atrasado && !completado
              ? TextStyle(
                  color: tema.colorScheme.error,
                  fontWeight: FontWeight.w600,
                )
              : null,
        ),
        trailing: alDeshacer == null
            ? (esElActual
                  ? Text(Textos.enCurso, style: tema.textTheme.bodyMedium)
                  : null)
            : IconButton(
                tooltip: Textos.deshacer,
                icon: const Icon(Icons.undo, size: 26),
                onPressed: alDeshacer,
              ),
      ),
    );
  }
}
