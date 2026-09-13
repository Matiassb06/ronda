import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:ronda/data/local/base_local.dart';
import 'package:ronda/data/remoto/fuente_remota.dart';
import 'package:ronda/data/repositorio_juntas.dart';
import 'package:ronda/data/sincronizacion/sincronizador.dart';
import 'package:ronda/features/juntas/domain/frecuencia.dart';
import 'package:ronda/features/juntas/domain/junta.dart';

/// Una fuente remota que no hace nada: aquí se prueba la lógica local.
class _SinRed implements FuenteRemota {
  @override
  bool get haySesion => false;

  @override
  String? get usuarioId => 'cabeza-1';

  @override
  Future<List<Map<String, dynamic>>> juntas() async => const [];

  @override
  Future<List<Map<String, dynamic>>> participantes(List<String> i) async =>
      const [];

  @override
  Future<List<Map<String, dynamic>>> turnos(List<String> i) async => const [];

  @override
  Future<List<Map<String, dynamic>>> aportes(List<String> i) async => const [];

  @override
  Future<void> aplicar({
    required String tabla,
    required String operacion,
    required String filaId,
    required Map<String, dynamic> datos,
  }) async {}

  @override
  Future<String> subirVoucher({
    required String juntaId,
    required String aporteId,
    required Uint8List bytes,
  }) async => '';
}

