# Contributing

Thanks for your interest in Rec. This project is a Flutter app with native
recording bridges for macOS, iOS, and Android.

## Development Setup

Install Flutter and the platform toolchains needed for the target you are
working on:

- macOS: Xcode with macOS development support
- iOS: Xcode and a simulator or device
- Android: Android Studio, Android SDK, and a configured emulator or device

Then run:

```bash
flutter pub get
flutter analyze
flutter test
```

## Project Structure

- `lib/`: Flutter UI, app preferences, localization wiring, and the recorder
  platform channel client.
- `macos/Runner/RecorderCore/`: ScreenCaptureKit capture, AVAssetWriter output,
  permissions, and desktop-only recording services.
- `macos/Runner/RecorderBridge.swift`: macOS MethodChannel bridge.
- `ios/Runner/AppDelegate.swift`: iOS ReplayKit bridge.
- `android/app/src/main/kotlin/com/example/rec/`: Android MediaProjection and
  foreground service implementation.
- `NOTICE`: attribution for the BetterCapture code that informed portions of
  the macOS recording stack.

## Before Opening a Pull Request

Please run the relevant checks before submitting changes:

```bash
flutter analyze
flutter test
```

For native changes, also run the platform build you touched when practical:

```bash
flutter build macos
flutter build ios --simulator --no-codesign
flutter build apk --debug
```

## Contribution Guidelines

- Keep platform differences explicit. macOS supports richer target selection;
  iOS and Android are intentionally simpler because of OS recording APIs.
- Do not add FFmpeg or other heavy codec dependencies without a clear licensing
  and distribution review.
- Keep generated build outputs out of commits.
- Update localization resources when adding user-visible text.
- Include focused tests for Flutter flow changes and manual verification notes
  for native recording behavior.
