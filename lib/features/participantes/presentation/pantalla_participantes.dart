import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repositorio_juntas.dart';
import '../../../l10n/textos.dart';
import '../../juntas/application/juntas.dart';
import '../domain/participante.dart';

/// Lista de participantes, con el orden en que van a cobrar.
///
/// Una vez generado el calendario, **la lista se congela**: se puede corregir un
/// nombre o un teléfono, pero no agregar ni quitar a nadie. No es una limitación
/// técnica que se pueda levantar: en Postgres las claves de turnos y aportes son
/// ON DELETE RESTRICT, así que un borrado se aceptaría en el teléfono y lo
/// rechazaría el servidor, dejando las dos bases distintas sin que nadie lo
/// note. Y en la vida real, cambiar quién participa a mitad de junta es algo
/// que se conversa, no que se resuelve con un botón.
class PantallaParticipantes extends ConsumerWidget {
  const PantallaParticipantes({required this.juntaId, super.key});

  final String juntaId;

  void _avisar(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _agregar(BuildContext context, WidgetRef ref) async {
    final datos = await showModalBottomSheet<_DatosDeParticipante>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _HojaDeParticipante(),
    );
    if (datos == null) return;

    try {
      await ref
          .read(repositorioJuntasProvider)
          .agregarParticipante(
            juntaId: juntaId,
            nombre: datos.nombre,
            telefono: datos.telefono,
          );
    } on JuntaYaEmpezada {
      if (context.mounted) _avisar(context, Textos.juntaYaEmpezada);
    }
  }

  Future<void> _editar(
    BuildContext context,
    WidgetRef ref,
    Participante p,
  ) async {
    final datos = await showModalBottomSheet<_DatosDeParticipante>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _HojaDeParticipante(inicial: p),
    );
    if (datos == null) return;

    await ref
        .read(repositorioJuntasProvider)
        .editarParticipante(
          participanteId: p.id,
          nombre: datos.nombre,
          telefono: datos.telefono,
        );
  }

  Future<void> _quitar(
    BuildContext context,
    WidgetRef ref,
    Participante p,
  ) async {
    try {
      await ref
          .read(repositorioJuntasProvider)
          .borrarParticipante(participanteId: p.id, juntaId: juntaId);
    } on JuntaYaEmpezada {
      if (context.mounted) _avisar(context, Textos.juntaYaEmpezada);
    }
  }

  Future<void> _empezar(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(repositorioJuntasProvider).generarCalendario(juntaId);
      if (!context.mounted) return;
      context.go('/junta/$juntaId');
    } catch (_) {
      if (context.mounted) _avisar(context, Textos.errorGenerico);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lista = ref.watch(participantesDeJuntaProvider(juntaId));
    final turnos = ref.watch(turnosDeJuntaProvider(juntaId)).value ?? const [];
    final yaEmpezo = turnos.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text(Textos.participantes)),
      body: lista.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text(Textos.errorGenerico)),
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
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Textos.ordenDeCobro,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      yaEmpezo
                          ? Textos.listaCongelada
                          : Textos.arrastraParaOrdenar,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: yaEmpezo
                    ? ListView(
                        padding: const EdgeInsets.only(bottom: 100),
                        children: [
                          for (var i = 0; i < participantes.length; i++)
                            _Fila(
                              posicion: i + 1,
                              participante: participantes[i],
                              alEditar: () =>
                                  _editar(context, ref, participantes[i]),
                              alQuitar: null,
                            ),
                        ],
                      )
                    : ReorderableListView.builder(
                        padding: const EdgeInsets.only(bottom: 140),
                        itemCount: participantes.length,
                        // onReorderItem ya entrega el índice corregido: no hay
                        // que restarle uno cuando el elemento baja en la lista.
                        onReorderItem: (viejo, nuevo) async {
                          final copia = [...participantes];
                          copia.insert(nuevo, copia.removeAt(viejo));
                          await ref
                              .read(repositorioJuntasProvider)
                              .reordenarParticipantes(copia);
                        },
                        itemBuilder: (context, i) {
                          final p = participantes[i];
                          return _Fila(
                            key: ValueKey(p.id),
                            posicion: i + 1,
                            participante: p,
                            alEditar: () => _editar(context, ref, p),
                            alQuitar: () => _quitar(context, ref, p),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: yaEmpezo
          ? null
          : Column(
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
    required this.alEditar,
    required this.alQuitar,
    super.key,
  });

  final int posicion;
  final Participante participante;
  final VoidCallback alEditar;

  /// Null cuando la junta ya empezó: la lista está congelada.
  final VoidCallback? alQuitar;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: alEditar,
      leading: CircleAvatar(
        radius: 24,
        child: Text(
          '$posicion',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      title: Text(participante.nombre),
      subtitle: Text(
        participante.tieneTelefono
            ? participante.telefono!
            : Textos.sinTelefono,
        style: participante.tieneTelefono
            ? null
            : TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      trailing: alQuitar == null
          ? const Icon(Icons.edit_outlined, size: 24)
          : IconButton(
              tooltip: Textos.quitarParticipante,
              icon: const Icon(Icons.close),
              onPressed: alQuitar,
            ),
    );
  }
}

typedef _DatosDeParticipante = ({String nombre, String? telefono});

/// Alta y edición en la misma hoja.
class _HojaDeParticipante extends StatefulWidget {
  const _HojaDeParticipante({this.inicial});

  /// Null al agregar; con valor al corregir a alguien que ya existe.
  final Participante? inicial;

  @override
  State<_HojaDeParticipante> createState() => _HojaDeParticipanteState();
}

class _HojaDeParticipanteState extends State<_HojaDeParticipante> {
  final _formulario = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _telefono;

  bool get _editando => widget.inicial != null;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.inicial?.nombre ?? '');
    _telefono = TextEditingController(text: widget.inicial?.telefono ?? '');
  }

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
              autofocus: !_editando,
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
                helperText: Textos.paraQueSirveElTelefono,
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
              child: Text(
                _editando ? Textos.guardar : Textos.agregarParticipante,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