void main() {
  late BaseLocal local;
  late RepositorioJuntas repo;

  setUp(() {
    local = BaseLocal.enMemoria();
    final remoto = _SinRed();
    repo = RepositorioJuntas(local, remoto, Sincronizador(local, remoto));
  });

  tearDown(() => local.close());

  Future<Junta> juntaDePrueba({int participantes = 3}) async {
    final junta = await repo.crearJunta(
      nombre: 'Junta del mercado',
      montoAporteCentavos: 5000,
      frecuencia: Frecuencia.semanal,
      fechaInicio: DateTime(2026, 9, 14),
    );
    for (var i = 0; i < participantes; i++) {
      await repo.agregarParticipante(juntaId: junta.id, nombre: 'Persona $i');
    }
    return junta;
  }

  Future<Junta> leer(String id) async => (await repo.verJunta(id).first)!;

  group('la junta se cierra sola', () {
    test('al completar el último turno pasa a cerrada', () async {
      final junta = await juntaDePrueba();
      await repo.generarCalendario(junta.id);

      final turnos = await repo.verTurnos(junta.id).first;
      expect(turnos, hasLength(3));
      expect((await leer(junta.id)).estado, EstadoJunta.activa);

      await repo.completarTurno(turnos[0].id, juntaId: junta.id);
      await repo.completarTurno(turnos[1].id, juntaId: junta.id);
      expect(
        (await leer(junta.id)).estado,
        EstadoJunta.activa,
        reason: 'todavía queda uno',
      );

      await repo.completarTurno(turnos[2].id, juntaId: junta.id);
      expect((await leer(junta.id)).estado, EstadoJunta.cerrada);
    });

    test('deshacer un turno vuelve a abrir la junta', () async {
      final junta = await juntaDePrueba(participantes: 1);
      await repo.generarCalendario(junta.id);
      final turno = (await repo.verTurnos(junta.id).first).single;

      await repo.completarTurno(turno.id, juntaId: junta.id);
      expect((await leer(junta.id)).estado, EstadoJunta.cerrada);

      await repo.deshacerTurno(turno.id, juntaId: junta.id);
      expect((await leer(junta.id)).estado, EstadoJunta.activa);
      expect((await repo.verTurnos(junta.id).first).single.completado, isFalse);
    });
  });

  group('la lista de participantes se congela al empezar', () {
    test(
      'agregar despues del calendario es un error, no un silencio',
      () async {
        final junta = await juntaDePrueba();
        await repo.generarCalendario(junta.id);

        expect(
          () => repo.agregarParticipante(juntaId: junta.id, nombre: 'Tardía'),
          throwsA(isA<JuntaYaEmpezada>()),
        );
        expect(await repo.verParticipantes(junta.id).first, hasLength(3));
      },
    );

    // Sin esta guarda, el borrado se aceptaba en el teléfono y Postgres lo
    // rechazaba por ON DELETE RESTRICT: las dos bases quedaban distintas.
    test('quitar despues del calendario tambien', () async {
      final junta = await juntaDePrueba();
      await repo.generarCalendario(junta.id);
      final gente = await repo.verParticipantes(junta.id).first;

      expect(
        () => repo.borrarParticipante(
          participanteId: gente.first.id,
          juntaId: junta.id,
        ),
        throwsA(isA<JuntaYaEmpezada>()),
      );
      expect(await repo.verParticipantes(junta.id).first, hasLength(3));
    });

    test('antes del calendario si se puede agregar y quitar', () async {
      final junta = await juntaDePrueba();
      final gente = await repo.verParticipantes(junta.id).first;

      await repo.borrarParticipante(
        participanteId: gente.first.id,
        juntaId: junta.id,
      );
      expect(await repo.verParticipantes(junta.id).first, hasLength(2));

      await repo.agregarParticipante(juntaId: junta.id, nombre: 'Nueva');
      expect(await repo.verParticipantes(junta.id).first, hasLength(3));
    });

    test('corregir un telefono SI se puede con la junta empezada', () async {
      final junta = await juntaDePrueba();
      await repo.generarCalendario(junta.id);
      final gente = await repo.verParticipantes(junta.id).first;

      await repo.editarParticipante(
        participanteId: gente.first.id,
        nombre: 'Rosa Quispe',
        telefono: '987 654 321',
      );

      final despues = (await repo.verParticipantes(junta.id).first).firstWhere(
        (p) => p.id == gente.first.id,
      );
      expect(despues.nombre, 'Rosa Quispe');
      expect(despues.telefono, '987654321', reason: 'se limpian los espacios');
    });
  });

  group('editar la junta', () {
    test('el nombre se cambia siempre', () async {
      final junta = await juntaDePrueba();
      await repo.generarCalendario(junta.id);

      await repo.editarJunta(juntaId: junta.id, nombre: 'Junta de la esquina');
      expect((await leer(junta.id)).nombre, 'Junta de la esquina');
    });

    test('el monto se cambia solo antes de generar el calendario', () async {
      final junta = await juntaDePrueba();

      await repo.editarJunta(
        juntaId: junta.id,
        nombre: junta.nombre,
        montoAporteCentavos: 8000,
      );
      expect((await leer(junta.id)).montoAporteCentavos, 8000);
    });

    test('con calendario, el monto queda donde estaba', () async {
      final junta = await juntaDePrueba();
      await repo.generarCalendario(junta.id);

      await repo.editarJunta(
        juntaId: junta.id,
        nombre: junta.nombre,
        montoAporteCentavos: 99999,
      );
      expect(
        (await leer(junta.id)).montoAporteCentavos,
        5000,
        reason: 'los aportes ya llevan su monto copiado',
      );
    });
  });

  group('borrar una junta', () {
    test('se lleva participantes, turnos y aportes', () async {
      final junta = await juntaDePrueba();
      await repo.generarCalendario(junta.id);

      expect(await repo.verAportes(junta.id).first, hasLength(9));

      await repo.borrarJunta(junta.id);

      expect(await repo.verJuntas().first, isEmpty);
      expect(await repo.verParticipantes(junta.id).first, isEmpty);
      expect(await repo.verTurnos(junta.id).first, isEmpty);
      expect(await repo.verAportes(junta.id).first, isEmpty);
    });

    test('no toca las demas juntas', () async {
      final unaJunta = await juntaDePrueba();
      final otra = await repo.crearJunta(
        nombre: 'La otra',
        montoAporteCentavos: 2000,
        frecuencia: Frecuencia.mensual,
        fechaInicio: DateTime(2026, 9, 14),
      );
      await repo.agregarParticipante(juntaId: otra.id, nombre: 'Alguien');

      await repo.borrarJunta(unaJunta.id);

      expect(await repo.verJuntas().first, hasLength(1));
      expect(await repo.verParticipantes(otra.id).first, hasLength(1));
    });
  });

  group('reparar juntas viejas', () {
    // Arreglar completarTurno no arregla los datos que ya estaban mal: una
    // junta terminada antes de la corrección se quedaba activa para siempre.
    test(
      'cierra una junta cuyos turnos ya estaban todos completados',
      () async {
        final junta = await juntaDePrueba(participantes: 2);
        await repo.generarCalendario(junta.id);
        final turnos = await repo.verTurnos(junta.id).first;

        // Se completan sin pasar por completarTurno, como si los hubiera dejado
        // así una versión anterior de la app.
        for (final t in turnos) {
          await (local.update(
            local.turnosLocales,
          )..where((f) => f.id.equals(t.id))).write(
            TurnosLocalesCompanion(
              estado: const Value('completado'),
              actualizadoEn: Value(DateTime.now()),
            ),
          );
        }
        expect((await leer(junta.id)).estado, EstadoJunta.activa);

        expect(await repo.repararJuntasTerminadas(), 1);
        expect((await leer(junta.id)).estado, EstadoJunta.cerrada);
      },
    );

    test('no toca una junta a la que le falta un turno', () async {
      final junta = await juntaDePrueba(participantes: 2);
      await repo.generarCalendario(junta.id);
      final turnos = await repo.verTurnos(junta.id).first;

      await repo.completarTurno(turnos.first.id, juntaId: junta.id);

      expect(await repo.repararJuntasTerminadas(), 0);
      expect((await leer(junta.id)).estado, EstadoJunta.activa);
    });

    test('no toca una junta sin calendario', () async {
      await juntaDePrueba();
      expect(await repo.repararJuntasTerminadas(), 0);
    });
  });

  group('cuando termina cada junta', () {
    test('es la fecha del ultimo turno', () async {
      final junta = await juntaDePrueba(participantes: 4);
      await repo.generarCalendario(junta.id);

      final fines = await repo.verFinDeCadaJunta().first;
      // Semanal desde el 14-sep: cuatro turnos, el ultimo el 5-oct.
      expect(fines[junta.id]!.toIso8601String().substring(0, 10), '2026-10-05');
    });

    test('una junta sin calendario no aparece', () async {
      final junta = await juntaDePrueba();
      expect(await repo.verFinDeCadaJunta().first, isEmpty);
      expect((await leer(junta.id)).estado, EstadoJunta.borrador);
    });
  });
}
