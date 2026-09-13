# Decisiones pendientes de revisión

Este registro es acumulativo. Cada entrada conserva el contexto, la decisión
aplicada y las alternativas descartadas. El esquema aprobado permanece intacto.

## D01. Instrucciones de esta sesión

- Contexto: CLAUDE.md pide una rama por paso y escribir prosa en el vault al cerrar;
  el encargo actual exige construccion-inicial y prohíbe toda escritura allí.
- Decisión: todos los pasos en construccion-inicial; cierre y decisiones solo en docs/.
- Descartado: ramas adicionales y cualquier actualización del vault.

## D02. Herramientas dentro del directorio permitido

- Contexto: flutter.bat quedó esperando al intentar crear su candado en el SDK
  instalado fuera del área de escritura de la sesión.
- Decisión: copia de herramientas y cachés bajo .tooling/, ignorada por git. Los
  archivos del proyecto, los resultados y los auxiliares permanecen en D:\ronda.
- Descartado: cambiar permisos del SDK, escribir fuera del repo o pedir elevación.

## D03. Fechas compatibles con el esquema aprobado

- Contexto: la regla general pide timestamptz, pero fecha_inicio,
  fecha_programada, fecha_entregado y ocr_fecha son DATE en el SQL aprobado.
- Decisión: conservar esas fechas civiles como YYYY-MM-DD, sin convertirlas por
  la zona del teléfono. pagado_en, creado_en y actualizado_en son instantes UTC
  serializados con zona y se presentan en America/Lima.
- Descartado: editar la migración o enviar marcas horarias a columnas DATE.

## D04. Tipografía disponible sin conexión

- Contexto: no se entregaron archivos de fuentes y el puesto tiene mala señal.
- Decisión: tipografía del sistema Android, grande y de alto contraste. Se
  mantiene google_fonts en el stack, sin descargas de fuentes al arrancar.
- Descartado: depender de una fuente remota para mostrar el cuaderno.

## D05. CI y publicación pendiente

- Contexto: el repositorio debe permanecer local hoy y aún no tiene URL remota.
- Decisión: workflow preparado y badge con propietario de ejemplo, identificado
  como tal en README. Leonardo cambiará el destino cuando publique el repo.
- Descartado: inventar un propietario real, crear remotes, publicar o hacer push.

---

# Decisiones del revisor (sesion del 13-sep, sin creditos de Codex)

Leonardo autorizo que Claude escribiera el codigo del paso 1 mientras Codex no
tuviera creditos. Estas son las decisiones tomadas en esa sesion.

## D06. El SDK no se copia al repositorio

- Contexto: D02 copio 3.6 GB del SDK de Flutter a .tooling/ para esquivar el
  sandbox, y aun asi la build fallo con "Access is denied".
- Decision: .tooling/ eliminado. La causa real era que la sesion de Codex solo
  podia escribir en D:\ronda; se resuelve dandole acceso al SDK real con
  --add-dir, no copiando herramientas.
- Descartado: mantener la copia, aunque estuviera ignorada por git.

## D07. compileSdk 37 fijado a mano

- Contexto: heredar flutter.compileSdkVersion daba 36 y una dependencia del
  stack exige 37; la build fallaba.
- Decision: compileSdk = 37 explicito en android/app/build.gradle.kts. El
  platform 37 ya estaba instalado y el AGP es 9.1.0.
- Descartado: bajar dependencias del stack cerrado para caber en 36.

## D08. Desugaring activado desde el paso 1

- Contexto: flutter_local_notifications usa APIs de java.time y exige
  coreLibraryDesugaring, aunque todavia no se use hasta el paso 4.
- Decision: activarlo ahora, con desugar_jdk_libs 2.1.5.
- Descartado: esperar al paso 4 y descubrir el fallo entonces.

## D09. Compilacion incremental de Kotlin desactivada

- Contexto: google_mlkit_commons y camera_android_camerax fallaban con "Could
  not close incremental caches" en D:\ronda\build. Es bloqueo de archivos de
  Windows, no un problema del codigo.
