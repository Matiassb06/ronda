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
  static const String telefonoOpcional = 'Celular';
  static const String faltaTelefono = 'Escribe su celular';
  static const String telefonoInvalido = 'El celular tiene 9 números';
  static const String sinParticipantes =
      'Agrega a las personas de tu junta.\nDespués podrás cambiar el orden.';
  static const String ordenDeCobro = 'Orden en que cobran';
  static const String arrastraParaOrdenar =
      'Arrastra desde las rayitas para cambiar el orden';
  static const String empezarJunta = 'Empezar la junta';
  static const String quitarParticipante = 'Quitar';

  // Cuaderno
  static const String cobraHoy = 'Le toca cobrar a';
  static const String cobraEsteTurno = 'cobra este turno';
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
  static const String recordarPorWhatsApp = 'Recordarle por WhatsApp';
  static const String noSePudoAbrirWhatsApp = 'No se pudo abrir WhatsApp';

  // Voucher
  static const String tomarFotoDelVoucher = 'Tomar foto del voucher';
  static const String confirmaElVoucher = 'Confirma el pago';
  static const String revisaLoLeido =
      'Revisa lo que se leyó de la foto y corrige si hace falta.';
  static const String noSeLeyoElVoucher =
      'No se pudo leer la foto. Escribe el monto y la fecha.';
  static const String cuantoPago = '¿Cuánto pagó?';
  static const String confirmarPago = 'Confirmar pago';
  static const String leyendoElVoucher = 'Leyendo la foto...';

  // Historial
  static const String historial = 'Historial';
  static const String verHistorial = 'Ver historial';
  static const String siempreATiempo = 'Siempre a tiempo';
  static const String cumplimiento = 'Cumplimiento';
  static const String compartirResumen = 'Compartir resumen';
  static const String codigoDeLaJunta = 'Código de la junta';
  static const String sinHistorial = 'Todavía no hay nada que mostrar';
  static const String deAportes = 'de los aportes';

  // Calendario
  static const String calendario = 'Calendario';
  static const String verCalendario = 'Ver el calendario';
  static const String laJuntaTermina = 'La junta termina el';
  static const String empezo = 'Empezó el';
  static const String cadaUnaSeLleva = 'Cada una se lleva';
  static const String enCurso = 'En curso';
  static const String deshacer = 'Deshacer';
  static const String deshacerEntrega = '¿Deshacer la entrega?';
  static const String deshacerEntregaDetalle =
      'El turno vuelve a quedar pendiente. Úsalo solo si tocaste el botón sin querer.';

  // Editar y borrar
  static const String editar = 'Editar';
  static const String editarJunta = 'Editar la junta';
  static const String editarParticipante = 'Editar';
  static const String borrarJunta = 'Borrar la junta';
  static const String borrarJuntaPregunta = '¿Borrar esta junta?';
  static const String borrarJuntaDetalle =
      'Se borra con todo: participantes, turnos y pagos. No se puede recuperar.';
  static const String borrar = 'Borrar';
  static const String escribeElNombre =
      'Escribe el nombre de la junta para confirmar';
  static const String elNombreNoCoincide = 'El nombre no coincide';
  static const String juntaYaEmpezada =
      'La junta ya empezó: no se puede cambiar quiénes participan.';
  static const String elMontoNoSeCambia =
      'El monto no se puede cambiar con la junta ya empezada.';
  static const String guardadoOk = 'Guardado';
  static const String listaCongelada =
      'La junta ya empezó. Puedes corregir nombres y celulares, pero no cambiar quiénes participan.';
  static const String sinTelefono = 'Sin celular: no se le puede recordar';
  static const String hastaEl = 'Hasta el';

  // Moverse entre turnos
  static const String turnoAnterior = 'Turno anterior';
  static const String turnoSiguiente = 'Turno siguiente';
  static const String turnoEntregado = 'Entregado';
  static const String entregarPozoIncompleto = 'Cerrar este turno';
  static const String entregarSinCobrarTodo = '¿Cerrar sin cobrar todo?';
  static const String faltanPorPagar = 'Todavía faltan por pagar:';
  static const String entregarSinCobrarTodoDetalle =
      'El turno se cierra y pasa al siguiente. Lo que falta queda como deuda y se sigue viendo en el historial.';
  static const String entregarIgual = 'Cerrar igual';

  // Duración de la junta
  static const String cuantoDuraLaJunta = '¿Cuánto dura la junta?';
  static const String participante = 'participante';
  static const String participantesEnLaJunta = 'participantes';
  static const String duracionInvalida = 'Tiene que ser al menos 1';
  static const String terminaEl = 'Termina el';
  static const String repartoParejo = 'Cada una cobra una vez';
  static const String repartoParejoDetalle =
      'La cuenta sale a mano: todas ponen lo mismo y todas cobran su vuelta.';
  static const String unaNoCobra = 'Una participante no cobraría';
  static const String variasNoCobran = 'participantes no cobrarían';
  static const String noCobranDetalle =
      'Hay menos turnos que gente. Quien no cobre va a poner dinero sin recibir nunca su vuelta. Conviene hablarlo antes de empezar.';
  static const String cadaUnaCobra = 'Cada una cobra';
  static const String veces = 'veces';
  static const String cobraUnaVezMas = 'participante cobra una vez más';
  static const String cobranUnaVezMas = 'participantes cobran una vez más';
  static const String cobrarDeMasDetalle =
      'Pasa cuando alguien toma más de un número: paga doble y cobra doble. Asegúrate de que todas lo sepan.';
  static const String paraQueSirveElTelefono =
      'Para abrirle el chat de WhatsApp con el recordatorio';
  static const String cancelar = 'Cancelar';
  static const String errorGenerico = 'Algo salió mal. Intenta de nuevo.';
}
