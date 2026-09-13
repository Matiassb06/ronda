import 'package:flutter/material.dart';

/// Tema de la app.
///
/// Esta pensado para una sola usuaria concreta: la cabeza de junta, alrededor
/// de 55 anos, parada en un puesto de mercado, con el telefono a un brazo de
/// distancia y sol encima. De ahi salen las tres decisiones de este archivo:
///
/// 1. Todo mas grande de lo que un diseno de oficina consideraria correcto.
/// 2. Contraste alto, sin grises claros sobre blanco.
/// 3. Los montos con su propio estilo, tabular y enorme: son lo que ella viene
///    a mirar.
///
/// No se usa `google_fonts` en tiempo de ejecucion a proposito (decision D04):
/// descargar una fuente exige red, y en el mercado la red es justo lo que no
/// hay. La tipografia del sistema siempre esta.
class TemaRonda {
  const TemaRonda._();

  /// Verde billete. Suficientemente serio para hablar de plata.
  static const Color semilla = Color(0xFF00695C);

  /// Altura minima de cualquier cosa que se toque, en logical pixels.
  /// Material recomienda 48; aqui 56, porque se usa con el pulgar y apurada.
  static const double areaTactilMinima = 56;

  static ThemeData get claro {
    final esquema = ColorScheme.fromSeed(
      seedColor: semilla,
      contrastLevel: 1.0, // alto contraste, no el 0.0 por defecto
    );
    return _construir(esquema);
  }

  static ThemeData get oscuro {
    final esquema = ColorScheme.fromSeed(
      seedColor: semilla,
      brightness: Brightness.dark,
      contrastLevel: 1.0,
    );
    return _construir(esquema);
  }

  static ThemeData _construir(ColorScheme esquema) {
    final base = ThemeData(colorScheme: esquema, useMaterial3: true);

    return base.copyWith(
      textTheme: _tipografia(base.textTheme),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: esquema.onSurface,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(areaTactilMinima),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(areaTactilMinima),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      // El color va explícito a propósito. Un TextStyle de tema sin color deja
      // que el widget elija, y varios eligen un gris clarísimo que sobre este
      // fondo no se lee. Esta app se usa con sol encima: el contraste no se
      // delega.
      listTileTheme: ListTileThemeData(
        minVerticalPadding: 16,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: esquema.onSurface,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 17,
          color: esquema.onSurfaceVariant,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        materialTapTargetSize: MaterialTapTargetSize.padded,
        visualDensity: VisualDensity.comfortable,
        side: BorderSide(width: 2.5, color: esquema.outline),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        labelStyle: TextStyle(fontSize: 19),
      ),
      snackBarTheme: const SnackBarThemeData(
        contentTextStyle: TextStyle(fontSize: 18),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Toda la escala subida respecto al default de Material.
  static TextTheme _tipografia(TextTheme base) {
    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 30,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.titleMedium?.copyWith(fontSize: 20),
      bodyLarge: base.bodyLarge?.copyWith(fontSize: 19, height: 1.4),
      bodyMedium: base.bodyMedium?.copyWith(fontSize: 18, height: 1.4),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 19,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Estilo para cualquier cifra de dinero.
  ///
  /// `FontFeature.tabularFigures` alinea los digitos en columna, para que una
  /// lista de montos se lea de un vistazo sin que las cifras bailen.
  static TextStyle estiloMonto(BuildContext context, {double tamano = 34}) {
    return TextStyle(
      fontSize: tamano,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      fontFeatures: const [FontFeature.tabularFigures()],
      color: Theme.of(context).colorScheme.onSurface,
    );
  }
}
