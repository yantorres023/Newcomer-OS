# Android release — human steps

1. Create a Google Play developer account (organisation account recommended — immigration-adjacent apps may get extra scrutiny).
2. Confirm the application ID (`android/app/build.gradle.kts`, currently placeholder `app.erstmal.newcomer_os`). It cannot change after first upload.
3. Create an upload keystore (never commit it):
   `keytool -genkey -v -keystore ~/erstmal-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
4. Add `android/key.properties` (git-ignored) and a `release` signingConfig reading it; replace the debug signing line in `build.gradle.kts`.
5. `flutter build appbundle --release` → upload to Internal testing; enrol in Play App Signing.
6. Fill Data safety, content rating, government-information declaration, privacy policy URL.
7. Closed testing track for the beta cohort.
