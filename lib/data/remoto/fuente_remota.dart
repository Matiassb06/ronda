import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Lo que el sincronizador necesita del otro lado de la red.
///
/// Es una interfaz y no una clase concreta para que la cola de cambios se pueda
/// testear sin levantar Supabase. La cola es la pieza de la que depende que no
/// se pierda un pago marcado en el mercado: tiene que estar cubierta.
abstract interface class FuenteRemota {
  bool get haySesion;
  String? get usuarioId;

  Future<List<Map<String, dynamic>>> juntas();
  Future<List<Map<String, dynamic>>> participantes(List<String> juntaIds);
  Future<List<Map<String, dynamic>>> turnos(List<String> juntaIds);
  Future<List<Map<String, dynamic>>> aportes(List<String> juntaIds);

  Future<void> aplicar({
    required String tabla,
    required String operacion,
    required String filaId,
    required Map<String, dynamic> datos,
  });

  /// Sube la foto de un voucher y devuelve la ruta dentro del bucket.
  Future<String> subirVoucher({
    required String juntaId,
    required String aporteId,
    required Uint8List bytes,
  });
}

/// La implementación de verdad: el único sitio que habla con Supabase.
///
/// Devuelve mapas crudos, tal como vienen de Postgres. Quien los convierte a
/// modelos es la capa local, así que la red y el dominio no se tocan.
///
/// Las consultas no filtran por `cabeza_id` porque el RLS ya lo hace. Si algún
/// día el filtro faltara, la base devuelve vacío en vez de datos ajenos.
class FuenteRemotaSupabase implements FuenteRemota {
  const FuenteRemotaSupabase(this._cliente);

  final SupabaseClient _cliente;

  @override
  String? get usuarioId => _cliente.auth.currentUser?.id;

  @override
  bool get haySesion => usuarioId != null;

  @override
  Future<List<Map<String, dynamic>>> juntas() async {
    final filas = await _cliente.from('juntas').select();
    return filas.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> _deJuntas(
    String tabla,
    List<String> juntaIds,
  ) async {
    if (juntaIds.isEmpty) return const [];
    final filas = await _cliente
        .from(tabla)
        .select()
        .inFilter('junta_id', juntaIds);
    return filas.cast<Map<String, dynamic>>();
  }

  @override
  Future<List<Map<String, dynamic>>> participantes(List<String> juntaIds) =>
      _deJuntas('participantes', juntaIds);

  @override
  Future<List<Map<String, dynamic>>> turnos(List<String> juntaIds) =>
      _deJuntas('turnos', juntaIds);

  @override
  Future<List<Map<String, dynamic>>> aportes(List<String> juntaIds) =>
      _deJuntas('aportes', juntaIds);

  /// Aplica un cambio de la cola.
  ///
  /// `insertar` usa **upsert** a propósito: si la respuesta se perdió pero el
  /// INSERT sí llegó, reintentar no puede fallar por clave duplicada. Una cola
  /// que no es idempotente se atasca para siempre en el primer timeout.
  @override
  Future<void> aplicar({
    required String tabla,
    required String operacion,
    required String filaId,
    required Map<String, dynamic> datos,
  }) async {
    switch (operacion) {
      case 'insertar':
        await _cliente.from(tabla).upsert(datos);
      case 'insertar_varias':
        // El calendario entero en una llamada. Para doce participantes son 12
        // turnos y 144 aportes: subirlos de a uno tardaría una eternidad y
        // dejaría la junta a medio crear si se corta la señal en el medio.
        final filas = (datos['filas'] as List)
            .map((f) => (f as Map).cast<String, dynamic>())
            .toList();
        if (filas.isNotEmpty) await _cliente.from(tabla).upsert(filas);
      case 'actualizar':
        await _cliente.from(tabla).update(datos).eq('id', filaId);
      case 'borrar':
        await _cliente.from(tabla).delete().eq('id', filaId);
      default:
        throw ArgumentError('Operación desconocida en la cola: $operacion');
    }
  }

  /// La ruta es `<junta_id>/<aporte_id>.jpg` y no es decorativa: la primera
  /// carpeta es lo que autoriza la política de RLS del bucket. Cambiarla rompe
  /// el permiso, no solo el orden.
  @override
  Future<String> subirVoucher({
    required String juntaId,
    required String aporteId,
    required Uint8List bytes,
  }) async {
    final ruta = '$juntaId/$aporteId.jpg';
    await _cliente.storage
        .from('vouchers')
        .uploadBinary(
          ruta,
          bytes,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );
    return ruta;
  }
}
