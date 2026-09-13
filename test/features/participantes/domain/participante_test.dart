import 'package:flutter_test/flutter_test.dart';
import 'package:ronda/features/participantes/domain/participante.dart';

void main() {
  group('Participante.telefonoEsValido', () {
    // El celular pasó de opcional a obligatorio: sin número no se le puede
    // mandar el recordatorio, que es la mitad del trabajo que la app le quita
    // de encima a la cabeza de junta.
    test('vacio ya NO vale', () {
      expect(Participante.telefonoEsValido(null), isFalse);
      expect(Participante.telefonoEsValido(''), isFalse);
      expect(Participante.telefonoEsValido('   '), isFalse);
    });

    test('nueve digitos vale', () {
      expect(Participante.telefonoEsValido('987654321'), isTrue);
    });

    test('con espacios o guiones tambien', () {
      expect(Participante.telefonoEsValido('987 654 321'), isTrue);
      expect(Participante.telefonoEsValido('987-654-321'), isTrue);
    });

    test('menos o mas de nueve no vale', () {
      expect(Participante.telefonoEsValido('98765432'), isFalse);
      expect(Participante.telefonoEsValido('9876543210'), isFalse);
    });
  });

  group('Participante, presentacion', () {
    const rosa = Participante(
      id: 'p',
      juntaId: 'j',
      nombre: 'Rosa Quispe Mamani',
      ordenTurno: 1,
      activo: true,
      telefono: '987654321',
    );

    test('el nombre corto es el primero', () {
      expect(rosa.nombreCorto, 'Rosa');
    });

    test('las iniciales son dos: primera y ultima', () {
      expect(rosa.iniciales, 'RM');
    });

    test('un solo nombre da una inicial', () {
      const solo = Participante(
        id: 'p',
        juntaId: 'j',
        nombre: 'Rosa',
        ordenTurno: 1,
        activo: true,
      );
      expect(solo.iniciales, 'R');
      expect(solo.tieneTelefono, isFalse);
    });
  });
}
