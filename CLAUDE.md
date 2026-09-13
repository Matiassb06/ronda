# Memoria — Ronda

Este repositorio tiene memoria persistente en un vault de Obsidian, fuera de
esta carpeta:

D:\Obsidian\Leonardo

Cualquier sesión de Claude Code que trabaje aquí debe conocer esa ruta antes
de cerrar sesión.

## La regla que manda sobre todas: el vault se lee, esta carpeta se escribe

Una sola dirección, sin excepciones.

| Qué | Dónde vive | Qué se hace con eso |
|---|---|---|
| La idea, el alcance, las decisiones y el porqué de cada una | `D:\Obsidian\Leonardo` | Se **lee** al arrancar. Solo se escribe en el cierre de sesión, y solo prosa |
| **Todo el código**: Dart, SQL, YAML, Gradle, configuración, tests, `docs/` | `D:\ronda` | Se escribe **solo aquí** |

"Todo el código" es literal: **ningún archivo de este proyecto se crea fuera de
`D:\ronda`.** Ni un `.sql` suelto, ni un snippet de prueba, ni un borrador, ni
un ejemplo "para mostrar cómo quedaría". Si algo merece guardarse y no es
código, entonces es una decisión, y va al vault escrito como prosa.

Del vault se saca **contexto y nada más**: qué hace la app, para quién, qué está
decidido y qué sigue abierto. No se copia código desde el vault porque ahí no
hay código, y no se copia código hacia el vault por la misma razón.

Antes de escribir el primer archivo, verificar que el directorio de trabajo es
`D:\ronda`. Codex hereda el workspace de la sesión de Claude Code: si la sesión
se abrió en el vault, Codex no puede escribir aquí y termina creando el proyecto
en el lugar equivocado. Ya pasó una vez.

Nunca se toca `D:\kerolabs\`: ese es el trabajo del curso, proyecto distinto y
con nota individual.

## Quién hace qué

**Claude decide y revisa. Codex programa.** Sin mezclarlo:

- **Claude** fija el stack y la estructura, escribe la especificación de cada
  paso y revisa lo que salió contra las reglas de este archivo. **Claude no
  escribe el código de la app**, con dos excepciones acordadas el 13-sep:
  1. Si al revisar encuentra lógica de dominio sin cubrir, escribe él los tests
     que faltan. Son Dart puro y existen justamente para atrapar lo que se hizo
     mal; que los escriba quien no escribió el código es la gracia.
  2. **Mientras Codex no tenga créditos disponibles, Claude construye.** El paso
     1 se escribió así, el 13-sep. Cuando Codex vuelva, vuelve el reparto normal.
- **Codex** escribe el código. Todo el código, en esta carpeta.
- Si Claude necesita explicar cómo debería quedar algo, lo describe en el
  encargo; no lo deja commiteado.

El motivo es que a mitad de camino no se cambien librerías ni estructura, y que
haya alguien mirando el resultado que no sea el mismo que lo escribió.

## Qué es esto

App Android en Flutter que le reemplaza el cuaderno a la cabeza de una junta
(ROSCA). Proyecto personal, con dos objetivos: repo público presentable y
piloto real con vendedoras del Mercado 10.

**La app la usa la cabeza de junta, sola.** Ella registra a las participantes y
marca quién pagó. Las demás no instalan nada. Esa decisión define el alcance:
todo lo que obligue a que doce personas instalen algo va a la fase dos.

## Stack cerrado

No se sustituyen paquetes sin aprobación previa.

| Para qué | Paquete |
|---|---|
| Estado e inyección | `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator` |
| Navegación | `go_router` |
| Modelos | `freezed`, `json_serializable`, `build_runner` |
| Backend | `supabase_flutter` (Postgres, auth con Google, storage privado) |
| Base local | `drift`, `sqlite3_flutter_libs`, `path_provider` |
| Cámara | `camera`, `image_picker`, `permission_handler` |
| OCR | `google_mlkit_text_recognition` (on-device) |
| Avisos | `flutter_local_notifications`, `timezone` |
| WhatsApp | `url_launcher` |
| Compartir | `share_plus`, `qr_flutter` |
| Formato | `intl`, `google_fonts` |
| Gráficos | `fl_chart` |
| Desarrollo | `flutter_lints`, `mocktail`, `integration_test` |

Sin versiones fijadas a mano: se resuelven con `flutter pub add` y manda el
`pubspec.lock`.

### El login va por navegador, no por hoja nativa

`supabase.auth.signInWithOAuth(OAuthProvider.google, ...)` con vuelta por deep
link a `pe.leonardo.ronda://login-callback/`. Abre una Chrome Custom Tab, el
usuario elige su cuenta y regresa a la app.

