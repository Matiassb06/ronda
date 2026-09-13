import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Configuración de idioma de la app.
///
/// La app es solo en español y sus textos están escritos a mano en [Textos],
/// así que esto no existe para traducir nada: existe porque **los diálogos que
/// trae Material necesitan sus propias localizaciones**. El selector de fecha,
/// el de hora, los botones de cancelar y aceptar, las etiquetas de
/// accesibilidad: todo eso lo dibuja Flutter, no nosotros.
///
/// Sin estos delegados, `MaterialApp` solo trae el inglés. Pedirle español a un
/// `showDatePicker` en esas condiciones no lo deja en inglés: lo revienta con
/// "No MaterialLocalizations found". Pasó, y por eso hay un test de widget que
/// abre el calendario.
class Idiomas {
  const Idiomas._();

  static const Locale espanol = Locale('es');

  static const List<Locale> soportados = [espanol];

  static const List<LocalizationsDelegate<dynamic>> delegados = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}
