import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/formato/monto.dart';
import '../../../l10n/textos.dart';
import '../application/juntas.dart';
import '../domain/frecuencia.dart';

/// Crear una junta: cuatro preguntas y listo.
///
/// Deliberadamente corto. Cada campo extra es una razón más para que la cabeza
/// de junta abandone y vuelva al cuaderno de papel, que no le pregunta nada.
class PantallaCrearJunta extends ConsumerStatefulWidget {
  const PantallaCrearJunta({super.key});

  @override
  ConsumerState<PantallaCrearJunta> createState() => _PantallaCrearJuntaState();
}

class _PantallaCrearJuntaState extends ConsumerState<PantallaCrearJunta> {
  final _formulario = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _monto = TextEditingController();

  Frecuencia _frecuencia = Frecuencia.mensual;
  DateTime _inicio = DateTime.now();
  bool _guardando = false;

  @override
  void dispose() {
    _nombre.dispose();
    _monto.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final hoy = DateTime.now();
    final elegida = await showDatePicker(
      context: context,
      initialDate: _inicio,
      firstDate: DateTime(hoy.year - 1),
      lastDate: DateTime(hoy.year + 3),
      locale: const Locale('es'),
    );
    if (elegida != null) setState(() => _inicio = elegida);
  }

  Future<void> _guardar() async {
    if (!_formulario.currentState!.validate()) return;

    setState(() => _guardando = true);
    try {
      final junta = await ref
          .read(repositorioJuntasProvider)
          .crearJunta(
            nombre: _nombre.text,
            montoAporteCentavos: Monto.aCentavos(_monto.text)!,
            frecuencia: _frecuencia,
            fechaInicio: _inicio,
          );
      if (!mounted) return;
      // Recién creada no tiene a nadie: el paso siguiente es agregarlas.
      context.go('/junta/${junta.id}/participantes');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(Textos.errorGenerico)));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Textos.nuevaJunta)),
      body: Form(
        key: _formulario,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nombre,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: Textos.nombreDeLaJunta,
                hintText: Textos.ejemploNombreJunta,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? Textos.faltaNombre : null,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _monto,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              ],
              decoration: const InputDecoration(
                labelText: Textos.cuantoPoneCadaUna,
                prefixText: '${Monto.simbolo} ',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return Textos.faltaMonto;
                final centavos = Monto.aCentavos(v);
                if (centavos == null || centavos <= 0) {
                  return Textos.montoInvalido;
                }
                return null;
              },
            ),
            const SizedBox(height: 28),
            Text(
              Textos.cadaCuanto,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            // Fila propia en vez de RadioListTile: dentro de un RadioGroup el
            // tile se pinta como deshabilitado y el texto queda en un gris
            // ilegible. Esta app se lee con sol encima, así que el contraste
            // no es negociable.
            RadioGroup<Frecuencia>(
              groupValue: _frecuencia,
              onChanged: (v) => setState(() => _frecuencia = v!),
              child: Column(
                children: [
                  for (final f in Frecuencia.values)
                    InkWell(
                      onTap: () => setState(() => _frecuencia = f),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Radio<Frecuencia>(value: f),
                            const SizedBox(width: 8),
                            Text(
                              f.etiqueta,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              Textos.cuandoEmpieza,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _elegirFecha,
              icon: const Icon(Icons.calendar_today),
              label: Text(_fechaLegible(_inicio)),
            ),
            const SizedBox(height: 36),
            FilledButton(
              onPressed: _guardando ? null : _guardar,
              child: Text(_guardando ? Textos.cargando : Textos.guardar),
            ),
          ],
        ),
      ),
    );
  }
}

const _meses = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'setiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

/// `14 de setiembre de 2026`. En Perú se dice setiembre, no septiembre.
String _fechaLegible(DateTime f) =>
    '${f.day} de ${_meses[f.month - 1]} de ${f.year}';
