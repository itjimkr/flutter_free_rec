import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rec/domain/recording.dart';
import 'package:rec/recorder_platform.dart';

class RecorderViewModel extends ChangeNotifier {
  RecorderViewModel(this._platform);

  final RecorderPlatform _platform;

  RecorderSnapshot? _snapshot;
  RecorderSnapshot? get snapshot => _snapshot;

  bool _loading = true;
  bool get loading => _loading;

  String? _actionError;
  String? get actionError => _actionError;

  int? _countdownValue;
  int? get countdownValue => _countdownValue;

  Timer? _refreshTimer;

  void Function(String message)? onMessage;
  void Function(String path)? onNewRecordingPath;

  void init() {
    _snapshot = RecorderSnapshot.fallback(defaultTargetPlatform);
    _loading = defaultTargetPlatform == TargetPlatform.macOS;
    refresh();
  }

  void configureRefresh({required bool enabled, required int seconds}) {
    _refreshTimer?.cancel();
    if (!enabled) {
      _refreshTimer = null;
      return;
    }
    _refreshTimer = Timer.periodic(
      Duration(seconds: seconds),
      (_) => refresh(silent: true),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<RecorderSnapshot?> refresh({bool silent = false}) async {
    if (!silent) {
      _loading = true;
      notifyListeners();
    }
    try {
      final snap = await _platform.snapshot();
      _notifyNewPath(snap.lastSavedRecordingPath);
      _snapshot = snap;
      _loading = false;
      _actionError = null;
      notifyListeners();
      return snap;
    } catch (error, stack) {
      debugPrint('[Rec] snapshot() failed: $error\n$stack');
      _loading = false;
      _actionError = error.toString();
      notifyListeners();
      return null;
    }
  }

  Future<RecorderSnapshot?> runAction(
    Future<RecorderSnapshot> Function() action, {
    String? successMessage,
  }) async {
    try {
      final snap = await action();
      _notifyNewPath(snap.lastSavedRecordingPath);
      _snapshot = snap;
      _actionError = null;
      notifyListeners();
      final message =
          successMessage ??
          snap.lastSavedRecordingPath ??
          snap.lastErrorMessage;
      if (message != null && message.isNotEmpty) onMessage?.call(message);
      return snap;
    } catch (error, stack) {
      debugPrint('[Rec] action failed: $error\n$stack');
      _actionError = error.toString();
      notifyListeners();
      onMessage?.call(error.toString());
      return null;
    }
  }

  Future<bool> runCountdown(int seconds) async {
    if (seconds <= 0) return true;
    for (var remaining = seconds; remaining > 0; remaining--) {
      _countdownValue = remaining;
      notifyListeners();
      await Future<void>.delayed(const Duration(seconds: 1));
    }
    _countdownValue = null;
    notifyListeners();
    return true;
  }

  Future<RecorderSnapshot?> requestPermissions({String? successMessage}) =>
      runAction(_platform.requestPermissions, successMessage: successMessage);

  Future<RecorderSnapshot?> presentPicker() =>
      runAction(_platform.presentPicker);

  Future<RecorderSnapshot?> openScreenRecordingSettings() =>
      runAction(_platform.openScreenRecordingSettings);

  Future<RecorderSnapshot?> openMicrophoneSettings() =>
      runAction(_platform.openMicrophoneSettings);

  Future<RecorderSnapshot?> selectTarget(RecordingTarget target) {
    return switch (target) {
      RecordingTarget.application => runAction(
          () => _platform.presentPicker(
            autoStartRecording: false,
            selectionMode: PickerSelectionMode.application,
          ),
        ),
      RecordingTarget.fullScreen => runAction(
          () => _platform.presentPicker(
            autoStartRecording: false,
            selectionMode: PickerSelectionMode.display,
          ),
        ),
      RecordingTarget.area => runAction(
          () => _platform.presentAreaSelection(autoStartRecording: false),
        ),
    };
  }

  Future<RecorderSnapshot?> applyAudioSettings({
    required bool captureSystemAudio,
    required bool captureMicrophone,
  }) => runAction(
    () => _platform.updateSettings(<String, dynamic>{
      'captureSystemAudio': captureSystemAudio,
      'captureMicrophone': captureMicrophone,
    }),
  );

  Future<RecorderSnapshot?> clearSelection() =>
      runAction(_platform.clearSelection);

  Future<RecorderSnapshot?> startRecording(
    Map<String, dynamic> settings,
    String successMessage,
  ) => runAction(
    () => _platform.startRecording(settings),
    successMessage: successMessage,
  );

  Future<RecorderSnapshot?> stopRecording(String successMessage) =>
      runAction(_platform.stopRecording, successMessage: successMessage);

  Future<RecorderSnapshot?> pauseRecording() =>
      runAction(_platform.pauseRecording);

  Future<RecorderSnapshot?> resumeRecording() =>
      runAction(_platform.resumeRecording);

  Future<RecorderSnapshot?> updateSettings(Map<String, dynamic> changes) =>
      runAction(() => _platform.updateSettings(changes));

  Future<RecorderSnapshot?> chooseOutputDirectory() =>
      runAction(_platform.chooseOutputDirectory);

  Future<RecorderSnapshot?> openOutputFolder() =>
      runAction(_platform.openOutputFolder);

  Future<RecorderSnapshot?> revealRecording(String path) =>
      runAction(() => _platform.revealRecording(path));

  void dismissError() {
    _actionError = null;
    notifyListeners();
  }

  void _notifyNewPath(String? path) {
    if (path != null && path.isNotEmpty) onNewRecordingPath?.call(path);
  }
}
