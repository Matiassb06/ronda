import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/formato/monto.dart';
import '../../../core/tema/tema_ronda.dart';
import '../../../l10n/textos.dart';
import '../../juntas/application/juntas.dart';
import '../../participantes/domain/participante.dart';
import '../domain/aporte.dart';

/// El cuaderno. Esta es la app.
///
/// Una lista de nombres con un check al costado, y arriba quién cobra y cuánto
/// se lleva juntado. Nada más. Se usa con el pulgar, de pie, con sol encima y
/// una señora esperando enfrente: cada toque tiene que resolver algo.
class PantallaCuaderno extends ConsumerWidget {
  const PantallaCuaderno({required this.juntaId, super.key});

  final String juntaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(cuadernoProvider(juntaId));

    return Scaffold(
      appBar: AppBar(
        title: Text(estado.value?.junta.nombre ?? Textos.cargando),
      ),
      body: estado.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _Error(juntaId: juntaId),
        data: (cuaderno) => _Contenido(cuaderno: cuaderno),
      ),
    );
  }
}

class _Error extends ConsumerWidget {
  const _Error({required this.juntaId});
  final String juntaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Textos.errorGenerico,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => ref.invalidate(cuadernoProvider(juntaId)),
            child: const Text(Textos.reintentar),
          ),
        ],
      ),
    );
  }
}

class _Contenido extends ConsumerWidget {
  const _Contenido({required this.cuaderno});
  final CuadernoDelTurno cuaderno;

  Future<void> _alternar(WidgetRef ref, Aporte aporte) async {
    await ref
        .read(repositorioJuntasProvider)
        .marcarAporte(aporteId: aporte.id, pagado: !aporte.estaPagado);
    ref.invalidate(cuadernoProvider(cuaderno.junta.id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!cuaderno.tieneCalendario) {
      return _Aviso(mensaje: Textos.sinCalendario);
    }
    if (cuaderno.termino) {
      return _Aviso(mensaje: Textos.juntaTerminada);
    }

    final resumen = cuaderno.resumen;
    final quienCobra = cuaderno.quienCobra;

    return Column(
      children: [
        _Cabecera(cuaderno: cuaderno, quienCobra: quienCobra, resumen: resumen),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: cuaderno.participantes.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final participante = cuaderno.participantes[i];
              final aporte = cuaderno.aportes[participante.id];
              if (aporte == null) return const SizedBox.shrink();

              return _FilaDelCuaderno(
                participante: participante,
                aporte: aporte,
                esQuienCobra: participante.id == quienCobra?.id,
                alTocar: () => _alternar(ref, aporte),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Aviso extends StatelessWidget {
  const _Aviso({required this.mensaje});
  final String mensaje;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          mensaje,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

/// Quién cobra, cuánto se juntó y cuántas faltan.
class _Cabecera extends ConsumerWidget {
  const _Cabecera({
    required this.cuaderno,
    required this.quienCobra,
    required this.resumen,
  });

  final CuadernoDelTurno cuaderno;
  final Participante? quienCobra;
  final ResumenDeTurno resumen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final turno = cuaderno.turnoActual!;

    return Container(
      width: double.infinity,
      color: tema.colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${Textos.turnoDe} ${turno.numero} ${Textos.de} ${cuaderno.turnos.length}',
                style: tema.textTheme.bodyMedium,
              ),
              const Spacer(),
              if (resumen.estaAtrasado)
                _Etiqueta(
                  texto:
                      '${Textos.atrasadoPorDias} ${resumen.diasDeAtraso} ${resumen.diasDeAtraso == 1 ? Textos.dia : Textos.dias}',
                  color: tema.colorScheme.error,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(Textos.cobraHoy, style: tema.textTheme.bodyLarge),
          Text(quienCobra?.nombre ?? '', style: tema.textTheme.headlineMedium),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Textos.recaudado, style: tema.textTheme.bodyMedium),
                    Text(
                      Monto.formatear(resumen.recaudadoCentavos),
                      style: TemaRonda.estiloMonto(context, tamano: 38),
                    ),
                    Text(
                      '${Textos.de} ${Monto.formatear(resumen.esperadoCentavos)}',
                      style: tema.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(Textos.pagaron, style: tema.textTheme.bodyMedium),
                  Text(
                    '${resumen.pagados} ${Textos.de} ${resumen.total}',
                    style: tema.textTheme.headlineSmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: resumen.avance,
              minHeight: 12,
              // Colores explícitos: con los de por defecto, la barra vacía se
              // pinta oscura sobre este fondo y se lee como si ya estuviera
              // completa. Justo al revés de lo que pasa.
              color: tema.colorScheme.primary,
              backgroundColor: tema.colorScheme.surface,
            ),
          ),
          if (resumen.estaCompleto) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                await ref
                    .read(repositorioJuntasProvider)
                    .completarTurno(turno.id);
                ref.invalidate(cuadernoProvider(cuaderno.junta.id));
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text(Textos.entregarPozo),
            ),
          ],
        ],
      ),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  const _Etiqueta({required this.texto, required this.color});
  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onError,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}

/// Una línea del cuaderno: nombre y check.
///
/// Toda la fila es el área de toque, no solo el cuadradito: con el pulgar y
/// apurada, apuntar a un checkbox de 24 píxeles es pedirle demasiado.
class _FilaDelCuaderno extends StatelessWidget {
  const _FilaDelCuaderno({
    required this.participante,
    required this.aporte,
    required this.esQuienCobra,
    required this.alTocar,
  });

  final Participante participante;
  final Aporte aporte;
  final bool esQuienCobra;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final pagado = aporte.estaPagado;

    return InkWell(
      onTap: alTocar,
      child: Container(
        constraints: const BoxConstraints(minHeight: 72),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: pagado
            ? tema.colorScheme.primaryContainer.withValues(alpha: 0.35)
            : null,
        child: Row(
          children: [
            Checkbox(value: pagado, onChanged: (_) => alTocar()),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    participante.nombre,
                    style: tema.textTheme.titleLarge?.copyWith(
                      decoration: pagado ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (esQuienCobra)
                    Text(
                      Textos.cobraEsteTurno,
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: tema.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              Monto.formatear(aporte.montoCentavos),
              style: TemaRonda.estiloMonto(context, tamano: 22),
            ),
          ],
        ),
      ),
    );
  }
}
