import 'package:flutter_test/flutter_test.dart';
import 'package:ronda/core/ids.dart';

void main() {
  group('Ids.uuid', () {
    final formato = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    );

    test('tiene el formato que acepta una columna uuid de Postgres', () {
      for (var i = 0; i < 200; i++) {
        expect(Ids.uuid(), matches(formato));
      }
    });

    test('la version es 4 y la variante es RFC 4122', () {
      final partes = Ids.uuid().split('-');
      expect(partes[2][0], '4');
      expect('89ab'.contains(partes[3][0]), isTrue);
    });

    test('no se repite', () {
      final vistos = <String>{};
      for (var i = 0; i < 5000; i++) {
        expect(vistos.add(Ids.uuid()), isTrue);
      }
    });
  });

  group('Ids.codigoDeJunta', () {
    test('son seis caracteres', () {
      for (var i = 0; i < 200; i++) {
        expect(Ids.codigoDeJunta(), hasLength(6));
      }
    });

    test('coincide con el CHECK del esquema', () {
      final formato = RegExp(r'^[A-Z0-9]{6}$');
      for (var i = 0; i < 200; i++) {
        expect(Ids.codigoDeJunta(), matches(formato));
      }
    });

    test('nunca usa O, 0, I ni 1: el codigo se dicta hablando', () {
      for (var i = 0; i < 500; i++) {
        final codigo = Ids.codigoDeJunta();
        for (final prohibido in ['O', '0', 'I', '1']) {
          expect(
            codigo.contains(prohibido),
            isFalse,
            reason: '$codigo trae un $prohibido, que se confunde al dictarlo',
          );
        }
      }
    });

    test('el alfabeto es el mismo que el de la funcion de Postgres', () {
      expect(Ids.alfabetoCodigo, 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789');
      expect(Ids.alfabetoCodigo.length, 32);
    });

    test('reparte, no se queda pegado en una letra', () {
      final letras = <String>{};
      for (var i = 0; i < 400; i++) {
        letras.addAll(Ids.codigoDeJunta().split(''));
      }
      expect(letras.length, greaterThan(25));
    });
  });
}
