# Ronda

<!-- El repositorio todavia es local: cuando se publique hay que cambiar
     USUARIO por el propietario real. Ver docs/decisiones-pendientes.md, D05. -->
[![CI](https://github.com/USUARIO/ronda/actions/workflows/ci.yml/badge.svg)](https://github.com/USUARIO/ronda/actions/workflows/ci.yml)

App Android que le reemplaza el cuaderno a la cabeza de una junta.

Una junta (o ROSCA) es un ahorro rotativo: un grupo pone la misma cantidad cada
semana o cada mes, y en cada vuelta el pozo completo se lo lleva una persona
distinta, hasta que todas cobraron. Quien organiza lleva la cuenta en un
cuaderno. Esta app es ese cuaderno.

## La decision que define el producto

**La app la usa la cabeza de junta, sola.** Ella registra a las participantes,
marca quien pago y a quien le toca cobrar. Las demas no instalan nada y no
tienen cuenta: reciben el recordatorio por WhatsApp, desde el numero de ella.

Conseguir que doce personas instalen una app es el muro real de adopcion, y esta
app lo esquiva en vez de estrellarse contra el.

**El dinero no pasa por la app.** Se sigue moviendo en efectivo o por Yape,
entre personas. La app solo lleva la cuenta.

## Estado

Paso 1 de 6: arranque. El proyecto compila, tiene tema, navegacion, login con
Google y el formateador de montos con sus tests. Todavia no se puede crear una
junta: eso es el paso 2.

| Paso | Que deja funcionando | Estado |
|---|---|---|
| 1 | Proyecto, tema, navegacion, login con Google | Hecho |
| 2 | Crear junta, participantes, calendario de turnos | Pendiente |
| 3 | Marcar pagos y ver quien falta (aqui ya reemplaza al cuaderno) | Pendiente |
| 4 | Recordatorio que abre WhatsApp con el mensaje escrito | Pendiente |
| 5 | Foto del voucher y OCR que prellena monto y fecha | Pendiente |
| 6 | Historial de cumplimiento | Pendiente |

## Como correrla

Hacen falta un proyecto de Supabase con el esquema de `supabase/migrations/`
aplicado y el proveedor de Google habilitado.

Las claves **nunca** se escriben en el codigo ni en un archivo del repositorio.
Entran por `--dart-define`:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://tu-proyecto.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=tu-clave-anonima
```

En Android Studio van en la run configuration, campo *Additional run args*.

Si se corre sin esas variables, la app no revienta: muestra una pantalla que
dice cuales faltan.

## Stack

| Capa | Que se usa |
|---|---|
| App | Flutter, solo Android |
| Estado | Riverpod con generacion de codigo |
| Navegacion | go_router |
| Backend | Supabase: Postgres con RLS, auth, storage privado |
| Base local | Drift, para que la app funcione sin senal |
| OCR | ML Kit on-device |
| Recordatorios | `url_launcher` hacia WhatsApp, sin API ni costo |

## Base de datos

El esquema vive en `supabase/migrations/0001_esquema_inicial.sql`: cinco tablas,
RLS activo en todas, bucket privado para los vouchers y una vista de resumen.

Dos decisiones que explican el resto del diseno:

- **Una participante no es un usuario.** Como solo la cabeza instala la app, no
  hay identidad que verificar del otro lado. Toda la autorizacion se reduce a
  una pregunta: esta junta es de quien la pide.
- **"Atrasado" no se guarda, se deriva** comparando la fecha programada con hoy.
  Un estado guardado envejece solo y hay que salir a actualizarlo; una fecha
  comparada nunca miente.

## Desarrollo

```bash
flutter pub get
dart run build_runner build   # Riverpod, freezed y Drift generan codigo
flutter analyze
flutter test
```

Las reglas del proyecto (stack cerrado, montos en centavos, nada de claves en el
repositorio) estan en `CLAUDE.md`. Las decisiones tomadas sobre la marcha, en
`docs/decisiones-pendientes.md`.

## Licencia

MIT.
