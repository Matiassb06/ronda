import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';

import '../local/base_local.dart';
import '../remoto/fuente_remota.dart';

/// Resultado de un intento de sincronización, para poder mostrarlo y probarlo.
class ResultadoSync {
  const ResultadoSync({
    required this.empujados,
    required this.pendientes,
    required this.descargo,
    this.error,
  });

  final int empujados;
  final int pendientes;
  final bool descargo;
  final Object? error;

  bool get todoAlDia => pendientes == 0 && error == null;
}

/// Mueve datos entre la base local y Supabase, en los dos sentidos.
///
/// El orden no es negociable: **primero empujar, después descargar**. Si se
/// descargara primero, lo de Supabase pisaría cambios locales que todavía no
/// se subieron, y la cabeza de junta vería desaparecer los pagos que acaba de
/// marcar. Por la misma razón, si la cola no se vació entero, no se descarga
/// nada: se deja la base local como está hasta que haya señal de verdad.
class Sincronizador {
  Sincronizador(this._local, this._remoto);

  final BaseLocal _local;
  final FuenteRemota _remoto;

  /// Después de tantos intentos fallidos, un cambio deja de bloquear la cola.
  ///
  /// Un fallo repetido ya no es falta de señal: es un dato que Postgres rechaza
  /// (una restricción rota, un código de junta repetido). Si se reintentara
  /// para siempre, todo lo que viene detrás se quedaría atascado.
  static const int intentosMaximos = 5;

  bool _corriendo = false;

  Future<ResultadoSync> sincronizar() async {
    // Dos pantallas pueden pedir sincronizar a la vez. Sin este candado, la
    // misma fila de la cola se mandaría dos veces.
    if (_corriendo) {
      return ResultadoSync(
        empujados: 0,
        pendientes: (await _local.leerCola()).length,
        descargo: false,
      );
    }
    if (!_remoto.haySesion) {
      return const ResultadoSync(empujados: 0, pendientes: 0, descargo: false);
    }

    _corriendo = true;
    try {
      await _subirVoucheres();
      final empujados = await _empujar();
      final quedan = (await _local.leerCola()).length;

      if (quedan > 0) {
        return ResultadoSync(
          empujados: empujados,
          pendientes: quedan,
          descargo: false,
        );
      }

      await _descargar();
      return ResultadoSync(empujados: empujados, pendientes: 0, descargo: true);
    } catch (e) {
      return ResultadoSync(
        empujados: 0,
        pendientes: (await _local.leerCola()).length,
        descargo: false,
        error: e,
      );
    } finally {
      _corriendo = false;
    }
  }

  /// Vacía la cola en orden de llegada.
  ///
  /// Se corta al primer fallo en vez de saltarse la fila y seguir: los cambios
  /// dependen unos de otros. Los participantes de una junta no pueden subir
  /// antes que la junta.
  Future<int> _empujar() async {
    var empujados = 0;

    for (final cambio in await _local.leerCola()) {
      try {
        await _remoto.aplicar(
          tabla: cambio.tabla,
          operacion: cambio.operacion,
          filaId: cambio.filaId,
          datos: (jsonDecode(cambio.datos) as Map).cast<String, dynamic>(),
        );
        await _local.quitarDeLaCola(cambio.id);
        empujados++;
      } catch (e) {
        if (cambio.intentos + 1 >= intentosMaximos) {
          // Rechazado por la base, no por falta de señal. Se aparta para que
          // la cola siga corriendo; queda en el reporte de sincronización.
          await _local.quitarDeLaCola(cambio.id);
          continue;
        }
        await _local.anotarFallo(cambio.id, e.toString(), cambio.intentos);
        break;
      }
    }

    return empujados;
  }

