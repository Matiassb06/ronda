import 'package:flutter_test/flutter_test.dart';
import 'package:ronda/features/aportes/domain/aporte.dart';
import 'package:ronda/features/historial/domain/cumplimiento.dart';

Turno turno(String id, DateTime fecha) => Turno(
  id: id,
  juntaId: 'j',
  participanteId: 'quien-cobra',
  numero: 1,
  fechaProgramada: fecha,
  completado: false,
);

Aporte aporte(String participanteId, String turnoId, {DateTime? pagadoEn}) =>
    Aporte(
      id: '$participanteId-$turnoId',
      juntaId: 'j',
      turnoId: turnoId,
      participanteId: participanteId,
      montoCentavos: 5000,
      estado: pagadoEn == null ? EstadoAporte.pendiente : EstadoAporte.pagado,
      pagadoEn: pagadoEn,
    );

void main() {
  final t1 = DateTime(2026, 9, 14);
  final t2 = DateTime(2026, 10, 14);
  final hoy = DateTime(2026, 11, 1);

  final turnos = [turno('t1', t1), turno('t2', t2)];
  final rosa = (id: 'rosa', nombre: 'Rosa Quispe');
  final maria = (id: 'maria', nombre: 'Maria Flores');

  group('una participante impecable', () {
    test('pago los dos aportes el mismo dia del turno', () {
      final r = HistorialDeJunta.calcular(
        participantes: [rosa],
        turnos: turnos,
        aportes: [
          aporte('rosa', 't1', pagadoEn: t1),
          aporte('rosa', 't2', pagadoEn: t2),
        ],
        hoy: hoy,
      ).single;

      expect(r.pagados, 2);
      expect(r.aTiempo, 2);
      expect(r.tarde, 0);
      expect(r.puntualidad, 1);
      expect(r.avance, 1);
      expect(r.siempreATiempo, isTrue);
      expect(r.debe, isFalse);
      expect(r.resumen, 'Siempre a tiempo');
    });

    test('pagar antes del turno tambien es a tiempo', () {
      final r = HistorialDeJunta.calcular(
        participantes: [rosa],
        turnos: turnos,
        aportes: [
          aporte('rosa', 't1', pagadoEn: t1.subtract(const Duration(days: 3))),
        ],
        hoy: hoy,
      ).single;

      expect(r.aTiempo, 1);
      expect(r.tarde, 0);
    });
  });

  group('una participante que se atrasa', () {
    test('un dia despues ya es tarde: no hay dias de gracia', () {
      final r = HistorialDeJunta.calcular(
        participantes: [rosa],
        turnos: turnos,
        aportes: [
          aporte('rosa', 't1', pagadoEn: t1.add(const Duration(days: 1))),
        ],
        hoy: hoy,
      ).single;

      expect(r.tarde, 1);
      expect(r.aTiempo, 0);
      expect(r.diasPromedioDeAtraso, 1);
      expect(r.siempreATiempo, isFalse);
    });

    test('promedia los dias de atraso de lo que pago tarde', () {
      final r = HistorialDeJunta.calcular(
        participantes: [rosa],
        turnos: turnos,
        aportes: [
          aporte('rosa', 't1', pagadoEn: t1.add(const Duration(days: 2))),
          aporte('rosa', 't2', pagadoEn: t2.add(const Duration(days: 6))),
        ],
        hoy: hoy,
      ).single;

      expect(r.tarde, 2);
      expect(r.diasPromedioDeAtraso, 4);
      expect(r.resumen, contains('Se atrasó 2 veces'));
    });

    test('el resumen usa singular cuando fue una sola vez', () {
      final r = HistorialDeJunta.calcular(
        participantes: [rosa],
        turnos: turnos,
        aportes: [
          aporte('rosa', 't1', pagadoEn: t1.add(const Duration(days: 3))),
          aporte('rosa', 't2', pagadoEn: t2),
        ],
        hoy: hoy,
      ).single;

      expect(r.resumen, 'Se atrasó 1 vez, 3 días');
    });
  });

  group('una participante que debe', () {
    test('un aporte vencido y sin pagar cuenta como deuda', () {
      final r = HistorialDeJunta.calcular(
        participantes: [rosa],
        turnos: turnos,
        aportes: [aporte('rosa', 't1'), aporte('rosa', 't2')],
        hoy: hoy,
      ).single;

      expect(r.pendientes, 2);
      expect(r.pendientesVencidos, 2);
      expect(r.debe, isTrue);
      expect(r.resumen, 'Debe 2 aportes');
    });

    test('lo pendiente que aun NO vencio no es deuda', () {
      final r = HistorialDeJunta.calcular(
        participantes: [rosa],
        turnos: turnos,
        aportes: [
          aporte('rosa', 't1', pagadoEn: t1),
          aporte('rosa', 't2'),
        ],
        hoy: DateTime(2026, 10, 1), // antes del turno 2
      ).single;

      expect(r.pendientes, 1);
      expect(r.pendientesVencidos, 0);
      expect(r.debe, isFalse);
      expect(r.siempreATiempo, isTrue);
    });

    test('el singular tambien aqui', () {
      final r = HistorialDeJunta.calcular(
        participantes: [rosa],
        turnos: turnos,
        aportes: [
          aporte('rosa', 't1'),
          aporte('rosa', 't2', pagadoEn: t2),
        ],
        hoy: hoy,
      ).single;

      expect(r.resumen, 'Debe 1 aporte');
    });
  });

  group('el orden de la lista', () {
    test('quien debe va primero, aunque la otra se haya atrasado', () {
      final lista = HistorialDeJunta.calcular(
        participantes: [maria, rosa],
        turnos: turnos,
        aportes: [
          // Maria se atraso pero pago todo.
          aporte('maria', 't1', pagadoEn: t1.add(const Duration(days: 9))),
          aporte('maria', 't2', pagadoEn: t2.add(const Duration(days: 9))),
          // Rosa debe.
          aporte('rosa', 't1'),
          aporte('rosa', 't2', pagadoEn: t2),
        ],
        hoy: hoy,
      );

      expect(lista.first.nombre, 'Rosa Quispe');
      expect(lista.last.nombre, 'Maria Flores');
    });

    test('sin deudas, primero la menos puntual', () {
      final lista = HistorialDeJunta.calcular(
        participantes: [rosa, maria],
        turnos: turnos,
        aportes: [
          aporte('rosa', 't1', pagadoEn: t1),
          aporte('rosa', 't2', pagadoEn: t2),
          aporte('maria', 't1', pagadoEn: t1.add(const Duration(days: 5))),
          aporte('maria', 't2', pagadoEn: t2),
        ],
        hoy: hoy,
      );

      expect(lista.first.nombre, 'Maria Flores');
    });
  });

  group('bordes', () {
    test('una junta que recien empieza no castiga a nadie', () {
      final r = HistorialDeJunta.calcular(
        participantes: [rosa],
        turnos: turnos,
        aportes: [aporte('rosa', 't1'), aporte('rosa', 't2')],
        hoy: DateTime(2026, 9, 1), // antes del primer turno
      ).single;

      expect(r.puntualidad, 1);
      expect(r.debe, isFalse);
      expect(r.siempreATiempo, isTrue);
    });

    test('sin participantes devuelve lista vacia', () {
      expect(
        HistorialDeJunta.calcular(
          participantes: [],
          turnos: turnos,
          aportes: [],
          hoy: hoy,
        ),
        isEmpty,
      );
    });

    test('un aporte de un turno que no existe se ignora', () {
      final r = HistorialDeJunta.calcular(
        participantes: [rosa],
        turnos: turnos,
        aportes: [aporte('rosa', 'fantasma', pagadoEn: t1)],
        hoy: hoy,
      ).single;

      expect(r.pagados, 0);
    });
  });

  group('resumen para compartir', () {
    test('nombra a las puntuales y no señala a nadie', () {
      final cumplimiento = HistorialDeJunta.calcular(
        participantes: [rosa, maria],
        turnos: turnos,
        aportes: [
          aporte('rosa', 't1', pagadoEn: t1),
          aporte('rosa', 't2', pagadoEn: t2),
          aporte('maria', 't1'),
          aporte('maria', 't2'),
        ],
        hoy: hoy,
      );

      final texto = HistorialDeJunta.resumenParaCompartir(
        nombreJunta: 'Junta del mercado',
        cumplimiento: cumplimiento,
      );

      expect(texto, contains('Junta del mercado'));
      expect(texto, contains('Siempre a tiempo: 1'));
      expect(texto, contains('Rosa'));
      // A Maria, que debe, no se la expone en el grupo.
      expect(texto, isNot(contains('Maria')));
      expect(texto.toLowerCase(), isNot(contains('debe')));
    });
  });
}
