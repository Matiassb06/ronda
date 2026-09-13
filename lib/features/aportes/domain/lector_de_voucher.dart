/// Lo que se pudo sacar de la foto de un voucher.
///
/// Los dos campos son opcionales a propósito. El OCR se equivoca: lee un 8 donde
/// hay un 3, pierde una línea con el brillo del sol. Devolver null es la
/// respuesta correcta cuando no se entendió, y es mejor que inventar un monto.
class LecturaDeVoucher {
  const LecturaDeVoucher({this.montoCentavos, this.fecha});

  final int? montoCentavos;
  final DateTime? fecha;

  bool get vacia => montoCentavos == null && fecha == null;
  bool get completa => montoCentavos != null && fecha != null;
}

/// Saca monto y fecha del texto que devuelve el OCR de un voucher.
///
/// Dart puro y con tests sobre cadenas reales de Yape y de los bancos. Es la
/// pieza que más se equivoca de todo el proyecto, así que es la que más pruebas
/// necesita.
///
/// **Esto nunca guarda un aporte solo** (regla 9 del CLAUDE.md). Lo que sale de
/// aquí va al formulario para que la cabeza de junta lo confirme o lo corrija.
/// El OCR sugiere; ella decide.
class LectorDeVoucher {
  const LectorDeVoucher._();

  /// Abreviaturas de mes como las escriben Yape y los bancos peruanos.
  ///
  /// Están las dos formas de setiembre: `set` es la peruana y `sep` la que usan
  /// las apps hechas afuera. En un voucher pueden aparecer cualquiera de las dos.
  static const Map<String, int> meses = {
    'ene': 1,
    'feb': 2,
    'mar': 3,
    'abr': 4,
    'may': 5,
    'jun': 6,
    'jul': 7,
    'ago': 8,
    'set': 9,
    'sep': 9,
    'oct': 10,
    'nov': 11,
    'dic': 12,
  };

  /// Palabras que, en la misma línea, señalan cuál es el monto que importa.
  ///
  /// Un voucher de banco trae varias cifras: el monto, la comisión, el saldo.
  /// Sin esto se tomaría la primera que aparezca, que a veces es la comisión.
  static const List<String> palabrasDeMonto = [
    'monto',
    'total',
    'importe',
    'yapeaste',
    'enviaste',
    'transferiste',
  ];

  static LecturaDeVoucher leer(String textoDelOcr) {
    return LecturaDeVoucher(
      montoCentavos: _buscarMonto(textoDelOcr),
      fecha: _buscarFecha(textoDelOcr),
    );
  }

  // ------------------------------------------------------------------ monto

  static final RegExp _conSimbolo = RegExp(
    r'S\s*/\.?\s*([\d.,]+)',
    caseSensitive: false,
  );

  static int? _buscarMonto(String texto) {
    final lineas = texto.split('\n');

    // Primero, una línea que diga explícitamente de qué monto se trata.
    for (final linea in lineas) {
      final minuscula = linea.toLowerCase();
      if (palabrasDeMonto.any(minuscula.contains)) {
        final monto = _primerMontoDeLaLinea(linea);
        if (monto != null) return monto;
      }
    }

    // Si ninguna lo dice, en Yape el monto está en la línea siguiente al
    // "¡Yapeaste!". Se recorre en orden y se toma el primero con S/.
    for (final linea in lineas) {
      final monto = _primerMontoDeLaLinea(linea);
      if (monto != null) return monto;
    }

    return null;
  }

  static int? _primerMontoDeLaLinea(String linea) {
    final coincidencia = _conSimbolo.firstMatch(linea);
    if (coincidencia == null) return null;
    return _aCentavos(coincidencia.group(1)!);
  }

  /// `50` -> 5000, `50.00` -> 5000, `1,250.50` -> 125050, `1.250,50` -> 125050.
  ///
  /// Los vouchers peruanos usan coma para miles y punto para decimales, pero
  /// algunos bancos hacen lo contrario. Se decide por la posición: el último
  /// separador manda, y si deja tres dígitos detrás era de miles.
  static int? _aCentavos(String crudo) {
    var texto = crudo.trim();
    if (texto.isEmpty) return null;

    final ultimo = texto.lastIndexOf(RegExp(r'[.,]'));
    if (ultimo == -1) {
      final soles = int.tryParse(texto);
      return soles == null ? null : soles * 100;
    }

    final entera = texto.substring(0, ultimo).replaceAll(RegExp(r'[.,]'), '');
    final decimal = texto.substring(ultimo + 1);

    if (decimal.length == 3 && !decimal.contains(RegExp(r'\D'))) {
      final soles = int.tryParse('$entera$decimal');
      return soles == null ? null : soles * 100;
    }
    if (decimal.isEmpty || decimal.length > 2) return null;
    if (decimal.contains(RegExp(r'\D')) || entera.contains(RegExp(r'\D'))) {
      return null;
    }

    final soles = entera.isEmpty ? 0 : int.tryParse(entera);
    final centavos = int.tryParse(decimal.padRight(2, '0'));
    if (soles == null || centavos == null) return null;

    return soles * 100 + centavos;
  }

  // ------------------------------------------------------------------ fecha

  /// `13/09/2026`, `13-09-2026`, `13/09/26`
  static final RegExp _conBarras = RegExp(
    r'\b(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})\b',
  );

  /// `13 set. 2026`, `13 Sep 2026`, `13 de setiembre de 2026`
  static final RegExp _conMesEnLetras = RegExp(
    r'\b(\d{1,2})\s+(?:de\s+)?([a-záéíóúñ]{3,10})\.?\s*(?:de\s+)?(\d{4})?\b',
    caseSensitive: false,
  );

  static DateTime? _buscarFecha(String texto) {
    final porBarras = _conBarras.firstMatch(texto);
    if (porBarras != null) {
      final dia = int.parse(porBarras.group(1)!);
      final mes = int.parse(porBarras.group(2)!);
      final anio = _anioCompleto(int.parse(porBarras.group(3)!));
      final fecha = _siEsValida(anio, mes, dia);
      if (fecha != null) return fecha;
    }

    for (final coincidencia in _conMesEnLetras.allMatches(texto)) {
      final mes = meses[coincidencia.group(2)!.toLowerCase().substring(0, 3)];
      if (mes == null) continue;

      final dia = int.parse(coincidencia.group(1)!);
      final grupoAnio = coincidencia.group(3);
      // Sin año en el voucher, se asume el actual: nadie yapea en 2019 y lo
      // registra hoy.
      final anio = grupoAnio == null
          ? DateTime.now().year
          : int.parse(grupoAnio);

      final fecha = _siEsValida(anio, mes, dia);
      if (fecha != null) return fecha;
    }

    return null;
  }

  static int _anioCompleto(int anio) => anio >= 100 ? anio : 2000 + anio;

  /// Rechaza el 31 de febrero en vez de dejar que DateTime lo corra al 3 de
  /// marzo, que es lo que hace por defecto y sería una fecha inventada.
  static DateTime? _siEsValida(int anio, int mes, int dia) {
    if (mes < 1 || mes > 12 || dia < 1 || dia > 31) return null;
    final fecha = DateTime(anio, mes, dia);
    if (fecha.year != anio || fecha.month != mes || fecha.day != dia) {
      return null;
    }
    return fecha;
  }
}
