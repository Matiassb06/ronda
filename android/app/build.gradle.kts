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

    buildTypes {
        release {
            // Firmado con la clave de debug por ahora, para que
            // `flutter run --release` funcione. El keystore de release todavia
            // no existe: cuando exista, se apunta aqui y NUNCA se versiona.
            signingConfig = signingConfigs.getByName("debug")
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
