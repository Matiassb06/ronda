import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/avisos/avisos.dart';
import '../../../core/formato/fecha.dart';
import '../../../core/formato/monto.dart';
import '../../../core/tema/tema_ronda.dart';
import '../../../l10n/textos.dart';
import '../../juntas/application/juntas.dart';
import '../../participantes/domain/participante.dart';
import '../domain/aporte.dart';
import '../../../core/ocr/lector_ocr.dart';
import '../domain/lector_de_voucher.dart';
import '../domain/recordatorio.dart';
import 'hoja_de_voucher.dart';

/// El cuaderno. Esta es la app.
///
/// Una lista de nombres con un check al costado, y arriba quién cobra y cuánto
/// se lleva juntado. Nada más. Se usa con el pulgar, de pie, con sol encima y
/// una señora esperando enfrente: cada toque tiene que resolver algo.
class PantallaCuaderno extends ConsumerStatefulWidget {
  const PantallaCuaderno({required this.juntaId, super.key});

  final String juntaId;

  @override
  ConsumerState<PantallaCuaderno> createState() => _PantallaCuadernoState();
}

class _PantallaCuadernoState extends ConsumerState<PantallaCuaderno> {
  /// Número del turno que se está mirando. Null significa "el que está en
  /// curso", que es lo que se quiere al abrir la pantalla.
  ///
  /// Poder moverse entre turnos no es un lujo: en una junta semanal el dinero
  /// entra cada semana, y antes una participante que no pagaba dejaba la app
  /// clavada en esa semana sin dónde anotar las siguientes.
  int? _turnoElegido;

  String get juntaId => widget.juntaId;

  @override
  Widget build(BuildContext context) {
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
        actions: [
          const _AvisoPendientes(),
          IconButton(
            tooltip: Textos.verCalendario,
            icon: const Icon(Icons.event_note, size: 26),
            onPressed: () => context.go('/junta/$juntaId/calendario'),
          ),
          IconButton(
            tooltip: Textos.verHistorial,
            icon: const Icon(Icons.bar_chart, size: 26),
            onPressed: () => context.go('/junta/$juntaId/historial'),
          ),
        ],
      ),
      body: cuaderno == null
          ? const Center(child: CircularProgressIndicator())
          : _Contenido(
              cuaderno: cuaderno,
              turnoElegido: _turnoElegido,
              alCambiarDeTurno: (numero) =>
                  setState(() => _turnoElegido = numero),
            ),
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
  const _Contenido({
    required this.cuaderno,
    required this.turnoElegido,
    required this.alCambiarDeTurno,
  });

  final CuadernoDelTurno cuaderno;

  /// Null significa el turno en curso.
  final int? turnoElegido;

  final void Function(int? numero) alCambiarDeTurno;

  /// El turno que se está mirando: el elegido, o el que está en curso, o el
  /// último si la junta ya terminó.
  Turno? get turnoMirado {
    if (cuaderno.turnos.isEmpty) return null;
    if (turnoElegido != null) {
      for (final t in cuaderno.turnos) {
        if (t.numero == turnoElegido) return t;
      }
    }
    return cuaderno.turnoActual ?? cuaderno.turnos.last;
  }

