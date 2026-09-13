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

  /// Un turno por participante, en el orden en que vienen.
  ///
  /// [participantesIdsEnOrden] tiene que venir ya ordenado por `orden_turno`.
  /// El turno 1 cae el día de inicio; los siguientes según la frecuencia.
  static List<TurnoPlanificado> generar({
    required List<String> participantesIdsEnOrden,
    required Frecuencia frecuencia,
    required DateTime fechaInicio,
  }) {
    if (participantesIdsEnOrden.isEmpty) {
      throw ArgumentError('Una junta sin participantes no tiene calendario');
    }
    if (participantesIdsEnOrden.toSet().length !=
        participantesIdsEnOrden.length) {
      throw ArgumentError('Hay un participante repetido en el orden de turnos');
    }

    return [
      for (var i = 0; i < participantesIdsEnOrden.length; i++)
        TurnoPlanificado(
          numero: i + 1,
          participanteId: participantesIdsEnOrden[i],
          fechaProgramada: CalculoDeFechas.fechaDeTurno(
            fechaInicio,
            frecuencia,
            i + 1,
          ),
        ),
    ];
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
    required int participantes,
    required Frecuencia frecuencia,
    required DateTime fechaInicio,
  }) {
    return CalculoDeFechas.fechaDeTurno(fechaInicio, frecuencia, participantes);
  }
}
