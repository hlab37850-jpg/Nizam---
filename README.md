# Nizam OS

Nizam OS — نظام التشغيل الشخصي، تطبيق Flutter عربي RTL يعمل Offline-first.

## البناء عبر GitHub

1. أنشئ مستودعًا جديدًا على GitHub.
2. ارفع **محتويات هذا المشروع** إلى الفرع `main`.
3. افتح تبويب **Actions**.
4. اختر **Build Nizam APK**.
5. اضغط **Run workflow** أو ادفع commit جديدًا إلى `main`.
6. بعد نجاح البناء افتح الـ workflow ثم قسم **Artifacts**.
7. نزّل `nizam-os-apk`.

## ملاحظة عن البناء

الـ workflow يستخدم Flutter 3.22.3 وJava 17 ويعيد توليد Android platform من نفس إصدار Flutter قبل البناء. هذا يمنع بقاء ملفات Gradle قديمة أو `gradle-wrapper.jar` مفقودًا. ثم يثبت Gradle 8.4، وهو الإصدار المستخدم مع مشروع Flutter 3.22.x.

## التخزين

يستخدم التطبيق Hive بصناديق محلية مشفرة، مع حفظ مفتاح Hive في `flutter_secure_storage`. لا توجد Firebase أو خدمة سحابية.

## المجلدات

- `lib/core` — النماذج والتخزين والثيم.
- `lib/providers` — حالة التطبيق وRiverpod.
- `lib/ui/screens` — الشاشات.
- `.github/workflows` — البناء التلقائي.
- `android` — إعداد Android.

## قبل النشر النهائي

نفّذ على GitHub:
`flutter analyze --no-fatal-infos`
ثم:
`flutter build apk --release`

يجب أن يظهر الملف:
`build/app/outputs/flutter-apk/app-release.apk`
