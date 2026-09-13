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
