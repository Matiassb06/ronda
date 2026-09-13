/// Todos los textos visibles de la app, en un solo lugar.
///
/// La regla 6 del CLAUDE.md dice que ningún texto visible vive dentro de un
/// widget. El motivo no es la internacionalización, que no existe aquí: es que
/// el vocabulario de una junta es específico y hay que poder corregirlo entero
/// después de la primera visita al mercado, sin salir a buscar strings sueltos
/// por las pantallas.
///
/// La app es solo en español, con sus tildes y sus eñes. Un texto sin acentos
/// se lee como escrito a las apuradas, y esta app tiene que dar confianza:
/// maneja la cuenta de la plata de doce personas.
library;

class Textos {
  const Textos._();

  // Identidad
  static const String nombreApp = 'Ronda';
  static const String lema = 'El cuaderno de tu junta';

  // Login
  static const String entrarConGoogle = 'Entrar con Google';
  static const String entrando = 'Abriendo Google...';
  static const String bienvenida = 'Tu junta, sin cuaderno';
  static const String explicacionLogin =
      'Entra con tu correo de Google. Solo tú necesitas la app: '
      'las participantes no tienen que instalar nada.';
  static const String errorLogin = 'No se pudo entrar. Intenta de nuevo.';
  static const String salir = 'Cerrar sesión';

  // Pantalla principal
  static const String misJuntas = 'Mis juntas';
  static const String sinJuntas = 'Todavía no tienes ninguna junta';
  static const String crearJunta = 'Crear junta';

  // Configuración faltante
  static const String configuracionFaltante = 'Falta configurar la app';
  static const String configuracionFaltanteDetalle =
      'La app no recibió los datos de conexión. Esto es un problema de '
      'instalación, no tuyo.';
  static const String configuracionFaltanteQueFalta = 'Falta:';
  static const String configuracionFaltanteComoSeArregla =
      'Quien instaló la app tiene que ejecutarla pasando estos valores con '
      '--dart-define.';

  // Crear junta
  static const String nuevaJunta = 'Nueva junta';
  static const String nombreDeLaJunta = 'Nombre de la junta';
  static const String ejemploNombreJunta = 'Junta del mercado';
  static const String cuantoPoneCadaUna = '¿Cuánto pone cada una?';
  static const String cadaCuanto = '¿Cada cuánto se cobra?';
  static const String cuandoEmpieza = '¿Qué día empieza?';
  static const String guardar = 'Guardar';
  static const String faltaNombre = 'Ponle un nombre';
  static const String faltaMonto = 'Escribe cuánto pone cada una';
  static const String montoInvalido = 'Ese monto no se entiende';

  // Participantes
  static const String participantes = 'Participantes';
  static const String agregarParticipante = 'Agregar';
  static const String nombreDeLaParticipante = 'Nombre';
  static const String telefonoOpcional = 'Celular (opcional)';
  static const String telefonoInvalido = 'El celular tiene 9 números';
  static const String sinParticipantes =
      'Agrega a las personas de tu junta.\nDespués podrás cambiar el orden.';
  static const String ordenDeCobro = 'Orden en que cobran';
  static const String arrastraParaOrdenar =
      'Mantén y arrastra para cambiar el orden';
  static const String empezarJunta = 'Empezar la junta';
  static const String quitarParticipante = 'Quitar';

  // Cuaderno
  static const String cobraHoy = 'Le toca cobrar a';
  static const String turnoDe = 'Turno';
  static const String de = 'de';
  static const String pagaron = 'Pagaron';
  static const String recaudado = 'Juntado';
  static const String pozoCompleto = '¡Ya está completo!';
  static const String entregarPozo = 'Ya le entregué el pozo';
  static const String juntaTerminada = 'Esta junta ya terminó';
  static const String sinCalendario = 'Esta junta todavía no empieza';
  static const String atrasadoPorDias = 'Atrasado';
  static const String dias = 'días';
  static const String dia = 'día';

  // Generales
  static const String reintentar = 'Reintentar';
  static const String cargando = 'Cargando...';
  static const String cancelar = 'Cancelar';
  static const String errorGenerico = 'Algo salió mal. Intenta de nuevo.';
}
