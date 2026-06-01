// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get checkedAccess => 'Zugriff geprüft.';

  @override
  String turnOnRecInSettings(Object label) {
    return 'Aktiviere Rec in den $label-Einstellungen und kehre dann zur App zurück und tippe auf Erneut prüfen.';
  }

  @override
  String get finishAccessSetup => 'Zugriffseinrichtung abschließen';

  @override
  String get screenSettings => 'Bildschirm-Einstellungen';

  @override
  String get microphoneSettings => 'Mikrofon-Einstellungen';

  @override
  String get checkAgain => 'Erneut prüfen';

  @override
  String get recordingStarted => 'Aufnahme gestartet.';

  @override
  String get recordingStopped => 'Aufnahme gestoppt.';

  @override
  String get guideSummaryNeedsPermission =>
      'Rec benötigt noch Berechtigungen, bevor die Aufnahme starten kann.';

  @override
  String get guideSummaryReadyForContent =>
      'Die Berechtigungen sehen gut aus. Wähle jetzt aus, was du aufnehmen möchtest.';

  @override
  String get guideStepAllowScreen =>
      'Tippe auf Zugriff erlauben und erlaube dann die Bildschirmaufnahme in der Systemabfrage.';

  @override
  String get guideStepScreenSettings =>
      'Tippe auf Bildschirm-Einstellungen und aktiviere den Bildschirmaufnahme-Zugriff für Rec.';

  @override
  String get guideStepAllowMic =>
      'Wenn du Bildschirm + Mikrofon verwendest, tippe auf Erlauben, wenn das System nach Mikrofonzugriff fragt.';

  @override
  String get guideStepMicSettings =>
      'Tippe auf Mikrofon-Einstellungen und aktiviere den Mikrofonzugriff für Rec.';

  @override
  String get guideStepPickContent =>
      'Tippe auf Inhalt auswählen und wähle den Bildschirm oder das Fenster aus, das du aufnehmen möchtest.';

  @override
  String get guideStepCheckAgain =>
      'Kehre zu Rec zurück und tippe auf Erneut prüfen.';

  @override
  String get recordHintTurnOnScreen =>
      'Bildschirmaufnahme in den Einstellungen aktivieren';

  @override
  String get recordHintAllowScreen => 'Zuerst Bildschirmaufnahme erlauben';

  @override
  String get recordHintTurnOnMicrophone =>
      'Mikrofon in den Einstellungen aktivieren';

  @override
  String get recordHintAllowMicrophone => 'Zuerst Mikrofon erlauben';

  @override
  String get recordHintPickContent => 'Inhalt zum Aufnehmen auswählen';

  @override
  String get tapToRecord => 'Tippen zum Aufnehmen';

  @override
  String get tapToStop => 'Tippen zum Stoppen';

  @override
  String get recordAction => 'Aufnahme starten';

  @override
  String get stopAction => 'Aufnahme stoppen';

  @override
  String get selectRecordTarget => 'Wähle aus, was aufgenommen werden soll';

  @override
  String get specificProgramRecord => 'Bestimmtes Programm aufnehmen';

  @override
  String get fullScreenRecord => 'Gesamten Bildschirm aufnehmen';

  @override
  String get specificAreaRecord => 'Bestimmten Bereich aufnehmen';

  @override
  String get selectAudioOption => 'Wähle aus, ob Ton aufgenommen werden soll';

  @override
  String get audioIncluded => 'Mit Ton aufnehmen';

  @override
  String get audioExcluded => 'Ohne Ton aufnehmen';

  @override
  String get shortcuts => 'Tastenkürzel';

  @override
  String get notReady => 'Nicht bereit';

  @override
  String get idleState => 'BEREIT';

  @override
  String get recordingState => 'AUFNAHME';

  @override
  String get stoppingState => 'WIRD GESTOPPT';

  @override
  String get screenOnly => 'Nur Bildschirm';

  @override
  String get screenOnlySublabel => 'Systemaudio';

  @override
  String get screenAndMic => 'Bildschirm + Mikrofon';

  @override
  String get screenAndMicSublabel => 'Mikrofon einschließen';

  @override
  String get setup => 'EINRICHTUNG';

  @override
  String get screen => 'Bildschirm';

  @override
  String get microphone => 'Mikrofon';

  @override
  String get ready => 'Bereit';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get needsAllow => 'Erlaubnis nötig';

  @override
  String get optional => 'Optional';

  @override
  String get screenPermissionDetailReady =>
      'Die Bildschirmaufnahme ist bereit.';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Android fragt beim Starten der Aufnahme, was aufgezeichnet werden soll.';

  @override
  String get screenPermissionDetailDenied =>
      'Aktiviere den Bildschirmaufnahme-Zugriff für Rec in den Einstellungen.';

  @override
  String get screenPermissionDetailUnknown =>
      'Das System fragt beim ersten Mal nach.';

  @override
  String get microphonePermissionDetailReady =>
      'Die Mikrofonaufnahme ist aktiviert.';

  @override
  String get microphonePermissionDetailDenied =>
      'Aktiviere den Mikrofonzugriff für Rec in den Einstellungen.';

  @override
  String get microphonePermissionDetailUnknown =>
      'Das System fragt nach, wenn du Bildschirm + Mikrofon verwendest.';

  @override
  String get microphonePermissionDetailOptional =>
      'Nur für Bildschirm + Mikrofon erforderlich.';

  @override
  String get beforeYouRecord => 'Vor der Aufnahme';

  @override
  String get allowAccess => 'Zugriff erlauben';

  @override
  String get pickContent => 'Inhalt auswählen';

  @override
  String get contentSelected => 'Inhalt ausgewählt';

  @override
  String get noContentSelected => 'Kein Inhalt ausgewählt';

  @override
  String get clear => 'Löschen';

  @override
  String get change => 'Ändern';

  @override
  String get openInFinder => 'Im Finder öffnen';

  @override
  String get openSavedFolder => 'Speicherordner öffnen';

  @override
  String get video => 'Video';

  @override
  String get frameRate => 'Bildrate';

  @override
  String get native => 'Standard';

  @override
  String get codec => 'Codec';

  @override
  String get container => 'Container';

  @override
  String get quality => 'Qualität';

  @override
  String get qualityLow => 'Niedrig';

  @override
  String get qualityMedium => 'Mittel';

  @override
  String get qualityHigh => 'Hoch';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'Alphakanal';

  @override
  String get nativeResolution => 'Native Auflösung';

  @override
  String get audio => 'Audio';

  @override
  String get systemAudio => 'Systemaudio';

  @override
  String get micDevice => 'Mikrofongerät';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get unknownDevice => 'Unbekanntes Gerät';

  @override
  String get display => 'Anzeige';

  @override
  String get showCursor => 'Cursor anzeigen';

  @override
  String get showWallpaper => 'Hintergrundbild anzeigen';

  @override
  String get showMenuBar => 'Menüleiste anzeigen';

  @override
  String get showDock => 'Dock anzeigen';

  @override
  String get showRecorderUi => 'Recorder-UI anzeigen';

  @override
  String get windowShadows => 'Fensterschatten';

  @override
  String get presenterOverlay => 'Präsentator-Overlay';

  @override
  String get enableOverlay => 'Overlay aktivieren';

  @override
  String get camera => 'Kamera';

  @override
  String get capabilities => 'FUNKTIONEN';

  @override
  String get capabilityContentPicker => 'Inhaltsauswahl';

  @override
  String get capabilityAreaSelection => 'Bereichsauswahl';

  @override
  String get capabilityPresenterOverlay => 'Präsentator-Overlay';

  @override
  String get capabilitySystemAudio => 'Systemaudio';

  @override
  String get capabilityMicrophone => 'Mikrofon';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'Alpha';

  @override
  String get capabilityWindowFiltering => 'Fensterfilterung';

  @override
  String get settings => 'Einstellungen';

  @override
  String get general => 'Allgemein';

  @override
  String get language => 'Sprache';

  @override
  String get autoRefresh => 'Automatische Aktualisierung';

  @override
  String get refreshInterval => 'Aktualisierungsintervall';

  @override
  String get recordingDefaults => 'Standard-Aufnahmeeinstellungen';

  @override
  String get accessAndStorage => 'Zugriff und Speicher';

  @override
  String get advancedControls => 'Erweiterte Steuerung';

  @override
  String get pausedState => 'PAUSIERT';

  @override
  String get pauseAction => 'Pausieren';

  @override
  String get resumeAction => 'Fortsetzen';

  @override
  String get countdown => 'Countdown';

  @override
  String get countdownState => 'Startet in';

  @override
  String get recentRecordings => 'Letzte Aufnahmen';

  @override
  String get audioSystemOnly => 'Nur Systemaudio';

  @override
  String get audioMicrophoneOnly => 'Nur Mikrofon';

  @override
  String get audioSystemAndMicrophone => 'Systemaudio + Mikrofon';
}
