import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/main.dart';
import 'package:rec/recorder_platform.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

Map<String, dynamic> _baseSnapshot({
  String platform = 'macos',
  String state = 'idle',
  bool captureMicrophone = false,
  bool captureSystemAudio = true,
  bool isRecording = false,
  bool canStartRecording = false,
  bool hasContentSelected = false,
  bool contentPicker = true,
  bool areaSelection = true,
  bool pauseResume = true,
  String screenPerm = 'unknown',
  String micPerm = 'unknown',
}) => <String, dynamic>{
  'platform': platform,
  'state': state == 'idle' && isRecording ? 'recording' : state,
  'canStartRecording': canStartRecording,
  'hasContentSelected': hasContentSelected,
  'isRecording': state == 'recording' || state == 'paused' || isRecording,
  'formattedDuration':
      state == 'recording' || state == 'paused' || isRecording
      ? '00:05'
      : '00:00',
  'recordingDuration':
      state == 'recording' || state == 'paused' || isRecording ? 5.0 : 0.0,
  'presenterOverlayActive': false,
  'permissions': <String, dynamic>{
    'screenRecording': screenPerm,
    'microphone': micPerm,
  },
  'settings': <String, dynamic>{
    'frameRate': 60,
    'videoCodec': 'H.265',
    'containerFormat': 'mov',
    'videoQuality': 'Medium',
    'audioCodec': 'AAC',
    'captureSystemAudio': captureSystemAudio,
    'captureMicrophone': captureMicrophone,
    'captureAlphaChannel': false,
    'captureHDR': false,
    'captureNativeResolution': true,
    'presenterOverlayEnabled': false,
    'showCursor': true,
    'showWallpaper': true,
    'showMenuBar': true,
    'showDock': true,
    'showRecorderUI': false,
    'showWindowShadows': true,
    'outputDirectory': '~/Movies/Rec',
  },
  'capabilities': <String, dynamic>{
    'contentPicker': contentPicker,
    'areaSelection': areaSelection,
    'presenterOverlay': true,
    'systemAudio': true,
    'microphone': true,
    'pauseResume': pauseResume,
    'hdr': true,
    'alpha': true,
    'windowFiltering': true,
  },
  'audioDevices': <dynamic>[],
  'cameraDevices': <dynamic>[],
  'note': '',
};

void _setMockChannelHandler(
  Future<dynamic> Function(MethodCall call)? handler,
) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(const MethodChannel('rec/platform'), handler);
}

/// 매 테스트마다 'rec/platform' 메서드 채널을 가짜로 교체.
void _mockChannel(
  Map<String, dynamic> snapshotData, {
  Map<String, dynamic> appPreferences = const <String, dynamic>{
    'countdownSeconds': 0,
  },
}) {
  _setMockChannelHandler((MethodCall call) async {
    switch (call.method) {
      case 'snapshot':
        return snapshotData;
      case 'loadAppPreferences':
        return appPreferences;
      case 'saveAppPreferences':
        return null;
      case 'updateSettings':
        final args = call.arguments as Map?;
        final merged = Map<String, dynamic>.from(
          snapshotData['settings'] as Map,
        )..addAll((args ?? <String, dynamic>{}).cast<String, dynamic>());
        return <String, dynamic>{...snapshotData, 'settings': merged};
      case 'requestPermissions':
        return <String, dynamic>{
          ...snapshotData,
          'permissions': <String, dynamic>{
            'screenRecording': 'granted',
            'microphone': 'granted',
          },
        };
      case 'clearSelection':
        return <String, dynamic>{...snapshotData, 'hasContentSelected': false};
      default:
        return snapshotData;
    }
  });
}

void _clearMockChannel() {
  _setMockChannelHandler(null);
}

