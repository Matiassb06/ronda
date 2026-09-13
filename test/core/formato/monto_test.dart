import 'package:flutter_test/flutter_test.dart';
import 'package:ronda/core/formato/monto.dart';

/// El formateador de montos es Dart puro y toca plata, asi que es de lo poco
/// que se testea a fondo. Un error aqui no rompe la app: hace que una senora le
/// cobre de menos a doce personas durante un ano sin darse cuenta.
void main() {
  group('Monto.formatear', () {
    test('cero se muestra completo, no vacio', () {
      expect(Monto.formatear(0), 'S/ 0.00');
    });

    test('un centimo', () {
      expect(Monto.formatear(1), 'S/ 0.01');
    });

    test('menos de un sol conserva los dos decimales', () {
      expect(Monto.formatear(50), 'S/ 0.50');
      expect(Monto.formatear(99), 'S/ 0.99');
    });

    test('un sol exacto', () {
      expect(Monto.formatear(100), 'S/ 1.00');
    });

    test('decenas y centenas sin separador', () {
      expect(Monto.formatear(5000), 'S/ 50.00');
      expect(Monto.formatear(99999), 'S/ 999.99');
    });

    test('los miles llevan coma', () {
      expect(Monto.formatear(100000), 'S/ 1,000.00');
      expect(Monto.formatear(125000), 'S/ 1,250.00');
    });

    test('decenas y centenas de miles', () {
      expect(Monto.formatear(1234567), 'S/ 12,345.67');
      expect(Monto.formatear(99999999), 'S/ 999,999.99');
    });

    test('millones llevan dos comas', () {
      expect(Monto.formatear(100000000), 'S/ 1,000,000.00');
      expect(Monto.formatear(123456789), 'S/ 1,234,567.89');
    });

    test('negativos: el signo va antes de la cifra', () {
      expect(Monto.formatear(-125000), 'S/ -1,250.00');
      expect(Monto.formatear(-1), 'S/ -0.01');
    });

    test('sin simbolo, para cuando la moneda se dibuja aparte', () {
      expect(Monto.formatearSinSimbolo(125000), '1,250.00');
    });
  });

  group('Monto.aCentavos', () {
    test('entero sin decimales', () {
      expect(Monto.aCentavos('1250'), 125000);
    });

    test('con punto decimal', () {
      expect(Monto.aCentavos('1250.50'), 125050);
    });

    test('con coma decimal, porque el teclado del telefono las confunde', () {
      expect(Monto.aCentavos('1250,50'), 125050);
    });

    test('con separador de miles y decimales', () {
      expect(Monto.aCentavos('1,250.50'), 125050);
    });

    test('con el simbolo pegado adelante', () {
      expect(Monto.aCentavos('S/ 1250'), 125000);
      expect(Monto.aCentavos('S/1250.50'), 125050);
    });

    test('un solo decimal se completa a dos', () {
      expect(Monto.aCentavos('10.5'), 1050);
    });

    test('tres digitos tras el separador son miles, no decimales', () {
      expect(Monto.aCentavos('1.250'), 125000);
      expect(Monto.aCentavos('1,250'), 125000);
    });

    test('espacios alrededor no molestan', () {
      expect(Monto.aCentavos('  1250.50  '), 125050);
    });

    test('lo que no es un monto devuelve null, nunca cero', () {
      expect(Monto.aCentavos(''), isNull);
      expect(Monto.aCentavos('   '), isNull);
      expect(Monto.aCentavos('abc'), isNull);
      expect(Monto.aCentavos('12.3a'), isNull);
      expect(Monto.aCentavos('1250.5555'), isNull);
    });

    test('ida y vuelta: formatear y volver a leer da lo mismo', () {
      for (final centavos in [0, 1, 50, 100, 125000, 123456789]) {
        expect(Monto.aCentavos(Monto.formatear(centavos)), centavos);
      }
    });
  });
}