- Decision: kotlin.incremental=false en android/gradle.properties.
- Pendiente para Leonardo: excluir D:\ronda de Windows Defender probablemente
  permita volver a activarla y acelerar las builds.

## D10. Permiso de INTERNET en el manifiesto principal

- Contexto: flutter create solo lo agrega a los manifiestos de debug y profile.
- Decision: declararlo en el manifiesto principal. Sin esto el APK de release
  que se lleva al mercado no puede hablar con Supabase, y el error aparece
  recien en el telefono de la cabeza de junta.

## D11. publishableKey en vez de anonKey

- Contexto: supabase_flutter 2.17 deprecio anonKey.
- Decision: usar publishableKey en Supabase.initialize. El nombre de la
  variable de entorno sigue siendo SUPABASE_ANON_KEY, que es como aparece en
  el panel de Supabase.

## D12. Los textos llevan tildes

- Contexto: la primera version de lib/l10n/textos.dart se escribio sin acentos.
- Decision: corregido. La app es solo en espanol y la usuaria es una senora de
  55 anos: un texto sin tildes se lee como hecho a las apuradas, y esta app
  maneja la cuenta de la plata de doce personas.

## D13. Sin google_fonts en tiempo de ejecucion

- Confirma D04. El paquete sigue en el stack pero no se invoca: la tipografia
  es la del sistema. Descargar fuentes exige red, y en el mercado no hay.

## D14. Modelos con mapeo escrito a mano, no freezed

- Contexto: freezed y json_serializable estan en el stack, pero las filas de
  Postgres vienen en snake_case, con montos en centavos y fechas civiles que no
  se convierten por zona horaria.
- Decision: clases Dart simples con `desdeMapa` explicito. Deja esas tres reglas
  a la vista en vez de esconderlas tras un generador y sus convertidores.
- freezed sigue en el stack y build_runner sigue configurado: cuando haga falta
  un modelo con muchas copias inmutables, se usa.

## D15. Todas aportan en cada vuelta, incluida la que cobra

- Contexto: el encargo no dice si la participante que recibe el pozo tambien
  pone su aporte esa vuelta. Hay juntas que lo hacen de las dos formas.
- Decision: todas ponen siempre. Es la forma mas comun y la que hace que la
  cuenta cierre: el pozo es N por el aporte, y la ganancia neta de quien cobra
  es (N - 1) veces el aporte.
- Para 12 participantes son 12 turnos y 144 aportes. Se insertan en dos
  llamadas, no una por una.

## D16. El dia del mes se recuerda, no se arrastra

- Contexto: una junta mensual que empieza un 31 se topa con febrero.
- Decision: el 31 de enero mas un mes da 28 de febrero, pero mas dos meses
  vuelve al 31 de marzo. El dia se conserva de la fecha original y solo se
  recorta cuando el mes no lo tiene. Si se fuera sumando mes a mes sobre el
  resultado anterior, la junta cobraria el 28 para siempre.
- Cubierto por tests, incluido el anio bisiesto.

## D17. `.order()` de supabase_flutter es DESCENDENTE por defecto

- Contexto: `.order('orden_turno')` devolvia las participantes al reves. El
  calendario se habria generado con el orden de cobro invertido.
- Decision: `ascending: true` explicito en toda consulta ordenada. Encontrado
  manejando la app, no leyendo el codigo ni corriendo los tests.

## D18. El contraste no se delega al widget

- Contexto: dos veces seguidas un texto salio en gris casi blanco: las opciones
  de frecuencia (RadioListTile dentro de RadioGroup se pinta deshabilitado) y
  los nombres de la lista (ListTileThemeData con titleTextStyle sin color).
- Decision: todo TextStyle de tema lleva su color explicito del ColorScheme, y
  la barra de progreso tambien. Esta app se usa con sol encima: si el widget
  puede elegir un gris, lo va a elegir.

---

# Paso 3: base local y sincronizacion

## D19. El id y el codigo de junta se generan en el telefono

- Contexto: la decision original decia que el codigo de 6 caracteres lo generaba
  Postgres. Con la base local eso impide crear una junta sin senal, que es
  justo lo que el piloto del Mercado 10 necesita.
