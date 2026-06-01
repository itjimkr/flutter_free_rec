// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => 'Odśwież';

  @override
  String get checkedAccess => 'Sprawdzono dostęp.';

  @override
  String turnOnRecInSettings(Object label) {
    return 'Włącz Rec w ustawieniach $label, a potem wróć do aplikacji i naciśnij Sprawdź ponownie.';
  }

  @override
  String get finishAccessSetup => 'Dokończ konfigurację dostępu';

  @override
  String get screenSettings => 'Ustawienia ekranu';

  @override
  String get microphoneSettings => 'Ustawienia mikrofonu';

  @override
  String get checkAgain => 'Sprawdź ponownie';

  @override
  String get recordingStarted => 'Nagrywanie rozpoczęte.';

  @override
  String get recordingStopped => 'Nagrywanie zatrzymane.';

  @override
  String get guideSummaryNeedsPermission =>
      'Rec nadal potrzebuje uprawnień, zanim będzie można rozpocząć nagrywanie.';

  @override
  String get guideSummaryReadyForContent =>
      'Uprawnienia są gotowe. Teraz wybierz, co chcesz nagrywać.';

  @override
  String get guideStepAllowScreen =>
      'Naciśnij Zezwól na dostęp, a następnie zezwól na przechwytywanie ekranu w komunikacie systemowym.';

  @override
  String get guideStepScreenSettings =>
      'Naciśnij Ustawienia ekranu i włącz dostęp do przechwytywania ekranu dla Rec.';

  @override
  String get guideStepAllowMic =>
      'Jeśli używasz Ekran + Mikrofon, naciśnij Zezwól, gdy system poprosi o dostęp do mikrofonu.';

  @override
  String get guideStepMicSettings =>
      'Naciśnij Ustawienia mikrofonu i włącz dostęp do mikrofonu dla Rec.';

  @override
  String get guideStepPickContent =>
      'Naciśnij Wybierz zawartość i wybierz ekran lub okno, które chcesz nagrywać.';

  @override
  String get guideStepCheckAgain => 'Wróć do Rec i naciśnij Sprawdź ponownie.';

  @override
  String get recordHintTurnOnScreen => 'Włącz Nagrywanie ekranu w Ustawieniach';

  @override
  String get recordHintAllowScreen => 'Najpierw zezwól na Nagrywanie ekranu';

  @override
  String get recordHintTurnOnMicrophone => 'Włącz Mikrofon w Ustawieniach';

  @override
  String get recordHintAllowMicrophone => 'Najpierw zezwól na Mikrofon';

  @override
  String get recordHintPickContent => 'Wybierz zawartość do nagrania';

  @override
  String get tapToRecord => 'Dotknij, aby nagrywać';

  @override
  String get tapToStop => 'Dotknij, aby zatrzymać';

  @override
  String get recordAction => 'Rozpocznij nagrywanie';

  @override
  String get stopAction => 'Zatrzymaj nagrywanie';

  @override
  String get selectRecordTarget => 'Wybierz, co chcesz nagrać';

  @override
  String get specificProgramRecord => 'Nagraj wybrany program';

  @override
  String get fullScreenRecord => 'Nagraj cały ekran';

  @override
  String get specificAreaRecord => 'Nagraj wybrany obszar';

  @override
  String get selectAudioOption => 'Wybierz, czy dołączyć dźwięk';

  @override
  String get audioIncluded => 'Nagraj z dźwiękiem';

  @override
  String get audioExcluded => 'Nagraj bez dźwięku';

  @override
  String get shortcuts => 'Skróty';

  @override
  String get notReady => 'Niegotowe';

  @override
  String get idleState => 'BEZCZYNNE';

  @override
  String get recordingState => 'NAGRYWANIE';

  @override
  String get stoppingState => 'ZATRZYMYWANIE';

  @override
  String get screenOnly => 'Tylko ekran';

  @override
  String get screenOnlySublabel => 'Dźwięk systemowy';

  @override
  String get screenAndMic => 'Ekran + Mikrofon';

  @override
  String get screenAndMicSublabel => 'Uwzględnij mikrofon';

  @override
  String get setup => 'KONFIGURACJA';

  @override
  String get screen => 'Ekran';

  @override
  String get microphone => 'Mikrofon';

  @override
  String get ready => 'Gotowe';

  @override
  String get openSettings => 'Otwórz Ustawienia';

  @override
  String get needsAllow => 'Wymaga zgody';

  @override
  String get optional => 'Opcjonalne';

  @override
  String get screenPermissionDetailReady =>
      'Przechwytywanie ekranu jest gotowe.';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Android zapyta, co chcesz nagrać po rozpoczęciu nagrywania.';

  @override
  String get screenPermissionDetailDenied =>
      'Włącz dostęp do przechwytywania ekranu dla Rec w Ustawieniach.';

  @override
  String get screenPermissionDetailUnknown =>
      'System zapyta przy pierwszym użyciu.';

  @override
  String get microphonePermissionDetailReady =>
      'Nagrywanie z mikrofonu jest włączone.';

  @override
  String get microphonePermissionDetailDenied =>
      'Włącz dostęp do mikrofonu dla Rec w Ustawieniach.';

  @override
  String get microphonePermissionDetailUnknown =>
      'System poprosi o zgodę, jeśli użyjesz Ekran + Mikrofon.';

  @override
  String get microphonePermissionDetailOptional =>
      'Potrzebne tylko dla Ekran + Mikrofon.';

  @override
  String get beforeYouRecord => 'Przed nagrywaniem';

  @override
  String get allowAccess => 'Zezwól na dostęp';

  @override
  String get pickContent => 'Wybierz zawartość';

  @override
  String get contentSelected => 'Zawartość wybrana';

  @override
  String get noContentSelected => 'Nie wybrano zawartości';

  @override
  String get clear => 'Wyczyść';

  @override
  String get change => 'Zmień';

  @override
  String get openInFinder => 'Otwórz w Finderze';

  @override
  String get openSavedFolder => 'Otwórz folder zapisu';

  @override
  String get video => 'Wideo';

  @override
  String get frameRate => 'Liczba klatek';

  @override
  String get native => 'Domyślne';

  @override
  String get codec => 'Kodek';

  @override
  String get container => 'Kontener';

  @override
  String get quality => 'Jakość';

  @override
  String get qualityLow => 'Niska';

  @override
  String get qualityMedium => 'Średnia';

  @override
  String get qualityHigh => 'Wysoka';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'Kanał alfa';

  @override
  String get nativeResolution => 'Rozdzielczość natywna';

  @override
  String get audio => 'Dźwięk';

  @override
  String get systemAudio => 'Dźwięk systemowy';

  @override
  String get micDevice => 'Urządzenie mikrofonu';

  @override
  String get systemDefault => 'Domyślne systemowe';

  @override
  String get unknownDevice => 'Nieznane urządzenie';

  @override
  String get display => 'Wyświetlacz';

  @override
  String get showCursor => 'Pokaż kursor';

  @override
  String get showWallpaper => 'Pokaż tapetę';

  @override
  String get showMenuBar => 'Pokaż pasek menu';

  @override
  String get showDock => 'Pokaż Dock';

  @override
  String get showRecorderUi => 'Pokaż interfejs nagrywania';

  @override
  String get windowShadows => 'Cienie okna';

  @override
  String get presenterOverlay => 'Nakładka prezentera';

  @override
  String get enableOverlay => 'Włącz nakładkę';

  @override
  String get camera => 'Kamera';

  @override
  String get capabilities => 'FUNKCJE';

  @override
  String get capabilityContentPicker => 'Wybór zawartości';

  @override
  String get capabilityAreaSelection => 'Wybór obszaru';

  @override
  String get capabilityPresenterOverlay => 'Nakładka prezentera';

  @override
  String get capabilitySystemAudio => 'Dźwięk systemowy';

  @override
  String get capabilityMicrophone => 'Mikrofon';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'Alfa';

  @override
  String get capabilityWindowFiltering => 'Filtrowanie okien';

  @override
  String get settings => 'Ustawienia';

  @override
  String get general => 'Ogólne';

  @override
  String get language => 'Język';

  @override
  String get autoRefresh => 'Automatyczne odświeżanie';

  @override
  String get refreshInterval => 'Częstotliwość odświeżania';

  @override
  String get recordingDefaults => 'Domyślne ustawienia nagrywania';

  @override
  String get accessAndStorage => 'Dostęp i pamięć';

  @override
  String get advancedControls => 'Zaawansowane sterowanie';

  @override
  String get pausedState => 'WSTRZYMANO';

  @override
  String get pauseAction => 'Wstrzymaj';

  @override
  String get resumeAction => 'Wznów';

  @override
  String get countdown => 'Odliczanie';

  @override
  String get countdownState => 'Start za';

  @override
  String get recentRecordings => 'Ostatnie nagrania';

  @override
  String get audioSystemOnly => 'Tylko dźwięk systemowy';

  @override
  String get audioMicrophoneOnly => 'Tylko mikrofon';

  @override
  String get audioSystemAndMicrophone => 'Dźwięk systemowy + Mikrofon';
}
