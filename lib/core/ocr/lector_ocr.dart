import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Lee el texto de una imagen, en el propio teléfono.
///
/// ML Kit corre **on-device**: no sube la foto a ningún lado y funciona sin
/// señal, que es la condición del Mercado 10. También es la razón de que sea
/// gratis y de que la foto del voucher, que lleva el nombre y el monto de una
/// persona, no salga del dispositivo hasta que ella lo decida.
class LectorOcr {
  LectorOcr();

  final TextRecognizer _reconocedor = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  /// Devuelve el texto plano de la imagen, o cadena vacía si no leyó nada.
  ///
  /// No lanza: una foto borrosa o de algo que no es un voucher es un caso
  /// normal, no un error. El parseo de lo que salga es cosa de
  /// `LectorDeVoucher`.
  Future<String> leerTexto(String rutaDeLaImagen) async {
    try {
      final resultado = await _reconocedor.processImage(
        InputImage.fromFilePath(rutaDeLaImagen),
      );
      return resultado.text;
    } catch (_) {
      return '';
    }
  }

  Future<void> cerrar() => _reconocedor.close();
}
