import '../../../core/formato/fecha.dart';
import '../../../core/formato/monto.dart';

/// El recordatorio que la cabeza de junta le manda a una participante.
///
/// Dart puro y con tests. La app **no manda nada**: arma el texto y abre el
/// chat de WhatsApp para que ella le dé enviar desde su propio número. Esa
/// diferencia es todo el producto: a ella le contestan, a un número desconocido
/// no.
///
/// Por eso tampoco se usa la API de WhatsApp Business: costaría plata, exigiría
/// verificación de empresa y los mensajes llegarían de un remitente que las
/// participantes no reconocen.
class Recordatorio {
  const Recordatorio._();

  /// Código de país del Perú. La app es solo para aquí.
  static const String codigoPais = '51';

  /// El texto del mensaje, tal cual lo va a leer la participante.
  ///
  /// Corto y en el tono en que se habla en una junta: se saluda por el nombre,
  /// se dice cuánto y cuándo, y se recuerda a quién le toca cobrar, porque eso
  /// es lo que hace que la gente pague a tiempo.
  static String mensaje({
    required String nombreParticipante,
    required String nombreJunta,
    required int montoCentavos,
    required DateTime fechaDelTurno,
    String? quienCobra,
    bool yaVencio = false,
  }) {
    final nombre = _primerNombre(nombreParticipante);
    final cuando = FechaEnEspanol.conDiaDeLaSemana(fechaDelTurno);
    final monto = Monto.formatear(montoCentavos);

    final lineas = <String>[
      'Hola $nombre, te escribo por la $nombreJunta.',
      yaVencio
          ? 'Tu aporte de $monto era para el $cuando y todavía falta.'
          : 'Tu aporte de $monto es para el $cuando.',
      if (quienCobra != null && quienCobra.trim().isNotEmpty)
        'Este turno le toca cobrar a ${_primerNombre(quienCobra)}.',
      '¡Gracias!',
    ];

    return lineas.join('\n');
  }

  /// El enlace que abre el chat con el mensaje ya escrito.
  ///
  /// `wa.me` no necesita API ni registro: es el enlace público de WhatsApp.
  /// Devuelve null si el teléfono no sirve, para que la pantalla pueda ocultar
  /// el botón en vez de abrir un chat con un número inventado.
  static Uri? enlaceDeWhatsApp({
    required String? telefono,
    required String mensaje,
  }) {
    final numero = normalizarTelefono(telefono);
    if (numero == null) return null;

    // encodeComponent y no encodeFull: hay que codificar también los saltos de
    // línea y los signos, no solo los espacios. Sin esto el mensaje llega
    // cortado en la primera tilde.
    return Uri.parse(
      'https://wa.me/$numero?text=${Uri.encodeComponent(mensaje)}',
    );
  }

  /// Deja el número como lo quiere `wa.me`: código de país y nueve dígitos.
  ///
  /// Acepta lo que la cabeza de junta haya escrito de verdad: con espacios, con
  /// guiones, con el +51 delante o sin nada. Devuelve null si no son nueve
  /// dígitos, que es como son todos los celulares peruanos.
  static String? normalizarTelefono(String? telefono) {
    if (telefono == null) return null;

    var digitos = telefono.replaceAll(RegExp(r'\D'), '');

    // Ya venía con el código de país, de una forma u otra.
    if (digitos.length == 11 && digitos.startsWith(codigoPais)) {
      digitos = digitos.substring(2);
    }

    if (digitos.length != 9) return null;
    return '$codigoPais$digitos';
  }

  static String _primerNombre(String nombreCompleto) {
    final partes = nombreCompleto.trim().split(RegExp(r'\s+'));
    return partes.isEmpty ? nombreCompleto.trim() : partes.first;
  }
}