**`google_sign_in` está deliberadamente fuera del stack.** La hoja nativa de "un
toque" obliga a un cliente OAuth Android con huella SHA-1, distinta en debug y
en release, y eso se paga en horas. Se agregará solo si el piloto en el mercado
muestra que el salto al navegador confunde a las usuarias. Hasta entonces, no se
agrega: es un cambio de stack y necesita aprobación.

Del lado de Google Cloud el cliente OAuth es de tipo **Web**, no Android, porque
quien recibe el callback es Supabase y no el teléfono.

## Estructura

```
lib/
  core/        tema, router, errores, formato de montos
  data/        supabase, drift, repositorios
  features/    auth, juntas, participantes, aportes, historial
  l10n/        textos, aunque solo haya español
```

Cada feature con `domain`, `application` y `presentation`. La lógica de turnos y
de aportes vive en `domain` y es Dart puro, sin imports de Flutter, porque es lo
único que se testea.

## Reglas que no se rompen

1. **Ninguna clave en el repo.** Supabase entra por `--dart-define`
   (`SUPABASE_URL`, `SUPABASE_ANON_KEY`). `.env` va al `.gitignore`.
2. **Montos en enteros de centavos.** Ni un `double` tocando plata.
3. **RLS activo en todas las tablas** antes de la primera pantalla que lea datos.
4. Fechas en `timestamptz`, mostradas en America/Lima.
5. Cero lógica de negocio dentro de un widget.
6. Textos visibles fuera de los widgets, en el archivo de traducción.
7. Commits en inglés, Conventional Commits, una rama por paso.
8. Nada de `print`, de código comentado, ni de `TODO` sin issue.
9. El OCR nunca guarda un aporte solo: siempre pasa por confirmación del usuario.

## Ruta de construcción

| Paso | Resultado |
|---|---|
| 1 | Proyecto, tema Material 3, go_router, Riverpod, login con Google, CI (HECHO el 13-sep) |
| 2 | Crear junta, participantes a mano, calendario de turnos |
| 3 | Marcar pagos y ver quién falta (aquí ya reemplaza el cuaderno) |
| 4 | Recordatorio que abre WhatsApp con el mensaje armado |
| 5 | Foto del voucher y OCR que prellena monto y fecha |
| 6 | Historial de cumplimiento |

## Entorno

Se trabaja en **Android Studio** con los plugins Flutter y Dart. Las claves van
en la run configuration, en *Additional run args*, nunca en el código.

## Al cerrar sesión

Si se hizo trabajo relevante en esta sesión, sin pedir permiso:

1. Actualizar el estado y las decisiones del proyecto en
   `D:\Obsidian\Leonardo\02-Proyectos\Ronda — app de juntas.md`
   (la sección "Estado" se reescribe entera, no se acumula; una decisión
   nueva suma una fila a la tabla de decisiones).
2. Si algo aprendido es reutilizable más allá de este proyecto, crear o
   actualizar una nota atómica en `D:\Obsidian\Leonardo\03-Conocimiento\`.
   Solo la idea, nunca código.
3. Agregar una línea a la nota del día en
   `D:\Obsidian\Leonardo\04-Bitacora\AAAA-MM-DD.md`, con la fecha de Lima
   (America/Lima, UTC-5: verificar la hora local con un comando del sistema
   antes de escribirla, nunca asumirla). Si la nota del día no existe, crearla.
4. Enlazar toda nota nueva desde su MOC (`MOC-Proyectos` o `MOC-Conocimiento`).
   Sin ese enlace, la nota no existe para el resto del vault.

Las reglas completas de búsqueda y escritura del vault están en
`D:\Obsidian\Leonardo\CLAUDE.md`.
