import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class RecorderPlatform {
  const RecorderPlatform();

  static const MethodChannel _channel = MethodChannel('rec/platform');
  static String? _lastSnapshotSummary;

  static bool get _hasNativeBridge =>
      Platform.isMacOS || Platform.isIOS || Platform.isAndroid;

  static void _log(String message) {
    if (!kDebugMode) {
      return;
    }
    debugPrint('[Rec][Platform] $message');
  }

  static String _describeMap(Map<String, dynamic> values) {
    final keys = values.keys.toList()..sort();
    return keys.map((key) => '$key=${values[key]}').join(', ');
  }

  static String _snapshotSummary(RecorderSnapshot snapshot) {
    final permissions = snapshot.permissions;
    return [
      'platform=${snapshot.platform}',
      'state=${snapshot.state}',
      'canStart=${snapshot.canStartRecording}',
      'selected=${snapshot.hasContentSelected}',
      'screen=${permissions.screenRecording}',
      'mic=${permissions.microphone}',
      'duration=${snapshot.formattedDuration}',
      if (snapshot.lastSavedRecordingPath != null)
        'saved=${snapshot.lastSavedRecordingPath}',
      if (snapshot.lastErrorMessage != null)
        'error=${snapshot.lastErrorMessage}',
    ].join(', ');
  }

  static void _logSnapshot(String source, RecorderSnapshot snapshot) {
    final summary = _snapshotSummary(snapshot);
    if (_lastSnapshotSummary == summary) {
      return;
    }
    _lastSnapshotSummary = summary;
    _log('$source => $summary');
  }

  Future<RecorderSnapshot> snapshot() async {
    if (_hasNativeBridge) {
      final raw = await _channel.invokeMapMethod<String, dynamic>('snapshot');
      if (raw == null) {
        throw PlatformException(
          code: 'empty_snapshot',
          message: 'Recorder bridge returned an empty snapshot.',
        );
      }
      final snapshot = RecorderSnapshot.fromMap(raw);
      _logSnapshot('snapshot()', snapshot);
      return snapshot;
    }

    final snapshot = RecorderSnapshot.fallback(defaultTargetPlatform);
    _logSnapshot('snapshot() fallback', snapshot);
    return snapshot;
  }

  Future<RecorderSnapshot> requestPermissions() async {
    if (!_hasNativeBridge) {
      final snapshot = RecorderSnapshot.fallback(defaultTargetPlatform);
      _logSnapshot('requestPermissions() fallback', snapshot);
      return snapshot;
    }

    _log('requestPermissions()');
    final raw = await _channel.invokeMapMethod<String, dynamic>(
      'requestPermissions',
    );
    final snapshot = RecorderSnapshot.fromMap(raw ?? <String, dynamic>{});
    _logSnapshot('requestPermissions()', snapshot);
    return snapshot;
  }

  Future<RecorderSnapshot> presentPicker({
    bool autoStartRecording = false,
    PickerSelectionMode selectionMode = PickerSelectionMode.any,
  }) async {
    if (!_hasNativeBridge) {
      throw UnsupportedError(
        'Native content selection is unavailable on this platform.',
      );
    }

    _log(
      'presentPicker(autoStartRecording=$autoStartRecording, selectionMode=${selectionMode.channelValue})',
    );
    final raw = await _channel
        .invokeMapMethod<String, dynamic>('presentPicker', <String, dynamic>{
          'autoStartRecording': autoStartRecording,
          'selectionMode': selectionMode.channelValue,
        });
    final snapshot = RecorderSnapshot.fromMap(raw ?? <String, dynamic>{});
    _logSnapshot('presentPicker()', snapshot);
    return snapshot;
  }

  Future<RecorderSnapshot> presentAreaSelection({
    bool autoStartRecording = false,
  }) async {
    if (!_hasNativeBridge) {
      throw UnsupportedError(
        'Native area selection is unavailable on this platform.',
      );
    }

    _log('presentAreaSelection(autoStartRecording=$autoStartRecording)');
    final raw = await _channel.invokeMapMethod<String, dynamic>(
      'presentAreaSelection',
      <String, dynamic>{'autoStartRecording': autoStartRecording},
    );
    final snapshot = RecorderSnapshot.fromMap(raw ?? <String, dynamic>{});
    _logSnapshot('presentAreaSelection()', snapshot);
    return snapshot;
  }

  Future<RecorderSnapshot> clearSelection() async {
    if (!_hasNativeBridge) {
      final snapshot = RecorderSnapshot.fallback(defaultTargetPlatform);
      _logSnapshot('clearSelection() fallback', snapshot);
      return snapshot;
    }

    _log('clearSelection()');
    final raw = await _channel.invokeMapMethod<String, dynamic>(
      'clearSelection',
    );
    final snapshot = RecorderSnapshot.fromMap(raw ?? <String, dynamic>{});
    _logSnapshot('clearSelection()', snapshot);
    return snapshot;
  }

  Future<RecorderSnapshot> startRecording(Map<String, dynamic> settings) async {
    if (!_hasNativeBridge) {
      throw UnsupportedError(
        'This platform does not provide a native recorder bridge.',
      );
    }

    _log('startRecording(${_describeMap(settings)})');
    final raw = await _channel.invokeMapMethod<String, dynamic>(
      'startRecording',
      settings,
    );
    final snapshot = RecorderSnapshot.fromMap(raw ?? <String, dynamic>{});
    _logSnapshot('startRecording()', snapshot);
    return snapshot;
  }

  Future<RecorderSnapshot> stopRecording() async {
    if (!_hasNativeBridge) {
      throw UnsupportedError(
        'This platform does not provide a native recorder bridge.',
      );
    }

    _log('stopRecording()');
    final raw = await _channel.invokeMapMethod<String, dynamic>(
      'stopRecording',
    );
    final snapshot = RecorderSnapshot.fromMap(raw ?? <String, dynamic>{});
    _logSnapshot('stopRecording()', snapshot);
    return snapshot;
  }

  Future<RecorderSnapshot> pauseRecording() async {
    if (!_hasNativeBridge) {
      throw UnsupportedError(
        'This platform does not provide a native recorder bridge.',
      );
    }

    _log('pauseRecording()');
    final raw = await _channel.invokeMapMethod<String, dynamic>(
      'pauseRecording',
    );
    final snapshot = RecorderSnapshot.fromMap(raw ?? <String, dynamic>{});
    _logSnapshot('pauseRecording()', snapshot);
    return snapshot;
  }

  Future<RecorderSnapshot> resumeRecording() async {
    if (!_hasNativeBridge) {
      throw UnsupportedError(
        'This platform does not provide a native recorder bridge.',
      );
    }

    _log('resumeRecording()');
    final raw = await _channel.invokeMapMethod<String, dynamic>(
      'resumeRecording',
    );
    final snapshot = RecorderSnapshot.fromMap(raw ?? <String, dynamic>{});
    _logSnapshot('resumeRecording()', snapshot);
    return snapshot;
  }

  Future<RecorderSnapshot> updateSettings(Map<String, dynamic> settings) async {
    if (!_hasNativeBridge) {
      final current = RecorderSnapshot.fallback(defaultTargetPlatform);
      final snapshot = current.copyWith(
        settings: current.settings.merge(settings),
      );
      _logSnapshot('updateSettings() fallback', snapshot);
      return snapshot;
    }

    _log('updateSettings(${_describeMap(settings)})');
    final raw = await _channel.invokeMapMethod<String, dynamic>(
      'updateSettings',
      settings,
    );
    final snapshot = RecorderSnapshot.fromMap(raw ?? <String, dynamic>{});
    _logSnapshot('updateSettings()', snapshot);
    return snapshot;
  }

  Future<RecorderSnapshot> chooseOutputDirectory() async {
    if (!_hasNativeBridge) {
      final snapshot = RecorderSnapshot.fallback(defaultTargetPlatform);
      _logSnapshot('chooseOutputDirectory() fallback', snapshot);
      return snapshot;
    }

    _log('chooseOutputDirectory()');
    final raw = await _channel.invokeMapMethod<String, dynamic>(
      'chooseOutputDirectory',
    );
    final snapshot = RecorderSnapshot.fromMap(raw ?? <String, dynamic>{});
    _logSnapshot('chooseOutputDirectory()', snapshot);
    return snapshot;
  }

  Future<RecorderSnapshot> openOutputFolder() async {
    if (!_hasNativeBridge) {
      final snapshot = RecorderSnapshot.fallback(defaultTargetPlatform);
      _logSnapshot('openOutputFolder() fallback', snapshot);
      return snapshot;
    }

    _log('openOutputFolder()');
    final raw = await _channel.invokeMapMethod<String, dynamic>(
      'openOutputFolder',
    );
    final snapshot = RecorderSnapshot.fromMap(raw ?? <String, dynamic>{});
    _logSnapshot('openOutputFolder()', snapshot);
    return snapshot;
  }

  Future<RecorderSnapshot> revealRecording(String path) async {
    if (!_hasNativeBridge) {
      final snapshot = RecorderSnapshot.fallback(defaultTargetPlatform);
      _logSnapshot('revealRecording() fallback', snapshot);
      return snapshot;
    }

    _log('revealRecording(path=$path)');
    final raw = await _channel.invokeMapMethod<String, dynamic>(
      'revealRecording',
      <String, dynamic>{'path': path},
    );
    final snapshot = RecorderSnapshot.fromMap(raw ?? <String, dynamic>{});
    _logSnapshot('revealRecording()', snapshot);
    return snapshot;
  }

  Future<RecorderSnapshot> openScreenRecordingSettings() async {
    if (!_hasNativeBridge) {
      final snapshot = RecorderSnapshot.fallback(defaultTargetPlatform);
      _logSnapshot('openScreenRecordingSettings() fallback', snapshot);
      return snapshot;
    }

    _log('openScreenRecordingSettings()');
    final raw = await _channel.invokeMapMethod<String, dynamic>(
      'openScreenRecordingSettings',
    );
    final snapshot = RecorderSnapshot.fromMap(raw ?? <String, dynamic>{});
    _logSnapshot('openScreenRecordingSettings()', snapshot);
    return snapshot;
  }

  Future<RecorderSnapshot> openMicrophoneSettings() async {
    if (!_hasNativeBridge) {
      final snapshot = RecorderSnapshot.fallback(defaultTargetPlatform);
      _logSnapshot('openMicrophoneSettings() fallback', snapshot);
      return snapshot;
    }

    _log('openMicrophoneSettings()');
    final raw = await _channel.invokeMapMethod<String, dynamic>(
      'openMicrophoneSettings',
    );
    final snapshot = RecorderSnapshot.fromMap(raw ?? <String, dynamic>{});
    _logSnapshot('openMicrophoneSettings()', snapshot);
    return snapshot;
  }

  Future<Map<String, dynamic>> loadAppPreferences() async {
    if (!_hasNativeBridge) {
      return const <String, dynamic>{};
    }

    _log('loadAppPreferences()');
    final raw = await _channel.invokeMapMethod<String, dynamic>(
      'loadAppPreferences',
    );
    final preferences = raw ?? const <String, dynamic>{};
    _log('loadAppPreferences() => ${_describeMap(preferences)}');
    return preferences;
  }

  Future<void> saveAppPreferences(Map<String, dynamic> preferences) async {
    if (!_hasNativeBridge) {
      return;
    }

    _log('saveAppPreferences(${_describeMap(preferences)})');
    await _channel.invokeMethod<void>('saveAppPreferences', preferences);
  }
}