- Decision: `Ids.uuid()` e `Ids.codigoDeJunta()` los generan en el dispositivo,
  con el mismo alfabeto de 32 caracteres que usa la funcion de Postgres.
- Riesgo aceptado: 32^6 son mil millones de combinaciones. Si dos chocaran, el
  UNIQUE de la base rechaza el segundo y la cola lo reporta tras los intentos
  maximos. La funcion de Postgres sigue existiendo como red para filas creadas
  del lado del servidor.

## D20. Primero empujar, despues descargar. Nunca al reves

- Contexto: si la descarga corriera primero, Supabase pisaria los cambios
  locales que todavia no subieron.
- Decision: el sincronizador empuja la cola y solo descarga si la cola quedo
  vacia. Con cambios pendientes no se descarga nada.
- Es el escenario que arruinaria la app: marcar doce pagos sin senal, que vuelva
  a medias, y que una descarga los borre. Cubierto por test.

## D21. La cola se corta al primer fallo, con tope de intentos

- Contexto: los cambios dependen unos de otros. Los participantes no pueden
  subir antes que su junta.
- Decision: se procesa por orden de llegada y se corta al primer error. Tras 5
  intentos fallidos un cambio se aparta, porque a esa altura ya no es falta de
  senal sino un dato que Postgres rechaza, y bloquearia todo lo de atras.

## D22. `insertar` sube como upsert

- Contexto: si la respuesta se pierde pero el INSERT llego, reintentar fallaria
  por clave duplicada y la cola se atascaria para siempre.
- Decision: upsert. Una cola de reintentos tiene que ser idempotente.

## D23. Sin deteccion de conectividad, a proposito

- Contexto: `connectivity_plus` no esta en el stack cerrado.
- Decision: no se pregunta si hay red; se intenta y si falla, la cola espera.
  Preguntar antes de usar la red es una carrera perdida: la respuesta puede
  cambiar entre la pregunta y la llamada. Hay un latido cada minuto.

## D24. Al cerrar sesion se borra el espejo local

- El telefono puede pasar a otra persona y la base guarda cuentas de plata
  ajena. `olvidarTodo()` vacia las cinco tablas y la cola.

## D05 resuelta (13-sep)

El repositorio ya existe: `Matiassb06/ronda`, privado. El badge del README
apunta al propietario real y el workflow de CI corre en cada push. Se mantiene
privado hasta que cierre el ciclo, porque el profesor de Moviles revisa repos y
este proyecto es personal.

---

# Paso 4: recordatorios

## D25. El mensaje saluda por el primer nombre

- Contexto: los participantes se guardan con nombre completo.
- Decision: el mensaje dice "Hola Rosa", no "Hola Rosa Quispe Mamani". El
  apellido completo suena a cobranza de banco, y esto es una vecina
  escribiendole a otra.

## D26. El mensaje nombra a quien cobra ese turno

- Decision: incluir "Este turno le toca cobrar a Maria". No es decoracion: en
  una junta, saber que el dinero va a una persona concreta y conocida es lo que
  hace que la gente pague a tiempo. Un recordatorio abstracto no mueve a nadie.

## D27. Si el turno ya vencio, el tono cambia pero no acusa

- Decision: "era para el lunes y todavia falta" en vez de "estas atrasada".
  Hay un test que comprueba que el mensaje nunca dice deuda ni moroso. La
  cabeza de junta tiene que seguir viendo a esta persona todos los dias en el
  mercado.

## D28. Alarmas inexactas, no exactas

- Contexto: `zonedSchedule` con alarma exacta exige SCHEDULE_EXACT_ALARM, que en
  Android 12 y posteriores el usuario concede a mano en una pantalla de Ajustes.
- Decision: `inexactAllowWhileIdle`. Un recordatorio de cobro no necesita
  punteria al minuto, y no vale la pena hacerle atravesar una pantalla de
  sistema a una senora de 55 anos.

## D29. El permiso de notificaciones se pide dentro, no al arrancar

- Decision: se pide al entrar a la lista de juntas, no en el splash. Un cuadro
  de permiso antes de que la persona haya visto nada de la app es un cuadro que
  se rechaza. Si lo niega, la app funciona igual.

