import '../../juntas/domain/frecuencia.dart';

enum EstadoAporte {
  pendiente('pendiente'),
  pagado('pagado');

  const EstadoAporte(this.valorEnBase);
  final String valorEnBase;

  static EstadoAporte desdeBase(String valor) => EstadoAporte.values.firstWhere(
    (e) => e.valorEnBase == valor,
    orElse: () => throw ArgumentError('Estado de aporte desconocido: $valor'),
  );
}

/// Lo que una participante pone en un turno.
class Aporte {
  const Aporte({
    required this.id,
    required this.juntaId,
    required this.turnoId,
    required this.participanteId,
    required this.montoCentavos,
    required this.estado,
    this.pagadoEn,
    this.voucherPath,
  });

  final String id;
  final String juntaId;
  final String turnoId;
  final String participanteId;
  final int montoCentavos;
  final EstadoAporte estado;

  /// Instante, no fecha civil: va en UTC y se muestra en America/Lima.
  final DateTime? pagadoEn;

  final String? voucherPath;

  bool get estaPagado => estado == EstadoAporte.pagado;

  factory Aporte.desdeMapa(Map<String, dynamic> fila) {
    final pagado = fila['pagado_en'] as String?;
    return Aporte(
      id: fila['id'] as String,
      juntaId: fila['junta_id'] as String,
      turnoId: fila['turno_id'] as String,
      participanteId: fila['participante_id'] as String,
      montoCentavos: (fila['monto_centavos'] as num).toInt(),
      estado: EstadoAporte.desdeBase(fila['estado'] as String),
      pagadoEn: pagado == null ? null : DateTime.parse(pagado).toLocal(),
      voucherPath: fila['voucher_path'] as String?,
    );
  }
}

/// Un turno del calendario, ya guardado.
class Turno {
  const Turno({
    required this.id,
    required this.juntaId,
    required this.participanteId,
    required this.numero,
    required this.fechaProgramada,
    required this.completado,
  });

  final String id;
  final String juntaId;

  /// Quién cobra en este turno.
  final String participanteId;

  final int numero;
  final DateTime fechaProgramada;
  final bool completado;

  factory Turno.desdeMapa(Map<String, dynamic> fila) {
    return Turno(
      id: fila['id'] as String,
      juntaId: fila['junta_id'] as String,
      participanteId: fila['participante_id'] as String,
      numero: (fila['numero'] as num).toInt(),
      fechaProgramada: DateTime.parse(fila['fecha_programada'] as String),
      completado: (fila['estado'] as String) == 'completado',
    );
  }

  /// Días de atraso respecto a hoy. Cero si todavía no vence.
  int diasDeAtraso(DateTime hoy) =>
      CalculoDeFechas.diasDeAtraso(fechaProgramada, hoy);

  bool estaAtrasado(DateTime hoy) => !completado && diasDeAtraso(hoy) > 0;
}

/// Las cuentas de un turno: lo que la cabeza de junta mira de un vistazo.
///
/// Dart puro y con tests. No calcula nada la base ni el widget.
class ResumenDeTurno {
  const ResumenDeTurno({
    required this.pagados,
    required this.total,
    required this.recaudadoCentavos,
    required this.esperadoCentavos,
    required this.diasDeAtraso,
  });

  final int pagados;
  final int total;
  final int recaudadoCentavos;
  final int esperadoCentavos;
  final int diasDeAtraso;

  int get faltan => total - pagados;
  int get faltaCobrarCentavos => esperadoCentavos - recaudadoCentavos;
  bool get estaCompleto => total > 0 && pagados == total;
  bool get estaAtrasado => diasDeAtraso > 0 && !estaCompleto;

  /// Entre 0 y 1. Sirve para la barra de progreso.
  double get avance => total == 0 ? 0 : pagados / total;

  /// Calcula el resumen de un turno a partir de sus aportes.
  static ResumenDeTurno calcular({
    required List<Aporte> aportes,
    required int montoAporteCentavos,
    required DateTime fechaProgramada,
    required DateTime hoy,
  }) {
    final pagados = aportes.where((a) => a.estaPagado).toList();
    return ResumenDeTurno(
      pagados: pagados.length,
      total: aportes.length,
      recaudadoCentavos: pagados.fold(0, (suma, a) => suma + a.montoCentavos),
      esperadoCentavos: aportes.length * montoAporteCentavos,
      diasDeAtraso: CalculoDeFechas.diasDeAtraso(fechaProgramada, hoy),
    );
  }
}
