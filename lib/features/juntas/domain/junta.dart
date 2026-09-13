import 'frecuencia.dart';

/// Estado de una junta en el ciclo de vida.
enum EstadoJunta {
  borrador('borrador', 'Sin empezar'),
  activa('activa', 'En curso'),
  cerrada('cerrada', 'Terminada');

  const EstadoJunta(this.valorEnBase, this.etiqueta);
  final String valorEnBase;
  final String etiqueta;

  static EstadoJunta desdeBase(String valor) => EstadoJunta.values.firstWhere(
    (e) => e.valorEnBase == valor,
    orElse: () => throw ArgumentError('Estado de junta desconocido: $valor'),
  );
}

/// Una junta.
///
/// Clase Dart simple con mapeo escrito a mano en vez de freezed: las columnas
/// van en snake_case, los montos son enteros de centavos y las fechas civiles
/// no se convierten por zona horaria (decisión D03). Escribir el mapeo explícito
/// deja esas tres reglas a la vista en vez de esconderlas tras un generador.
class Junta {
  const Junta({
    required this.id,
    required this.cabezaId,
    required this.nombre,
    required this.codigo,
    required this.montoAporteCentavos,
    required this.frecuencia,
    required this.fechaInicio,
    required this.estado,
    this.notas,
  });

  final String id;
  final String cabezaId;
  final String nombre;

  /// Los 6 caracteres que se dictan hablando. Los genera la base, no la app.
  final String codigo;

  final int montoAporteCentavos;
  final Frecuencia frecuencia;

  /// Fecha civil, sin hora.
  final DateTime fechaInicio;

  final EstadoJunta estado;
  final String? notas;

  factory Junta.desdeMapa(Map<String, dynamic> fila) {
    return Junta(
      id: fila['id'] as String,
      cabezaId: fila['cabeza_id'] as String,
      nombre: fila['nombre'] as String,
      codigo: fila['codigo'] as String,
      montoAporteCentavos: (fila['monto_aporte_centavos'] as num).toInt(),
      frecuencia: Frecuencia.desdeBase(fila['frecuencia'] as String),
      fechaInicio: DateTime.parse(fila['fecha_inicio'] as String),
      estado: EstadoJunta.desdeBase(fila['estado'] as String),
      notas: fila['notas'] as String?,
    );
  }

  /// Lo que se manda al crear. Sin id ni código: los pone Postgres.
  static Map<String, dynamic> paraCrear({
    required String cabezaId,
    required String nombre,
    required int montoAporteCentavos,
    required Frecuencia frecuencia,
    required DateTime fechaInicio,
  }) {
    return {
      'cabeza_id': cabezaId,
      'nombre': nombre.trim(),
      'monto_aporte_centavos': montoAporteCentavos,
      'frecuencia': frecuencia.valorEnBase,
      'fecha_inicio': comoFechaCivil(fechaInicio),
      'estado': EstadoJunta.borrador.valorEnBase,
    };
  }

  /// `YYYY-MM-DD`, que es lo que espera una columna DATE.
  static String comoFechaCivil(DateTime fecha) {
    final mes = fecha.month.toString().padLeft(2, '0');
    final dia = fecha.day.toString().padLeft(2, '0');
    return '${fecha.year}-$mes-$dia';
  }
}
