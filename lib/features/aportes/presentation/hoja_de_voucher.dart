import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/formato/fecha.dart';
import '../../../core/formato/monto.dart';
import '../../../l10n/textos.dart';
import '../domain/lector_de_voucher.dart';

/// Lo que la cabeza de junta confirmó tras ver la foto.
typedef VoucherConfirmado = ({
  int montoCentavos,
  DateTime fecha,
  String rutaLocal,
  int? ocrMonto,
  DateTime? ocrFecha,
});

/// Confirmación del voucher, con lo que el OCR creyó leer ya puesto.
///
/// **La regla 9 del CLAUDE.md vive en esta pantalla**: el OCR nunca guarda un
/// aporte solo. Lo que leyó llega aquí como sugerencia, escrito en campos que
/// se pueden corregir, y nada se guarda hasta que ella toca confirmar.
///
/// Por eso también se muestra la foto: para que pueda comparar la cifra del
/// papel con la que la app entendió, sin salir de aquí.
class HojaDeVoucher extends StatefulWidget {
  const HojaDeVoucher({
    required this.rutaLocal,
    required this.lectura,
    required this.montoEsperadoCentavos,
    super.key,
  });

  final String rutaLocal;
  final LecturaDeVoucher lectura;

  /// El aporte que le tocaba. Se usa cuando el OCR no entendió el monto: es
  /// mejor sugerir lo que debía pagar que dejar el campo vacío.
  final int montoEsperadoCentavos;

  @override
  State<HojaDeVoucher> createState() => _HojaDeVoucherState();
}

class _HojaDeVoucherState extends State<HojaDeVoucher> {
  late final TextEditingController _monto;
  late DateTime _fecha;

  @override
  void initState() {
    super.initState();
    final leido = widget.lectura.montoCentavos ?? widget.montoEsperadoCentavos;
    _monto = TextEditingController(text: Monto.formatearSinSimbolo(leido));
    _fecha = widget.lectura.fecha ?? DateTime.now();
  }

  @override
  void dispose() {
    _monto.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (elegida != null) setState(() => _fecha = elegida);
  }

  void _confirmar() {
    final centavos = Monto.aCentavos(_monto.text);
    if (centavos == null || centavos <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(Textos.montoInvalido)));
      return;
    }

    Navigator.of(context).pop((
      montoCentavos: centavos,
      fecha: _fecha,
      rutaLocal: widget.rutaLocal,
      ocrMonto: widget.lectura.montoCentavos,
      ocrFecha: widget.lectura.fecha,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final noEntendio = widget.lectura.vacia;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(Textos.confirmaElVoucher, style: tema.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              noEntendio ? Textos.noSeLeyoElVoucher : Textos.revisaLoLeido,
              style: tema.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(widget.rutaLocal),
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _monto,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              ],
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              decoration: const InputDecoration(
                labelText: Textos.cuantoPago,
                prefixText: '${Monto.simbolo} ',
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _elegirFecha,
              icon: const Icon(Icons.calendar_today),
              label: Text(FechaEnEspanol.completa(_fecha)),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _confirmar,
              child: const Text(Textos.confirmarPago),
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
