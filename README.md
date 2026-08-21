# Nizam OS

نظام التشغيل الشخصي لإدارة الحياة — Offline-first و RTL عربي.

## التشغيل محلياً

يتطلب Flutter 3.22.3 وJava 17.

```bash
flutter pub get
flutter run
```

## GitHub → APK

1. أنشئ Repository جديداً على GitHub.
2. ارفع **جميع ملفات المشروع** إلى الفرع `main`.
3. افتح تبويب **Actions**.
4. اختر `Build Nizam APK`.
5. اضغط `Run workflow` أو ادفع commit جديداً إلى `main`.
6. بعد نجاح البناء افتح الـ workflow ثم **Artifacts**.
7. نزّل `nizam-os-apk`.

ملف البناء موجود هنا:

`.github/workflows/build-apk.yml`

والـ APK الناتج:

`build/app/outputs/flutter-apk/app-release.apk`

## البيانات

التطبيق لا يستخدم Firebase. البيانات محلية داخل Hive ومشفرة بمفتاح محفوظ في `flutter_secure_storage`.

الصناديق المحلية:
- settings
- tasks
- projects
- transactions
- wallets
- budgets
- debts
- habits
- prayers
- vault
- goals
- journal
- notes
- water
- sleep

## ملاحظة مهمة

النسخة الأولى تحتوي على البنية التشغيلية والوظائف الأساسية الحقيقية للمهام والمال والعادات والخزنة والبحث والإعدادات. بعض الأنظمة المتقدمة مثل Kanban بالسحب، جدولة الإشعارات المتقدمة، تصدير ملف JSON فعلي إلى جهاز المستخدم، وتفاصيل الديون/الميزانيات/المفكرة تحتاج إكمال واجهاتها قبل اعتبارها نسخة إنتاجية نهائية.

## GitHub build compatibility

This project is prepared for Flutter 3.22.3 and Java 17. The Android toolchain is pinned to AGP 8.3.0, Kotlin 1.9.24 and Gradle 8.5.

The GitHub workflow also restores `gradle-wrapper.jar` on the clean runner and applies a narrowly scoped compatibility patch to Flutter 3.22.3's `flutter.groovy` for the `groovy.xml.QName` compile-time issue reported by Gradle. This does not modify the application source code.

After pushing to `main`, open **GitHub → Actions → Build Nizam APK**. The generated APK is uploaded as the `nizam-os-apk` artifact.
