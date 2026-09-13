import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/avisos/avisos.dart';
import '../../../core/formato/monto.dart';
import '../../../core/tema/tema_ronda.dart';
import '../../../l10n/textos.dart';
import '../../juntas/application/juntas.dart';
import '../../participantes/domain/participante.dart';
import '../domain/aporte.dart';
import '../domain/recordatorio.dart';

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
    // Viene de la base local, así que o está listo o la junta todavía no se
    // descargó. No hay estado de error de red aquí: eso lo maneja la cola.
    final cuaderno = ref.watch(cuadernoProvider(juntaId));

    // Cada vez que cambia el cuaderno se reprograman los avisos del turno en
    // curso. Se hace aquí y no al crear la junta porque el texto del aviso
    // depende de cuántas faltan por pagar, y eso cambia todo el tiempo.
    ref.listen<CuadernoDelTurno?>(cuadernoProvider(juntaId), (_, nuevo) {
      final turno = nuevo?.turnoActual;
      if (nuevo == null || turno == null) return;
      Avisos.programarTurno(
        turnoId: turno.id,
        nombreJunta: nuevo.junta.nombre,
        fechaDelTurno: turno.fechaProgramada,
        montoCentavos: nuevo.junta.montoAporteCentavos,
        cuantasFaltan: nuevo.resumen.faltan,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(cuaderno?.junta.nombre ?? Textos.cargando),
        actions: const [_AvisoPendientes()],
      ),
      body: cuaderno == null
          ? const Center(child: CircularProgressIndicator())
          : _Contenido(cuaderno: cuaderno),
    );
  }
}

/// Cuántos cambios esperan señal.
///
/// No es un error ni una advertencia: la app funciona igual. Es información,
/// para que la cabeza de junta sepa que lo que marcó está guardado en su
/// teléfono y todavía no viajó.
class _AvisoPendientes extends ConsumerWidget {
  const _AvisoPendientes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendientes = ref.watch(cambiosPendientesProvider).value ?? 0;
    if (pendientes == 0) return const SizedBox.shrink();

    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 12),
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

class _Contenido extends ConsumerWidget {
  const _Contenido({required this.cuaderno});
  final CuadernoDelTurno cuaderno;

  /// Abre el chat de WhatsApp con el mensaje ya escrito.
  ///
  /// La app no manda nada: deja el texto listo y ella le da enviar desde su
  /// propio número. A ella le contestan; a un número desconocido, no.
  Future<void> _recordar(
    BuildContext context,
    Participante participante,
    Aporte aporte,
  ) async {
    final turno = cuaderno.turnoActual;
    if (turno == null) return;

    final texto = Recordatorio.mensaje(
      nombreParticipante: participante.nombre,
      nombreJunta: cuaderno.junta.nombre,
      montoCentavos: aporte.montoCentavos,
      fechaDelTurno: turno.fechaProgramada,
      quienCobra: cuaderno.quienCobra?.nombre,
      yaVencio: turno.estaAtrasado(DateTime.now()),
    );

    final enlace = Recordatorio.enlaceDeWhatsApp(
      telefono: participante.telefono,
      mensaje: texto,
    );
    if (enlace == null) return;

    final abrio = await launchUrl(enlace, mode: LaunchMode.externalApplication);
    if (!abrio && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(Textos.noSePudoAbrirWhatsApp)),
      );
    }
  }

  Future<void> _alternar(WidgetRef ref, Aporte aporte) async {
    await ref
        .read(repositorioJuntasProvider)
        .marcarAporte(aporteId: aporte.id, pagado: !aporte.estaPagado);
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
                alRecordar: participante.tieneTelefono && !aporte.estaPagado
                    ? () => _recordar(context, participante, aporte)
                    : null,
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
    required this.alRecordar,
  });

  final Participante participante;
  final Aporte aporte;
  final bool esQuienCobra;
  final VoidCallback alTocar;

  /// Null cuando no hay a quién escribirle: sin teléfono, o ya pagó.
  final VoidCallback? alRecordar;

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
            if (alRecordar != null)
              IconButton(
                tooltip: Textos.recordarPorWhatsApp,
                icon: const Icon(Icons.chat_outlined, size: 28),
                onPressed: alRecordar,
              )
            else
              const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
