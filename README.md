# Nizam OS — نظام التشغيل الشخصي

تطبيق Flutter عربي RTL يعمل Offline-first ويستخدم Hive للتخزين المحلي مع مفتاح تشفير محفوظ في `flutter_secure_storage`.

## Build with GitHub Actions

المشروع مجهز بملف:

`.github/workflows/build-apk.yml`

الـ workflow يعمل عند أي `push` وعلى `workflow_dispatch`، لذلك لا يعتمد على أن اسم الفرع هو `main`.

### رفع المشروع

1. أنشئ مستودع GitHub جديدًا.
2. ارفع **محتويات هذا المجلد** إلى جذر المستودع، وليس ملف ZIP نفسه.
3. تأكد أن المسار التالي موجود:

```text
.github/workflows/build-apk.yml
```

4. افتح تبويب **Actions**.
5. اختر **Build Nizam APK**.
6. اضغط **Run workflow** إذا كان زر التشغيل ظاهرًا، أو اعمل `git push` ليبدأ تلقائيًا.
7. بعد نجاح البناء افتح نتيجة التشغيل ثم **Artifacts** ثم `nizam-os-apk`.

## Build environment

- Flutter 3.22.3
- Java 17
- Android Gradle Plugin 8.3.2
- Gradle 8.4
- Android compile/target SDK 34
- Dart package name: `nizam_os`
- Android application id: `com.nizam.os`

## Important

لا يتم تشغيل `flutter create .` على المشروع نفسه داخل GitHub. يتم إنشاء مشروع Android مؤقت فقط لاستخراج `gradle-wrapper.jar`، ثم يُبنى المشروع الحالي كما هو. هذا يمنع اسم مستودع GitHub من أن يصبح اسم Dart غير صالح مثل `Nizam---`.

الـ workflow يحتوي أيضًا على معالجة محددة لـ Flutter 3.22.3 لمشكلة `groovy.xml.QName` التي تظهر في بعض بيئات Gradle الحديثة.

## Local build

```bash
flutter pub get
flutter analyze --no-fatal-infos
flutter test
flutter build apk --release
```

الناتج:

```text
build/app/outputs/flutter-apk/app-release.apk
```


## Build compatibility note
This project uses Flutter 3.22.3 with Gradle 8.4, Java 17, and explicitly adds Groovy XML 3.0.17 to the Flutter Gradle script classpath. Flutter 3.22.3 imports `groovy.xml.QName`; Gradle 8.4 uses Groovy 3.0.17, and the XML module is required for that class. The workflow verifies the expected Flutter source before patching and never relies on the GitHub repository folder name as the Dart project name.