enum PickerSelectionMode {
  any('any'),
  display('display'),
  application('application');

  const PickerSelectionMode(this.channelValue);

  final String channelValue;
}

class RecorderSnapshot {
  const RecorderSnapshot({
    required this.platform,
    required this.state,
    required this.canStartRecording,
    required this.hasContentSelected,
    required this.isRecording,
    required this.formattedDuration,
    required this.recordingDuration,
    required this.presenterOverlayActive,
    required this.permissions,
    required this.settings,
    required this.capabilities,
    required this.audioDevices,
    required this.cameraDevices,
    required this.note,
    this.lastSavedRecordingPath,
    this.lastErrorMessage,
  });

  final String platform;
  final String state;
  final bool canStartRecording;
  final bool hasContentSelected;
  final bool isRecording;
  final String formattedDuration;
  final double recordingDuration;
  final bool presenterOverlayActive;
  final PermissionSnapshot permissions;
  final RecorderSettings settings;
  final RecorderCapabilities capabilities;
  final List<DeviceOption> audioDevices;
  final List<DeviceOption> cameraDevices;
  final String note;
  final String? lastSavedRecordingPath;
  final String? lastErrorMessage;

  bool get isMacRecorder => platform == 'macos';

  bool get isSimpleMobileRecorder => platform == 'ios' || platform == 'android';

