# Nizam OS
Personal Life OS - Offline-first Arabic RTL

## Upload to GitHub
1. Create repo at github.com/new (name can be anything, package stays nizam_os)
2. Extract ZIP, `git init`, `git add .`, `git commit -m "init"`, `git remote add origin <url>`, `git push -u origin main`
3. Enable Actions if prompted
4. Actions -> Build Nizam OS APK -> Run workflow
5. Download artifact nizam-os-apk -> app-release.apk

## Local
flutter pub get
flutter analyze # No issues found!
flutter test
flutter build apk --release

## Troubleshooting
- Wrapper jar missing: workflow auto-downloads via curl
- Groovy QName: fixed via settings.gradle groovyClasspath = localGroovy()
- local_auth: MainActivity extends FlutterFragmentActivity
