import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rec/domain/app_preferences.dart';
import 'package:rec/domain/recording.dart';
import 'package:rec/presentation/app_view_model.dart';
import 'package:rec/presentation/recorder_view_model.dart';
import 'package:rec/presentation/settings_page.dart';
import 'package:rec/presentation/widgets.dart';
import 'package:rec/recorder_platform.dart';

class RecorderHomePage extends StatefulWidget {
  const RecorderHomePage({
    super.key,
    required this.appVm,
    required this.recorderVm,
  });

  final AppViewModel appVm;
  final RecorderViewModel recorderVm;

  @override
  State<RecorderHomePage> createState() => _RecorderHomePageState();
}

class _RecorderHomePageState extends State<RecorderHomePage> {
  static const List<int> _frameRates = <int>[0, 24, 30, 60];
  static const List<String> _videoCodecs = <String>[
    'H.264',
    'H.265',
    'ProRes 422',
    'ProRes 4444',
  ];
  static const List<String> _containerFormats = <String>['mov', 'mp4'];
  static const List<String> _videoQualities = <String>['Low', 'Medium', 'High'];
  static const List<String> _audioCodecs = <String>['AAC', 'PCM'];

  RecorderViewModel get _vm => widget.recorderVm;
  AppViewModel get _appVm => widget.appVm;

  @override
  void initState() {
    super.initState();
    _vm.onMessage = _showMessage;
    _vm.onNewRecordingPath = _appVm.rememberRecordingPath;
    _vm.init();
    _reconfigureRefresh();
    _appVm.addListener(_onPreferencesChanged);
  }

