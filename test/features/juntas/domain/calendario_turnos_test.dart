import 'package:flutter_test/flutter_test.dart';
import 'package:ronda/features/juntas/domain/calendario_turnos.dart';
import 'package:ronda/features/juntas/domain/frecuencia.dart';

String soloDia(DateTime f) => f.toIso8601String().substring(0, 10);

void main() {
  group('CalculoDeFechas.fechaDeTurno semanal', () {
    final inicio = DateTime(2026, 9, 14); // lunes

    test('el turno 1 cae el dia de inicio', () {
      expect(
        soloDia(CalculoDeFechas.fechaDeTurno(inicio, Frecuencia.semanal, 1)),
        '2026-09-14',
      );
    });

    test('cada turno suma siete dias', () {
      expect(
        soloDia(CalculoDeFechas.fechaDeTurno(inicio, Frecuencia.semanal, 2)),
        '2026-09-21',
      );
      expect(
        soloDia(CalculoDeFechas.fechaDeTurno(inicio, Frecuencia.semanal, 5)),
        '2026-10-12',
      );
    });

    test('cae siempre en el mismo dia de la semana', () {
      for (var n = 1; n <= 12; n++) {
        final fecha = CalculoDeFechas.fechaDeTurno(
          inicio,
          Frecuencia.semanal,
          n,
        );
        expect(fecha.weekday, DateTime.monday);
      }
    });
  });

  group('CalculoDeFechas.fechaDeTurno quincenal', () {
    test('suma catorce dias por turno', () {
      final inicio = DateTime(2026, 9, 14);
      expect(
        soloDia(CalculoDeFechas.fechaDeTurno(inicio, Frecuencia.quincenal, 2)),
        '2026-09-28',
      );
      expect(
        soloDia(CalculoDeFechas.fechaDeTurno(inicio, Frecuencia.quincenal, 3)),
        '2026-10-12',
      );
    });
  });

  group('CalculoDeFechas.fechaDeTurno mensual', () {
    test('conserva el dia del mes', () {
      final inicio = DateTime(2026, 9, 5);
      expect(
        soloDia(CalculoDeFechas.fechaDeTurno(inicio, Frecuencia.mensual, 4)),
        '2026-12-05',
      );
    });

    test('cruza el cambio de anio', () {
      final inicio = DateTime(2026, 11, 20);
      expect(
        soloDia(CalculoDeFechas.fechaDeTurno(inicio, Frecuencia.mensual, 3)),
        '2027-01-20',
      );
    });

    // El caso feo, y la razon por la que esta logica no vive en SQL.
    test('el 31 de enero mas un mes cae el 28 de febrero', () {
      final inicio = DateTime(2027, 1, 31);
      expect(
        soloDia(CalculoDeFechas.fechaDeTurno(inicio, Frecuencia.mensual, 2)),
        '2027-02-28',
      );
    });

    test('pero mas dos meses vuelve al 31, no se queda en 28', () {
      final inicio = DateTime(2027, 1, 31);
      expect(
        soloDia(CalculoDeFechas.fechaDeTurno(inicio, Frecuencia.mensual, 3)),
        '2027-03-31',
      );
      expect(
        soloDia(CalculoDeFechas.fechaDeTurno(inicio, Frecuencia.mensual, 4)),
        '2027-04-30',
      );
      expect(
        soloDia(CalculoDeFechas.fechaDeTurno(inicio, Frecuencia.mensual, 5)),
        '2027-05-31',
      );
    });

    test('anio bisiesto: el 31 de enero de 2028 da 29 de febrero', () {
      final inicio = DateTime(2028, 1, 31);
      expect(
        soloDia(CalculoDeFechas.fechaDeTurno(inicio, Frecuencia.mensual, 2)),
        '2028-02-29',
      );
    });

    test('el 30 de enero tambien se recorta en febrero', () {
      final inicio = DateTime(2027, 1, 30);
      expect(
        soloDia(CalculoDeFechas.fechaDeTurno(inicio, Frecuencia.mensual, 2)),
        '2027-02-28',
      );
    });
  });

  group('CalculoDeFechas.fechaDeTurno, bordes', () {
    test('un turno menor que 1 es un error de programacion', () {
      expect(
        () => CalculoDeFechas.fechaDeTurno(
          DateTime(2026, 9, 14),
          Frecuencia.semanal,
          0,
        ),
        throwsArgumentError,
      );
    });

    test('la hora del dia de inicio no ensucia el resultado', () {
      final conHora = DateTime(2026, 9, 14, 23, 45);
      expect(
        soloDia(CalculoDeFechas.fechaDeTurno(conHora, Frecuencia.semanal, 2)),
        '2026-09-21',
      );
    });
  });

  group('CalculoDeFechas.diasDeAtraso', () {
    test('antes del vencimiento no hay atraso', () {
      expect(
        CalculoDeFechas.diasDeAtraso(
          DateTime(2026, 9, 20),
          DateTime(2026, 9, 14),
        ),
        0,
      );
    });

    test('el mismo dia todavia no es atraso', () {
      expect(
        CalculoDeFechas.diasDeAtraso(
          DateTime(2026, 9, 14),
          DateTime(2026, 9, 14),
        ),
        0,
      );
    });

    test('cuenta los dias pasados', () {
      expect(
        CalculoDeFechas.diasDeAtraso(
          DateTime(2026, 9, 14),
          DateTime(2026, 9, 17),
        ),
        3,
      );
    });

    test('la hora no cuenta como un dia mas', () {
      expect(
        CalculoDeFechas.diasDeAtraso(
          DateTime(2026, 9, 14),
          DateTime(2026, 9, 14, 23, 59),
        ),
        0,
      );
    });
  });

  group('CalendarioTurnos.generar', () {
    test('un turno por participante, en orden', () {
      final turnos = CalendarioTurnos.generar(
        participantesIdsEnOrden: ['rosa', 'maria', 'julia'],
        frecuencia: Frecuencia.semanal,
        fechaInicio: DateTime(2026, 9, 14),
      );

      expect(turnos, hasLength(3));
      expect(turnos.map((t) => t.numero), [1, 2, 3]);
      expect(turnos.map((t) => t.participanteId), ['rosa', 'maria', 'julia']);
      expect(soloDia(turnos[0].fechaProgramada), '2026-09-14');
      expect(soloDia(turnos[2].fechaProgramada), '2026-09-28');
    });

    test('doce participantes, mensual: un anio completo', () {
      final ids = List.generate(12, (i) => 'p$i');
      final turnos = CalendarioTurnos.generar(
        participantesIdsEnOrden: ids,
        frecuencia: Frecuencia.mensual,
        fechaInicio: DateTime(2026, 9, 15),
      );

      expect(turnos, hasLength(12));
      expect(soloDia(turnos.first.fechaProgramada), '2026-09-15');
      expect(soloDia(turnos.last.fechaProgramada), '2027-08-15');
    });

    test('dos participantes es una junta valida', () {
      final turnos = CalendarioTurnos.generar(
        participantesIdsEnOrden: ['rosa', 'maria'],
        frecuencia: Frecuencia.quincenal,
        fechaInicio: DateTime(2026, 9, 14),
      );
      expect(turnos, hasLength(2));
      expect(soloDia(turnos[1].fechaProgramada), '2026-09-28');
    });

    test('una sola participante tambien, aunque no tenga mucho sentido', () {
      final turnos = CalendarioTurnos.generar(
        participantesIdsEnOrden: ['rosa'],
        frecuencia: Frecuencia.mensual,
        fechaInicio: DateTime(2026, 9, 14),
      );
      expect(turnos, hasLength(1));
    });

    test('sin participantes es un error, no una lista vacia', () {
      expect(
        () => CalendarioTurnos.generar(
          participantesIdsEnOrden: [],
          frecuencia: Frecuencia.mensual,
          fechaInicio: DateTime(2026, 9, 14),
        ),
        throwsArgumentError,
      );
    });

    test('una participante repetida es un error: cobraria dos veces', () {
      expect(
        () => CalendarioTurnos.generar(
          participantesIdsEnOrden: ['rosa', 'maria', 'rosa'],
          frecuencia: Frecuencia.mensual,
          fechaInicio: DateTime(2026, 9, 14),
        ),
        throwsArgumentError,
      );
    });

    test('las fechas salen siempre en orden creciente', () {
      final turnos = CalendarioTurnos.generar(
        participantesIdsEnOrden: List.generate(12, (i) => 'p$i'),
        frecuencia: Frecuencia.mensual,
        fechaInicio: DateTime(2027, 1, 31),
      );
      for (var i = 1; i < turnos.length; i++) {
        expect(
          turnos[i].fechaProgramada.isAfter(turnos[i - 1].fechaProgramada),
          isTrue,
          reason: 'el turno ${i + 1} no puede caer antes que el $i',
        );
      }
    });
  });

  group('la duración se elige aparte de cuánta gente hay', () {
    final gente = ['rosa', 'maria', 'julia', 'elena'];

    test('sin decir nada, un turno por participante', () {
      final turnos = CalendarioTurnos.generar(
        participantesIdsEnOrden: gente,
        frecuencia: Frecuencia.semanal,
        fechaInicio: DateTime(2026, 9, 14),
      );
      expect(turnos, hasLength(4));
      expect(turnos.map((t) => t.participanteId), gente);
    });

    test('mas turnos que gente: se da la vuelta a la lista', () {
      final turnos = CalendarioTurnos.generar(
        participantesIdsEnOrden: gente,
        frecuencia: Frecuencia.semanal,
        fechaInicio: DateTime(2026, 9, 14),
        cuantosTurnos: 6,
      );

      expect(turnos, hasLength(6));
      expect(turnos.map((t) => t.participanteId), [
        'rosa',
        'maria',
        'julia',
        'elena',
        'rosa',
        'maria',
      ]);
      // Las fechas siguen corriendo, no vuelven al principio.
      expect(soloDia(turnos.last.fechaProgramada), '2026-10-19');
    });

    test('menos turnos que gente: alguien no cobra', () {
      final turnos = CalendarioTurnos.generar(
        participantesIdsEnOrden: gente,
        frecuencia: Frecuencia.semanal,
        fechaInicio: DateTime(2026, 9, 14),
        cuantosTurnos: 2,
      );
      expect(turnos, hasLength(2));
      expect(turnos.map((t) => t.participanteId), ['rosa', 'maria']);
    });

    test('una junta semanal larga con poca gente', () {
      final turnos = CalendarioTurnos.generar(
        participantesIdsEnOrden: ['rosa', 'maria'],
        frecuencia: Frecuencia.semanal,
        fechaInicio: DateTime(2026, 9, 14),
        cuantosTurnos: 20,
      );
      expect(turnos, hasLength(20));
      // 19 semanas después del 14 de setiembre.
      expect(soloDia(turnos.last.fechaProgramada), '2027-01-25');
    });

    test('cero turnos es un error', () {
      expect(
        () => CalendarioTurnos.generar(
          participantesIdsEnOrden: gente,
          frecuencia: Frecuencia.semanal,
          fechaInicio: DateTime(2026, 9, 14),
          cuantosTurnos: 0,
        ),
        throwsArgumentError,
      );
    });
  });

  group('el aviso del reparto, antes de generar nada', () {
    test('parejo: nadie cobra de mas ni de menos', () {
      final r = CalendarioTurnos.repartoDeCobros(participantes: 4, turnos: 4);
      expect(r.esParejo, isTrue);
      expect(r.hayQueAvisar, isFalse);
      expect(r.cobranDeMas, 0);
      expect(r.alguienNoCobra, isFalse);
    });

    test('seis turnos entre cuatro: dos cobran dos veces', () {
      final r = CalendarioTurnos.repartoDeCobros(participantes: 4, turnos: 6);
      expect(r.hayQueAvisar, isTrue);
      expect(r.vecesQueCobraLaMayoria, 1);
      expect(r.cobranDeMas, 2);
      expect(r.alguienNoCobra, isFalse);
    });

    test('veinte turnos entre dos: cada una cobra diez veces', () {
      final r = CalendarioTurnos.repartoDeCobros(participantes: 2, turnos: 20);
      expect(r.vecesQueCobraLaMayoria, 10);
      expect(r.cobranDeMas, 0);
      expect(r.hayQueAvisar, isTrue, reason: 'no es una vuelta limpia');
    });

    // Lo mas grave que puede pasar aqui.
    test('menos turnos que gente: se avisa que alguien NO cobra', () {
      final r = CalendarioTurnos.repartoDeCobros(participantes: 4, turnos: 3);
      expect(r.alguienNoCobra, isTrue);
      expect(r.sinCobrar, 1);
      expect(r.vecesQueCobraLaMayoria, 0);
    });

    test('la mitad de la gente se queda sin cobrar', () {
      final r = CalendarioTurnos.repartoDeCobros(participantes: 12, turnos: 6);
      expect(r.sinCobrar, 6);
      expect(r.alguienNoCobra, isTrue);
    });
  });

  group('CalendarioTurnos, dinero y cierre', () {
    test('el pozo es el aporte por la cantidad de participantes', () {
      expect(
        CalendarioTurnos.pozoPorTurnoEnCentavos(
          participantes: 12,
          montoAporteCentavos: 5000,
        ),
        60000,
      );
    });

    test('la fecha de cierre es la del ultimo turno', () {
      expect(
        soloDia(
          CalendarioTurnos.fechaDeCierre(
            turnos: 12,
            frecuencia: Frecuencia.mensual,
            fechaInicio: DateTime(2026, 9, 15),
          ),
        ),
        '2027-08-15',
      );
    });
  });

  group('Frecuencia', () {
    test('los valores coinciden con el enum de Postgres', () {
      expect(Frecuencia.semanal.valorEnBase, 'semanal');
      expect(Frecuencia.quincenal.valorEnBase, 'quincenal');
      expect(Frecuencia.mensual.valorEnBase, 'mensual');
    });

    test('se reconstruye desde lo que devuelve la base', () {
      expect(Frecuencia.desdeBase('mensual'), Frecuencia.mensual);
    });

    test('un valor desconocido revienta en vez de adivinar', () {
      expect(() => Frecuencia.desdeBase('anual'), throwsArgumentError);
    });
  });
}
