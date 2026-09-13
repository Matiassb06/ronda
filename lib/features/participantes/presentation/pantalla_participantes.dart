import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/textos.dart';
import '../../juntas/application/juntas.dart';
import '../domain/participante.dart';

/// Lista de participantes, con el orden en que van a cobrar.
///
/// El orden es lo delicado: en una junta real se negocia y se cambia. Por eso
/// se arrastra, y por eso la restricción de unicidad del esquema es diferible.
class PantallaParticipantes extends ConsumerWidget {
  const PantallaParticipantes({required this.juntaId, super.key});

  final String juntaId;

  Future<void> _agregar(BuildContext context, WidgetRef ref) async {
    final datos =
        await showModalBottomSheet<({String nombre, String? telefono})>(
          context: context,
          isScrollControlled: true,
          builder: (_) => const _HojaAgregar(),
        );
    if (datos == null) return;

    await ref
        .read(repositorioJuntasProvider)
        .agregarParticipante(
          juntaId: juntaId,
          nombre: datos.nombre,
          telefono: datos.telefono,
        );
    ref.invalidate(participantesDeJuntaProvider(juntaId));
  }

  Future<void> _empezar(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(repositorioJuntasProvider).generarCalendario(juntaId);
      ref.invalidate(cuadernoProvider(juntaId));
      ref.invalidate(listaDeJuntasProvider);
      if (!context.mounted) return;
      context.go('/junta/$juntaId');
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(Textos.errorGenerico)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lista = ref.watch(participantesDeJuntaProvider(juntaId));

    return Scaffold(
      appBar: AppBar(title: const Text(Textos.participantes)),
      body: lista.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(Textos.errorGenerico)),
        data: (participantes) {
          if (participantes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  Textos.sinParticipantes,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Row(
                  children: [
                    Text(
                      Textos.ordenDeCobro,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  Textos.arrastraParaOrdenar,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.only(bottom: 140),
                  itemCount: participantes.length,
                  // onReorderItem ya entrega el índice corregido: no hay que
                  // restarle uno cuando el elemento baja en la lista.
                  onReorderItem: (viejo, nuevo) async {
                    final copia = [...participantes];
                    copia.insert(nuevo, copia.removeAt(viejo));
                    await ref
                        .read(repositorioJuntasProvider)
                        .reordenarParticipantes(copia);
                    ref.invalidate(participantesDeJuntaProvider(juntaId));
                  },
                  itemBuilder: (context, i) {
                    final p = participantes[i];
                    return _Fila(
                      key: ValueKey(p.id),
                      posicion: i + 1,
                      participante: p,
                      alQuitar: () async {
                        await ref
                            .read(repositorioJuntasProvider)
                            .borrarParticipante(p.id);
                        ref.invalidate(participantesDeJuntaProvider(juntaId));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if ((lista.value ?? []).isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FilledButton.icon(
                onPressed: () => _empezar(context, ref),
                icon: const Icon(Icons.play_arrow),
                label: const Text(Textos.empezarJunta),
              ),
            ),
          FloatingActionButton.extended(
            onPressed: () => _agregar(context, ref),
            icon: const Icon(Icons.person_add),
            label: const Text(Textos.agregarParticipante),
          ),
        ],
      ),
    );
  }
}

class _Fila extends StatelessWidget {
  const _Fila({
    required this.posicion,
    required this.participante,
    required this.alQuitar,
    super.key,
  });

  final int posicion;
  final Participante participante;
  final VoidCallback alQuitar;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        child: Text(
          '$posicion',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      title: Text(participante.nombre),
      subtitle: participante.tieneTelefono
          ? Text(participante.telefono!)
          : null,
      trailing: IconButton(
        tooltip: Textos.quitarParticipante,
        icon: const Icon(Icons.close),
        onPressed: alQuitar,
      ),
    );
  }
}

/// Formulario de alta, en una hoja que sube desde abajo.
class _HojaAgregar extends StatefulWidget {
  const _HojaAgregar();

  @override
  State<_HojaAgregar> createState() => _HojaAgregarState();
}

class _HojaAgregarState extends State<_HojaAgregar> {
  final _formulario = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _telefono = TextEditingController();

  @override
  void dispose() {
    _nombre.dispose();
    _telefono.dispose();
    super.dispose();
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
          children: [
            TextFormField(
              controller: _nombre,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: Textos.nombreDeLaParticipante,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? Textos.faltaNombre : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _telefono,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ],
              decoration: const InputDecoration(
                labelText: Textos.telefonoOpcional,
              ),
              validator: (v) => Participante.telefonoEsValido(v)
                  ? null
                  : Textos.telefonoInvalido,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () {
                if (!_formulario.currentState!.validate()) return;
                Navigator.of(context).pop((
                  nombre: _nombre.text,
                  telefono: _telefono.text.isEmpty ? null : _telefono.text,
                ));
              },
              child: const Text(Textos.agregarParticipante),
            ),
          ],
        ),
      ),
    );
  }
}
