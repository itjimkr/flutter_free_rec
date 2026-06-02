import 'package:rec/l10n/app_localizations.dart';
import 'package:rec/recorder_platform.dart';

enum RecordingTarget { application, fullScreen, area }

enum PermissionTarget { screen, microphone }

enum PreparationDialogAction {
  allowAccess,
  screenSettings,
  microphoneSettings,
  checkAgain,
}

enum RecordingAudioChoice {
  none('none', captureSystemAudio: false, captureMicrophone: false),
  systemOnly(
    'system_only',
    captureSystemAudio: true,
    captureMicrophone: false,
  ),
  microphoneOnly(
    'microphone_only',
    captureSystemAudio: false,
    captureMicrophone: true,
  ),
  systemAndMicrophone(
    'system_and_microphone',
    captureSystemAudio: true,
    captureMicrophone: true,
  );

  const RecordingAudioChoice(
    this.storageKey, {
    required this.captureSystemAudio,
    required this.captureMicrophone,
  });

  final String storageKey;
  final bool captureSystemAudio;
  final bool captureMicrophone;
}

List<RecordingAudioChoice> availableAudioChoices(RecorderSnapshot snapshot) {
  final supportsSystemAudio = snapshot.capabilities.systemAudio;
  final supportsMicrophone = snapshot.capabilities.microphone;

  return <RecordingAudioChoice>[
    if (supportsSystemAudio) RecordingAudioChoice.systemOnly,
    if (supportsMicrophone) RecordingAudioChoice.microphoneOnly,
    if (supportsSystemAudio && supportsMicrophone)
      RecordingAudioChoice.systemAndMicrophone,
    RecordingAudioChoice.none,
  ];
}

class RecordingPreparationGuide {
  const RecordingPreparationGuide({
    required this.needsScreenPermission,
    required this.screenDenied,
    required this.requestScreenPermissionInApp,
    required this.needsMicrophonePermission,
    required this.microphoneDenied,
    required this.requestMicrophonePermissionInApp,
    required this.needsContentSelection,
  });

  final bool needsScreenPermission;
  final bool screenDenied;
  final bool requestScreenPermissionInApp;
  final bool needsMicrophonePermission;
  final bool microphoneDenied;
  final bool requestMicrophonePermissionInApp;
  final bool needsContentSelection;

  bool get hasUnknownPermissions =>
      requestScreenPermissionInApp || requestMicrophonePermissionInApp;

  bool get hasPermissionAttention =>
      needsScreenPermission ||
      screenDenied ||
      needsMicrophonePermission ||
      microphoneDenied ||
      hasUnknownPermissions;

  bool get requiresSetup => hasPermissionAttention || needsContentSelection;

  String summary(AppLocalizations l10n) => hasPermissionAttention
      ? l10n.guideSummaryNeedsPermission
      : l10n.guideSummaryReadyForContent;

  List<String> steps(AppLocalizations l10n) => <String>[
    if (requestScreenPermissionInApp) l10n.guideStepAllowScreen,
    if (screenDenied) l10n.guideStepScreenSettings,
    if (requestMicrophonePermissionInApp) l10n.guideStepAllowMic,
    if (microphoneDenied) l10n.guideStepMicSettings,
    if (needsContentSelection) l10n.guideStepPickContent,
    if (hasPermissionAttention) l10n.guideStepCheckAgain,
  ];

  String recordHint(AppLocalizations l10n, RecorderSnapshot snapshot) {
    return needsScreenPermission
        ? (screenDenied
              ? l10n.recordHintTurnOnScreen
              : l10n.recordHintAllowScreen)
        : needsMicrophonePermission
        ? (microphoneDenied
              ? l10n.recordHintTurnOnMicrophone
              : l10n.recordHintAllowMicrophone)
        : needsContentSelection
        ? l10n.recordHintPickContent
        : snapshot.canStartRecording
        ? l10n.tapToRecord
        : l10n.notReady;
  }

  factory RecordingPreparationGuide.fromSnapshot(RecorderSnapshot snapshot) {
    final requestScreenPermissionInApp =
        snapshot.permissions.canAskForScreenAccessInApp;
    final screenDenied = snapshot.permissions.isScreenDenied;
    final needsScreenPermission = requestScreenPermissionInApp || screenDenied;
    final microphoneRequired = snapshot.settings.captureMicrophone;
    final requestMicrophonePermissionInApp =
        microphoneRequired && snapshot.permissions.canAskForMicrophoneAccessInApp;
    final microphoneDenied =
        microphoneRequired && snapshot.permissions.isMicrophoneDenied;
    final needsMicrophonePermission =
        microphoneRequired &&
        (microphoneDenied ||
            (snapshot.isMacRecorder && requestMicrophonePermissionInApp));
    final needsContentSelection = !snapshot.hasContentSelected;

    return RecordingPreparationGuide(
      needsScreenPermission: needsScreenPermission,
      screenDenied: screenDenied,
      requestScreenPermissionInApp: requestScreenPermissionInApp,
      needsMicrophonePermission: needsMicrophonePermission,
      microphoneDenied: microphoneDenied,
      requestMicrophonePermissionInApp: requestMicrophonePermissionInApp,
      needsContentSelection: needsContentSelection,
    );
  }
}
