import '../../aportes/domain/aporte.dart';
import '../../juntas/domain/frecuencia.dart';

/// Cómo se portó una participante a lo largo de toda la junta.
///
/// Es lo que la cabeza de junta quiere saber cuando arma la siguiente: a quién
/// vuelve a invitar. En el mercado esa decisión hoy se toma de memoria y de
/// rencores; esto la apoya con la cuenta real.
class CumplimientoDeParticipante {
  const CumplimientoDeParticipante({
    required this.participanteId,
    required this.nombre,
    required this.totales,
    required this.aTiempo,
    required this.tarde,
    required this.diasDeAtrasoSumados,
    required this.pendientes,
    required this.pendientesVencidos,
  });

  final String participanteId;
  final String nombre;

  /// Cuántos aportes le tocaban en toda la junta.
  final int totales;

  final int aTiempo;
  final int tarde;

  /// Suma de días de atraso de lo que sí pagó, para poder promediar.
  final int diasDeAtrasoSumados;

  final int pendientes;

  /// De lo pendiente, lo que además ya venció. Es lo que de verdad duele.
  final int pendientesVencidos;

  int get pagados => aTiempo + tarde;

  /// Entre 0 y 1. De lo que pagó, cuánto fue puntual.
  ///
  /// Quien no pagó nada todavía no tiene puntualidad que mostrar: devuelve 1
  /// para no castigar a una junta que recién empieza. Para saber quién debe
  /// está [pendientesVencidos], que es otra pregunta.
  double get puntualidad => pagados == 0 ? 1 : aTiempo / pagados;

  /// Entre 0 y 1. Cuánto del total de la junta lleva pagado.
  double get avance => totales == 0 ? 0 : pagados / totales;

  /// Días de atraso promedio de lo que pagó tarde. Cero si nunca se atrasó.
  int get diasPromedioDeAtraso =>
      tarde == 0 ? 0 : (diasDeAtrasoSumados / tarde).round();

  bool get siempreATiempo => tarde == 0 && pendientesVencidos == 0;
  bool get debe => pendientesVencidos > 0;

  /// Una línea para mostrar en la lista, sin que la pantalla arme frases.
  String get resumen {
    if (debe) {
      return pendientesVencidos == 1
          ? 'Debe 1 aporte'
          : 'Debe $pendientesVencidos aportes';
    }
    if (siempreATiempo) return 'Siempre a tiempo';
    return tarde == 1
        ? 'Se atrasó 1 vez, $diasPromedioDeAtraso días'
        : 'Se atrasó $tarde veces, $diasPromedioDeAtraso días en promedio';
  }
}

/// El historial completo de una junta.
///
/// Dart puro y con tests. Ni la base ni el widget calculan nada de esto.
class HistorialDeJunta {
  const HistorialDeJunta._();

  /// Cuántos días de gracia hay antes de considerar tarde un pago.
  ///
  /// Cero: si el turno era el lunes y pagó el martes, se atrasó. Una junta se
  /// sostiene porque el dinero está el día que tiene que estar; suavizar esto
  /// sería mentirle a la cabeza de junta sobre en quién puede confiar.
  static const int diasDeGracia = 0;

  /// Ordena de peor a mejor cumplimiento: primero quien debe, después quien se
  /// atrasó más. Lo que la cabeza de junta necesita ver está arriba.
  static List<CumplimientoDeParticipante> calcular({
    required List<({String id, String nombre})> participantes,
    required List<Turno> turnos,
    required List<Aporte> aportes,
    required DateTime hoy,
  }) {
    final fechaPorTurno = {for (final t in turnos) t.id: t.fechaProgramada};

    final resultado = <CumplimientoDeParticipante>[];

    for (final p in participantes) {
      final suyos = aportes.where((a) => a.participanteId == p.id).toList();

      var aTiempo = 0;
      var tarde = 0;
      var diasSumados = 0;
      var pendientes = 0;
      var vencidos = 0;

      for (final aporte in suyos) {
        final vence = fechaPorTurno[aporte.turnoId];
        if (vence == null) continue;

        if (!aporte.estaPagado) {
          pendientes++;
          if (CalculoDeFechas.diasDeAtraso(vence, hoy) > diasDeGracia) {
            vencidos++;
          }
          continue;
        }

        final pagado = aporte.pagadoEn;
        // Pagado sin fecha no debería existir: el CHECK del esquema lo impide.
        // Si aun así llega, se cuenta a favor en vez de inventar un atraso.
        if (pagado == null) {
          aTiempo++;
          continue;
        }

        final dias = CalculoDeFechas.diasDeAtraso(vence, pagado);
        if (dias > diasDeGracia) {
          tarde++;
          diasSumados += dias;
        } else {
          aTiempo++;
        }
      }

      resultado.add(
        CumplimientoDeParticipante(
          participanteId: p.id,
          nombre: p.nombre,
          totales: suyos.length,
          aTiempo: aTiempo,
          tarde: tarde,
          diasDeAtrasoSumados: diasSumados,
          pendientes: pendientes,
          pendientesVencidos: vencidos,
        ),
      );
    }

    resultado.sort((a, b) {
      if (a.debe != b.debe) return a.debe ? -1 : 1;
      final porVencidos = b.pendientesVencidos.compareTo(a.pendientesVencidos);
      if (porVencidos != 0) return porVencidos;
      final porPuntualidad = a.puntualidad.compareTo(b.puntualidad);
      if (porPuntualidad != 0) return porPuntualidad;
      return a.nombre.compareTo(b.nombre);
    });

    return resultado;
  }

  /// Texto para compartir por WhatsApp al cerrar el ciclo.
  ///
  /// Sin señalar a nadie con nombre y apellido en un grupo: se dice quiénes
  /// cumplieron y cuántas se atrasaron, no quién es la que debe. Esa
  /// conversación es de dos personas, no del grupo.
  static String resumenParaCompartir({
    required String nombreJunta,
    required List<CumplimientoDeParticipante> cumplimiento,
  }) {
    final puntuales = cumplimiento.where((c) => c.siempreATiempo).toList();

    final lineas = <String>[
      'Cierre de la $nombreJunta',
      '',
      'Participantes: ${cumplimiento.length}',
      'Siempre a tiempo: ${puntuales.length}',
      if (puntuales.isNotEmpty)
        puntuales.map((c) => c.nombre.split(' ').first).join(', '),
      '',
      '¡Gracias a todas!',
    ];

    return lineas.join('\n');
  }
}
