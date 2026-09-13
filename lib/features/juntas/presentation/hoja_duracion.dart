import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/formato/fecha.dart';
import '../../../core/formato/monto.dart';
import '../../../l10n/textos.dart';
import '../domain/calendario_turnos.dart';
import '../domain/frecuencia.dart';

/// Cuánto va a durar la junta, preguntado justo antes de empezarla.
///
/// Se pregunta aquí y no al crearla porque aquí ya se sabe cuánta gente hay, y
/// **la duración y la cantidad de participantes son dos cosas distintas**: una
/// junta semanal puede durar veinte semanas con diez personas, porque alguien
/// tomó dos números, paga doble y cobra dos veces.
///
/// Cuando no coinciden, esta pantalla lo dice en la cara antes de generar nada.
/// Que alguien cobre dos veces y otra ninguna, descubierto en la semana cinco,
/// es de las cosas que rompen una junta.
class HojaDuracion extends StatefulWidget {
  const HojaDuracion({
    required this.participantes,
    required this.frecuencia,
    required this.fechaInicio,
    required this.montoAporteCentavos,
    super.key,
  });

  final int participantes;
  final Frecuencia frecuencia;
  final DateTime fechaInicio;
  final int montoAporteCentavos;

  @override
  State<HojaDuracion> createState() => _HojaDuracionState();
}

class _HojaDuracionState extends State<HojaDuracion> {
  late final TextEditingController _turnos;

  /// Por defecto, una vuelta limpia: tantos turnos como gente.
  late int _cantidad = widget.participantes;

  @override
  void initState() {
    super.initState();
    _turnos = TextEditingController(text: '${widget.participantes}');
  }

  @override
  void dispose() {
    _turnos.dispose();
    super.dispose();
  }

  void _leerCantidad(String texto) {
    final valor = int.tryParse(texto.trim());
    setState(() => _cantidad = (valor == null || valor < 1) ? 0 : valor);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final valida = _cantidad >= 1;

    final reparto = valida
        ? CalendarioTurnos.repartoDeCobros(
            participantes: widget.participantes,
            turnos: _cantidad,
          )
        : null;

    final cierra = valida
        ? CalendarioTurnos.fechaDeCierre(
            turnos: _cantidad,
            frecuencia: widget.frecuencia,
            fechaInicio: widget.fechaInicio,
          )
        : null;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(Textos.cuantoDuraLaJunta, style: tema.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              '${widget.participantes} ${widget.participantes == 1 ? Textos.participante : Textos.participantesEnLaJunta}',
              style: tema.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            TextField(
              autofocus: true,
              controller: _turnos,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              onChanged: _leerCantidad,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                labelText: widget.frecuencia.etiquetaDeDuracion,
                errorText: valida ? null : Textos.duracionInvalida,
              ),
            ),
            const SizedBox(height: 20),
            if (reparto != null && cierra != null) ...[
              _Dato(
                icono: Icons.event_available,
                texto: '${Textos.terminaEl} ${FechaEnEspanol.completa(cierra)}',
              ),
              const SizedBox(height: 8),
              _Dato(
                icono: Icons.savings_outlined,
                texto:
                    '${Textos.cadaUnaSeLleva} ${Monto.formatear(CalendarioTurnos.pozoPorTurnoEnCentavos(participantes: widget.participantes, montoAporteCentavos: widget.montoAporteCentavos))}',
              ),
              const SizedBox(height: 16),
              _Advertencia(reparto: reparto),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: valida
                  ? () => Navigator.of(context).pop(_cantidad)
                  : null,
              child: const Text(Textos.empezarJunta),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(Textos.cancelar),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({required this.icono, required this.texto});
  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Row(
      children: [
        Icon(icono, size: 22, color: tema.colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(child: Text(texto, style: tema.textTheme.bodyLarge)),
      ],
    );
  }
}

/// El aviso de que la cuenta no sale a mano.
///
/// No bloquea: la cabeza de junta sabe lo que hace y estos repartos existen de
/// verdad. Pero tiene que verlo antes, no en la semana cinco.
class _Advertencia extends StatelessWidget {
  const _Advertencia({required this.reparto});
  final RepartoDeCobros reparto;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    if (reparto.esParejo) {
      return _Caja(
        color: tema.colorScheme.primaryContainer,
        icono: Icons.check_circle_outline,
        titulo: Textos.repartoParejo,
        detalle: Textos.repartoParejoDetalle,
      );
    }

    if (reparto.alguienNoCobra) {
      return _Caja(
        color: tema.colorScheme.errorContainer,
        icono: Icons.warning_amber_rounded,
        titulo: reparto.sinCobrar == 1
            ? Textos.unaNoCobra
            : '${reparto.sinCobrar} ${Textos.variasNoCobran}',
        detalle: Textos.noCobranDetalle,
      );
    }

    return _Caja(
      color: tema.colorScheme.tertiaryContainer,
      icono: Icons.info_outline,
      titulo: reparto.cobranDeMas == 0
          ? '${Textos.cadaUnaCobra} ${reparto.vecesQueCobraLaMayoria} ${Textos.veces}'
          : '${reparto.cobranDeMas} ${reparto.cobranDeMas == 1 ? Textos.cobraUnaVezMas : Textos.cobranUnaVezMas}',
      detalle: Textos.cobrarDeMasDetalle,
    );
  }
}

class _Caja extends StatelessWidget {
  const _Caja({
    required this.color,
    required this.icono,
    required this.titulo,
    required this.detalle,
  });

  final Color color;
  final IconData icono;
  final String titulo;
  final String detalle;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: tema.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(detalle, style: tema.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