  bool get isPaused => state == 'paused';

  bool get hasActiveRecording => isRecording || isPaused;

  factory RecorderSnapshot.fromMap(Map<String, dynamic> map) {
    return RecorderSnapshot(
      platform: map['platform'] as String? ?? 'macos',
      state: map['state'] as String? ?? 'idle',
      canStartRecording: map['canStartRecording'] as bool? ?? false,
      hasContentSelected: map['hasContentSelected'] as bool? ?? false,
      isRecording: map['isRecording'] as bool? ?? false,
      formattedDuration: map['formattedDuration'] as String? ?? '00:00',
      recordingDuration: (map['recordingDuration'] as num?)?.toDouble() ?? 0,
      presenterOverlayActive: map['presenterOverlayActive'] as bool? ?? false,
      permissions: PermissionSnapshot.fromMap(
        (map['permissions'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      settings: RecorderSettings.fromMap(
        (map['settings'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      capabilities: RecorderCapabilities.fromMap(
        (map['capabilities'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      audioDevices: _deviceListFromMap(map['audioDevices']),
      cameraDevices: _deviceListFromMap(map['cameraDevices']),
      note:
          map['note'] as String? ??
          'This build uses a native recorder bridge for the current platform. Platform-specific restrictions still apply.',
      lastSavedRecordingPath:
          map['stoppedRecordingPath'] as String? ??
          map['lastSavedRecordingPath'] as String?,
      lastErrorMessage: map['lastErrorMessage'] as String?,
    );
  }

  factory RecorderSnapshot.fallback(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.iOS:
        return RecorderSnapshot(
          platform: 'ios',
          state: 'idle',
          canStartRecording: false,
          hasContentSelected: true,
          isRecording: false,
          formattedDuration: '00:00',
          recordingDuration: 0,
          presenterOverlayActive: false,
          permissions: const PermissionSnapshot(
            screenRecording: 'unknown',
            microphone: 'unknown',
          ),
          settings: const RecorderSettings(outputDirectory: 'App sandbox'),
          capabilities: const RecorderCapabilities(
            contentPicker: false,
            areaSelection: false,
            presenterOverlay: false,
            systemAudio: false,
            microphone: true,
            pauseResume: false,
            hdr: false,
            alpha: false,
            windowFiltering: false,
          ),
          audioDevices: const <DeviceOption>[],
          cameraDevices: const <DeviceOption>[],
          note:
              'iOS can support full-screen capture with ReplayKit, but BetterCapture-style window picking, system audio routing, and menu-bar style controls are not available. The shared Flutter UI is ready; the iOS native recorder bridge still needs implementation.',
        );
      case TargetPlatform.android:
        return RecorderSnapshot(
          platform: 'android',
          state: 'idle',
          canStartRecording: false,
          hasContentSelected: true,
          isRecording: false,
          formattedDuration: '00:00',
          recordingDuration: 0,
          presenterOverlayActive: false,
          permissions: const PermissionSnapshot(
            screenRecording: 'unknown',
            microphone: 'unknown',
          ),
          settings: const RecorderSettings(outputDirectory: 'App sandbox'),
          capabilities: const RecorderCapabilities(
            contentPicker: false,
            areaSelection: false,
            presenterOverlay: false,
            systemAudio: false,
            microphone: true,
            pauseResume: false,
            hdr: false,
            alpha: false,
            windowFiltering: false,
          ),
          audioDevices: const <DeviceOption>[],
          cameraDevices: const <DeviceOption>[],
          note:
              'Android can support full-screen capture with MediaProjection, but BetterCapture-style per-window capture, dock/menu-bar filtering, and Apple-specific codecs are not possible. The shared Flutter UI is ready; the Android native recorder bridge still needs implementation.',
        );
      case TargetPlatform.macOS:
        return const RecorderSnapshot(
          platform: 'macos',
          state: 'idle',
          canStartRecording: false,
          hasContentSelected: false,
          isRecording: false,
          formattedDuration: '00:00',
          recordingDuration: 0,
          presenterOverlayActive: false,
          permissions: PermissionSnapshot(
            screenRecording: 'unknown',
            microphone: 'unknown',
          ),
          settings: RecorderSettings(outputDirectory: '~/Movies/Rec'),
          capabilities: RecorderCapabilities(
            contentPicker: true,
            areaSelection: true,
            presenterOverlay: true,
            systemAudio: true,
            microphone: true,
            pauseResume: true,
            hdr: true,
            alpha: true,
            windowFiltering: true,
          ),
          audioDevices: <DeviceOption>[],
          cameraDevices: <DeviceOption>[],
          note: 'Loading native macOS recorder state...',
        );
      default:
        return const RecorderSnapshot(
          platform: 'unknown',
          state: 'idle',
          canStartRecording: false,
          hasContentSelected: false,
          isRecording: false,
          formattedDuration: '00:00',
          recordingDuration: 0,
          presenterOverlayActive: false,
          permissions: PermissionSnapshot(
            screenRecording: 'unknown',
            microphone: 'unknown',
          ),
          settings: RecorderSettings(outputDirectory: ''),
          capabilities: RecorderCapabilities(
            contentPicker: false,
            areaSelection: false,
            presenterOverlay: false,
            systemAudio: false,
            microphone: false,
            pauseResume: false,
            hdr: false,
            alpha: false,
            windowFiltering: false,
          ),
          audioDevices: <DeviceOption>[],
          cameraDevices: <DeviceOption>[],
          note: 'Unsupported platform.',
        );
    }
  }

  RecorderSnapshot copyWith({
    String? platform,
    String? state,
    bool? canStartRecording,
    bool? hasContentSelected,
    bool? isRecording,
    String? formattedDuration,
    double? recordingDuration,
    bool? presenterOverlayActive,
    PermissionSnapshot? permissions,
    RecorderSettings? settings,
    RecorderCapabilities? capabilities,
    List<DeviceOption>? audioDevices,
    List<DeviceOption>? cameraDevices,
    String? note,
    String? lastSavedRecordingPath,
    String? lastErrorMessage,
  }) {
    return RecorderSnapshot(
      platform: platform ?? this.platform,
      state: state ?? this.state,
      canStartRecording: canStartRecording ?? this.canStartRecording,
      hasContentSelected: hasContentSelected ?? this.hasContentSelected,
      isRecording: isRecording ?? this.isRecording,
      formattedDuration: formattedDuration ?? this.formattedDuration,
      recordingDuration: recordingDuration ?? this.recordingDuration,
      presenterOverlayActive:
          presenterOverlayActive ?? this.presenterOverlayActive,
      permissions: permissions ?? this.permissions,
      settings: settings ?? this.settings,
      capabilities: capabilities ?? this.capabilities,
      audioDevices: audioDevices ?? this.audioDevices,
      cameraDevices: cameraDevices ?? this.cameraDevices,
      note: note ?? this.note,
      lastSavedRecordingPath:
          lastSavedRecordingPath ?? this.lastSavedRecordingPath,
      lastErrorMessage: lastErrorMessage ?? this.lastErrorMessage,
    );
  }

  static List<DeviceOption> _deviceListFromMap(dynamic raw) {
    if (raw is! List) {
      return const <DeviceOption>[];
    }

    return raw
        .whereType<Map>()
        .map((device) => DeviceOption.fromMap(device.cast<String, dynamic>()))
        .toList(growable: false);
  }
}

class PermissionSnapshot {
  const PermissionSnapshot({
    required this.screenRecording,
    required this.microphone,
  });

  final String screenRecording;
  final String microphone;

  factory PermissionSnapshot.fromMap(Map<String, dynamic> map) {
    return PermissionSnapshot(
      screenRecording: map['screenRecording'] as String? ?? 'unknown',
      microphone: map['microphone'] as String? ?? 'unknown',
    );
  }

  bool get isScreenGranted => screenRecording == 'granted';

  bool get isScreenPromptOnStart => screenRecording == 'prompt-on-start';

  bool get isScreenReady => isScreenGranted || isScreenPromptOnStart;

  bool get isScreenDenied => screenRecording == 'denied';

  bool get isScreenUnknown => screenRecording == 'unknown';

  bool get canAskForScreenAccessInApp => isScreenUnknown;

  bool get isMicrophoneGranted => microphone == 'granted';

  bool get isMicrophoneDenied => microphone == 'denied';

  bool get isMicrophoneUnknown => microphone == 'unknown';

  bool get isMicrophonePrompt => microphone == 'prompt';

  bool get canAskForMicrophoneAccessInApp =>
      isMicrophoneUnknown || isMicrophonePrompt;
}

class RecorderCapabilities {
  const RecorderCapabilities({
    required this.contentPicker,
    required this.areaSelection,
    required this.presenterOverlay,
    required this.systemAudio,
    required this.microphone,
    required this.pauseResume,
    required this.hdr,
    required this.alpha,
    required this.windowFiltering,
  });

  final bool contentPicker;
  final bool areaSelection;
  final bool presenterOverlay;
  final bool systemAudio;
  final bool microphone;
  final bool pauseResume;
  final bool hdr;
  final bool alpha;
  final bool windowFiltering;

  factory RecorderCapabilities.fromMap(Map<String, dynamic> map) {
    return RecorderCapabilities(
      contentPicker: map['contentPicker'] as bool? ?? false,
      areaSelection: map['areaSelection'] as bool? ?? false,
      presenterOverlay: map['presenterOverlay'] as bool? ?? false,
      systemAudio: map['systemAudio'] as bool? ?? false,
      microphone: map['microphone'] as bool? ?? false,
      pauseResume: map['pauseResume'] as bool? ?? false,
      hdr: map['hdr'] as bool? ?? false,
      alpha: map['alpha'] as bool? ?? false,
      windowFiltering: map['windowFiltering'] as bool? ?? false,
    );
  }
}

class RecorderSettings {
  const RecorderSettings({
    this.frameRate = 60,
    this.videoCodec = 'H.265',
    this.containerFormat = 'mov',
    this.videoQuality = 'Medium',
    this.audioCodec = 'AAC',
    this.captureSystemAudio = true,
    this.captureMicrophone = false,
    this.captureAlphaChannel = false,
    this.captureHDR = false,
    this.captureNativeResolution = true,
    this.presenterOverlayEnabled = false,
    this.selectedMicrophoneID,
    this.selectedCameraID,
    this.showCursor = true,
    this.showWallpaper = true,
    this.showMenuBar = true,
    this.showDock = true,
    this.showRecorderUI = false,
    this.showWindowShadows = true,
    required this.outputDirectory,
  });

  final int frameRate;
  final String videoCodec;
  final String containerFormat;
  final String videoQuality;
  final String audioCodec;
  final bool captureSystemAudio;
  final bool captureMicrophone;
  final bool captureAlphaChannel;
  final bool captureHDR;
  final bool captureNativeResolution;
  final bool presenterOverlayEnabled;
  final String? selectedMicrophoneID;
  final String? selectedCameraID;
  final bool showCursor;
  final bool showWallpaper;
  final bool showMenuBar;
  final bool showDock;
  final bool showRecorderUI;
  final bool showWindowShadows;
  final String outputDirectory;

  factory RecorderSettings.fromMap(Map<String, dynamic> map) {
    return RecorderSettings(
      frameRate: map['frameRate'] as int? ?? 60,
      videoCodec: map['videoCodec'] as String? ?? 'H.265',
      containerFormat: map['containerFormat'] as String? ?? 'mov',
      videoQuality: map['videoQuality'] as String? ?? 'Medium',
      audioCodec: map['audioCodec'] as String? ?? 'AAC',
      captureSystemAudio: map['captureSystemAudio'] as bool? ?? true,
      captureMicrophone: map['captureMicrophone'] as bool? ?? false,
      captureAlphaChannel: map['captureAlphaChannel'] as bool? ?? false,
      captureHDR: map['captureHDR'] as bool? ?? false,
      captureNativeResolution: map['captureNativeResolution'] as bool? ?? true,
      presenterOverlayEnabled: map['presenterOverlayEnabled'] as bool? ?? false,
      selectedMicrophoneID: map['selectedMicrophoneID'] as String?,
      selectedCameraID: map['selectedCameraID'] as String?,
      showCursor: map['showCursor'] as bool? ?? true,
      showWallpaper: map['showWallpaper'] as bool? ?? true,
      showMenuBar: map['showMenuBar'] as bool? ?? true,
      showDock: map['showDock'] as bool? ?? true,
      showRecorderUI: map['showRecorderUI'] as bool? ?? false,
      showWindowShadows: map['showWindowShadows'] as bool? ?? true,
      outputDirectory: map['outputDirectory'] as String? ?? '',
    );
  }

  RecorderSettings merge(Map<String, dynamic> changes) {
    return RecorderSettings(
      frameRate: changes['frameRate'] as int? ?? frameRate,
      videoCodec: changes['videoCodec'] as String? ?? videoCodec,
      containerFormat: changes['containerFormat'] as String? ?? containerFormat,
      videoQuality: changes['videoQuality'] as String? ?? videoQuality,
      audioCodec: changes['audioCodec'] as String? ?? audioCodec,
      captureSystemAudio:
          changes['captureSystemAudio'] as bool? ?? captureSystemAudio,
      captureMicrophone:
          changes['captureMicrophone'] as bool? ?? captureMicrophone,
      captureAlphaChannel:
          changes['captureAlphaChannel'] as bool? ?? captureAlphaChannel,
      captureHDR: changes['captureHDR'] as bool? ?? captureHDR,
      captureNativeResolution:
          changes['captureNativeResolution'] as bool? ??
          captureNativeResolution,
      presenterOverlayEnabled:
          changes['presenterOverlayEnabled'] as bool? ??
          presenterOverlayEnabled,
      selectedMicrophoneID: changes.containsKey('selectedMicrophoneID')
          ? changes['selectedMicrophoneID'] as String?
          : selectedMicrophoneID,
      selectedCameraID: changes.containsKey('selectedCameraID')
          ? changes['selectedCameraID'] as String?
          : selectedCameraID,
      showCursor: changes['showCursor'] as bool? ?? showCursor,
      showWallpaper: changes['showWallpaper'] as bool? ?? showWallpaper,
      showMenuBar: changes['showMenuBar'] as bool? ?? showMenuBar,
      showDock: changes['showDock'] as bool? ?? showDock,
      showRecorderUI: changes['showRecorderUI'] as bool? ?? showRecorderUI,
      showWindowShadows:
          changes['showWindowShadows'] as bool? ?? showWindowShadows,
      outputDirectory: changes['outputDirectory'] as String? ?? outputDirectory,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'frameRate': frameRate,
      'videoCodec': videoCodec,
      'containerFormat': containerFormat,
      'videoQuality': videoQuality,
      'audioCodec': audioCodec,
      'captureSystemAudio': captureSystemAudio,
      'captureMicrophone': captureMicrophone,
      'captureAlphaChannel': captureAlphaChannel,
      'captureHDR': captureHDR,
      'captureNativeResolution': captureNativeResolution,
      'presenterOverlayEnabled': presenterOverlayEnabled,
      'selectedMicrophoneID': selectedMicrophoneID,
      'selectedCameraID': selectedCameraID,
      'showCursor': showCursor,
      'showWallpaper': showWallpaper,
      'showMenuBar': showMenuBar,
      'showDock': showDock,
      'showRecorderUI': showRecorderUI,
      'showWindowShadows': showWindowShadows,
      'outputDirectory': outputDirectory,
    };
  }
}

class DeviceOption {
  const DeviceOption({
    required this.id,
    required this.name,
    this.isDefault = false,
  });

  final String id;
  final String name;
  final bool isDefault;

  factory DeviceOption.fromMap(Map<String, dynamic> map) {
    return DeviceOption(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? 'Unknown device',
      isDefault: map['isDefault'] as bool? ?? false,
    );
  }
}
