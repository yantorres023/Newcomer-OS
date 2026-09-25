# iOS release — human steps (blockers for TestFlight)

1. Apple Developer Program membership (organisation account recommended; D-U-N-S number needed).
2. Confirm bundle ID (currently placeholder `app.erstmal.newcomerOs` in `ios/Runner.xcodeproj`), register it in the developer portal.
3. On a Mac with Xcode: open `ios/Runner.xcworkspace`, set Team, enable automatic signing.
4. Verify privacy manifests at archive time (plugins ship their own `PrivacyInfo.xcprivacy`; add an app-level one if Xcode reports missing required-reason APIs).
5. `flutter build ipa --release` → upload with Transporter/Xcode → TestFlight internal group → external beta (requires Beta App Review).
6. App Store Connect: privacy label "Data Not Collected", support URL, privacy policy URL, age rating.
CI builds `flutter build ios --release --no-codesign` on macOS to prove the project compiles; it cannot sign.
