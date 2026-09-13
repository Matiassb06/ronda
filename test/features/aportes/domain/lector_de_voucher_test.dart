import 'package:flutter_test/flutter_test.dart';
import 'package:ronda/features/aportes/domain/lector_de_voucher.dart';

String soloDia(DateTime? f) =>
    f == null ? 'null' : f.toIso8601String().substring(0, 10);

void main() {
  group('Yape', () {
    test('constancia tipica', () {
      final r = LectorDeVoucher.leer('''
¡Yapeaste!
S/ 50
a Rosa Quispe Mamani
13 set. 2026 - 10:35 am
N° de operación: 12345678
''');

      expect(r.montoCentavos, 5000);
      expect(soloDia(r.fecha), '2026-09-13');
      expect(r.completa, isTrue);
    });

    test('con centimos', () {
      final r = LectorDeVoucher.leer('''
¡Yapeaste!
S/ 37.50
a Julia Ccahua
02 oct. 2026 - 08:12 am
''');
      expect(r.montoCentavos, 3750);
      expect(soloDia(r.fecha), '2026-10-02');
    });

    test('acepta sep ademas de set', () {
      final r = LectorDeVoucher.leer('S/ 50\n13 Sep 2026');
      expect(soloDia(r.fecha), '2026-09-13');
    });
  });

  group('vouchers de banco', () {
    test('constancia con etiquetas y fecha con barras', () {
      final r = LectorDeVoucher.leer('''
BANCO DE CREDITO DEL PERU
Constancia de transferencia
Monto S/ 120.00
Fecha 13/09/2026
Destino 193-12345678-0-11
''');
      expect(r.montoCentavos, 12000);
      expect(soloDia(r.fecha), '2026-09-13');
    });

    test('la comision NO se confunde con el monto', () {
      // El caso que justifica buscar por palabra clave en vez de tomar la
      // primera cifra que aparezca.
      final r = LectorDeVoucher.leer('''
Transferencia exitosa
Comision S/ 3.50
Monto transferido S/ 250.00
Fecha 13/09/2026
''');
      expect(r.montoCentavos, 25000);
    });

    test('miles con coma', () {
      final r = LectorDeVoucher.leer('Monto S/ 1,250.50\nFecha 13/09/2026');
      expect(r.montoCentavos, 125050);
    });

    test('miles con punto, como lo escriben algunos bancos', () {
      final r = LectorDeVoucher.leer('Monto S/ 1.250,50\nFecha 13/09/2026');
      expect(r.montoCentavos, 125050);
    });

    test('S/. con punto tambien vale', () {
      final r = LectorDeVoucher.leer('Importe S/. 80.00');
      expect(r.montoCentavos, 8000);
    });

    test('fecha con guiones', () {
      final r = LectorDeVoucher.leer('Monto S/ 50.00\n13-09-2026');
      expect(soloDia(r.fecha), '2026-09-13');
    });

    test('anio de dos digitos', () {
      final r = LectorDeVoucher.leer('S/ 50\n13/09/26');
      expect(soloDia(r.fecha), '2026-09-13');
    });

    test('mes escrito completo', () {
      final r = LectorDeVoucher.leer('S/ 50\n13 de setiembre de 2026');
      expect(soloDia(r.fecha), '2026-09-13');
    });
  });

  group('cuando el OCR no entendio', () {
    test('texto sin nada util devuelve todo en null', () {
      final r = LectorDeVoucher.leer('foto borrosa sin datos');
      expect(r.montoCentavos, isNull);
      expect(r.fecha, isNull);
      expect(r.vacia, isTrue);
    });

    test('texto vacio no revienta', () {
      final r = LectorDeVoucher.leer('');
      expect(r.vacia, isTrue);
    });

    test('solo monto: la fecha la pone ella', () {
      final r = LectorDeVoucher.leer('S/ 50');
      expect(r.montoCentavos, 5000);
      expect(r.fecha, isNull);
      expect(r.completa, isFalse);
    });

    test('solo fecha: el monto lo pone ella', () {
      final r = LectorDeVoucher.leer('13/09/2026');
      expect(r.montoCentavos, isNull);
      expect(soloDia(r.fecha), '2026-09-13');
      expect(r.completa, isFalse);
    });

    // Prefiere no saber antes que inventar.
    test('una fecha imposible se descarta, no se corre al mes siguiente', () {
      final r = LectorDeVoucher.leer('S/ 50\n31/02/2026');
      expect(r.fecha, isNull);
    });

    test('un mes 13 no pasa', () {
      final r = LectorDeVoucher.leer('S/ 50\n13/13/2026');
      expect(r.fecha, isNull);
    });

    test('un numero de operacion no se lee como fecha', () {
      final r = LectorDeVoucher.leer('S/ 50\nN de operacion: 12345678');
      expect(r.fecha, isNull);
    });

    test('un numero suelto sin S/ no se toma como monto', () {
      final r = LectorDeVoucher.leer('Codigo 987654\nCuenta 193456789');
      expect(r.montoCentavos, isNull);
    });
  });

  group('bordes del formato', () {
    test('el espacio entre S y / no molesta', () {
      expect(LectorDeVoucher.leer('S / 50.00').montoCentavos, 5000);
    });

    test('minusculas tambien', () {
      expect(LectorDeVoucher.leer('monto s/ 50.00').montoCentavos, 5000);
    });

    test('el bisiesto es una fecha valida', () {
      final r = LectorDeVoucher.leer('S/ 50\n29/02/2028');
      expect(soloDia(r.fecha), '2028-02-29');
    });

    test('el 29 de febrero de un anio normal no lo es', () {
      final r = LectorDeVoucher.leer('S/ 50\n29/02/2027');
      expect(r.fecha, isNull);
    });

    test('las abreviaturas cubren los doce meses', () {
      expect(LectorDeVoucher.meses.values.toSet(), hasLength(12));
      expect(LectorDeVoucher.meses['set'], 9);
      expect(LectorDeVoucher.meses['sep'], 9);
    });
  });
}
