import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ronda/data/local/base_local.dart';
import 'package:ronda/data/remoto/fuente_remota.dart';
import 'package:ronda/data/sincronizacion/sincronizador.dart';

/// Una fuente remota de mentira, con interruptor de señal.
///
/// Todo lo que llega se apunta, para poder afirmar qué se subió y en qué orden.
class FuenteFalsa implements FuenteRemota {
  FuenteFalsa();

  /// Con esto en false, cada llamada falla como si no hubiera datos.
  bool haySenal = true;

  /// Tablas que rechazan siempre, para simular un dato que Postgres no acepta.
  final Set<String> rechazaSiempre = {};

  final List<String> aplicados = [];
  final List<String> voucheresSubidos = [];
  List<Map<String, dynamic>> juntasRemotas = [];

  @override
  bool get haySesion => true;

  @override
  String? get usuarioId => 'cabeza-1';

  void _comprobarSenal() {
    if (!haySenal) throw Exception('SocketException: sin conexión');
  }

  @override
  Future<List<Map<String, dynamic>>> juntas() async {
    _comprobarSenal();
    return juntasRemotas;
  }

  @override
  Future<List<Map<String, dynamic>>> participantes(List<String> ids) async {
    _comprobarSenal();
    return const [];
  }

  @override
  Future<List<Map<String, dynamic>>> turnos(List<String> ids) async {
    _comprobarSenal();
    return const [];
  }

  @override
  Future<List<Map<String, dynamic>>> aportes(List<String> ids) async {
    _comprobarSenal();
    return const [];
  }

  @override
  Future<void> aplicar({
    required String tabla,
    required String operacion,
    required String filaId,
    required Map<String, dynamic> datos,
  }) async {
    _comprobarSenal();
    if (rechazaSiempre.contains(tabla)) {
      throw Exception('violación de restricción en $tabla');
    }
    aplicados.add('$operacion:$tabla:$filaId');
  }

  @override
  Future<String> subirVoucher({
    required String juntaId,
    required String aporteId,
    required Uint8List bytes,
  }) async {
    _comprobarSenal();
    voucheresSubidos.add(aporteId);
    return '$juntaId/$aporteId.jpg';
  }
}

void main() {
  late BaseLocal local;
  late FuenteFalsa remoto;
  late Sincronizador sync;

  setUp(() {
    local = BaseLocal.enMemoria();
    remoto = FuenteFalsa();
    sync = Sincronizador(local, remoto);
  });

  tearDown(() => local.close());

  Future<void> encolar(String tabla, String id, [String op = 'insertar']) {
    return local.encolar(
      tabla: tabla,
      filaId: id,
      operacion: op,
      datos: jsonEncode({'id': id}),
    );
  }

  group('con señal', () {
    test('vacía la cola y descarga', () async {
      await encolar('juntas', 'j1');
      await encolar('participantes', 'p1');

      final r = await sync.sincronizar();

      expect(r.empujados, 2);
      expect(r.pendientes, 0);
      expect(r.descargo, isTrue);
      expect(r.todoAlDia, isTrue);
      expect(await local.leerCola(), isEmpty);
    });

    test('respeta el orden de llegada', () async {
      await encolar('juntas', 'j1');
      await encolar('participantes', 'p1');
      await encolar('participantes', 'p2');
      await encolar('turnos', 't1');

      await sync.sincronizar();

      expect(remoto.aplicados, [
        'insertar:juntas:j1',
        'insertar:participantes:p1',
        'insertar:participantes:p2',
        'insertar:turnos:t1',
      ]);
    });
  });

  group('sin señal', () {
    test('no sube nada y la cola queda intacta', () async {
      await encolar('juntas', 'j1');
      await encolar('aportes', 'a1', 'actualizar');
      remoto.haySenal = false;

      final r = await sync.sincronizar();

      expect(r.empujados, 0);
      expect(r.pendientes, 2);
      expect(r.descargo, isFalse);
      expect(r.todoAlDia, isFalse);
      expect(await local.leerCola(), hasLength(2));
    });

    test('NO descarga: descargar pisaría lo que todavía no subió', () async {
      // Este es el escenario que arruinaría la app: la cabeza de junta marca
      // pagos sin señal, vuelve la señal a medias y una descarga los borra.
      await encolar('aportes', 'a1', 'actualizar');
      remoto.haySenal = false;
      remoto.juntasRemotas = [
        {'id': 'j1', 'nombre': 'del mercado'},
      ];

      final r = await sync.sincronizar();

      expect(r.descargo, isFalse);
      expect(await local.verJuntas().first, isEmpty);
    });

    test('al volver la señal sube todo lo acumulado', () async {
      await encolar('juntas', 'j1');
      await encolar('participantes', 'p1');
      remoto.haySenal = false;

      await sync.sincronizar();
      expect(await local.leerCola(), hasLength(2));

      remoto.haySenal = true;
      final r = await sync.sincronizar();

      expect(r.empujados, 2);
      expect(await local.leerCola(), isEmpty);
    });

    test('cuenta los intentos fallidos en vez de perderlos', () async {
      await encolar('juntas', 'j1');
      remoto.haySenal = false;

      await sync.sincronizar();
      await sync.sincronizar();

      final cola = await local.leerCola();
      expect(cola.first.intentos, 2);
      expect(cola.first.ultimoError, contains('SocketException'));
    });
  });

  group('un cambio que la base rechaza', () {
    test('no bloquea la cola para siempre', () async {
      remoto.rechazaSiempre.add('juntas');
      await encolar('juntas', 'j-mala');
      await encolar('aportes', 'a1', 'actualizar');

      // Se corta en la fallida: lo de atrás no puede subir antes que lo de
      // adelante, porque puede depender de ello.
      for (var i = 0; i < Sincronizador.intentosMaximos; i++) {
        await sync.sincronizar();
      }

      final cola = await local.leerCola();
      expect(
        cola.any((c) => c.filaId == 'j-mala'),
        isFalse,
        reason: 'tras los intentos máximos se aparta',
      );

      await sync.sincronizar();
      expect(remoto.aplicados, contains('actualizar:aportes:a1'));
    });

    test('lo que va detrás espera, no se adelanta', () async {
      remoto.rechazaSiempre.add('juntas');
      await encolar('juntas', 'j-mala');
      await encolar('participantes', 'p1');

      await sync.sincronizar();

      expect(remoto.aplicados, isEmpty);
      expect(await local.leerCola(), hasLength(2));
    });
  });

  group('sin sesión', () {
    test('no intenta nada', () async {
      final sinSesion = Sincronizador(local, _SinSesion());
      await encolar('juntas', 'j1');

      final r = await sinSesion.sincronizar();

      expect(r.empujados, 0);
      expect(r.descargo, isFalse);
      expect(await local.leerCola(), hasLength(1));
    });
  });
}

class _SinSesion extends FuenteFalsa {
  @override
  bool get haySesion => false;
}
