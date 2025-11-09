// Settings Gradle for Flutter + Android + FlutterFire integration
// Modified by Simba Z for CIS 3334 Mobile App Development Project
// This configuration links Flutter tools, Kotlin, and Firebase setup

pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    // Include Flutter’s Gradle tools for project management
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.9.1" apply false
    // FlutterFire plugin for Google services configuration
    id("com.google.gms.google-services") version("4.3.15") apply false
    // End of Firebase setup section
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