## D30. La hora del aviso se calcula en America/Lima, no en la zona del telefono

- Decision: `tz.setLocalLocation(tz.getLocation('America/Lima'))` fijo. Un
  telefono con la zona mal puesta no deberia mover el dia de cobro de una junta.

## D31. Localizaciones de Material, tras un error que llego al usuario

- Sintoma: tocar "¿Que dia empieza?" al crear una junta mostraba la pantalla roja
  "No MaterialLocalizations found" en vez del calendario.
- Causa: se le pasaba `locale: Locale('es')` a `showDatePicker` sin declarar los
  delegados de localizacion en MaterialApp. Pedirle espanol a un dialogo de
  Material sin el idioma cargado no lo deja en ingles: lo revienta.
- Decision: se agrega `flutter_localizations` (paquete del SDK de Flutter, no un
  tercero, asi que no toca el stack cerrado) y se centraliza en lib/l10n/idiomas.dart.
- **Lo importante**: el proyecto tenia 98 tests de logica pura y CERO tests de
  widget. Este fallo vivia justo en ese hueco, en el armado de la app. Se
  agregaron 7 tests de widget sobre la pantalla de crear junta, dos de ellos
  comprobando que el calendario abre y que sale en espanol.
- Nota menor: el dialogo del sistema dice "septiembre" (forma de la RAE, la que
  trae Flutter) mientras los textos propios dicen "setiembre" (uso peruano). Se
  deja asi: la voz de la app es nuestra, la del dialogo del sistema no.

---

# Pasos 5 y 6

## D32. El OCR sugiere, ella decide

- Regla 9 del CLAUDE.md, hecha pantalla: lo que lee ML Kit llega a una hoja de
  confirmacion en campos editables, con la foto arriba para poder comparar.
  Nada se guarda hasta que ella toca confirmar.
- Lo leido se guarda aparte en `ocr_monto_centavos` y `ocr_fecha`, separado de
  lo confirmado. Asi se puede medir despues que tan bien funciona el OCR sin que
  eso toque nunca la cuenta real.
- Si el OCR no entiende el monto, se sugiere el que le tocaba pagar, no un campo
  vacio.

## D33. El monto se busca por palabra clave, no por posicion

- Contexto: un voucher de banco trae varias cifras (monto, comision, saldo).
  Tomar la primera a veces agarra la comision.
- Decision: primero se busca una linea con "monto", "total", "importe",
  "yapeaste"; si ninguna lo dice, se toma la primera con S/. Cubierto por test.

## D34. Una fecha imposible se descarta, no se corrige

- `DateTime(2026, 2, 31)` en Dart devuelve el 3 de marzo sin avisar. Se valida y
  se devuelve null. Prefiere no saber antes que inventar una fecha de pago.

## D35. La foto espera senal en el telefono

- El aporte queda pagado al instante; la foto se guarda local y el sincronizador
  la sube despues. Va ANTES de la cola de filas, para que cuando el UPDATE del
  aporte llegue a Postgres la ruta del voucher ya exista.
- Un fallo al subir no detiene nada: la foto es respaldo, no el dato.

## D36. Cero dias de gracia en el historial

- Si el turno era el lunes y pago el martes, se atraso. Suavizarlo seria
  mentirle a la cabeza de junta sobre en quien puede confiar, que es justo para
  lo que sirve esa pantalla.

## D37. El resumen que se comparte no senala a nadie

- Dice cuantas cumplieron y nombra a las puntuales, pero NO dice quien debe. Esa
  conversacion es de dos personas, no del grupo de WhatsApp. Cubierto por test.

## D38. PENDIENTE: la junta no se cierra sola

- Encontrado probando: al completar el ultimo turno, la junta sigue en estado
  'activa'. La lista dice "En curso" mientras el cuaderno dice "Esta junta ya
  termino". Hay que pasar el estado a 'cerrada' al completar el ultimo turno.

---

# Pasada de revision como probador (13-sep)

## D38 RESUELTA. La junta se cierra sola

