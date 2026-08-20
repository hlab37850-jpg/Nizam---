# Nizam OS - نظام التشغيل الشخصي
Super App لإدارة الحياة كامل - Offline-first 100%

## كيف تحصل على APK من GitHub Actions
1. انشئ repo جديد على GitHub
2. ارفع هذا المشروع:
```
git init
git add .
git commit -m "feat: Nizam OS v1"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/nizam-os.git
git push -u origin main
```
3. اذهب لتبويب Actions -> ستجد Build Nizam APK يعمل تلقائيا (5-7 دقائق)
4. ادخل على آخر Run -> الاسفل Artifacts -> حمل nizam-os-apk
5. بداخله app-release.apk جاهز

## تشغيل محلي
flutter pub get
flutter run
