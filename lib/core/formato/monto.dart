/// Formato de montos de dinero.
///
/// Dart puro, sin un solo import de Flutter: esta es la clase que los tests
/// tocan de verdad. Toda la plata del proyecto se mueve en enteros de centavos,
/// nunca en `double`. Un `double` que representa soles pierde centavos al
/// sumar, y aqui se suman aportes de doce personas durante un ano.
library;

/// Convierte centavos a texto listo para mostrar.
///
/// `125000` se vuelve `S/ 1,250.00`: coma para los miles, punto para los
/// decimales, que es como se escribe en Peru.
class Monto {
  const Monto._();

  /// Simbolo de la moneda. La app es solo para Peru, asi que no se parametriza.
  static const String simbolo = 'S/';

  /// `125000` -> `S/ 1,250.00`
  static String formatear(int centavos) {
    return '$simbolo ${formatearSinSimbolo(centavos)}';
  }

  /// `125000` -> `1,250.00`
  ///
  /// Util cuando el simbolo se dibuja aparte, mas pequeno que la cifra.
  static String formatearSinSimbolo(int centavos) {
    final negativo = centavos < 0;
    final absoluto = centavos.abs();

    final soles = absoluto ~/ 100;
    final resto = absoluto % 100;

    final enteroConSeparadores = _separarMiles(soles);
    final decimales = resto.toString().padLeft(2, '0');

    return '${negativo ? '-' : ''}$enteroConSeparadores.$decimales';
  }

  /// Inserta una coma cada tres digitos, empezando por la derecha.
  static String _separarMiles(int valor) {
    final digitos = valor.toString();
    if (digitos.length <= 3) return digitos;

    final partes = <String>[];
    var corte = digitos.length;
    while (corte > 3) {
      partes.add(digitos.substring(corte - 3, corte));
      corte -= 3;
    }
    partes.add(digitos.substring(0, corte));

    return partes.reversed.join(',');
  }

  /// Convierte lo que la cabeza de junta escribio a centavos.
  ///
  /// Acepta `1250`, `1250.50`, `1,250.50`, `S/ 1250` y `1250,50`, porque en el
  /// teclado del telefono la coma y el punto se confunden. Devuelve `null` si
  /// el texto no es un monto, para que la pantalla muestre el error en vez de
  /// guardar un cero silencioso.
  static int? aCentavos(String texto) {
    var limpio = texto.trim().replaceAll(simbolo, '').trim();
    if (limpio.isEmpty) return null;

    // La ultima coma o punto es el separador decimal; los demas son de miles.
    final ultimoSeparador = limpio.lastIndexOf(RegExp(r'[.,]'));
    if (ultimoSeparador == -1) {
      final soles = int.tryParse(limpio);
      return soles == null ? null : soles * 100;
    }

    final parteEntera = limpio
        .substring(0, ultimoSeparador)
        .replaceAll(RegExp(r'[.,]'), '');
    final parteDecimal = limpio.substring(ultimoSeparador + 1);

    // Tres digitos despues del separador significan que era separador de miles.
    if (parteDecimal.length == 3 && !parteDecimal.contains(RegExp(r'\D'))) {
      final soles = int.tryParse('$parteEntera$parteDecimal');
      return soles == null ? null : soles * 100;
    }

    if (parteDecimal.length > 2 || parteDecimal.contains(RegExp(r'\D'))) {
      return null;
    }
    if (parteEntera.contains(RegExp(r'\D'))) return null;

    final soles = parteEntera.isEmpty ? 0 : int.tryParse(parteEntera);
    final centavos = int.tryParse(parteDecimal.padRight(2, '0'));
    if (soles == null || centavos == null) return null;

    return soles * 100 + centavos;
  }
}
