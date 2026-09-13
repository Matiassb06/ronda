/// Todos los textos visibles de la app, en un solo lugar.
///
/// La regla 6 del CLAUDE.md dice que ningun texto visible vive dentro de un
/// widget. El motivo no es la internacionalizacion, que no existe aqui: es que
/// el vocabulario de una junta es especifico y hay que poder corregirlo entero
/// despues de la primera visita al mercado, sin salir a buscar strings sueltos
/// por las pantallas.
///
/// La app es solo en espanol. Si algun dia deja de serlo, este archivo es el
/// unico que se duplica.
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
      'Entra con tu correo de Google. Solo tu necesitas la app: '
      'las participantes no tienen que instalar nada.';
  static const String errorLogin = 'No se pudo entrar. Intenta de nuevo.';
  static const String salir = 'Cerrar sesion';

  // Pantalla principal
  static const String misJuntas = 'Mis juntas';
  static const String sinJuntas = 'Todavia no tienes ninguna junta';
  static const String crearJunta = 'Crear junta';

  // Configuracion faltante
  static const String configuracionFaltante = 'Falta configurar la app';
  static const String configuracionFaltanteDetalle =
      'La app no recibio los datos de conexion. Esto es un problema de '
      'instalacion, no tuyo.';
  static const String configuracionFaltanteQueFalta = 'Falta:';
  static const String configuracionFaltanteComoSeArregla =
      'Quien instalo la app tiene que ejecutarla pasando estos valores con '
      '--dart-define.';

  // Generales
  static const String reintentar = 'Reintentar';
  static const String cargando = 'Cargando...';
}
