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