  /// Sube las fotos de voucher que esperan señal.
  ///
  /// Va antes de la cola de filas para que, cuando el UPDATE del aporte llegue
  /// a Postgres, la ruta del voucher ya exista. Al revés se subiría una fila
  /// apuntando a un archivo que todavía no está.
  ///
  /// Un fallo aquí no detiene nada: el aporte ya está marcado como pagado y la
  /// foto es un respaldo, no el dato. Se reintenta en el siguiente latido.
  Future<void> _subirVoucheres() async {
    for (final aporte in await _local.leerVoucheresPendientes()) {
      final ruta = aporte.voucherLocal;
      if (ruta == null) continue;

      try {
        final archivo = File(ruta);
        if (!archivo.existsSync()) {
          // La foto ya no está en el teléfono: se deja de intentar.
          await _local.olvidarVoucherLocal(aporte.id);
          continue;
        }

        final enElBucket = await _remoto.subirVoucher(
          juntaId: aporte.juntaId,
          aporteId: aporte.id,
          bytes: await archivo.readAsBytes(),
        );

        await _local.anotarVoucherSubido(aporte.id, enElBucket);
        await _local.encolar(
          tabla: 'aportes',
          filaId: aporte.id,
          operacion: 'actualizar',
          datos: jsonEncode({'voucher_path': enElBucket}),
        );
      } catch (_) {
        // Sin señal o el bucket rechazó: se intenta en el próximo latido.
        continue;
      }
    }
  }

  /// Trae todo lo del usuario y reemplaza el espejo local.
  ///
  /// Solo corre con la cola vacía, así que aquí Supabase es la verdad completa
  /// y se puede reescribir sin perder nada. Es más simple y más seguro que
  /// intentar mezclar fila por fila.
  Future<void> _descargar() async {
    final juntas = await _remoto.juntas();
    final ids = juntas.map((j) => j['id'] as String).toList();

    final participantes = await _remoto.participantes(ids);
    final turnos = await _remoto.turnos(ids);
    final aportes = await _remoto.aportes(ids);

    await _local.transaction(() async {
      await _local.delete(_local.aportesLocales).go();
      await _local.delete(_local.turnosLocales).go();
      await _local.delete(_local.participantesLocales).go();
      await _local.delete(_local.juntasLocales).go();

      await _local.batch((b) {
        b.insertAll(_local.juntasLocales, [
          for (final j in juntas)
            JuntasLocalesCompanion.insert(
              id: j['id'] as String,
              cabezaId: j['cabeza_id'] as String,
              nombre: j['nombre'] as String,
              codigo: j['codigo'] as String,
              montoAporteCentavos: (j['monto_aporte_centavos'] as num).toInt(),
              frecuencia: j['frecuencia'] as String,
              fechaInicio: DateTime.parse(j['fecha_inicio'] as String),
              estado: j['estado'] as String,
              actualizadoEn: _instante(j['actualizado_en']),
            ),
        ]);

        b.insertAll(_local.participantesLocales, [
          for (final p in participantes)
            ParticipantesLocalesCompanion.insert(
              id: p['id'] as String,
              juntaId: p['junta_id'] as String,
              nombre: p['nombre'] as String,
              telefono: Value(p['telefono'] as String?),
              ordenTurno: (p['orden_turno'] as num).toInt(),
              activo: Value(p['activo'] as bool? ?? true),
              actualizadoEn: _instante(p['actualizado_en']),
            ),
        ]);

        b.insertAll(_local.turnosLocales, [
          for (final t in turnos)
            TurnosLocalesCompanion.insert(
              id: t['id'] as String,
              juntaId: t['junta_id'] as String,
              participanteId: t['participante_id'] as String,
              numero: (t['numero'] as num).toInt(),
              fechaProgramada: DateTime.parse(t['fecha_programada'] as String),
              estado: t['estado'] as String,
              actualizadoEn: _instante(t['actualizado_en']),
            ),
        ]);

        b.insertAll(_local.aportesLocales, [
          for (final a in aportes)
            AportesLocalesCompanion.insert(
              id: a['id'] as String,
              juntaId: a['junta_id'] as String,
              turnoId: a['turno_id'] as String,
              participanteId: a['participante_id'] as String,
              montoCentavos: (a['monto_centavos'] as num).toInt(),
              estado: a['estado'] as String,
              pagadoEn: Value(
                a['pagado_en'] == null
                    ? null
                    : DateTime.parse(a['pagado_en'] as String).toLocal(),
              ),
              voucherPath: Value(a['voucher_path'] as String?),
              actualizadoEn: _instante(a['actualizado_en']),
            ),
        ]);
      });
    });
  }

  static DateTime _instante(Object? valor) {
    if (valor is String) return DateTime.parse(valor).toLocal();
    return DateTime.now();
  }
}
