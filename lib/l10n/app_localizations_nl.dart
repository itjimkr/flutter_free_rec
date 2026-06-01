// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => 'Vernieuwen';

  @override
  String get checkedAccess => 'Toegang gecontroleerd.';

  @override
  String turnOnRecInSettings(Object label) {
    return 'Schakel Rec in bij de instellingen van $label, ga daarna terug naar de app en tik op Opnieuw controleren.';
  }

  @override
  String get finishAccessSetup => 'Toegangsinstelling afronden';

  @override
  String get screenSettings => 'Scherminstellingen';

  @override
  String get microphoneSettings => 'Microfooninstellingen';

  @override
  String get checkAgain => 'Opnieuw controleren';

  @override
  String get recordingStarted => 'Opname gestart.';

  @override
  String get recordingStopped => 'Opname gestopt.';

  @override
  String get guideSummaryNeedsPermission =>
      'Rec heeft nog toestemming nodig voordat de opname kan starten.';

  @override
  String get guideSummaryReadyForContent =>
      'De toestemmingen zijn in orde. Kies nu wat je wilt opnemen.';

  @override
  String get guideStepAllowScreen =>
      'Tik op Toegang toestaan en sta daarna schermopname toe in de systeemmelding.';

  @override
  String get guideStepScreenSettings =>
      'Tik op Scherminstellingen en schakel schermopname-toegang in voor Rec.';

  @override
  String get guideStepAllowMic =>
      'Als je Scherm + Microfoon gebruikt, tik dan op Toestaan wanneer het systeem om microfoontoegang vraagt.';

  @override
  String get guideStepMicSettings =>
      'Tik op Microfooninstellingen en schakel microfoontoegang in voor Rec.';

  @override
  String get guideStepPickContent =>
      'Tik op Inhoud kiezen en selecteer het scherm of venster dat je wilt opnemen.';

  @override
  String get guideStepCheckAgain =>
      'Ga terug naar Rec en tik op Opnieuw controleren.';

  @override
  String get recordHintTurnOnScreen =>
      'Schermopname inschakelen in Instellingen';

  @override
  String get recordHintAllowScreen => 'Sta eerst Schermopname toe';

  @override
  String get recordHintTurnOnMicrophone =>
      'Microfoon inschakelen in Instellingen';

  @override
  String get recordHintAllowMicrophone => 'Sta eerst de microfoon toe';

  @override
  String get recordHintPickContent => 'Kies inhoud om op te nemen';

  @override
  String get tapToRecord => 'Tik om op te nemen';

  @override
  String get tapToStop => 'Tik om te stoppen';

  @override
  String get recordAction => 'Opname starten';

  @override
  String get stopAction => 'Opname stoppen';

  @override
  String get selectRecordTarget => 'Kies wat je wilt opnemen';

  @override
  String get specificProgramRecord => 'Specifiek programma opnemen';

  @override
  String get fullScreenRecord => 'Heel scherm opnemen';

  @override
  String get specificAreaRecord => 'Specifiek gebied opnemen';

  @override
  String get selectAudioOption => 'Kies of je audio wilt opnemen';

  @override
  String get audioIncluded => 'Met audio opnemen';

  @override
  String get audioExcluded => 'Zonder audio opnemen';

  @override
  String get shortcuts => 'Sneltoetsen';

  @override
  String get notReady => 'Niet klaar';

  @override
  String get idleState => 'INACTIEF';

  @override
  String get recordingState => 'OPNEMEN';

  @override
  String get stoppingState => 'STOPPEN';

  @override
  String get screenOnly => 'Alleen scherm';

  @override
  String get screenOnlySublabel => 'Systeemaudio';

  @override
  String get screenAndMic => 'Scherm + Microfoon';

  @override
  String get screenAndMicSublabel => 'Microfoon opnemen';

  @override
  String get setup => 'INSTELLING';

  @override
  String get screen => 'Scherm';

  @override
  String get microphone => 'Microfoon';

  @override
  String get ready => 'Klaar';

  @override
  String get openSettings => 'Instellingen openen';

  @override
  String get needsAllow => 'Toestemming nodig';

  @override
  String get optional => 'Optioneel';

  @override
  String get screenPermissionDetailReady => 'Schermopname is klaar.';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Android vraagt wat je wilt opnemen wanneer je de opname start.';

  @override
  String get screenPermissionDetailDenied =>
      'Schakel schermopname-toegang voor Rec in bij Instellingen.';

  @override
  String get screenPermissionDetailUnknown =>
      'Het systeem vraagt het de eerste keer.';

  @override
  String get microphonePermissionDetailReady =>
      'Microfoonopname is ingeschakeld.';

  @override
  String get microphonePermissionDetailDenied =>
      'Schakel microfoontoegang voor Rec in bij Instellingen.';

  @override
  String get microphonePermissionDetailUnknown =>
      'Het systeem vraagt om toestemming als je Scherm + Microfoon gebruikt.';

  @override
  String get microphonePermissionDetailOptional =>
      'Alleen nodig voor Scherm + Microfoon.';

  @override
  String get beforeYouRecord => 'Voordat je opneemt';

  @override
  String get allowAccess => 'Toegang toestaan';

  @override
  String get pickContent => 'Inhoud kiezen';

  @override
  String get contentSelected => 'Inhoud geselecteerd';

  @override
  String get noContentSelected => 'Geen inhoud geselecteerd';

  @override
  String get clear => 'Wissen';

  @override
  String get change => 'Wijzigen';

  @override
  String get openInFinder => 'Openen in Finder';

  @override
  String get openSavedFolder => 'Opnamemap openen';

  @override
  String get video => 'Video';

  @override
  String get frameRate => 'Framesnelheid';

  @override
  String get native => 'Standaard';

  @override
  String get codec => 'Codec';

  @override
  String get container => 'Container';

  @override
  String get quality => 'Kwaliteit';

  @override
  String get qualityLow => 'Laag';

  @override
  String get qualityMedium => 'Gemiddeld';

  @override
  String get qualityHigh => 'Hoog';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'Alfakanaal';

  @override
  String get nativeResolution => 'Native resolutie';

  @override
  String get audio => 'Audio';

  @override
  String get systemAudio => 'Systeemaudio';

  @override
  String get micDevice => 'Microfoonapparaat';

  @override
  String get systemDefault => 'Systeemstandaard';

  @override
  String get unknownDevice => 'Onbekend apparaat';

  @override
  String get display => 'Scherm';

  @override
  String get showCursor => 'Cursor tonen';

  @override
  String get showWallpaper => 'Achtergrond tonen';

  @override
  String get showMenuBar => 'Menubalk tonen';

  @override
  String get showDock => 'Dock tonen';

  @override
  String get showRecorderUi => 'Recorder-UI tonen';

  @override
  String get windowShadows => 'Vensterschaduwen';

  @override
  String get presenterOverlay => 'Presentator-overlay';

  @override
  String get enableOverlay => 'Overlay inschakelen';

  @override
  String get camera => 'Camera';

  @override
  String get capabilities => 'MOGELIJKHEDEN';

  @override
  String get capabilityContentPicker => 'Inhoudskieser';

  @override
  String get capabilityAreaSelection => 'Gebiedsselectie';

  @override
  String get capabilityPresenterOverlay => 'Presentator-overlay';

  @override
  String get capabilitySystemAudio => 'Systeemaudio';

  @override
  String get capabilityMicrophone => 'Microfoon';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'Alpha';

  @override
  String get capabilityWindowFiltering => 'Vensterfiltering';

  @override
  String get settings => 'Instellingen';

  @override
  String get general => 'Algemeen';

  @override
  String get language => 'Taal';

  @override
  String get autoRefresh => 'Automatisch verversen';

  @override
  String get refreshInterval => 'Verversinterval';

  @override
  String get recordingDefaults => 'Standaard opname-instellingen';

  @override
  String get accessAndStorage => 'Toegang en opslag';

  @override
  String get advancedControls => 'Geavanceerde bediening';

  @override
  String get pausedState => 'GEPAUZEERD';

  @override
  String get pauseAction => 'Pauzeren';

  @override
  String get resumeAction => 'Hervatten';

  @override
  String get countdown => 'Aftellen';

  @override
  String get countdownState => 'Start over';

  @override
  String get recentRecordings => 'Recente opnames';

  @override
  String get audioSystemOnly => 'Alleen systeemgeluid';

  @override
  String get audioMicrophoneOnly => 'Alleen microfoon';

  @override
  String get audioSystemAndMicrophone => 'Systeemgeluid + Microfoon';
}
