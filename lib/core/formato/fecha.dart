/// Fechas escritas como las diría una persona en Perú.
///
/// Dart puro, sin `intl` y sin datos de locale que cargar: son doce meses y
/// siete días, y escribirlos a mano evita depender de la inicialización de un
/// paquete para mostrar "14 de setiembre".
///
/// **En Perú se dice setiembre, no septiembre.** Escribirlo con la p delata al
/// software hecho en otro lado, y esta app tiene que sonar de aquí.
class FechaEnEspanol {
  const FechaEnEspanol._();

  static const List<String> meses = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'setiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  /// `DateTime.weekday` va de 1 (lunes) a 7 (domingo).
  static const List<String> dias = [
    'lunes',
    'martes',
    'miércoles',
    'jueves',
    'viernes',
    'sábado',
    'domingo',
  ];

  /// `14 de setiembre`
  static String diaYMes(DateTime f) => '${f.day} de ${meses[f.month - 1]}';

  /// `14 de setiembre de 2026`
  static String completa(DateTime f) => '${diaYMes(f)} de ${f.year}';

  /// `lunes 14 de setiembre`
  ///
  /// Con el día de la semana porque en una junta se habla así: "el lunes toca",
  /// no "el 14 toca".
  static String conDiaDeLaSemana(DateTime f) =>
      '${dias[f.weekday - 1]} ${diaYMes(f)}';
}
