/// Una participante de la junta.
///
/// **No es un usuario de la app.** Es una línea del cuaderno: nombre, teléfono
/// y el lugar que le toca en la rueda. No instala nada, no tiene cuenta y no
/// existe en `auth.users`. Toda la autorización cuelga de la junta.
class Participante {
  const Participante({
    required this.id,
    required this.juntaId,
    required this.nombre,
    required this.ordenTurno,
    required this.activo,
    this.telefono,
  });

  final String id;
  final String juntaId;
  final String nombre;

  /// Nueve dígitos, sin código de país. El 51 se antepone al armar el enlace
  /// de WhatsApp, no se guarda.
  final String? telefono;

  /// Desde 1. Es el orden en que cobra.
  final int ordenTurno;

  final bool activo;

  /// Primer nombre, para los espacios cortos de la lista.
  String get nombreCorto => nombre.trim().split(RegExp(r'\s+')).first;

  /// Iniciales para el avatar. Una o dos letras, nunca más.
  String get iniciales {
    final partes = nombre
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty);
    if (partes.isEmpty) return '?';
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return (partes.first.substring(0, 1) + partes.last.substring(0, 1))
        .toUpperCase();
  }

  bool get tieneTelefono => telefono != null && telefono!.trim().isNotEmpty;

  factory Participante.desdeMapa(Map<String, dynamic> fila) {
    return Participante(
      id: fila['id'] as String,
      juntaId: fila['junta_id'] as String,
      nombre: fila['nombre'] as String,
      telefono: fila['telefono'] as String?,
      ordenTurno: (fila['orden_turno'] as num).toInt(),
      activo: fila['activo'] as bool? ?? true,
    );
  }

  static Map<String, dynamic> paraCrear({
    required String juntaId,
    required String nombre,
    required int ordenTurno,
    String? telefono,
  }) {
    final limpio = telefono?.replaceAll(RegExp(r'\D'), '');
    return {
      'junta_id': juntaId,
      'nombre': nombre.trim(),
      'orden_turno': ordenTurno,
      if (limpio != null && limpio.isNotEmpty) 'telefono': limpio,
    };
  }

  /// Nueve dígitos exactos, que es como son los celulares en Perú.
  /// Vacío se acepta: el teléfono es opcional hasta el paso 4.
  static bool telefonoEsValido(String? texto) {
    if (texto == null || texto.trim().isEmpty) return true;
    return RegExp(r'^\d{9}$').hasMatch(texto.replaceAll(RegExp(r'\D'), ''));
  }

  Participante copiarCon({int? ordenTurno}) {
    return Participante(
      id: id,
      juntaId: juntaId,
      nombre: nombre,
      telefono: telefono,
      ordenTurno: ordenTurno ?? this.ordenTurno,
      activo: activo,
    );
  }
}
