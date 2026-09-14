# Reglas de R8 para la compilación de release.

# El paquete google_mlkit_text_recognition sabe leer cinco alfabetos: latino,
# chino, devanagari, japonés y coreano. Su código los menciona a los cinco, pero
# cada uno viene en una dependencia aparte y aquí solo está instalado el latino,
# que es el único que necesita un voucher peruano.
#
# Sin estas líneas, R8 se detiene porque no encuentra las clases de los otros
# cuatro. La alternativa sería agregar los cuatro paquetes y cargar el APK con
# modelos de idiomas que nadie va a usar.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
