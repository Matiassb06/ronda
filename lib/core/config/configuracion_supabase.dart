/// Datos de conexion a Supabase.
///
/// Entran por `--dart-define` en tiempo de compilacion y NUNCA viven en el
/// repositorio (regla 1 del CLAUDE.md). `String.fromEnvironment` es constante:
/// si no se pasa el valor, queda en cadena vacia, no en null.
///
/// Para correr la app:
///
/// ```
/// flutter run \
///   --dart-define=SUPABASE_URL=https://<ref>.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=<anon key>
/// ```
///
/// Dart puro: se puede testear sin levantar Flutter.
library;

class ConfiguracionSupabase {
  const ConfiguracionSupabase._();

  static const String nombreUrl = 'SUPABASE_URL';
  static const String nombreClave = 'SUPABASE_ANON_KEY';

  static const String url = String.fromEnvironment(nombreUrl);
  static const String claveAnonima = String.fromEnvironment(nombreClave);

  /// True solo si los dos valores llegaron.
  static bool get estaCompleta => faltantes.isEmpty;

  /// Que variables faltan, para poder decirselo al usuario en pantalla en vez
  /// de reventar con una excepcion que nadie sabe leer.
  static List<String> get faltantes => [
    if (url.trim().isEmpty) nombreUrl,
    if (claveAnonima.trim().isEmpty) nombreClave,
  ];
}
