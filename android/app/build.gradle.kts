plugins {
    id("com.android.application")
    // FlutterFire setup plugin
    id("com.google.gms.google-services")
    // End of FlutterFire setup
    id("kotlin-android")
    // Note: The Flutter plugin should be applied after both Android and Kotlin plugins
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "css.cis3334.flutter_firestore_itemlist"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Ensures Java 11 compatibility for both source and target builds
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        // Matches Kotlin’s JVM target version to Java 11
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Update this with your unique app ID (learn more: https://developer.android.com/studio/build/application-id.html)
        applicationId = "css.cis3334.flutter_firestore_itemlist"

        // You can tweak these values according to your app’s requirements
        // See Flutter’s build documentation for additional customization
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
