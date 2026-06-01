# Rec

Flutter-based screen recording app targeting `macOS`, `iOS`, and `Android`.

## Current Status

- `macOS`: Native `ScreenCaptureKit` bridge is the primary product path. The app now supports a simplified home screen, permission recovery, target selection (`application`, `full screen`, `area`), audio choice, countdown, pause/resume, recent recordings, saved-folder reveal, editable shortcuts, and detailed runtime logging.
- `iOS`: Native `ReplayKit` recording is wired into the Flutter app. The mobile UI is intentionally simpler than `macOS`: the main flow is `record / stop`, with permission recovery, countdown, and microphone capture where supported. Recordings are saved into the app's `Documents/Recordings` directory and exposed through Files.
- `Android`: Native `MediaProjection` + `MediaRecorder` recording is wired into the Flutter app. The mobile UI is also simplified to `record / stop`, with permission recovery, countdown, localized strings, and a foreground service notification during active capture. Recordings are saved into the app-specific movies directory.
- Localization: Flutter `ARB` files and native strings now cover `ko`, `ja`, `tr`, `hi`, `id`, `vi`, `th`, `en`, `pt_BR`, `it`, `es`, `de`, `fr`, `pl`, `nl`, `ru`, and `zh_TW` with localized text instead of English fallback.

## Progress Log

### 2026-03-23

- Simplified the main product UX around direct recording instead of a complex dashboard.
- Added a status card, recording timer, explicit stop action, and verbose terminal logging for recording flow diagnostics.
- Added localization coverage across the requested market languages in Flutter `ARB` files and native Apple/Android string resources.
- Added a settings screen, persisted app preferences, and initial locale selection based on the device language when no saved locale exists.
- Added macOS-only power-user features: target choice (`application`, `full screen`, `area`), audio mode choice, countdown, pause/resume, recent recordings, and editable keyboard shortcuts.
- Simplified `iOS` and `Android` home UI to the minimal mobile flow while keeping supported features such as countdown, permission recovery, and start/stop recording.
- Confirmed that recording on Apple platforms uses `AVAssetWriter` and that Android uses `MediaRecorder`, rather than bundling `FFmpeg`.
- Added Flutter ARB localization for the recording UI with `en` and `ko`.
- Localized native Apple permission descriptions through `InfoPlist.strings` on both `macOS` and `iOS`.
- Added native `Localizable.strings` for Apple-side note/error text.
- Added Android native `strings.xml` and `values-ko/strings.xml`.
- Updated the permission/setup UI so `Android` `prompt-on-start` screen capture is treated correctly instead of looking blocked.
- Added Android app-settings fallback for denied microphone permission.
- Added Android foreground service handling for active MediaProjection recording.
- Verified Flutter tests and native platform builds after these changes.

### 2026-03-22

- Wired the native recorder bridges into the Flutter app for `macOS`, `iOS`, and `Android`.
- Fixed macOS bridge registration timing to avoid startup `MissingPluginException`.
- Added widget coverage for startup polling, setup UI, content selection, permission actions, and record/stop flow.

## Verified On 2026-03-23

- Full verification earlier on `2026-03-23`:
  - `flutter analyze`: passed
  - `flutter test`: passed (`54/54` at that point)
  - `flutter build macos`: passed
  - `flutter build ios --simulator`: passed
  - `flutter build apk --debug`: passed
  - `xcodebuild test -project macos/Runner.xcodeproj -scheme Runner -destination 'platform=macOS'`: passed
- Additional verification after later UI/flow changes on `2026-03-23`:
  - `flutter analyze`: passed
  - `flutter test`: passed
  - `flutter build macos`: passed

Note:
Later `iOS` / `Android` home-screen simplification changes were rechecked with `flutter analyze` and `flutter test`, but native mobile builds were not rerun after that final Dart-only pass.

## Latest Verification

Checked on `2026-06-01`:

- `flutter analyze`: passed
- `flutter test`: passed

Native platform builds were not rerun during this latest verification pass.

Verified outputs:

```text
build/macos/Build/Products/Debug/rec.app
build/macos/Build/Products/Release/rec.app
build/ios/iphonesimulator/Runner.app
build/app/outputs/flutter-apk/app-debug.apk
```

## Not Verified Yet

- `Android release apk` is not currently verified in this README flow.
- Flutter release builds on Android use the internal `gen_snapshot` AOT step.
- If you do not want `gen_snapshot` to run, avoid `flutter build apk` release mode and use `flutter build apk --debug` instead.

## Commercial Release Notes

- Current codec path is relatively safe compared with bundling `FFmpeg`: `macOS` and `iOS` use platform `AVAssetWriter`, and `Android` uses platform `MediaRecorder` / `MediaProjection`.
- The project is not release-ready yet for store submission:
  - Apple bundle identifiers still use `com.example.rec`.
  - Android `applicationId` / `namespace` still use `com.example.rec`.
  - Android release signing still points at the debug signing config.
  - A production privacy policy link and in-app privacy entry point are still missing.
  - App Store `App Privacy` and Google Play `Data safety` disclosures still need to be completed before submission.
- Store metadata must accurately describe platform differences:
  - `macOS` is the full-featured desktop recorder.
  - `iOS` and `Android` are simplified full-screen style recorders and do not match the macOS feature set.

## Platform Limits

- `macOS` is the closest to BetterCapture and supports native content picking.
- `iOS` and `Android` only support simplified full-screen style recording through their OS recording APIs.
- `iOS` and `Android` cannot match BetterCapture's macOS-only features such as per-window capture, menu bar filtering, dock filtering, or Apple-specific desktop capture options.
- System permission alerts themselves are still controlled by the OS. The app can localize the usage description text and guide the user into Settings, but it cannot rewrite Apple or Android system button labels.

## What Was Ported From BetterCapture

- Core macOS recording stack into `macos/Runner/RecorderCore/`
- Shared recording dashboard and settings UI into `lib/`
- macOS permission strings and sandbox entitlements
- Flutter-to-native method channel bridge in `macos/Runner/RecorderBridge.swift`
- iOS method channel bridge in `ios/Runner/AppDelegate.swift`
- Android method channel bridge in `android/app/src/main/kotlin/com/example/rec/MainActivity.kt`

## Build

```bash
flutter analyze
flutter test
xcodebuild test -project macos/Runner.xcodeproj -scheme Runner -destination 'platform=macOS'
flutter build macos
flutter build ios --simulator --no-codesign
flutter build apk --debug
```

Built macOS app:

```text
build/macos/Build/Products/Release/rec.app
```

## Maintainer Update Workflow

For normal GitHub updates, keep commit history and push a new commit:

```bash
git status
flutter analyze
flutter test
git add .
git commit -m "Update project"
git push
```

The local working branch is `clean-main`, and it tracks GitHub `main`, so a
plain `git push` updates `https://github.com/itjimkr/flutter_free_rec`.

Only rewrite the single initial commit when intentionally replacing the public
history:

```bash
git add .
git commit --amend --no-edit
git push --force-with-lease origin clean-main:main
```

## Upstream Attribution

The root app does not vendor the upstream BetterCapture source tree. Portions of
the macOS recording stack were adapted from BetterCapture and are attributed in
`NOTICE`.

Upstream reference:
`https://github.com/jsattler/BetterCapture`

## License

Rec is released under the MIT License. Portions of the macOS recording stack
were adapted from BetterCapture by Joshua Sattler, also licensed under MIT. See
`LICENSE` and `NOTICE` for details.