/// 앱을 펌프하고 채널 응답이 반영될 때까지 대기.
Future<void> _pumpApp(WidgetTester tester, {Locale? locale}) async {
  tester.view.physicalSize = const Size(1600, 2200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(RecApp(locale: locale));
  // 채널 응답 + setState 반영
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

Future<void> _chooseRecordingDialogs(
  WidgetTester tester, {
  String targetKey = 'record_target_full_screen',
  String audioKey = 'audio_choice_system_only',
}) async {
  await tester.tap(find.byKey(ValueKey<String>(targetKey)));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.tap(find.byKey(ValueKey<String>(audioKey)));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

// ─────────────────────────────────────────────────────────────────────────────
// Unit tests — model layer
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  group('RecorderSnapshot.fromMap', () {
    test('parses all basic fields', () {
      final snap = RecorderSnapshot.fromMap(_baseSnapshot());
      expect(snap.platform, 'macos');
      expect(snap.state, 'idle');
      expect(snap.isRecording, false);
      expect(snap.canStartRecording, false);
      expect(snap.formattedDuration, '00:00');
    });

    test('isRecording=true when state is recording', () {
      final snap = RecorderSnapshot.fromMap(_baseSnapshot(isRecording: true));
      expect(snap.isRecording, true);
      expect(snap.formattedDuration, '00:05');
    });

    test('isMacRecorder is true for macos platform', () {
      final snap = RecorderSnapshot.fromMap(_baseSnapshot());
      expect(snap.isMacRecorder, true);
    });

    test('missing fields fall back to defaults', () {
      final snap = RecorderSnapshot.fromMap(<String, dynamic>{});
      expect(snap.platform, 'macos');
      expect(snap.formattedDuration, '00:00');
      expect(snap.settings.captureMicrophone, false);
    });
  });

  group('RecorderSettings', () {
    test('default captureMicrophone is false', () {
      const settings = RecorderSettings(outputDirectory: '~/Movies');
      expect(settings.captureMicrophone, false);
    });

    test('fromMap parses captureMicrophone', () {
      final settings = RecorderSettings.fromMap(<String, dynamic>{
        'captureMicrophone': true,
        'outputDirectory': '~/Movies',
      });
      expect(settings.captureMicrophone, true);
    });

    test('merge updates only specified fields', () {
      const settings = RecorderSettings(outputDirectory: '~/Movies');
      final merged = settings.merge(<String, dynamic>{
        'captureMicrophone': true,
      });
      expect(merged.captureMicrophone, true);
      expect(
        merged.captureSystemAudio,
        settings.captureSystemAudio,
      ); // unchanged
      expect(merged.outputDirectory, '~/Movies'); // unchanged
    });

    test('toMap / fromMap roundtrip', () {
      const original = RecorderSettings(
        outputDirectory: '~/Movies',
        frameRate: 30,
        videoCodec: 'H.264',
        captureMicrophone: true,
        captureHDR: true,
      );
      final roundtrip = RecorderSettings.fromMap(original.toMap());
      expect(roundtrip.frameRate, 30);
      expect(roundtrip.videoCodec, 'H.264');
      expect(roundtrip.captureMicrophone, true);
      expect(roundtrip.captureHDR, true);
      expect(roundtrip.outputDirectory, '~/Movies');
    });
  });

  group('RecorderCapabilities.fromMap', () {
    test('all false when empty map', () {
      final caps = RecorderCapabilities.fromMap(<String, dynamic>{});
      expect(caps.contentPicker, false);
      expect(caps.microphone, false);
      expect(caps.hdr, false);
    });

    test('parses all fields', () {
      final caps = RecorderCapabilities.fromMap(<String, dynamic>{
        'contentPicker': true,
        'areaSelection': false,
        'presenterOverlay': true,
        'systemAudio': true,
        'microphone': true,
        'hdr': true,
        'alpha': true,
        'windowFiltering': false,
      });
      expect(caps.contentPicker, true);
      expect(caps.systemAudio, true);
      expect(caps.windowFiltering, false);
    });
  });

  group('PermissionSnapshot.fromMap', () {
    test('defaults to unknown', () {
      final perms = PermissionSnapshot.fromMap(<String, dynamic>{});
      expect(perms.screenRecording, 'unknown');
      expect(perms.microphone, 'unknown');
    });

    test('parses granted', () {
      final perms = PermissionSnapshot.fromMap(<String, dynamic>{
        'screenRecording': 'granted',
        'microphone': 'denied',
      });
      expect(perms.screenRecording, 'granted');
      expect(perms.microphone, 'denied');
    });

    test('treats prompt-on-start screen capture as ready', () {
      final perms = PermissionSnapshot.fromMap(<String, dynamic>{
        'screenRecording': 'prompt-on-start',
        'microphone': 'prompt',
      });
      expect(perms.isScreenPromptOnStart, true);
      expect(perms.isScreenReady, true);
      expect(perms.canAskForScreenAccessInApp, false);
      expect(perms.canAskForMicrophoneAccessInApp, true);
    });
  });

  group('DeviceOption.fromMap', () {
    test('parses id and name', () {
      final device = DeviceOption.fromMap(<String, dynamic>{
        'id': 'mic-001',
        'name': 'Built-in Microphone',
        'isDefault': true,
      });
      expect(device.id, 'mic-001');
      expect(device.name, 'Built-in Microphone');
      expect(device.isDefault, true);
    });

    test('fallback name on empty map', () {
      final device = DeviceOption.fromMap(<String, dynamic>{});
      expect(device.name, 'Unknown device');
    });
  });

  group('RecorderSnapshot.copyWith', () {
    test('copies with changed isRecording', () {
      final original = RecorderSnapshot.fromMap(_baseSnapshot());
      final copy = original.copyWith(isRecording: true, state: 'recording');
      expect(copy.isRecording, true);
      expect(copy.state, 'recording');
      expect(copy.platform, original.platform); // unchanged
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Widget tests
  // ─────────────────────────────────────────────────────────────────────────

  group('RecApp widget', () {
    tearDown(_clearMockChannel);

    testWidgets('requests snapshot immediately on startup', (tester) async {
      var snapshotCalls = 0;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('rec/platform'), (
            MethodCall call,
          ) async {
            if (call.method == 'loadAppPreferences') {
              return const <String, dynamic>{'countdownSeconds': 0};
            }
            if (call.method == 'saveAppPreferences') {
              return null;
            }
            if (call.method == 'snapshot') {
              snapshotCalls += 1;
            }
            return _baseSnapshot();
          });

      await _pumpApp(tester);

      expect(snapshotCalls, 1);
    });

    testWidgets('polls snapshot again after one second', (tester) async {
      var snapshotCalls = 0;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('rec/platform'), (
            MethodCall call,
          ) async {
            if (call.method == 'loadAppPreferences') {
              return const <String, dynamic>{'countdownSeconds': 0};
            }
            if (call.method == 'saveAppPreferences') {
              return null;
            }
            if (call.method == 'snapshot') {
              snapshotCalls += 1;
            }
            return _baseSnapshot();
          });

      await _pumpApp(tester);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      expect(snapshotCalls, 2);
    });

    testWidgets('shows minimal home with record, folder, settings, shortcuts', (
      tester,
    ) async {
      _mockChannel(
        _baseSnapshot(
          canStartRecording: true,
          hasContentSelected: true,
          screenPerm: 'granted',
          micPerm: 'granted',
        ),
      );
      await _pumpApp(tester);

      expect(
        find.byKey(const ValueKey<String>('primary_record')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('open_output_folder')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('open_app_settings')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('open_shortcuts')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('minimal_status_card')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('minimal_status_label')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('minimal_duration_text')),
        findsOneWidget,
      );
      expect(find.text('IDLE'), findsOneWidget);
      expect(find.text('00:00'), findsOneWidget);
      expect(find.text('SETUP'), findsNothing);
      expect(find.text('CAPABILITIES'), findsNothing);
      expect(find.text('Screen Only'), findsNothing);
    });

    testWidgets('shows simplified mobile home for ios', (tester) async {
      _mockChannel(
        _baseSnapshot(
          platform: 'ios',
          hasContentSelected: true,
          canStartRecording: true,
          contentPicker: false,
          areaSelection: false,
          pauseResume: false,
          screenPerm: 'granted',
          micPerm: 'granted',
        ),
      );
      await _pumpApp(tester);

      expect(
        find.byKey(const ValueKey<String>('primary_record')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('open_output_folder')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey<String>('open_app_settings')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey<String>('open_shortcuts')),
        findsNothing,
      );
    });

    testWidgets('renders Korean strings when locale is ko', (tester) async {
      _mockChannel(
        _baseSnapshot(
          canStartRecording: true,
          hasContentSelected: true,
          screenPerm: 'granted',
          micPerm: 'granted',
        ),
      );
      await _pumpApp(tester, locale: const Locale('ko'));

      expect(find.text('녹화하기'), findsOneWidget);
      expect(find.text('저장폴더 열기'), findsOneWidget);
    });

    testWidgets('shortcuts button opens shortcuts dialog', (tester) async {
      _mockChannel(
        _baseSnapshot(
          canStartRecording: true,
          hasContentSelected: true,
          screenPerm: 'granted',
          micPerm: 'granted',
        ),
      );
      await _pumpApp(tester);

      await tester.tap(find.byKey(const ValueKey<String>('open_shortcuts')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.byKey(const ValueKey<String>('shortcuts_dialog')),
        findsOneWidget,
      );
      expect(find.text('Cmd/Ctrl + 1'), findsOneWidget);
      expect(find.text('Cmd/Ctrl + 2'), findsOneWidget);
      expect(find.text('Cmd/Ctrl + 3'), findsOneWidget);
    });

    testWidgets('shortcuts dialog saves updated shortcut mapping', (
      tester,
    ) async {
      Map<String, dynamic>? lastSavedPreferences;
      _setMockChannelHandler((MethodCall call) async {
        switch (call.method) {
          case 'loadAppPreferences':
            return const <String, dynamic>{'countdownSeconds': 0};
          case 'saveAppPreferences':
            lastSavedPreferences = (call.arguments! as Map<Object?, Object?>)
                .cast<String, dynamic>();
            return null;
          case 'snapshot':
            return _baseSnapshot(
              canStartRecording: true,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          default:
            return _baseSnapshot(
              canStartRecording: true,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
        }
      });

      await _pumpApp(tester);
      await tester.tap(find.byKey(const ValueKey<String>('open_shortcuts')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const ValueKey<String>('shortcutRecordApplication_digit1'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cmd/Ctrl + 4').last);
      await tester.pumpAndSettle();

      expect(lastSavedPreferences, isNotNull);
      expect(lastSavedPreferences!['shortcutRecordApplication'], 'digit4');
    });

    testWidgets('loads saved app language preference on startup', (
      tester,
    ) async {
      _mockChannel(
        _baseSnapshot(
          canStartRecording: true,
          hasContentSelected: true,
          screenPerm: 'granted',
          micPerm: 'granted',
        ),
        appPreferences: const <String, dynamic>{
          'localeKey': 'ja',
          'autoRefreshEnabled': false,
          'autoRefreshSeconds': 5,
        },
      );
      await _pumpApp(tester);

      expect(find.text('録画する'), findsOneWidget);
    });

    testWidgets(
      'uses device locale as initial language when saved preference is missing',
      (tester) async {
        final binding = TestWidgetsFlutterBinding.ensureInitialized();
        binding.platformDispatcher.localesTestValue = const <Locale>[
          Locale('ja'),
        ];
        addTearDown(binding.platformDispatcher.clearLocalesTestValue);

        _mockChannel(
          _baseSnapshot(
            canStartRecording: true,
            hasContentSelected: true,
            screenPerm: 'granted',
            micPerm: 'granted',
          ),
        );
        await _pumpApp(tester);

        expect(find.text('録画する'), findsOneWidget);
      },
    );

    testWidgets(
      'record button opens permission dialog when access is missing',
      (tester) async {
        _mockChannel(
          _baseSnapshot(
            hasContentSelected: true,
            screenPerm: 'unknown',
            micPerm: 'unknown',
          ),
        );
        await _pumpApp(tester);

        await tester.tap(find.byKey(const ValueKey<String>('primary_record')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        await _chooseRecordingDialogs(tester);

        expect(find.text('Before you record'), findsOneWidget);
        expect(
          find.byKey(const ValueKey<String>('permission_dialog_allow_access')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('permission_dialog_check_again')),
          findsOneWidget,
        );
      },
    );

    testWidgets('mobile record flow skips target dialog', (tester) async {
      var startCalls = 0;
      var state = 'idle';
      _setMockChannelHandler((MethodCall call) async {
        switch (call.method) {
          case 'loadAppPreferences':
            return const <String, dynamic>{'countdownSeconds': 0};
          case 'saveAppPreferences':
            return null;
          case 'snapshot':
            return _baseSnapshot(
              platform: 'android',
              state: state,
              hasContentSelected: true,
              canStartRecording: state == 'idle',
              contentPicker: false,
              areaSelection: false,
              pauseResume: false,
              screenPerm: 'prompt-on-start',
              micPerm: 'granted',
            );
          case 'updateSettings':
            return _baseSnapshot(
              platform: 'android',
              state: state,
              hasContentSelected: true,
              canStartRecording: state == 'idle',
              contentPicker: false,
              areaSelection: false,
              pauseResume: false,
              screenPerm: 'prompt-on-start',
              micPerm: 'granted',
              captureSystemAudio:
                  (call.arguments! as Map<Object?, Object?>)['captureSystemAudio']
                      as bool,
              captureMicrophone:
                  (call.arguments! as Map<Object?, Object?>)['captureMicrophone']
                      as bool,
            );
          case 'startRecording':
            startCalls += 1;
            state = 'recording';
            return _baseSnapshot(
              platform: 'android',
              state: 'recording',
              hasContentSelected: true,
              canStartRecording: false,
              contentPicker: false,
              areaSelection: false,
              pauseResume: false,
              screenPerm: 'prompt-on-start',
              micPerm: 'granted',
            );
          default:
            return _baseSnapshot(
              platform: 'android',
              state: state,
              hasContentSelected: true,
              canStartRecording: state == 'idle',
              contentPicker: false,
              areaSelection: false,
              pauseResume: false,
              screenPerm: 'prompt-on-start',
              micPerm: 'granted',
            );
        }
      });

      await _pumpApp(tester);
      await tester.tap(find.byKey(const ValueKey<String>('primary_record')));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey<String>('record_target_dialog')), findsNothing);
      expect(find.byKey(const ValueKey<String>('audio_choice_dialog')), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey<String>('audio_choice_none')));
      await tester.pumpAndSettle();

      expect(startCalls, 1);
      expect(find.byKey(const ValueKey<String>('primary_stop')), findsOneWidget);
    });

    testWidgets('record flow waits for countdown before starting', (
      tester,
    ) async {
      var hasSelection = false;
      var startCalls = 0;
      _setMockChannelHandler((MethodCall call) async {
        switch (call.method) {
          case 'loadAppPreferences':
            return const <String, dynamic>{'countdownSeconds': 3};
          case 'saveAppPreferences':
            return null;
          case 'snapshot':
            return _baseSnapshot(
              canStartRecording: hasSelection,
              hasContentSelected: hasSelection,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          case 'presentPicker':
            hasSelection = true;
            return _baseSnapshot(
              canStartRecording: true,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          case 'startRecording':
            startCalls += 1;
            return _baseSnapshot(
              state: 'recording',
              canStartRecording: false,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          default:
            return _baseSnapshot(
              canStartRecording: hasSelection,
              hasContentSelected: hasSelection,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
        }
      });

      await _pumpApp(tester);
      await tester.tap(find.byKey(const ValueKey<String>('primary_record')));
      await tester.pumpAndSettle();
      await _chooseRecordingDialogs(
        tester,
        targetKey: 'record_target_full_screen',
        audioKey: 'audio_choice_system_only',
      );

      expect(startCalls, 0);
      expect(find.text('STARTING IN'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(startCalls, 1);
      expect(find.byKey(const ValueKey<String>('primary_stop')), findsOneWidget);
    });

    testWidgets('screen denial exposes settings action from dialog', (
      tester,
    ) async {
      var openScreenSettingsCalls = 0;
      _setMockChannelHandler((MethodCall call) async {
        switch (call.method) {
          case 'loadAppPreferences':
            return const <String, dynamic>{'countdownSeconds': 0};
          case 'saveAppPreferences':
            return null;
          case 'snapshot':
            return _baseSnapshot(
              hasContentSelected: true,
              screenPerm: 'denied',
              micPerm: 'granted',
            );
          case 'openScreenRecordingSettings':
            openScreenSettingsCalls += 1;
            return _baseSnapshot(
              hasContentSelected: true,
              screenPerm: 'denied',
              micPerm: 'granted',
            );
          default:
            return _baseSnapshot(
              hasContentSelected: true,
              screenPerm: 'denied',
              micPerm: 'granted',
            );
        }
      });

      await _pumpApp(tester);
      await tester.tap(find.byKey(const ValueKey<String>('primary_record')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await _chooseRecordingDialogs(tester);
      await tester.tap(
        find.byKey(const ValueKey<String>('permission_dialog_screen_settings')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(openScreenSettingsCalls, 1);
    });

    testWidgets('allow access can continue straight into recording', (
      tester,
    ) async {
      var permissionsGranted = false;
      var hasSelection = false;
      var recording = false;
      var requestCalls = 0;
      var clearSelectionCalls = 0;
      var pickerCalls = 0;
      var startCalls = 0;
      _setMockChannelHandler((MethodCall call) async {
        switch (call.method) {
          case 'loadAppPreferences':
            return const <String, dynamic>{'countdownSeconds': 0};
          case 'saveAppPreferences':
            return null;
          case 'snapshot':
            return _baseSnapshot(
              isRecording: recording,
              canStartRecording:
                  permissionsGranted && hasSelection && !recording,
              hasContentSelected: hasSelection,
              screenPerm: permissionsGranted ? 'granted' : 'unknown',
              micPerm: permissionsGranted ? 'granted' : 'unknown',
            );
          case 'clearSelection':
            clearSelectionCalls += 1;
            hasSelection = false;
            return _baseSnapshot(
              canStartRecording: false,
              hasContentSelected: false,
              screenPerm: permissionsGranted ? 'granted' : 'unknown',
              micPerm: permissionsGranted ? 'granted' : 'unknown',
            );
          case 'requestPermissions':
            requestCalls += 1;
            permissionsGranted = true;
            return _baseSnapshot(
              canStartRecording: false,
              hasContentSelected: false,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          case 'presentPicker':
            pickerCalls += 1;
            hasSelection = true;
            return _baseSnapshot(
              canStartRecording: true,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          case 'startRecording':
            startCalls += 1;
            recording = true;
            return _baseSnapshot(
              isRecording: true,
              canStartRecording: false,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          default:
            return _baseSnapshot(
              isRecording: recording,
              canStartRecording:
                  permissionsGranted && hasSelection && !recording,
              hasContentSelected: hasSelection,
              screenPerm: permissionsGranted ? 'granted' : 'unknown',
              micPerm: permissionsGranted ? 'granted' : 'unknown',
            );
        }
      });

      await _pumpApp(tester);
      await tester.tap(find.byKey(const ValueKey<String>('primary_record')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await _chooseRecordingDialogs(tester);
      await tester.tap(
        find.byKey(const ValueKey<String>('permission_dialog_allow_access')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(requestCalls, 1);
      expect(clearSelectionCalls, 0);
      expect(pickerCalls, 1);
      expect(startCalls, 1);
      expect(
        find.byKey(const ValueKey<String>('primary_stop')),
        findsOneWidget,
      );
    });

    testWidgets('record button picks chosen target and starts when needed', (
      tester,
    ) async {
      var hasSelection = false;
      var isRecording = false;
      var pickerCalls = 0;
      var startCalls = 0;
      _setMockChannelHandler((MethodCall call) async {
        switch (call.method) {
          case 'loadAppPreferences':
            return const <String, dynamic>{'countdownSeconds': 0};
          case 'saveAppPreferences':
            return null;
          case 'snapshot':
            return _baseSnapshot(
              isRecording: isRecording,
              canStartRecording: hasSelection && !isRecording,
              hasContentSelected: hasSelection,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          case 'presentPicker':
            pickerCalls += 1;
            hasSelection = true;
            return _baseSnapshot(
              canStartRecording: true,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          case 'startRecording':
            startCalls += 1;
            isRecording = true;
            return _baseSnapshot(
              isRecording: true,
              canStartRecording: false,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          default:
            return _baseSnapshot(
              isRecording: isRecording,
              canStartRecording: hasSelection && !isRecording,
              hasContentSelected: hasSelection,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
        }
      });

      await _pumpApp(tester);
      await tester.tap(find.byKey(const ValueKey<String>('primary_record')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await _chooseRecordingDialogs(tester);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(pickerCalls, 1);
      expect(startCalls, 1);
      expect(
        find.byKey(const ValueKey<String>('primary_stop')),
        findsOneWidget,
      );
    });

    testWidgets('record button starts recording after area selection', (
      tester,
    ) async {
      var isRecording = false;
      var areaSelectionCalls = 0;
      Map<String, dynamic>? startArgs;
      _setMockChannelHandler((MethodCall call) async {
        switch (call.method) {
          case 'loadAppPreferences':
            return const <String, dynamic>{'countdownSeconds': 0};
          case 'saveAppPreferences':
            return null;
          case 'snapshot':
            return _baseSnapshot(
              isRecording: isRecording,
              canStartRecording: false,
              hasContentSelected: false,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          case 'presentAreaSelection':
            areaSelectionCalls += 1;
            return _baseSnapshot(
              canStartRecording: true,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          case 'startRecording':
            startArgs = (call.arguments! as Map<Object?, Object?>)
                .cast<String, dynamic>();
            isRecording = true;
            return _baseSnapshot(
              isRecording: true,
              canStartRecording: false,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          default:
            return _baseSnapshot(
              isRecording: isRecording,
              canStartRecording: false,
              hasContentSelected: false,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
        }
      });

      await _pumpApp(tester);
      expect(
        find.byKey(const ValueKey<String>('primary_record')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const ValueKey<String>('primary_record')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await _chooseRecordingDialogs(
        tester,
        targetKey: 'record_target_area',
        audioKey: 'audio_choice_system_only',
      );

      expect(startArgs, isNotNull);
      expect(areaSelectionCalls, 1);
      expect(
        find.byKey(const ValueKey<String>('primary_stop')),
        findsOneWidget,
      );
      expect(find.text('RECORDING'), findsOneWidget);
      expect(find.text('00:05'), findsOneWidget);
    });

    testWidgets('record flow enables system audio when selected', (
      tester,
    ) async {
      var isRecording = false;
      var captureSystemAudio = false;
      var areaSelectionCalls = 0;
      Map<String, dynamic>? startArgs;
      _setMockChannelHandler((MethodCall call) async {
        switch (call.method) {
          case 'loadAppPreferences':
            return const <String, dynamic>{'countdownSeconds': 0};
          case 'saveAppPreferences':
            return null;
          case 'snapshot':
            return _baseSnapshot(
              isRecording: isRecording,
              canStartRecording: false,
              hasContentSelected: false,
              screenPerm: 'granted',
              micPerm: 'granted',
              captureSystemAudio: captureSystemAudio,
            );
          case 'updateSettings':
            final args = (call.arguments! as Map<Object?, Object?>)
                .cast<String, dynamic>();
            captureSystemAudio = args['captureSystemAudio'] as bool;
            return _baseSnapshot(
              isRecording: isRecording,
              canStartRecording: false,
              hasContentSelected: false,
              screenPerm: 'granted',
              micPerm: 'granted',
              captureSystemAudio: captureSystemAudio,
            );
          case 'presentAreaSelection':
            areaSelectionCalls += 1;
            return _baseSnapshot(
              canStartRecording: true,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
              captureSystemAudio: captureSystemAudio,
            );
          case 'startRecording':
            startArgs = (call.arguments! as Map<Object?, Object?>)
                .cast<String, dynamic>();
            isRecording = true;
            return _baseSnapshot(
              isRecording: true,
              canStartRecording: false,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
              captureSystemAudio: startArgs!['captureSystemAudio'] as bool,
            );
          default:
            return _baseSnapshot(
              isRecording: isRecording,
              canStartRecording: false,
              hasContentSelected: false,
              screenPerm: 'granted',
              micPerm: 'granted',
              captureSystemAudio: captureSystemAudio,
            );
        }
      });

      await _pumpApp(tester);
      await tester.tap(find.byKey(const ValueKey<String>('primary_record')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await _chooseRecordingDialogs(
        tester,
        targetKey: 'record_target_area',
        audioKey: 'audio_choice_system_only',
      );

      expect(startArgs, isNotNull);
      expect(areaSelectionCalls, 1);
      expect(startArgs!['captureSystemAudio'], true);
    });

    testWidgets('record flow can start with microphone only', (tester) async {
      var isRecording = false;
      var captureSystemAudio = true;
      var captureMicrophone = false;
      Map<String, dynamic>? startArgs;
      _setMockChannelHandler((MethodCall call) async {
        switch (call.method) {
          case 'loadAppPreferences':
            return const <String, dynamic>{'countdownSeconds': 0};
          case 'saveAppPreferences':
            return null;
          case 'snapshot':
            return _baseSnapshot(
              isRecording: isRecording,
              canStartRecording: false,
              hasContentSelected: false,
              screenPerm: 'granted',
              micPerm: 'granted',
              captureSystemAudio: captureSystemAudio,
              captureMicrophone: captureMicrophone,
            );
          case 'updateSettings':
            final args = (call.arguments! as Map<Object?, Object?>)
                .cast<String, dynamic>();
            captureSystemAudio = args['captureSystemAudio'] as bool;
            captureMicrophone = args['captureMicrophone'] as bool;
            return _baseSnapshot(
              isRecording: isRecording,
              canStartRecording: false,
              hasContentSelected: false,
              screenPerm: 'granted',
              micPerm: 'granted',
              captureSystemAudio: captureSystemAudio,
              captureMicrophone: captureMicrophone,
            );
          case 'presentAreaSelection':
            return _baseSnapshot(
              canStartRecording: true,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
              captureSystemAudio: captureSystemAudio,
              captureMicrophone: captureMicrophone,
            );
          case 'startRecording':
            startArgs = (call.arguments! as Map<Object?, Object?>)
                .cast<String, dynamic>();
            isRecording = true;
            return _baseSnapshot(
              state: 'recording',
              canStartRecording: false,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
              captureSystemAudio: captureSystemAudio,
              captureMicrophone: captureMicrophone,
            );
          default:
            return _baseSnapshot(
              isRecording: isRecording,
              canStartRecording: false,
              hasContentSelected: false,
              screenPerm: 'granted',
              micPerm: 'granted',
              captureSystemAudio: captureSystemAudio,
              captureMicrophone: captureMicrophone,
            );
        }
      });

      await _pumpApp(tester);
      await tester.tap(find.byKey(const ValueKey<String>('primary_record')));
      await tester.pumpAndSettle();
      await _chooseRecordingDialogs(
        tester,
        targetKey: 'record_target_area',
        audioKey: 'audio_choice_microphone_only',
      );

      expect(startArgs, isNotNull);
      expect(startArgs!['captureSystemAudio'], false);
      expect(startArgs!['captureMicrophone'], true);
    });

    testWidgets('pause button toggles between pause and resume', (tester) async {
      var state = 'recording';
      var pauseCalls = 0;
      var resumeCalls = 0;
      _setMockChannelHandler((MethodCall call) async {
        switch (call.method) {
          case 'loadAppPreferences':
            return const <String, dynamic>{'countdownSeconds': 0};
          case 'saveAppPreferences':
            return null;
          case 'snapshot':
            return _baseSnapshot(
              state: state,
              hasContentSelected: true,
              canStartRecording: false,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          case 'pauseRecording':
            pauseCalls += 1;
            state = 'paused';
            return _baseSnapshot(
              state: 'paused',
              hasContentSelected: true,
              canStartRecording: false,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          case 'resumeRecording':
            resumeCalls += 1;
            state = 'recording';
            return _baseSnapshot(
              state: 'recording',
              hasContentSelected: true,
              canStartRecording: false,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          default:
            return _baseSnapshot(
              state: state,
              hasContentSelected: true,
              canStartRecording: false,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
        }
      });

      await _pumpApp(tester);
      expect(find.text('Pause'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey<String>('pause_resume_button')));
      await tester.pumpAndSettle();

      expect(pauseCalls, 1);
      expect(find.text('Resume'), findsOneWidget);
      expect(find.text('PAUSED'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey<String>('pause_resume_button')));
      await tester.pumpAndSettle();

      expect(resumeCalls, 1);
      expect(find.text('Pause'), findsOneWidget);
      expect(find.text('RECORDING'), findsOneWidget);
    });

    testWidgets('record button stops recording when active', (tester) async {
      var stopCalls = 0;
      _setMockChannelHandler((MethodCall call) async {
        switch (call.method) {
          case 'loadAppPreferences':
            return const <String, dynamic>{'countdownSeconds': 0};
          case 'saveAppPreferences':
            return null;
          case 'snapshot':
            return _baseSnapshot(
              isRecording: stopCalls == 0,
              canStartRecording: stopCalls > 0,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          case 'stopRecording':
            stopCalls += 1;
            return _baseSnapshot(
              isRecording: false,
              canStartRecording: true,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          default:
            return _baseSnapshot(
              isRecording: stopCalls == 0,
              canStartRecording: stopCalls > 0,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
        }
      });

      await _pumpApp(tester);
      expect(
        find.byKey(const ValueKey<String>('primary_stop')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const ValueKey<String>('primary_stop')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(stopCalls, 1);
      expect(
        find.byKey(const ValueKey<String>('primary_record')),
        findsOneWidget,
      );
      expect(find.text('IDLE'), findsOneWidget);
      expect(find.text('00:00'), findsOneWidget);
    });

    testWidgets('stopped recordings appear in recent recordings list', (
      tester,
    ) async {
      const path = '/tmp/Rec-2026.mp4';
      var state = 'recording';
      var revealCalls = 0;
      _setMockChannelHandler((MethodCall call) async {
        switch (call.method) {
          case 'loadAppPreferences':
            return const <String, dynamic>{'countdownSeconds': 0};
          case 'saveAppPreferences':
            return null;
          case 'snapshot':
            return _baseSnapshot(
              state: state,
              hasContentSelected: true,
              canStartRecording: false,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          case 'stopRecording':
            state = 'idle';
            return <String, dynamic>{
              ..._baseSnapshot(
                state: 'idle',
                hasContentSelected: true,
                canStartRecording: true,
                screenPerm: 'granted',
                micPerm: 'granted',
              ),
              'stoppedRecordingPath': path,
            };
          case 'revealRecording':
            revealCalls += 1;
            return _baseSnapshot(
              state: 'idle',
              hasContentSelected: true,
              canStartRecording: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          default:
            return _baseSnapshot(
              state: state,
              hasContentSelected: true,
              canStartRecording: state == 'idle',
              screenPerm: 'granted',
              micPerm: 'granted',
            );
        }
      });

      await _pumpApp(tester);
      await tester.tap(find.byKey(const ValueKey<String>('primary_stop')));
      await tester.pumpAndSettle();

      expect(find.text('Recent Recordings'), findsOneWidget);
      expect(find.text('Rec-2026.mp4'), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey<String>('recent_recording_Rec-2026.mp4')),
      );
      await tester.pumpAndSettle();

      expect(revealCalls, 1);
    });

    testWidgets('folder button uses native open output folder action', (
      tester,
    ) async {
      var openFolderCalls = 0;
      _setMockChannelHandler((MethodCall call) async {
        switch (call.method) {
          case 'loadAppPreferences':
            return const <String, dynamic>{'countdownSeconds': 0};
          case 'saveAppPreferences':
            return null;
          case 'snapshot':
            return _baseSnapshot(
              canStartRecording: true,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          case 'openOutputFolder':
            openFolderCalls += 1;
            return _baseSnapshot(
              canStartRecording: true,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
          default:
            return _baseSnapshot(
              canStartRecording: true,
              hasContentSelected: true,
              screenPerm: 'granted',
              micPerm: 'granted',
            );
        }
      });

      await _pumpApp(tester);
      await tester.tap(
        find.byKey(const ValueKey<String>('open_output_folder')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(openFolderCalls, 1);
    });
  });
}
