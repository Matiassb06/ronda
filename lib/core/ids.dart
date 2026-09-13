import 'dart:math';

/// Generación de identificadores en el teléfono.
///
/// Hace falta porque la app escribe sin señal: si el id lo pusiera Postgres,
/// no se podría crear nada hasta sincronizar, y en el mercado eso significa no
/// poder crear nada. Dart puro y con tests.
class Ids {
  const Ids._();

  static final Random _azar = Random.secure();

  /// UUID v4, en el formato que espera una columna `uuid` de Postgres.
  ///
  /// Se generan 16 bytes al azar y se fuerzan la versión (4) y la variante
  /// (RFC 4122), que son los dos campos que Postgres valida.
  static String uuid() {
    final bytes = List<int>.generate(16, (_) => _azar.nextInt(256));

    bytes[6] = (bytes[6] & 0x0f) | 0x40; // versión 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // variante RFC 4122

    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).toList();

    return '${hex.sublist(0, 4).join()}-'
        '${hex.sublist(4, 6).join()}-'
        '${hex.sublist(6, 8).join()}-'
        '${hex.sublist(8, 10).join()}-'
        '${hex.sublist(10, 16).join()}';
  }

  /// Alfabeto del código de junta: sin O, 0, I ni 1.
  ///
  /// El código se dicta hablando, de una señora a otra, en un mercado con
  /// ruido. Una O que se oye como cero arruina el intento.
  static const String alfabetoCodigo = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  /// Código de 6 caracteres, el mismo formato que genera Postgres.
  ///
  /// Se genera en el teléfono para poder crear juntas sin señal. Son 32^6, algo
  /// más de mil millones de combinaciones; si aun así chocara, la restricción
  /// UNIQUE de la base rechaza el segundo y la sincronización lo reporta.
  static String codigoDeJunta() {
    return List.generate(
      6,
      (_) => alfabetoCodigo[_azar.nextInt(alfabetoCodigo.length)],
    ).join();
  }
}
