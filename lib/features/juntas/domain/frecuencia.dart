/// Cada cuánto se cobra en una junta.
///
/// Dart puro. Toda la aritmética de fechas del proyecto pasa por aquí y está
/// cubierta por tests: si esto se equivoca, la app le dice a una señora que
/// cobre el día que no era.
library;

enum Frecuencia {
  semanal('semanal', 'Cada semana'),
  quincenal('quincenal', 'Cada quince días'),
  mensual('mensual', 'Cada mes');

  const Frecuencia(this.valorEnBase, this.etiqueta);

  /// Como se guarda en el enum de Postgres. No cambiar sin migración.
  final String valorEnBase;

  /// Como se le muestra a la cabeza de junta.
  final String etiqueta;

  static Frecuencia desdeBase(String valor) {
    return Frecuencia.values.firstWhere(
      (f) => f.valorEnBase == valor,
      orElse: () => throw ArgumentError('Frecuencia desconocida: $valor'),
    );
  }
}

/// Aritmética de fechas de turnos.
///
/// Las fechas de turno son fechas civiles (columnas DATE en el esquema), no
/// instantes: no se convierten por zona horaria. Ver la decisión D03.
class CalculoDeFechas {
  const CalculoDeFechas._();

  /// Fecha del turno número [numero], contando desde 1.
  ///
  /// El turno 1 cae el mismo día de inicio.
  static DateTime fechaDeTurno(
    DateTime fechaInicio,
    Frecuencia frecuencia,
    int numero,
  ) {
    if (numero < 1) {
      throw ArgumentError('El número de turno empieza en 1, llegó $numero');
    }

    final saltos = numero - 1;
    final inicio = soloFecha(fechaInicio);

    switch (frecuencia) {
      case Frecuencia.semanal:
        return inicio.add(Duration(days: 7 * saltos));
      case Frecuencia.quincenal:
        return inicio.add(Duration(days: 14 * saltos));
      case Frecuencia.mensual:
        return sumarMeses(inicio, saltos);
    }
  }

  /// Suma meses conservando el día, y si ese día no existe usa el último del mes.
  ///
  /// La regla importa y es deliberada: el 31 de enero más un mes es el 28 de
  /// febrero, **pero más dos meses es el 31 de marzo, no el 28**. El día se
  /// recuerda desde la fecha original y solo se recorta cuando hace falta. Si
  /// se fuera sumando mes a mes sobre el resultado anterior, una junta que
  /// empieza el 31 terminaría cobrando el 28 para siempre.
  static DateTime sumarMeses(DateTime fecha, int meses) {
    if (meses == 0) return soloFecha(fecha);

    final totalMeses = fecha.month - 1 + meses;
    final anio = fecha.year + (totalMeses ~/ 12);
    final mes = (totalMeses % 12) + 1;

    final diaMaximo = diasEnElMes(anio, mes);
    final dia = fecha.day <= diaMaximo ? fecha.day : diaMaximo;

    return DateTime(anio, mes, dia);
  }

  static int diasEnElMes(int anio, int mes) {
    // El día 0 del mes siguiente es el último del mes pedido.
    return DateTime(anio, mes + 1, 0).day;
  }

  /// Recorta la hora. Las fechas de turno son días del calendario, no momentos.
  static DateTime soloFecha(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day);
  }

  /// Días de atraso de un turno respecto a [hoy]. Cero si todavía no vence.
  ///
  /// "Atrasado" nunca se guarda en la base: se calcula aquí cada vez. Un estado
  /// guardado envejece solo; una fecha comparada contra hoy nunca miente.
  static int diasDeAtraso(DateTime fechaProgramada, DateTime hoy) {
    final vencimiento = soloFecha(fechaProgramada);
    final dia = soloFecha(hoy);
    final diferencia = dia.difference(vencimiento).inDays;
    return diferencia > 0 ? diferencia : 0;
  }
}
