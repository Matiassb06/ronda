import 'package:flutter_test/flutter_test.dart';
import 'package:ronda/features/aportes/domain/aporte.dart';

Aporte aporte({required bool pagado, int monto = 5000}) {
  return Aporte(
    id: 'a',
    juntaId: 'j',
    turnoId: 't',
    participanteId: 'p',
    montoCentavos: monto,
    estado: pagado ? EstadoAporte.pagado : EstadoAporte.pendiente,
    pagadoEn: pagado ? DateTime(2026, 9, 14) : null,
  );
}

void main() {
  final hoy = DateTime(2026, 9, 20);

  group('ResumenDeTurno de una junta de doce a S/ 50', () {
    test('nadie pago todavia', () {
      final r = ResumenDeTurno.calcular(
        aportes: List.generate(12, (_) => aporte(pagado: false)),
        montoAporteCentavos: 5000,
        fechaProgramada: DateTime(2026, 9, 25),
        hoy: hoy,
      );

      expect(r.pagados, 0);
      expect(r.faltan, 12);
      expect(r.recaudadoCentavos, 0);
      expect(r.esperadoCentavos, 60000);
      expect(r.faltaCobrarCentavos, 60000);
      expect(r.estaCompleto, isFalse);
      expect(r.avance, 0);
    });

    test('pagaron cinco de doce', () {
      final r = ResumenDeTurno.calcular(
        aportes: [
          ...List.generate(5, (_) => aporte(pagado: true)),
          ...List.generate(7, (_) => aporte(pagado: false)),
        ],
        montoAporteCentavos: 5000,
        fechaProgramada: DateTime(2026, 9, 25),
        hoy: hoy,
      );

      expect(r.pagados, 5);
      expect(r.faltan, 7);
      expect(r.recaudadoCentavos, 25000);
      expect(r.faltaCobrarCentavos, 35000);
      expect(r.estaCompleto, isFalse);
      expect(r.avance, closeTo(5 / 12, 0.0001));
    });

    test('pagaron todas: el pozo esta completo', () {
      final r = ResumenDeTurno.calcular(
        aportes: List.generate(12, (_) => aporte(pagado: true)),
        montoAporteCentavos: 5000,
        fechaProgramada: DateTime(2026, 9, 25),
        hoy: hoy,
      );

      expect(r.estaCompleto, isTrue);
      expect(r.recaudadoCentavos, 60000);
      expect(r.faltaCobrarCentavos, 0);
      expect(r.avance, 1);
    });
  });

  group('ResumenDeTurno y el atraso', () {
    test('antes del vencimiento no esta atrasado', () {
      final r = ResumenDeTurno.calcular(
        aportes: [aporte(pagado: false)],
        montoAporteCentavos: 5000,
        fechaProgramada: DateTime(2026, 9, 25),
        hoy: hoy,
      );
      expect(r.diasDeAtraso, 0);
      expect(r.estaAtrasado, isFalse);
    });

    test('pasado el vencimiento y con gente debiendo, esta atrasado', () {
      final r = ResumenDeTurno.calcular(
        aportes: [aporte(pagado: true), aporte(pagado: false)],
        montoAporteCentavos: 5000,
        fechaProgramada: DateTime(2026, 9, 14),
        hoy: hoy,
      );
      expect(r.diasDeAtraso, 6);
      expect(r.estaAtrasado, isTrue);
    });

    test('un turno vencido pero cobrado entero no esta atrasado', () {
      final r = ResumenDeTurno.calcular(
        aportes: [aporte(pagado: true), aporte(pagado: true)],
        montoAporteCentavos: 5000,
        fechaProgramada: DateTime(2026, 9, 14),
        hoy: hoy,
      );
      expect(r.diasDeAtraso, 6);
      expect(r.estaAtrasado, isFalse);
    });
  });

  group('ResumenDeTurno, bordes', () {
    test('un turno sin aportes no revienta ni divide por cero', () {
      final r = ResumenDeTurno.calcular(
        aportes: [],
        montoAporteCentavos: 5000,
        fechaProgramada: DateTime(2026, 9, 25),
        hoy: hoy,
      );
      expect(r.avance, 0);
      expect(r.estaCompleto, isFalse);
      expect(r.esperadoCentavos, 0);
    });

    test('suma lo realmente pagado, no lo que deberia ser', () {
      // Alguien pago de menos: la cuenta tiene que reflejar la realidad.
      final r = ResumenDeTurno.calcular(
        aportes: [aporte(pagado: true, monto: 3000), aporte(pagado: true)],
        montoAporteCentavos: 5000,
        fechaProgramada: DateTime(2026, 9, 25),
        hoy: hoy,
      );
      expect(r.recaudadoCentavos, 8000);
      expect(r.esperadoCentavos, 10000);
      expect(r.faltaCobrarCentavos, 2000);
      expect(r.estaCompleto, isTrue, reason: 'marcaron las dos como pagadas');
    });
  });

  group('Turno', () {
    test('un turno completado nunca esta atrasado', () {
      final t = Turno(
        id: 't',
        juntaId: 'j',
        participanteId: 'p',
        numero: 1,
        fechaProgramada: DateTime(2026, 9, 1),
        completado: true,
      );
      expect(t.diasDeAtraso(hoy), 19);
      expect(t.estaAtrasado(hoy), isFalse);
    });

    test('un turno pendiente y vencido si lo esta', () {
      final t = Turno(
        id: 't',
        juntaId: 'j',
        participanteId: 'p',
        numero: 1,
        fechaProgramada: DateTime(2026, 9, 1),
        completado: false,
      );
      expect(t.estaAtrasado(hoy), isTrue);
    });
  });
}
