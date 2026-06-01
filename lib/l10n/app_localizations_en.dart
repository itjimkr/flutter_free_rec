// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => 'Refresh';

  @override
  String get checkedAccess => 'Checked access.';

  @override
  String turnOnRecInSettings(Object label) {
    return 'Turn on Rec in $label settings, then come back and press Check Again.';
  }

  @override
  String get finishAccessSetup => 'Finish access setup';

  @override
  String get screenSettings => 'Screen Settings';

  @override
  String get microphoneSettings => 'Microphone Settings';

  @override
  String get checkAgain => 'Check Again';

  @override
  String get recordingStarted => 'Recording started.';

  @override
  String get recordingStopped => 'Recording stopped.';

  @override
  String get guideSummaryNeedsPermission =>
      'Rec still needs permission before recording can start.';

  @override
  String get guideSummaryReadyForContent =>
      'Permissions look good. Choose what you want to record next.';

  @override
  String get guideStepAllowScreen =>
      'Press Allow Access, then allow screen capture in the system prompt.';

  @override
  String get guideStepScreenSettings =>
      'Press Screen Settings and turn on screen capture access for Rec.';

  @override
  String get guideStepAllowMic =>
      'If you use Screen + Mic, press Allow when the system asks for microphone access.';

  @override
  String get guideStepMicSettings =>
      'Press Microphone Settings and turn on microphone access for Rec.';

  @override
  String get guideStepPickContent =>
      'Press Pick Content and choose the screen or window you want to record.';

  @override
  String get guideStepCheckAgain => 'Come back to Rec and press Check Again.';

  @override
  String get recordHintTurnOnScreen => 'Turn on Screen Recording in Settings';

  @override
  String get recordHintAllowScreen => 'Allow Screen Recording first';

  @override
  String get recordHintTurnOnMicrophone => 'Turn on Microphone in Settings';

  @override
  String get recordHintAllowMicrophone => 'Allow Microphone first';

  @override
  String get recordHintPickContent => 'Pick content to record';

  @override
  String get tapToRecord => 'Tap to record';

  @override
  String get tapToStop => 'Tap to stop';

  @override
  String get recordAction => 'Start Recording';

  @override
  String get stopAction => 'Stop Recording';

  @override
  String get selectRecordTarget => 'Choose what to record';

  @override
  String get specificProgramRecord => 'Record a Specific App';

  @override
  String get fullScreenRecord => 'Record Full Screen';

  @override
  String get specificAreaRecord => 'Record a Specific Area';

  @override
  String get selectAudioOption => 'Choose whether to include audio';

  @override
  String get audioIncluded => 'Record with Audio';

  @override
  String get audioExcluded => 'Record without Audio';

  @override
  String get shortcuts => 'Shortcuts';

  @override
  String get notReady => 'Not ready';

  @override
  String get idleState => 'IDLE';

  @override
  String get recordingState => 'RECORDING';

  @override
  String get stoppingState => 'STOPPING';

  @override
  String get screenOnly => 'Screen Only';

  @override
  String get screenOnlySublabel => 'System audio';

  @override
  String get screenAndMic => 'Screen + Mic';

  @override
  String get screenAndMicSublabel => 'Include microphone';

  @override
  String get setup => 'SETUP';

  @override
  String get screen => 'Screen';

  @override
  String get microphone => 'Microphone';

  @override
  String get ready => 'Ready';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get needsAllow => 'Needs Allow';

  @override
  String get optional => 'Optional';

  @override
  String get screenPermissionDetailReady => 'Screen capture is ready.';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Android will ask what to record when you start recording.';

  @override
  String get screenPermissionDetailDenied =>
      'Turn on screen capture access for Rec in Settings.';

  @override
  String get screenPermissionDetailUnknown =>
      'The system will ask the first time.';

  @override
  String get microphonePermissionDetailReady =>
      'Microphone capture is enabled.';

  @override
  String get microphonePermissionDetailDenied =>
      'Turn on microphone access for Rec in Settings.';

  @override
  String get microphonePermissionDetailUnknown =>
      'The system will ask if you use Screen + Mic.';

  @override
  String get microphonePermissionDetailOptional =>
      'Needed only for Screen + Mic.';

  @override
  String get beforeYouRecord => 'Before you record';

  @override
  String get allowAccess => 'Allow Access';

  @override
  String get pickContent => 'Pick Content';

  @override
  String get contentSelected => 'Content selected';

  @override
  String get noContentSelected => 'No content selected';

  @override
  String get clear => 'Clear';

  @override
  String get change => 'Change';

  @override
  String get openInFinder => 'Open in Finder';

  @override
  String get openSavedFolder => 'Open Saved Folder';

  @override
  String get video => 'Video';

  @override
  String get frameRate => 'Frame Rate';

  @override
  String get native => 'Native';

  @override
  String get codec => 'Codec';

  @override
  String get container => 'Container';

  @override
  String get quality => 'Quality';

  @override
  String get qualityLow => 'Low';

  @override
  String get qualityMedium => 'Medium';

  @override
  String get qualityHigh => 'High';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'Alpha Channel';

  @override
  String get nativeResolution => 'Native Resolution';

  @override
  String get audio => 'Audio';

  @override
  String get systemAudio => 'System Audio';

  @override
  String get micDevice => 'Mic Device';

  @override
  String get systemDefault => 'System Default';

  @override
  String get unknownDevice => 'Unknown device';

  @override
  String get display => 'Display';

  @override
  String get showCursor => 'Show Cursor';

  @override
  String get showWallpaper => 'Show Wallpaper';

  @override
  String get showMenuBar => 'Show Menu Bar';

  @override
  String get showDock => 'Show Dock';

  @override
  String get showRecorderUi => 'Show Recorder UI';

  @override
  String get windowShadows => 'Window Shadows';

  @override
  String get presenterOverlay => 'Presenter Overlay';

  @override
  String get enableOverlay => 'Enable Overlay';

  @override
  String get camera => 'Camera';

  @override
  String get capabilities => 'CAPABILITIES';

  @override
  String get capabilityContentPicker => 'Content Picker';

  @override
  String get capabilityAreaSelection => 'Area Selection';

  @override
  String get capabilityPresenterOverlay => 'Presenter Overlay';

  @override
  String get capabilitySystemAudio => 'System Audio';

  @override
  String get capabilityMicrophone => 'Microphone';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'Alpha';

  @override
  String get capabilityWindowFiltering => 'Window Filtering';

  @override
  String get settings => 'Settings';

  @override
  String get general => 'General';

  @override
  String get language => 'Language';

  @override
  String get autoRefresh => 'Auto Refresh';

  @override
  String get refreshInterval => 'Refresh Interval';

  @override
  String get recordingDefaults => 'Recording Defaults';

  @override
  String get accessAndStorage => 'Access & Storage';

  @override
  String get advancedControls => 'Advanced Controls';

  @override
  String get pausedState => 'PAUSED';

  @override
  String get pauseAction => 'Pause';

  @override
  String get resumeAction => 'Resume';

  @override
  String get countdown => 'Countdown';

  @override
  String get countdownState => 'STARTING IN';

  @override
  String get recentRecordings => 'Recent Recordings';

  @override
  String get audioSystemOnly => 'System Audio Only';

  @override
  String get audioMicrophoneOnly => 'Microphone Only';

  @override
  String get audioSystemAndMicrophone => 'System Audio + Microphone';
}
