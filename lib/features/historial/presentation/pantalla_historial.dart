import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/tema/tema_ronda.dart';
import '../../../l10n/textos.dart';
import '../../juntas/application/juntas.dart';
import '../domain/cumplimiento.dart';

/// El historial de la junta: quién cumplió y quién no.
///
/// Sirve para una decisión concreta y bastante cargada: **a quién vuelve a
/// invitar en la siguiente junta**. Hoy eso se decide de memoria y de rencores.
/// Aquí está la cuenta real, ordenada de quien más debe a quien menos.
class PantallaHistorial extends ConsumerWidget {
  const PantallaHistorial({required this.juntaId, super.key});

  final String juntaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cuaderno = ref.watch(cuadernoProvider(juntaId));
    final aportes = ref.watch(aportesDeJuntaProvider(juntaId)).value;

    if (cuaderno == null || aportes == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final cumplimiento = HistorialDeJunta.calcular(
      participantes: [
        for (final p in cuaderno.participantes) (id: p.id, nombre: p.nombre),
      ],
      turnos: cuaderno.turnos,
      aportes: aportes,
      hoy: DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(Textos.historial),
        actions: [
          IconButton(
            tooltip: Textos.compartirResumen,
            icon: const Icon(Icons.share, size: 26),
            onPressed: () => SharePlus.instance.share(
              ShareParams(
                text: HistorialDeJunta.resumenParaCompartir(
                  nombreJunta: cuaderno.junta.nombre,
                  cumplimiento: cumplimiento,
                ),
              ),
            ),
          ),
        ],
      ),
      body: cumplimiento.isEmpty
          ? const Center(child: Text(Textos.sinHistorial))
          : ListView(
              padding: const EdgeInsets.only(bottom: 40),
              children: [
                _Grafico(cumplimiento: cumplimiento),
                const Divider(height: 1),
                for (final c in cumplimiento) _Fila(cumplimiento: c),
                const SizedBox(height: 24),
                _CodigoQr(codigo: cuaderno.junta.codigo),
              ],
            ),
    );
  }
}

/// Una barra por participante, con el porcentaje de aportes que pagó.
///
/// Deliberadamente simple: sin ejes, sin leyenda, sin cuadrícula. Lo va a leer
/// una señora en un puesto de mercado, no un analista. Lo único que tiene que
/// transmitir es quién está corto de barra.
class _Grafico extends StatelessWidget {
  const _Grafico({required this.cumplimiento});
  final List<CumplimientoDeParticipante> cumplimiento;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Textos.cumplimiento, style: tema.textTheme.titleLarge),
          Text(Textos.deAportes, style: tema.textTheme.bodyMedium),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                maxY: 1,
                minY: 0,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      getTitlesWidget: (valor, meta) {
                        final i = valor.toInt();
                        if (i < 0 || i >= cumplimiento.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            cumplimiento[i].nombre.split(' ').first,
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < cumplimiento.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: cumplimiento[i].avance,
                          width: 26,
                          borderRadius: BorderRadius.circular(6),
                          color: cumplimiento[i].debe
                              ? tema.colorScheme.error
                              : tema.colorScheme.primary,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 1,
                            color: tema.colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Fila extends StatelessWidget {
  const _Fila({required this.cumplimiento});
  final CumplimientoDeParticipante cumplimiento;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final color = cumplimiento.debe
        ? tema.colorScheme.error
        : cumplimiento.siempreATiempo
        ? tema.colorScheme.primary
        : tema.colorScheme.tertiary;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        radius: 24,
        child: Icon(
          cumplimiento.debe
              ? Icons.priority_high
              : cumplimiento.siempreATiempo
              ? Icons.check
              : Icons.schedule,
          color: tema.colorScheme.onPrimary,
        ),
      ),
      title: Text(cumplimiento.nombre),
      subtitle: Text(cumplimiento.resumen),
      trailing: Text(
        '${cumplimiento.pagados}/${cumplimiento.totales}',
        style: TemaRonda.estiloMonto(context, tamano: 20),
      ),
    );
  }
}

/// El código de la junta en grande y en QR.
///
/// El QR es para que otra persona lo escanee sin dictarlo; el texto de abajo es
/// para cuando no hay con qué escanear, que en el mercado es lo habitual.
class _CodigoQr extends StatelessWidget {
  const _CodigoQr({required this.codigo});
  final String codigo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Column(
      children: [
        Text(Textos.codigoDeLaJunta, style: tema.textTheme.titleMedium),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: QrImageView(data: codigo, size: 160),
        ),
        const SizedBox(height: 12),
        Text(
          codigo,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: 6,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}
