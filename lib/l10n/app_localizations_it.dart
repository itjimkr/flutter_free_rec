// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get checkedAccess => 'Accesso verificato.';

  @override
  String turnOnRecInSettings(Object label) {
    return 'Attiva Rec nelle impostazioni di $label, poi torna all\'app e premi Ricontrolla.';
  }

  @override
  String get finishAccessSetup => 'Completa la configurazione dell\'accesso';

  @override
  String get screenSettings => 'Impostazioni Schermo';

  @override
  String get microphoneSettings => 'Impostazioni Microfono';

  @override
  String get checkAgain => 'Ricontrolla';

  @override
  String get recordingStarted => 'Registrazione avviata.';

  @override
  String get recordingStopped => 'Registrazione interrotta.';

  @override
  String get guideSummaryNeedsPermission =>
      'Rec ha ancora bisogno di autorizzazioni prima di iniziare la registrazione.';

  @override
  String get guideSummaryReadyForContent =>
      'Le autorizzazioni sono a posto. Ora scegli cosa vuoi registrare.';

  @override
  String get guideStepAllowScreen =>
      'Premi Consenti accesso, poi consenti la cattura dello schermo nella richiesta di sistema.';

  @override
  String get guideStepScreenSettings =>
      'Premi Impostazioni Schermo e attiva l\'accesso alla cattura schermo per Rec.';

  @override
  String get guideStepAllowMic =>
      'Se usi Schermo + Microfono, premi Consenti quando il sistema chiede l\'accesso al microfono.';

  @override
  String get guideStepMicSettings =>
      'Premi Impostazioni Microfono e attiva l\'accesso al microfono per Rec.';

  @override
  String get guideStepPickContent =>
      'Premi Scegli contenuto e seleziona lo schermo o la finestra da registrare.';

  @override
  String get guideStepCheckAgain => 'Torna a Rec e premi Ricontrolla.';

  @override
  String get recordHintTurnOnScreen =>
      'Attiva Registrazione schermo nelle Impostazioni';

  @override
  String get recordHintAllowScreen => 'Consenti prima la Registrazione schermo';

  @override
  String get recordHintTurnOnMicrophone =>
      'Attiva il Microfono nelle Impostazioni';

  @override
  String get recordHintAllowMicrophone => 'Consenti prima il Microfono';

  @override
  String get recordHintPickContent => 'Scegli il contenuto da registrare';

  @override
  String get tapToRecord => 'Tocca per registrare';

  @override
  String get tapToStop => 'Tocca per fermare';

  @override
  String get recordAction => 'Avvia registrazione';

  @override
  String get stopAction => 'Ferma registrazione';

  @override
  String get selectRecordTarget => 'Scegli cosa registrare';

  @override
  String get specificProgramRecord => 'Registra un\'app specifica';

  @override
  String get fullScreenRecord => 'Registra lo schermo intero';

  @override
  String get specificAreaRecord => 'Registra un\'area specifica';

  @override
  String get selectAudioOption => 'Scegli se includere l\'audio';

  @override
  String get audioIncluded => 'Registra con audio';

  @override
  String get audioExcluded => 'Registra senza audio';

  @override
  String get shortcuts => 'Scorciatoie';

  @override
  String get notReady => 'Non pronto';

  @override
  String get idleState => 'INATTIVO';

  @override
  String get recordingState => 'REGISTRAZIONE';

  @override
  String get stoppingState => 'ARRESTO';

  @override
  String get screenOnly => 'Solo Schermo';

  @override
  String get screenOnlySublabel => 'Audio di sistema';

  @override
  String get screenAndMic => 'Schermo + Microfono';

  @override
  String get screenAndMicSublabel => 'Includi microfono';

  @override
  String get setup => 'CONFIGURAZIONE';

  @override
  String get screen => 'Schermo';

  @override
  String get microphone => 'Microfono';

  @override
  String get ready => 'Pronto';

  @override
  String get openSettings => 'Apri Impostazioni';

  @override
  String get needsAllow => 'Serve consenso';

  @override
  String get optional => 'Opzionale';

  @override
  String get screenPermissionDetailReady => 'La cattura schermo è pronta.';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Android chiederà cosa registrare quando inizi la registrazione.';

  @override
  String get screenPermissionDetailDenied =>
      'Attiva l\'accesso alla cattura schermo per Rec nelle Impostazioni.';

  @override
  String get screenPermissionDetailUnknown =>
      'Il sistema lo chiederà al primo avvio.';

  @override
  String get microphonePermissionDetailReady =>
      'La cattura del microfono è attiva.';

  @override
  String get microphonePermissionDetailDenied =>
      'Attiva l\'accesso al microfono per Rec nelle Impostazioni.';

  @override
  String get microphonePermissionDetailUnknown =>
      'Il sistema chiederà l\'autorizzazione se usi Schermo + Microfono.';

  @override
  String get microphonePermissionDetailOptional =>
      'Necessario solo per Schermo + Microfono.';

  @override
  String get beforeYouRecord => 'Prima di registrare';

  @override
  String get allowAccess => 'Consenti accesso';

  @override
  String get pickContent => 'Scegli contenuto';

  @override
  String get contentSelected => 'Contenuto selezionato';

  @override
  String get noContentSelected => 'Nessun contenuto selezionato';

  @override
  String get clear => 'Cancella';

  @override
  String get change => 'Modifica';

  @override
  String get openInFinder => 'Apri nel Finder';

  @override
  String get openSavedFolder => 'Apri cartella di salvataggio';

  @override
  String get video => 'Video';

  @override
  String get frameRate => 'Frame rate';

  @override
  String get native => 'Predefinito';

  @override
  String get codec => 'Codec';

  @override
  String get container => 'Contenitore';

  @override
  String get quality => 'Qualità';

  @override
  String get qualityLow => 'Bassa';

  @override
  String get qualityMedium => 'Media';

  @override
  String get qualityHigh => 'Alta';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'Canale alfa';

  @override
  String get nativeResolution => 'Risoluzione nativa';

  @override
  String get audio => 'Audio';

  @override
  String get systemAudio => 'Audio di sistema';

  @override
  String get micDevice => 'Dispositivo microfono';

  @override
  String get systemDefault => 'Predefinito di sistema';

  @override
  String get unknownDevice => 'Dispositivo sconosciuto';

  @override
  String get display => 'Schermo';

  @override
  String get showCursor => 'Mostra cursore';

  @override
  String get showWallpaper => 'Mostra sfondo';

  @override
  String get showMenuBar => 'Mostra barra menu';

  @override
  String get showDock => 'Mostra Dock';

  @override
  String get showRecorderUi => 'Mostra interfaccia registratore';

  @override
  String get windowShadows => 'Ombre finestra';

  @override
  String get presenterOverlay => 'Overlay presentatore';

  @override
  String get enableOverlay => 'Attiva overlay';

  @override
  String get camera => 'Fotocamera';

  @override
  String get capabilities => 'FUNZIONI';

  @override
  String get capabilityContentPicker => 'Selettore contenuto';

  @override
  String get capabilityAreaSelection => 'Selezione area';

  @override
  String get capabilityPresenterOverlay => 'Overlay presentatore';

  @override
  String get capabilitySystemAudio => 'Audio di sistema';

  @override
  String get capabilityMicrophone => 'Microfono';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'Alfa';

  @override
  String get capabilityWindowFiltering => 'Filtro finestre';

  @override
  String get settings => 'Impostazioni';

  @override
  String get general => 'Generale';

  @override
  String get language => 'Lingua';

  @override
  String get autoRefresh => 'Aggiornamento automatico';

  @override
  String get refreshInterval => 'Intervallo di aggiornamento';

  @override
  String get recordingDefaults => 'Impostazioni predefinite di registrazione';

  @override
  String get accessAndStorage => 'Accesso e archiviazione';

  @override
  String get advancedControls => 'Controlli avanzati';

  @override
  String get pausedState => 'IN PAUSA';

  @override
  String get pauseAction => 'Metti in pausa';

  @override
  String get resumeAction => 'Riprendi';

  @override
  String get countdown => 'Conto alla rovescia';

  @override
  String get countdownState => 'Inizio tra';

  @override
  String get recentRecordings => 'Registrazioni recenti';

  @override
  String get audioSystemOnly => 'Solo audio di sistema';

  @override
  String get audioMicrophoneOnly => 'Solo microfono';

  @override
  String get audioSystemAndMicrophone => 'Audio di sistema + Microfono';
}
