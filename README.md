# Nizam OS — نظام التشغيل الشخصي

Flutter Android app designed for offline-first personal life management with Arabic RTL UI.

## GitHub Actions

The repository includes:

```text
.github/workflows/build-apk.yml
```

The workflow:

1. Checks out the repository.
2. Installs Java 17.
3. Installs Flutter 3.22.3.
4. Verifies the project identity and Android files.
5. Creates only a temporary Flutter seed project if the Gradle wrapper JAR is absent; it never regenerates or overwrites Nizam OS source files.
6. Pins Gradle 8.4.
7. Adds `groovy-xml:3.0.17` to the Flutter 3.22.3 Gradle plugin classpath to address the `groovy.xml.QName` compilation issue.
8. Runs `flutter pub get`.
9. Runs `flutter analyze --no-fatal-infos` and requires zero analyzer issues.
10. Runs Flutter tests.
11. Builds `app-release.apk`.
12. Verifies that the APK exists and uploads it as `nizam-os-apk`.

## Build environment

- Flutter 3.22.3
- Java 17
- Android Gradle Plugin 8.3.2
- Gradle 8.4
- compileSdk 34
- targetSdk 34
- minSdk 24
- Kotlin 1.9.22

## Uploading to GitHub

Upload the **contents** of this project to the repository root. The repository must contain `.github/workflows/build-apk.yml` directly at the root.

After pushing to GitHub:

1. Open **Actions**.
2. Select **Build Nizam APK**.
3. Wait for the build to finish.
4. Open the successful run.
5. Download the **nizam-os-apk** artifact.

The workflow also supports **Run workflow** from the Actions tab when the workflow file exists on the repository's default branch.

## Important

Do not rename `pubspec.yaml`'s package name. It is intentionally `nizam_os`, which satisfies Dart package naming rules. The visible Android application name is `Nizam OS` and is independent of the Dart package name.
