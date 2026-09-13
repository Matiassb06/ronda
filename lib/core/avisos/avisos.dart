import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as datos_de_zonas;
import 'package:timezone/timezone.dart' as tz;

import '../formato/fecha.dart';
import '../formato/monto.dart';

/// Avisos que la app se pone a sí misma.
///
/// Son para la cabeza de junta, no para las participantes: a ellas les llega el
/// recordatorio por WhatsApp, escrito por ella. Esto solo le avisa a ella que
/// mañana toca cobrar, para que no se le pase.
///
/// La hora se calcula siempre en **America/Lima**, no en la zona del teléfono.
/// Un teléfono con la zona mal puesta no debería mover el día de cobro de una
/// junta.
class Avisos {
  const Avisos._();

  static const String _canalId = 'turnos';
  static const String _canalNombre = 'Avisos de cobro';
  static const String _canalDescripcion =
      'Recordatorios del día en que toca cobrar la junta';

  /// A las 9 de la mañana: el mercado ya está abierto y todavía queda día.
  static const int horaDelAviso = 9;

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _listo = false;

  static Future<void> inicializar() async {
    if (_listo) return;

    datos_de_zonas.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Lima'));

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    _listo = true;
  }

  /// Pide el permiso de notificaciones, que en Android 13 y posteriores hace
  /// falta pedir explícitamente. Si el usuario dice que no, la app sigue
  /// funcionando igual: los avisos son un extra, no el producto.
  static Future<bool> pedirPermiso() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.requestNotificationsPermission() ?? false;
  }

  /// Programa los dos avisos de un turno: el día anterior y el mismo día.
  ///
  /// El id se deriva del id del turno para que reprogramar reemplace el aviso
  /// viejo en vez de acumular duplicados cada vez que se abre la app.
  static Future<void> programarTurno({
    required String turnoId,
    required String nombreJunta,
    required DateTime fechaDelTurno,
    required int montoCentavos,
    required int cuantasFaltan,
  }) async {
    await inicializar();

    final base = turnoId.hashCode.abs() % 1000000;
    await _plugin.cancel(id: base);
    await _plugin.cancel(id: base + 1);

    final cuando = FechaEnEspanol.conDiaDeLaSemana(fechaDelTurno);

    await _programar(
      id: base,
      fecha: _aLasNueve(fechaDelTurno.subtract(const Duration(days: 1))),
      titulo: 'Mañana cobra la $nombreJunta',
      cuerpo: cuantasFaltan > 0
          ? 'Faltan $cuantasFaltan por pagar. Buen momento para recordarles.'
          : 'Ya está todo cobrado. Mañana toca entregar el pozo.',
    );

    await _programar(
      id: base + 1,
      fecha: _aLasNueve(fechaDelTurno),
      titulo: 'Hoy toca la $nombreJunta',
      cuerpo: cuantasFaltan > 0
          ? 'Faltan $cuantasFaltan de ${Monto.formatear(montoCentavos)}. Era para el $cuando.'
          : 'Todas pagaron. Toca entregar el pozo.',
    );
  }

  static Future<void> cancelarTurno(String turnoId) async {
    await inicializar();
    final base = turnoId.hashCode.abs() % 1000000;
    await _plugin.cancel(id: base);
    await _plugin.cancel(id: base + 1);
  }

  static Future<void> _programar({
    required int id,
    required tz.TZDateTime fecha,
    required String titulo,
    required String cuerpo,
  }) async {
    // Una fecha pasada no se programa: dispararía el aviso al instante.
    if (fecha.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _plugin.zonedSchedule(
      id: id,
      title: titulo,
      body: cuerpo,
      scheduledDate: fecha,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _canalId,
          _canalNombre,
          channelDescription: _canalDescripcion,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      // Inexacto a propósito: la alarma exacta exige SCHEDULE_EXACT_ALARM, que
      // en Android 12 y posteriores el usuario tiene que conceder a mano en
      // Ajustes. Un recordatorio de cobro no necesita puntería al minuto, y no
      // vale la pena hacerle atravesar una pantalla de sistema a la usuaria.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static tz.TZDateTime _aLasNueve(DateTime dia) {
    return tz.TZDateTime(tz.local, dia.year, dia.month, dia.day, horaDelAviso);
  }
}