  /// Abre el chat de WhatsApp con el mensaje ya escrito.
  ///
  /// La app no manda nada: deja el texto listo y ella le da enviar desde su
  /// propio número. A ella le contestan; a un número desconocido, no.
  Future<void> _recordar(
    BuildContext context,
    Participante participante,
    Aporte aporte,
  ) async {
    final turno = turnoMirado;
    if (turno == null) return;

    final texto = Recordatorio.mensaje(
      nombreParticipante: participante.nombre,
      nombreJunta: cuaderno.junta.nombre,
      montoCentavos: aporte.montoCentavos,
      fechaDelTurno: turno.fechaProgramada,
      quienCobra: cuaderno.quienCobraEn(turno)?.nombre,
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

  /// Foto del voucher, OCR y confirmación.
  ///
  /// Nada se guarda hasta que ella confirma en la hoja: esa es la regla 9 del
  /// CLAUDE.md, y por eso el OCR solo prellena campos editables.
  Future<void> _conVoucher(
    BuildContext context,
    WidgetRef ref,
    Aporte aporte,
  ) async {
    final foto = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxWidth: 1600,
    );
    if (foto == null || !context.mounted) return;

    final lector = LectorOcr();
    final texto = await lector.leerTexto(foto.path);
    await lector.cerrar();
    if (!context.mounted) return;

    final confirmado = await showModalBottomSheet<VoucherConfirmado>(
      context: context,
      isScrollControlled: true,
      builder: (_) => HojaDeVoucher(
        rutaLocal: foto.path,
        lectura: LectorDeVoucher.leer(texto),
        montoEsperadoCentavos: aporte.montoCentavos,
      ),
    );
    if (confirmado == null) return;

    await ref
        .read(repositorioJuntasProvider)
        .registrarPagoConVoucher(
          aporteId: aporte.id,
          montoCentavos: confirmado.montoCentavos,
          fechaDelPago: confirmado.fecha,
          rutaLocalDeLaFoto: confirmado.rutaLocal,
          ocrMontoCentavos: confirmado.ocrMonto,
          ocrFecha: confirmado.ocrFecha,
        );
  }

  Future<void> _alternar(WidgetRef ref, Aporte aporte) async {
    await ref
        .read(repositorioJuntasProvider)
        .marcarAporte(aporteId: aporte.id, pagado: !aporte.estaPagado);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!cuaderno.tieneCalendario) {
      return const _Aviso(mensaje: Textos.sinCalendario);
    }

    final turno = turnoMirado;
    if (turno == null) return const _Aviso(mensaje: Textos.sinCalendario);

    final aportes = cuaderno.aportesDe(turno);
    final resumen = cuaderno.resumenDe(turno);
    final quienCobra = cuaderno.quienCobraEn(turno);

    return Column(
      children: [
        _Cabecera(
          cuaderno: cuaderno,
          turno: turno,
          quienCobra: quienCobra,
          resumen: resumen,
          alCambiarDeTurno: alCambiarDeTurno,
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: cuaderno.participantes.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final participante = cuaderno.participantes[i];
              final aporte = aportes[participante.id];
              if (aporte == null) return const SizedBox.shrink();

              return _FilaDelCuaderno(
                participante: participante,
                aporte: aporte,
                esQuienCobra: participante.id == quienCobra?.id,
                alTocar: () => _alternar(ref, aporte),
                alRecordar: participante.tieneTelefono && !aporte.estaPagado
                    ? () => _recordar(context, participante, aporte)
                    : null,
                alFotografiar: aporte.estaPagado
                    ? null
                    : () => _conVoucher(context, ref, aporte),
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
    required this.turno,
    required this.quienCobra,
    required this.resumen,
    required this.alCambiarDeTurno,
  });

  final CuadernoDelTurno cuaderno;
  final Turno turno;
  final Participante? quienCobra;
  final ResumenDeTurno resumen;
  final void Function(int? numero) alCambiarDeTurno;

  /// Cierra el turno aunque falte gente por pagar.
  ///
  /// En una junta real el pozo se entrega igual y quien debe queda debiendo: la
  /// vida sigue y la semana siguiente también. Antes el botón solo aparecía con
  /// todo cobrado, así que una sola participante morosa dejaba la junta clavada
  /// sin forma de anotar las semanas que venían.
  Future<void> _entregar(BuildContext context, WidgetRef ref) async {
    if (!resumen.estaCompleto) {
      final seguir = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(Textos.entregarSinCobrarTodo),
          content: Text(
            '${Textos.faltanPorPagar} ${resumen.faltan}.\n\n'
            '${Textos.entregarSinCobrarTodoDetalle}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(Textos.cancelar),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(Textos.entregarIgual),
            ),
          ],
        ),
      );
      if (seguir != true) return;
    }

    await ref
        .read(repositorioJuntasProvider)
        .completarTurno(turno.id, juntaId: cuaderno.junta.id);
    alCambiarDeTurno(null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    final primero = turno.numero <= 1;
    final ultimo = turno.numero >= cuaderno.turnos.length;

    return Container(
      width: double.infinity,
      color: tema.colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Moverse entre semanas. Sin esto, el cuaderno solo dejaba tocar
              // el turno en curso.
              IconButton(
                tooltip: Textos.turnoAnterior,
                icon: const Icon(Icons.chevron_left, size: 30),
                onPressed: primero
                    ? null
                    : () => alCambiarDeTurno(turno.numero - 1),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
              Text(
                '${Textos.turnoDe} ${turno.numero} ${Textos.de} ${cuaderno.turnos.length}',
                style: tema.textTheme.bodyMedium,
              ),
              IconButton(
                tooltip: Textos.turnoSiguiente,
                icon: const Icon(Icons.chevron_right, size: 30),
                onPressed: ultimo
                    ? null
                    : () => alCambiarDeTurno(turno.numero + 1),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
              const Spacer(),
              if (turno.completado)
                _Etiqueta(
                  texto: Textos.turnoEntregado,
                  color: tema.colorScheme.primary,
                )
              else if (resumen.estaAtrasado)
                _Etiqueta(
                  texto:
                      '${Textos.atrasadoPorDias} ${resumen.diasDeAtraso} ${resumen.diasDeAtraso == 1 ? Textos.dia : Textos.dias}',
                  color: tema.colorScheme.error,
                ),
            ],
          ),
          const SizedBox(height: 6),
          // La pregunta número uno de una junta es cuándo hay que pagar. Antes
          // esta pantalla no la respondía: decía quién cobra pero no qué día.
          Row(
            children: [
              Icon(
                Icons.event,
                size: 22,
                color: tema.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  FechaEnEspanol.conDiaDeLaSemana(turno.fechaProgramada),
                  style: tema.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
          if (!turno.completado) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _entregar(context, ref),
              icon: const Icon(Icons.check_circle_outline),
              label: Text(
                resumen.estaCompleto
                    ? Textos.entregarPozo
                    : Textos.entregarPozoIncompleto,
              ),
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
    required this.alFotografiar,
  });

  final Participante participante;
  final Aporte aporte;
  final bool esQuienCobra;
  final VoidCallback alTocar;

  /// Null cuando no hay a quién escribirle: sin teléfono, o ya pagó.
  final VoidCallback? alRecordar;

  /// Null cuando ya pagó: no hay voucher que tomar.
  final VoidCallback? alFotografiar;

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
            if (alFotografiar != null)
              IconButton(
                tooltip: Textos.tomarFotoDelVoucher,
                icon: const Icon(Icons.photo_camera_outlined, size: 28),
                onPressed: alFotografiar,
              ),
            if (alRecordar != null)
              IconButton(
                tooltip: Textos.recordarPorWhatsApp,
                icon: const Icon(Icons.chat_outlined, size: 28),
                onPressed: alRecordar,
              ),
          ],
        ),
      ),
    );
  }
}
