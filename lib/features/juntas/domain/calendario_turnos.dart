import 'frecuencia.dart';

/// Un turno del calendario, antes de existir en la base.
///
/// Es el resultado del cálculo, no la fila de Postgres: por eso no tiene id.
class TurnoPlanificado {
  const TurnoPlanificado({
    required this.numero,
    required this.participanteId,
    required this.fechaProgramada,
  });

  /// Desde 1. Es el orden en que se cobra.
  final int numero;

  final String participanteId;

  /// Fecha civil, sin hora.
  final DateTime fechaProgramada;

  @override
  String toString() =>
      'TurnoPlanificado($numero, $participanteId, ${fechaProgramada.toIso8601String().substring(0, 10)})';
}

/// Genera el calendario de una junta.
///
/// Dart puro y sin imports de Flutter: es el corazón del producto y es lo que
/// se testea de verdad. Una junta de doce personas con turnos mal calculados es
/// exactamente el error que el cuaderno de papel no comete.
class CalendarioTurnos {
  const CalendarioTurnos._();

  /// Genera el calendario.
  ///
  /// [participantesIdsEnOrden] tiene que venir ya ordenado por `orden_turno`.
  /// El turno 1 cae el día de inicio; los siguientes según la frecuencia.
  ///
  /// [cuantosTurnos] es la duración de la junta y **se elige aparte de cuánta
  /// gente haya**. Si no se dice, es uno por participante, que es el caso
  /// clásico y el que hace que la cuenta salga a mano.
  ///
  /// Cuando no coinciden, los turnos se reparten dando la vuelta a la lista:
  /// con 4 personas y 6 turnos, las dos primeras cobran dos veces. Eso es
  /// legítimo (alguien tomó dos números y paga doble) pero **hay que avisarlo
  /// antes**, y para eso está [repartoDeCobros].
  static List<TurnoPlanificado> generar({
    required List<String> participantesIdsEnOrden,
    required Frecuencia frecuencia,
    required DateTime fechaInicio,
    int? cuantosTurnos,
  }) {
    if (participantesIdsEnOrden.isEmpty) {
      throw ArgumentError('Una junta sin participantes no tiene calendario');
    }
    if (participantesIdsEnOrden.toSet().length !=
        participantesIdsEnOrden.length) {
      throw ArgumentError('Hay un participante repetido en el orden de turnos');
    }

    final total = cuantosTurnos ?? participantesIdsEnOrden.length;
    if (total < 1) {
      throw ArgumentError('Una junta tiene al menos un turno, llegó $total');
    }

    return [
      for (var i = 0; i < total; i++)
        TurnoPlanificado(
          numero: i + 1,
          // Da la vuelta a la lista cuando hay más turnos que gente.
          participanteId:
              participantesIdsEnOrden[i % participantesIdsEnOrden.length],
          fechaProgramada: CalculoDeFechas.fechaDeTurno(
            fechaInicio,
            frecuencia,
            i + 1,
          ),
        ),
    ];
  }

  /// Cuántas veces cobra cada participante con esa duración.
  ///
  /// Sirve para decírselo a la cabeza de junta **antes** de generar el
  /// calendario. Que alguien cobre dos veces y otra ninguna es exactamente el
  /// tipo de cosa que, descubierta en la semana cinco, termina en pelea.
  static RepartoDeCobros repartoDeCobros({
    required int participantes,
    required int turnos,
  }) {
    if (participantes < 1) {
      throw ArgumentError('No hay participantes que repartir');
    }

    final vueltasCompletas = turnos ~/ participantes;
    final sobran = turnos % participantes;

    return RepartoDeCobros(
      participantes: participantes,
      turnos: turnos,
      cobranDeMas: vueltasCompletas >= 1 ? sobran : 0,
      vecesQueCobraLaMayoria: vueltasCompletas,
      sinCobrar: vueltasCompletas == 0 ? participantes - sobran : 0,
    );
  }

  /// Cuánto se lleva quien cobra: todas las participantes aportan cada vuelta,
  /// incluida la que recibe.
  ///
  /// Decisión no especificada en el encargo, anotada en
  /// docs/decisiones-pendientes.md: es la forma más común y la que hace que la
  /// cuenta cierre. La que cobra pone su aporte y se lleva el pozo entero, así
  /// que su ganancia neta de esa vuelta es (N - 1) veces el aporte.
  static int pozoPorTurnoEnCentavos({
    required int participantes,
    required int montoAporteCentavos,
  }) {
    return participantes * montoAporteCentavos;
  }

  /// Cuándo termina la junta: la fecha del último turno.
  static DateTime fechaDeCierre({
    required int turnos,
    required Frecuencia frecuencia,
    required DateTime fechaInicio,
  }) {
    return CalculoDeFechas.fechaDeTurno(fechaInicio, frecuencia, turnos);
  }
}

/// Cómo queda el reparto de cobros con una duración dada.
///
/// Es el aviso que la app le da a la cabeza de junta antes de empezar.
class RepartoDeCobros {
  const RepartoDeCobros({
    required this.participantes,
    required this.turnos,
    required this.cobranDeMas,
    required this.vecesQueCobraLaMayoria,
    required this.sinCobrar,
  });

  final int participantes;
  final int turnos;

  /// Cuántas cobran una vez más que las demás.
  final int cobranDeMas;

  /// Cuántas veces cobra quien cobra menos.
  final int vecesQueCobraLaMayoria;

  /// Cuántas no cobran ninguna vez. Solo pasa con menos turnos que gente.
  final int sinCobrar;

  /// El caso limpio: cada una cobra exactamente una vez.
  bool get esParejo => turnos == participantes;

  /// Hay algo que advertir antes de generar el calendario.
  bool get hayQueAvisar => !esParejo;

  /// Alguien se queda sin cobrar. Es lo más grave que puede pasar aquí.
  bool get alguienNoCobra => sinCobrar > 0;
}