Al completar el ultimo turno pasa a 'cerrada'. Se agrego ademas
`repararJuntasTerminadas()`, que corre al arrancar: **arreglar el codigo no
arregla los datos que ya estaban mal guardados**, y una junta terminada antes de
la correccion se habria quedado activa para siempre.

## D39. La lista de participantes se congela al generar el calendario

- **Era un bug serio y silencioso.** En Postgres las claves de turnos y aportes
  hacia participantes son ON DELETE RESTRICT; en Drift no hay claves declaradas.
  Borrar una participante se aceptaba en el telefono, el servidor lo rechazaba,
  la cola lo reintentaba cinco veces y lo descartaba. **Las dos bases quedaban
  distintas para siempre** y nadie se enteraba hasta contar el dinero.
- Agregar tarde tenia el problema simetrico: la persona quedaba sin turno ni
  aportes, no salia en el cuaderno y nadie sabia por que.
- Decision: con calendario generado se pueden corregir nombres y telefonos, pero
  no cambiar quienes participan. Ademas de proteger la sincronizacion, es lo
  correcto: cambiar la rueda a mitad de junta se conversa, no se resuelve con un
  boton.

## D40. El monto no se cambia con la junta empezada

Los aportes ya llevan su monto copiado. Cambiar el de la junta dejaria el pozo
distinto de la suma de lo que cada una tiene que poner, y nadie sabria cual de
los dos numeros es el bueno. El nombre si se cambia siempre.

## D41. El cuaderno muestra la fecha del turno

Faltaba. Decia quien cobra pero no que dia, que es la pregunta numero uno de una
junta. Se agrego ademas una pantalla de calendario con todos los turnos, porque
la otra pregunta es "cuando me toca a mi" y el cuaderno solo muestra el actual.

## D42. Se puede deshacer la entrega del pozo

Entregar el dinero es irreversible en la vida real, pero tocar un boton no. Sin
esto, un dedo torpe adelantaba la junta entera sin vuelta atras.

## D43. Reparar y sincronizar van en ese orden, no en paralelo

- **Bug encontrado probando**: lanzados a la vez, la descarga llegaba antes que
  la reparacion y la pisaba. Se veia el cambio pendiente en la nube y la
  pantalla sin cambiar.
- Ademas, `_descargar` vuelve a comprobar que la cola este vacia **dentro** de
  la transaccion: entre la comprobacion inicial y la escritura puede entrar un
  cambio local. Perder un refresco no cuesta nada; pisar un pago marcado cuesta
  la confianza de la cabeza de junta.

## D44. Se puede mirar y anotar cualquier turno, no solo el actual

- **Bug reportado por Leonardo, y el peor de todos hasta ahora.** El cuaderno
  solo dejaba tocar el turno en curso, y el boton de entregar el pozo solo
  aparecia con todas pagadas. En una junta semanal eso es fatal: si una no paga,
  la semana no cierra, no hay donde anotar la siguiente, y la junta queda
  clavada para siempre.
- Decision: flechas para moverse entre turnos, y el turno se puede cerrar aunque
  falte gente, con una confirmacion que dice cuantas faltan y avisa que queda
  como deuda. Es lo que pasa en una junta de verdad: el pozo se entrega igual y
  quien debe queda debiendo.

## D45. El celular es obligatorio

- Antes era opcional. Sin numero no se le puede mandar el recordatorio, que es
  la mitad del trabajo que la app le quita de encima a la cabeza de junta. Una
  participante sin celular es una a la que hay que ir a buscar al puesto.

## D46. PENDIENTE de confirmar con Leonardo: cuanto dura una junta

En el modelo actual **la cantidad de turnos es la cantidad de participantes**:
una junta semanal de 4 personas dura 4 semanas, una de 12 dura 12. Es como
funciona una ROSCA y es lo que hace que la cuenta cierre (cada una pone N veces
y cobra una).

Leonardo comento que "si elijo semanal, el deposito es cada semana", lo que
podria significar que espera otra cosa: una junta que dure un numero de semanas
elegido aparte, independiente de cuanta gente haya. Eso seria otro producto y
cambiaria el modelo de datos. Hay que preguntarselo antes de tocar nada.
