import java.util.Properties

// La clave de firma vive FUERA del repositorio, en android/key.properties, que
// el .gitignore excluye. Si el archivo no está, la app igual compila en debug:
// solo se cae al pedir un release, que es cuando de verdad hace falta.
val propiedadesDeFirma = Properties().apply {
    val archivo = rootProject.file("key.properties")
    if (archivo.exists()) archivo.inputStream().use { load(it) }
}
val hayFirmaDeRelease = propiedadesDeFirma.getProperty("storeFile") != null

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "pe.leonardo.ronda"

    // Fijado a mano, no heredado de flutter.compileSdkVersion: alguna
    // dependencia del stack ya exige 37 y la build falla con 36.
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // flutter_local_notifications usa APIs de java.time, que no existen en
        // los Android viejos. El desugaring las traduce en tiempo de compilacion.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "pe.leonardo.ronda"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Sale de la version declarada en pubspec.yaml.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hayFirmaDeRelease) {
            create("release") {
                storeFile = file(propiedadesDeFirma.getProperty("storeFile"))
                storePassword = propiedadesDeFirma.getProperty("storePassword")
                keyAlias = propiedadesDeFirma.getProperty("keyAlias")
                keyPassword = propiedadesDeFirma.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // Con la clave de release cuando está disponible; con la de debug
            // cuando no, para que alguien que clone el repo pueda compilar sin
            // pedirle la llave a nadie.
            signingConfig = if (hayFirmaDeRelease) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }

            // Ver proguard-rules.pro: el paquete de OCR menciona alfabetos que
            // no están instalados y sin esto R8 no compila.
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

kotlin {
    compilerOptions {
        // Tiene que coincidir con sourceCompatibility/targetCompatibility de
        // arriba, o Gradle falla por incompatibilidad entre Java y Kotlin.
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

flutter {
    source = "../.."
}
