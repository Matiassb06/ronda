import 'package:flutter_test/flutter_test.dart';
import 'package:ronda/features/aportes/domain/recordatorio.dart';

void main() {
  final turno = DateTime(2026, 9, 14); // lunes

  group('Recordatorio.normalizarTelefono', () {
    test('nueve digitos limpios', () {
      expect(Recordatorio.normalizarTelefono('987654321'), '51987654321');
    });

    test('con espacios, como lo escribe la gente', () {
      expect(Recordatorio.normalizarTelefono('987 654 321'), '51987654321');
    });

    test('con guiones', () {
      expect(Recordatorio.normalizarTelefono('987-654-321'), '51987654321');
    });

    test('con +51 delante no lo duplica', () {
      expect(Recordatorio.normalizarTelefono('+51 987 654 321'), '51987654321');
      expect(Recordatorio.normalizarTelefono('51987654321'), '51987654321');
    });

    test('lo que no son nueve digitos no sirve', () {
      expect(Recordatorio.normalizarTelefono('98765432'), isNull);
      expect(Recordatorio.normalizarTelefono('9876543210'), isNull);
      expect(Recordatorio.normalizarTelefono(''), isNull);
      expect(Recordatorio.normalizarTelefono(null), isNull);
      expect(Recordatorio.normalizarTelefono('no tengo'), isNull);
    });

    test('un numero de 11 digitos que NO empieza en 51 se rechaza', () {
      expect(Recordatorio.normalizarTelefono('34987654321'), isNull);
    });
  });

  group('Recordatorio.mensaje', () {
    test('saluda por el primer nombre, no por el nombre completo', () {
      final m = Recordatorio.mensaje(
        nombreParticipante: 'Rosa Quispe Mamani',
        nombreJunta: 'Junta del mercado',
        montoCentavos: 5000,
        fechaDelTurno: turno,
      );
      expect(m, startsWith('Hola Rosa,'));
      expect(m, isNot(contains('Quispe')));
    });

    test('dice cuanto y cuando, con el dia de la semana', () {
      final m = Recordatorio.mensaje(
        nombreParticipante: 'Rosa',
        nombreJunta: 'Junta del mercado',
        montoCentavos: 5000,
        fechaDelTurno: turno,
      );
      expect(m, contains('S/ 50.00'));
      expect(m, contains('lunes 14 de setiembre'));
    });

    test('escribe setiembre, no septiembre', () {
      final m = Recordatorio.mensaje(
        nombreParticipante: 'Rosa',
        nombreJunta: 'Junta',
        montoCentavos: 5000,
        fechaDelTurno: turno,
      );
      expect(m, contains('setiembre'));
      expect(m, isNot(contains('septiembre')));
    });

    test('menciona a quien cobra, que es lo que hace pagar a tiempo', () {
      final m = Recordatorio.mensaje(
        nombreParticipante: 'Rosa',
        nombreJunta: 'Junta del mercado',
        montoCentavos: 5000,
        fechaDelTurno: turno,
        quienCobra: 'María Flores',
      );
      expect(m, contains('le toca cobrar a María'));
    });

    test('sin quien cobra, esa linea no aparece', () {
      final m = Recordatorio.mensaje(
        nombreParticipante: 'Rosa',
        nombreJunta: 'Junta',
        montoCentavos: 5000,
        fechaDelTurno: turno,
      );
      expect(m, isNot(contains('le toca cobrar')));
    });

    test('cuando ya vencio, el tono cambia sin ser grosero', () {
      final m = Recordatorio.mensaje(
        nombreParticipante: 'Rosa',
        nombreJunta: 'Junta',
        montoCentavos: 5000,
        fechaDelTurno: turno,
        yaVencio: true,
      );
      expect(m, contains('todavía falta'));
      expect(m.toLowerCase(), isNot(contains('deuda')));
      expect(m.toLowerCase(), isNot(contains('moroso')));
    });

    test('va en varias lineas', () {
      final m = Recordatorio.mensaje(
        nombreParticipante: 'Rosa',
        nombreJunta: 'Junta',
        montoCentavos: 5000,
        fechaDelTurno: turno,
        quienCobra: 'María',
      );
      expect(m.split('\n'), hasLength(4));
    });
  });

  group('Recordatorio.enlaceDeWhatsApp', () {
    test('apunta a wa.me con el codigo de Peru', () {
      final url = Recordatorio.enlaceDeWhatsApp(
        telefono: '987654321',
        mensaje: 'hola',
      );
      expect(url, isNotNull);
      expect(url!.host, 'wa.me');
      expect(url.path, '/51987654321');
    });

    test('sin telefono no hay enlace: la pantalla oculta el boton', () {
      expect(
        Recordatorio.enlaceDeWhatsApp(telefono: null, mensaje: 'hola'),
        isNull,
      );
      expect(
        Recordatorio.enlaceDeWhatsApp(telefono: '12', mensaje: 'hola'),
        isNull,
      );
    });

    // Lo que rompe de verdad este tipo de enlace.
    test('las tildes viajan codificadas y vuelven enteras', () {
      final texto = 'Le toca cobrar a María. El próximo será en año nuevo.';
      final url = Recordatorio.enlaceDeWhatsApp(
        telefono: '987654321',
        mensaje: texto,
      )!;

      expect(url.toString(), isNot(contains('í')));
      expect(url.queryParameters['text'], texto);
    });

    test('la enie sobrevive', () {
      final texto = 'Doña Begoña, el año que viene';
      final url = Recordatorio.enlaceDeWhatsApp(
        telefono: '987654321',
        mensaje: texto,
      )!;
      expect(url.queryParameters['text'], texto);
    });

    test('los saltos de linea no cortan el mensaje', () {
      final texto = 'Primera línea\nSegunda línea\nTercera';
      final url = Recordatorio.enlaceDeWhatsApp(
        telefono: '987654321',
        mensaje: texto,
      )!;

      expect(url.toString(), contains('%0A'));
      expect(url.queryParameters['text'], texto);
      expect(url.queryParameters['text']!.split('\n'), hasLength(3));
    });

    test('los signos de pregunta y admiracion no rompen la query', () {
      final texto = '¿Puedes pagar hoy? ¡Gracias! 50% listo & contando';
      final url = Recordatorio.enlaceDeWhatsApp(
        telefono: '987654321',
        mensaje: texto,
      )!;

      expect(url.queryParameters['text'], texto);
      expect(url.queryParameters.keys, hasLength(1));
    });

    test('ida y vuelta del mensaje real completo', () {
      final texto = Recordatorio.mensaje(
        nombreParticipante: 'Rosa Quispe',
        nombreJunta: 'Junta del mercado',
        montoCentavos: 125050,
        fechaDelTurno: DateTime(2027, 3, 31),
        quienCobra: 'María Ccahua',
      );
      final url = Recordatorio.enlaceDeWhatsApp(
        telefono: '987 654 321',
        mensaje: texto,
      )!;

      expect(url.queryParameters['text'], texto);
      expect(texto, contains('S/ 1,250.50'));
      expect(texto, contains('miércoles 31 de marzo'));
    });
  });
}