  @override
  void didUpdateWidget(covariant RecorderHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.appVm != widget.appVm) {
      oldWidget.appVm.removeListener(_onPreferencesChanged);
      widget.appVm.addListener(_onPreferencesChanged);
      _vm.onNewRecordingPath = _appVm.rememberRecordingPath;
      _reconfigureRefresh();
    }
  }

  @override
  void dispose() {
    _appVm.removeListener(_onPreferencesChanged);
    super.dispose();
  }

  void _onPreferencesChanged() {
    _reconfigureRefresh();
  }

  void _reconfigureRefresh() {
    final prefs = _appVm.preferences;
    _vm.configureRefresh(
      enabled: prefs.autoRefreshEnabled,
      seconds: prefs.autoRefreshSeconds,
    );
  }

  // ─── Dialogs ────────────────────────────────────────────────────────────────

  Future<RecordingTarget?> _showRecordingTargetDialog() {
    final l10n = context.l10n;
    return showDialog<RecordingTarget>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          key: const ValueKey<String>('record_target_dialog'),
          title: Text(l10n.selectRecordTarget),
          children: <Widget>[
            SimpleDialogOption(
              key: const ValueKey<String>('record_target_application'),
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(RecordingTarget.application),
              child: Text(recordingTargetLabel(l10n, RecordingTarget.application)),
            ),
            SimpleDialogOption(
              key: const ValueKey<String>('record_target_full_screen'),
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(RecordingTarget.fullScreen),
              child: Text(
                recordingTargetLabel(l10n, RecordingTarget.fullScreen),
              ),
            ),
            SimpleDialogOption(
              key: const ValueKey<String>('record_target_area'),
              onPressed: () =>
                  Navigator.of(dialogContext).pop(RecordingTarget.area),
              child: Text(recordingTargetLabel(l10n, RecordingTarget.area)),
            ),
          ],
        );
      },
    );
  }

  Future<RecordingAudioChoice?> _showAudioChoiceDialog(
    RecorderSnapshot snapshot,
  ) {
    final l10n = context.l10n;
    final options = availableAudioChoices(snapshot);
    if (options.length == 1) {
      return Future<RecordingAudioChoice?>.value(options.single);
    }
    return showDialog<RecordingAudioChoice>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          key: const ValueKey<String>('audio_choice_dialog'),
          title: Text(l10n.selectAudioOption),
          children: options
              .map(
                (choice) => SimpleDialogOption(
                  key: ValueKey<String>('audio_choice_${choice.storageKey}'),
                  onPressed: () => Navigator.of(dialogContext).pop(choice),
                  child: Text(audioChoiceLabel(l10n, choice)),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }

  Future<void> _showShortcutsDialog() {
    final l10n = context.l10n;
    final material = MaterialLocalizations.of(context);
    var shortcuts = _appVm.preferences.shortcuts;

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              key: const ValueKey<String>('shortcuts_dialog'),
              title: Text(l10n.shortcuts),
              content: SizedBox(
                width: 460,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ShortcutAction.values
                      .map(
                        (action) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(shortcutActionLabel(l10n, action)),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 150,
                                child: DropdownButtonFormField<String>(
                                  key: ValueKey<String>(
                                    '${action.storageKey}_${shortcuts.keyFor(action)}',
                                  ),
                                  initialValue: shortcuts.keyFor(action),
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  items: shortcutKeyChoices
                                      .map(
                                        (choice) => DropdownMenuItem<String>(
                                          value: choice.id,
                                          child: Text(
                                            shortcutDisplayLabel(choice.id),
                                          ),
                                        ),
                                      )
                                      .toList(growable: false),
                                  onChanged: (value) {
                                    if (value == null) return;
                                    final updated =
                                        shortcuts.update(action, value);
                                    setDialogState(() => shortcuts = updated);
                                    _appVm.update(
                                      _appVm.preferences.copyWith(
                                        shortcuts: updated,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(material.okButtonLabel),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<PreparationDialogAction?> _showRecordingPreparationDialog(
    RecorderSnapshot snapshot,
  ) {
    final guide = RecordingPreparationGuide.fromSnapshot(snapshot);
    final l10n = context.l10n;
    final steps = guide.steps(l10n);

    return showDialog<PreparationDialogAction>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.beforeYouRecord),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(guide.summary(l10n)),
                const SizedBox(height: 12),
                for (var index = 0; index < steps.length; index++) ...<Widget>[
                  Text('${index + 1}. ${steps[index]}'),
                  if (index != steps.length - 1) const SizedBox(height: 8),
                ],
              ],
            ),
          ),
          actions: <Widget>[
            if (guide.hasUnknownPermissions)
              TextButton(
                key: const ValueKey<String>('permission_dialog_allow_access'),
                onPressed: () => Navigator.of(
                  dialogContext,
                ).pop(PreparationDialogAction.allowAccess),
                child: Text(l10n.allowAccess),
              ),
            if (guide.screenDenied)
              TextButton(
                key: const ValueKey<String>(
                  'permission_dialog_screen_settings',
                ),
                onPressed: () => Navigator.of(
                  dialogContext,
                ).pop(PreparationDialogAction.screenSettings),
                child: Text(l10n.screenSettings),
              ),
            if (guide.microphoneDenied)
              TextButton(
                key: const ValueKey<String>(
                  'permission_dialog_microphone_settings',
                ),
                onPressed: () => Navigator.of(
                  dialogContext,
                ).pop(PreparationDialogAction.microphoneSettings),
                child: Text(l10n.microphoneSettings),
              ),
            TextButton(
              key: const ValueKey<String>('permission_dialog_check_again'),
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(PreparationDialogAction.checkAgain),
              child: Text(l10n.checkAgain),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPermissionHelpDialog(RecorderSnapshot snapshot) {
    final guide = RecordingPreparationGuide.fromSnapshot(snapshot);
    final l10n = context.l10n;
    final steps = guide.steps(l10n);

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.finishAccessSetup),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(guide.summary(l10n)),
              const SizedBox(height: 12),
              for (var index = 0; index < steps.length; index++) ...<Widget>[
                Text('${index + 1}. ${steps[index]}'),
                if (index != steps.length - 1) const SizedBox(height: 8),
              ],
            ],
          ),
          actions: <Widget>[
            if (guide.screenDenied)
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  unawaited(_vm.openScreenRecordingSettings());
                },
                child: Text(l10n.screenSettings),
              ),
            if (guide.microphoneDenied)
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  unawaited(_vm.openMicrophoneSettings());
                },
                child: Text(l10n.microphoneSettings),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                unawaited(_vm.refresh());
              },
              child: Text(l10n.checkAgain),
            ),
          ],
        );
      },
    );
  }

  // ─── Recording flows ─────────────────────────────────────────────────────────

  Future<RecorderSnapshot?> _handlePermissionRequest() async {
    final l10n = context.l10n;
    final updated = await _vm.requestPermissions(
      successMessage: l10n.checkedAccess,
    );
    if (!mounted || updated == null) return null;

    final guide = RecordingPreparationGuide.fromSnapshot(updated);
    if (guide.hasPermissionAttention) {
      await _showPermissionHelpDialog(updated);
    }
    return updated;
  }

  Future<void> _handlePrimaryRecordAction() async {
    if (_vm.countdownValue != null) return;
    final initialSnapshot = await _vm.refresh();
    if (!mounted || initialSnapshot == null) return;

    if (initialSnapshot.hasActiveRecording) {
      await _vm.stopRecording(context.l10n.recordingStopped);
      return;
    }

    if (initialSnapshot.isSimpleMobileRecorder) {
      await _handleMobileRecordAction(initialSnapshot);
      return;
    }

    final target = await _showRecordingTargetDialog();
    if (!mounted || target == null) return;

    final audioChoice = await _showAudioChoiceDialog(initialSnapshot);
    if (!mounted || audioChoice == null) return;

    await _beginRecordingFlow(target: target, audioChoice: audioChoice);
  }

  Future<void> _handleMobileRecordAction(RecorderSnapshot snapshot) async {
    final audioChoice = await _showAudioChoiceDialog(snapshot);
    if (!mounted || audioChoice == null) return;
    await _beginMobileRecordingFlow(audioChoice: audioChoice);
  }

  Future<void> _handleShortcutRecording(RecordingTarget target) async {
    if (_vm.countdownValue != null) return;
    final snapshot = await _vm.refresh();
    if (!mounted || snapshot == null) return;
    if (snapshot.hasActiveRecording) return;

    final audioChoice = await _showAudioChoiceDialog(snapshot);
    if (!mounted || audioChoice == null) return;

    await _beginRecordingFlow(target: target, audioChoice: audioChoice);
  }

  Future<void> _handleStopShortcut() async {
    if (_vm.countdownValue != null) return;
    final snapshot = await _vm.refresh();
    if (!mounted || snapshot == null || !snapshot.hasActiveRecording) return;
    await _vm.stopRecording(context.l10n.recordingStopped);
  }

  Future<void> _handlePauseOrResumeAction() async {
    if (_vm.countdownValue != null) return;
    final snapshot = await _vm.refresh();
    if (!mounted ||
        snapshot == null ||
        !snapshot.hasActiveRecording ||
        !snapshot.capabilities.pauseResume) {
      return;
    }

    if (snapshot.isPaused) {
      await _vm.resumeRecording();
    } else {
      await _vm.pauseRecording();
    }
  }

  Future<void> _beginRecordingFlow({
    required RecordingTarget target,
    required RecordingAudioChoice audioChoice,
  }) async {
    final l10n = context.l10n;
    final initial = await _vm.refresh();
    if (!mounted || initial == null) return;
    RecorderSnapshot snapshot = initial;

    if (snapshot.hasContentSelected) {
      final cleared = await _vm.clearSelection();
      if (!mounted || cleared == null) return;
      snapshot = cleared;
    }

    final captureSystemAudio = audioChoice.captureSystemAudio;
    final captureMicrophone = audioChoice.captureMicrophone;
    if (snapshot.settings.captureSystemAudio != captureSystemAudio ||
        snapshot.settings.captureMicrophone != captureMicrophone) {
      final updated = await _vm.applyAudioSettings(
        captureSystemAudio: captureSystemAudio,
        captureMicrophone: captureMicrophone,
      );
      if (!mounted || updated == null) return;
      snapshot = updated;
    }

    while (mounted) {
      final guide = RecordingPreparationGuide.fromSnapshot(snapshot);
      if (!guide.hasPermissionAttention) break;

      final action = await _showRecordingPreparationDialog(snapshot);
      if (!mounted || action == null) return;

      switch (action) {
        case PreparationDialogAction.allowAccess:
          final updated = await _vm.requestPermissions();
          if (!mounted || updated == null) return;
          snapshot = updated;
        case PreparationDialogAction.screenSettings:
          await _vm.openScreenRecordingSettings();
          return;
        case PreparationDialogAction.microphoneSettings:
          await _vm.openMicrophoneSettings();
          return;
        case PreparationDialogAction.checkAgain:
          final updated = await _vm.refresh();
          if (!mounted || updated == null) return;
          _showMessage(l10n.checkedAccess);
          snapshot = updated;
      }
    }

    final selectedRaw = await _vm.selectTarget(target);
    if (!mounted || selectedRaw == null) return;
    final selected = selectedRaw;

    if (selected.isRecording) return;

    if (selected.canStartRecording) {
      await _startRecordingWithCountdown(selected);
      return;
    }

    if (!selected.hasContentSelected) return;

    _showMessage(
      RecordingPreparationGuide.fromSnapshot(selected).recordHint(l10n, selected),
    );
  }

  Future<void> _beginMobileRecordingFlow({
    required RecordingAudioChoice audioChoice,
  }) async {
    final l10n = context.l10n;
    final initial = await _vm.refresh();
    if (!mounted || initial == null) return;
    RecorderSnapshot snapshot = initial;

    final captureSystemAudio = audioChoice.captureSystemAudio;
    final captureMicrophone = audioChoice.captureMicrophone;
    if (snapshot.settings.captureSystemAudio != captureSystemAudio ||
        snapshot.settings.captureMicrophone != captureMicrophone) {
      final updated = await _vm.applyAudioSettings(
        captureSystemAudio: captureSystemAudio,
        captureMicrophone: captureMicrophone,
      );
      if (!mounted || updated == null) return;
      snapshot = updated;
    }

    while (mounted) {
      final guide = RecordingPreparationGuide.fromSnapshot(snapshot);
      if (!guide.hasPermissionAttention) break;

      final action = await _showRecordingPreparationDialog(snapshot);
      if (!mounted || action == null) return;

      switch (action) {
        case PreparationDialogAction.allowAccess:
          final updated = await _vm.requestPermissions();
          if (!mounted || updated == null) return;
          snapshot = updated;
        case PreparationDialogAction.screenSettings:
          await _vm.openScreenRecordingSettings();
          return;
        case PreparationDialogAction.microphoneSettings:
          await _vm.openMicrophoneSettings();
          return;
        case PreparationDialogAction.checkAgain:
          final updated = await _vm.refresh();
          if (!mounted || updated == null) return;
          _showMessage(l10n.checkedAccess);
          snapshot = updated;
      }
    }

    await _startRecordingWithCountdown(snapshot);
  }

  Future<void> _startRecordingWithCountdown(RecorderSnapshot snapshot) async {
    final ready = await _vm.runCountdown(_appVm.preferences.countdownSeconds);
    if (!mounted || !ready) return;
    await _vm.startRecording(
      snapshot.settings.toMap(),
      context.l10n.recordingStarted,
    );
  }

  Future<void> _openSettingsPage() async {
    final snapshot = _vm.snapshot;
    if (snapshot == null) return;

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => SettingsPage(
          appVm: _appVm,
          recorderVm: _vm,
          frameRates: _frameRates,
          videoCodecs: _videoCodecs,
          containerFormats: _containerFormats,
          videoQualities: _videoQualities,
          audioCodecs: _audioCodecs,
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_appVm, _vm]),
      builder: (context, _) {
        final snapshot = _vm.snapshot;
        final prefs = _appVm.preferences;
        final shortcuts = prefs.shortcuts;
        final bindings = <ShortcutActivator, VoidCallback>{};

        void bindShortcut(String keyId, VoidCallback callback) {
          final keyChoice = shortcutKeyChoiceForId(keyId);
          if (keyChoice == null) return;
          bindings[SingleActivator(keyChoice.key, meta: true)] = callback;
          bindings[SingleActivator(keyChoice.key, control: true)] = callback;
        }

        if (snapshot?.isMacRecorder ?? false) {
          bindShortcut(
            shortcuts.recordApplicationKey,
            () => unawaited(
              _handleShortcutRecording(RecordingTarget.application),
            ),
          );
          bindShortcut(
            shortcuts.recordFullScreenKey,
            () => unawaited(
              _handleShortcutRecording(RecordingTarget.fullScreen),
            ),
          );
          bindShortcut(
            shortcuts.recordAreaKey,
            () => unawaited(
              _handleShortcutRecording(RecordingTarget.area),
            ),
          );
          if (snapshot?.capabilities.pauseResume ?? false) {
            bindShortcut(shortcuts.pauseResumeKey, () {
              unawaited(_handlePauseOrResumeAction());
            });
          }
          bindShortcut(shortcuts.stopKey, () {
            unawaited(_handleStopShortcut());
          });
          bindShortcut(shortcuts.openSettingsKey, _openSettingsPage);
          bindShortcut(shortcuts.openSavedFolderKey, () {
            unawaited(_vm.openOutputFolder());
          });
        }

        return CallbackShortcuts(
          bindings: bindings,
          child: Focus(
            autofocus: true,
            child: Scaffold(
              body: _vm.loading
                  ? const Center(child: CircularProgressIndicator())
                  : SafeArea(
                      child: snapshot == null
                          ? const SizedBox.shrink()
                          : Stack(
                              children: <Widget>[
                                _buildMinimalHome(snapshot, prefs),
                                _buildHiddenLegacyPanels(snapshot),
                              ],
                            ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMinimalHome(RecorderSnapshot snapshot, AppPreferences prefs) {
    if (snapshot.isSimpleMobileRecorder) {
      return _buildMinimalMobileHome(snapshot);
    }
    return _buildMinimalDesktopHome(snapshot, prefs);
  }

  Widget _buildMinimalDesktopHome(
    RecorderSnapshot snapshot,
    AppPreferences prefs,
  ) {
    final l10n = context.l10n;
    final isRecording = snapshot.hasActiveRecording;
    final isPaused = snapshot.isPaused;
    final isStopping = snapshot.state == 'stopping';
    final controlsLocked = isStopping || _vm.countdownValue != null;
    final primaryLabel = switch (snapshot.state) {
      'stopping' => l10n.stoppingState,
      _ when isRecording => l10n.stopAction,
      _ => l10n.recordAction,
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MinimalRecordingStatus(
                snapshot: snapshot,
                countdownValue: _vm.countdownValue,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 72,
                child: ElevatedButton.icon(
                  key: ValueKey<String>(
                    isRecording ? 'primary_stop' : 'primary_record',
                  ),
                  onPressed: controlsLocked ? null : _handlePrimaryRecordAction,
                  icon: Icon(
                    isRecording
                        ? Icons.stop_circle_outlined
                        : Icons.fiber_manual_record,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRecording
                        ? const Color(0xFFB71C1C)
                        : const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  label: Text(primaryLabel),
                ),
              ),
              if (snapshot.capabilities.pauseResume && isRecording) ...<Widget>[
                const SizedBox(height: 12),
                SizedBox(
                  height: 56,
                  child: OutlinedButton.icon(
                    key: const ValueKey<String>('pause_resume_button'),
                    onPressed:
                        controlsLocked ? null : _handlePauseOrResumeAction,
                    icon: Icon(
                      isPaused
                          ? Icons.play_arrow_outlined
                          : Icons.pause_circle_outline,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1C1C1E),
                      side: const BorderSide(color: Color(0xFFD1D1D6)),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    label: Text(
                      isPaused ? l10n.resumeAction : l10n.pauseAction,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              SizedBox(
                height: 60,
                child: OutlinedButton.icon(
                  key: const ValueKey<String>('open_output_folder'),
                  onPressed: controlsLocked
                      ? null
                      : () => unawaited(_vm.openOutputFolder()),
                  icon: const Icon(Icons.folder_open_outlined),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1C1C1E),
                    side: const BorderSide(color: Color(0xFFD1D1D6)),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  label: Text(l10n.openSavedFolder),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        key: const ValueKey<String>('open_app_settings'),
                        onPressed: controlsLocked ? null : _openSettingsPage,
                        icon: const Icon(Icons.tune_outlined),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1C1C1E),
                          side: const BorderSide(color: Color(0xFFD1D1D6)),
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        label: Text(l10n.settings),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        key: const ValueKey<String>('open_shortcuts'),
                        onPressed:
                            controlsLocked ? null : _showShortcutsDialog,
                        icon: const Icon(Icons.keyboard_command_key_outlined),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1C1C1E),
                          side: const BorderSide(color: Color(0xFFD1D1D6)),
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        label: Text(l10n.shortcuts),
                      ),
                    ),
                  ),
                ],
              ),
              if (snapshot.isMacRecorder &&
                  prefs.recentRecordingPaths.isNotEmpty) ...<Widget>[
                const SizedBox(height: 18),
                RecentRecordingsCard(
                  title: l10n.recentRecordings,
                  paths: prefs.recentRecordingPaths,
                  onOpen: (path) => unawaited(_vm.revealRecording(path)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalMobileHome(RecorderSnapshot snapshot) {
    final isRecording = snapshot.hasActiveRecording;
    final isStopping = snapshot.state == 'stopping';
    final controlsLocked = isStopping || _vm.countdownValue != null;
    final primaryLabel = switch (snapshot.state) {
      'stopping' => context.l10n.stoppingState,
      _ when isRecording => context.l10n.stopAction,
      _ => context.l10n.recordAction,
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MinimalRecordingStatus(
                snapshot: snapshot,
                countdownValue: _vm.countdownValue,
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 72,
                child: ElevatedButton.icon(
                  key: ValueKey<String>(
                    isRecording ? 'primary_stop' : 'primary_record',
                  ),
                  onPressed: controlsLocked ? null : _handlePrimaryRecordAction,
                  icon: Icon(
                    isRecording
                        ? Icons.stop_circle_outlined
                        : Icons.fiber_manual_record,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRecording
                        ? const Color(0xFFB71C1C)
                        : const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  label: Text(primaryLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHiddenLegacyPanels(RecorderSnapshot snapshot) {
    return Offstage(
      offstage: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PlatformBadge(platform: snapshot.platform),
          if (snapshot.note.isNotEmpty) NoteBanner(note: snapshot.note),
          if (_vm.actionError != null)
            ErrorBanner(
              message: _vm.actionError!,
              onDismiss: _vm.dismissError,
            ),
          RecordingCard(
            snapshot: snapshot,
            onRequestPermissions: () =>
                unawaited(_handlePermissionRequest()),
            onOpenScreenRecordingSettings: () =>
                unawaited(_vm.openScreenRecordingSettings()),
            onOpenMicrophoneSettings: () =>
                unawaited(_vm.openMicrophoneSettings()),
            onCheckPermissions: () => unawaited(_vm.refresh()),
            onPickContent: snapshot.capabilities.contentPicker
                ? () => unawaited(_vm.presentPicker())
                : null,
            onClearSelection: snapshot.capabilities.contentPicker
                ? () => unawaited(_vm.clearSelection())
                : null,
            onStart: snapshot.canStartRecording
                ? () => unawaited(
                    _vm.startRecording(
                      snapshot.settings.toMap(),
                      context.l10n.recordingStarted,
                    ),
                  )
                : null,
            onStop: snapshot.isRecording
                ? () => unawaited(
                    _vm.stopRecording(context.l10n.recordingStopped),
                  )
                : null,
            onChooseOutputDirectory: snapshot.isMacRecorder
                ? () => unawaited(_vm.chooseOutputDirectory())
                : null,
            onOpenOutputFolder: snapshot.isMacRecorder
                ? () => unawaited(_vm.openOutputFolder())
                : null,
            onUpdateSetting: (changes) =>
                unawaited(_vm.updateSettings(changes)),
          ),
          SettingsAccordion(
            snapshot: snapshot,
            frameRates: _frameRates,
            videoCodecs: _videoCodecs,
            containerFormats: _containerFormats,
            videoQualities: _videoQualities,
            audioCodecs: _audioCodecs,
            onUpdateSetting: (changes) =>
                unawaited(_vm.updateSettings(changes)),
          ),
          CapabilityRow(capabilities: snapshot.capabilities),
        ],
      ),
    );
  }
}
