import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/formato/monto.dart';
import '../../../l10n/textos.dart';
import '../application/juntas.dart';
import '../domain/junta.dart';

/// Corregir el nombre y, si todavía se puede, el monto de una junta.
///
/// Faltaba, y era un agujero feo: un cero de más al crearla dejaba la junta
/// inservible y sin forma de arreglarla salvo borrarla y volver a escribir a
/// todas las participantes.
///
/// **El monto se bloquea una vez generado el calendario.** Los aportes ya
/// llevan su monto copiado, así que cambiarlo dejaría el pozo distinto de la
/// suma de lo que cada una tiene que poner, y nadie sabría cuál de los dos
/// números es el bueno.
class HojaEditarJunta extends ConsumerStatefulWidget {
  const HojaEditarJunta({required this.junta, super.key});

  final Junta junta;

  @override
  ConsumerState<HojaEditarJunta> createState() => _HojaEditarJuntaState();
}

class _HojaEditarJuntaState extends ConsumerState<HojaEditarJunta> {
  final _formulario = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _monto;

  bool _cargando = true;
  bool _puedeCambiarMonto = false;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.junta.nombre);
    _monto = TextEditingController(
      text: Monto.formatearSinSimbolo(widget.junta.montoAporteCentavos),
    );
    _mirarSiYaEmpezo();
  }

  Future<void> _mirarSiYaEmpezo() async {
    final tiene = await ref
        .read(repositorioJuntasProvider)
        .tieneCalendario(widget.junta.id);
    if (!mounted) return;
    setState(() {
      _puedeCambiarMonto = !tiene;
      _cargando = false;
    });
  }

  @override
  void dispose() {
    _nombre.dispose();
    _monto.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formulario.currentState!.validate()) return;

    await ref
        .read(repositorioJuntasProvider)
        .editarJunta(
          juntaId: widget.junta.id,
          nombre: _nombre.text,
          montoAporteCentavos: _puedeCambiarMonto
              ? Monto.aCentavos(_monto.text)
              : null,
        );

    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text(Textos.guardadoOk)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formulario,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              Textos.editarJunta,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nombre,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: Textos.nombreDeLaJunta,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? Textos.faltaNombre : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _monto,
              enabled: _puedeCambiarMonto,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              ],
              decoration: InputDecoration(
                labelText: Textos.cuantoPoneCadaUna,
                prefixText: '${Monto.simbolo} ',
                helperText: _cargando
                    ? null
                    : _puedeCambiarMonto
                    ? null
                    : Textos.elMontoNoSeCambia,
                helperMaxLines: 3,
              ),
              validator: (v) {
                if (!_puedeCambiarMonto) return null;
                if (v == null || v.trim().isEmpty) return Textos.faltaMonto;
                final centavos = Monto.aCentavos(v);
                if (centavos == null || centavos <= 0) {
                  return Textos.montoInvalido;
                }
                return null;
              },
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _cargando ? null : _guardar,
              child: const Text(Textos.guardar),
            ),
          ],
        ),
      ),
    );
  }
}
