// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => 'Actualiser';

  @override
  String get checkedAccess => 'Accès vérifié.';

  @override
  String turnOnRecInSettings(Object label) {
    return 'Activez Rec dans les réglages $label, puis revenez dans l\'app et appuyez sur Vérifier à nouveau.';
  }

  @override
  String get finishAccessSetup => 'Terminer la configuration d\'accès';

  @override
  String get screenSettings => 'Réglages d\'écran';

  @override
  String get microphoneSettings => 'Réglages du microphone';

  @override
  String get checkAgain => 'Vérifier à nouveau';

  @override
  String get recordingStarted => 'Enregistrement démarré.';

  @override
  String get recordingStopped => 'Enregistrement arrêté.';

  @override
  String get guideSummaryNeedsPermission =>
      'Rec a encore besoin d\'autorisations avant de pouvoir démarrer l\'enregistrement.';

  @override
  String get guideSummaryReadyForContent =>
      'Les autorisations sont prêtes. Choisissez maintenant ce que vous voulez enregistrer.';

  @override
  String get guideStepAllowScreen =>
      'Appuyez sur Autoriser l\'accès, puis autorisez la capture d\'écran dans l\'invite système.';

  @override
  String get guideStepScreenSettings =>
      'Appuyez sur Réglages d\'écran et activez l\'accès à la capture d\'écran pour Rec.';

  @override
  String get guideStepAllowMic =>
      'Si vous utilisez Écran + Micro, appuyez sur Autoriser lorsque le système demande l\'accès au microphone.';

  @override
  String get guideStepMicSettings =>
      'Appuyez sur Réglages du microphone et activez l\'accès au microphone pour Rec.';

  @override
  String get guideStepPickContent =>
      'Appuyez sur Choisir le contenu et sélectionnez l\'écran ou la fenêtre à enregistrer.';

  @override
  String get guideStepCheckAgain =>
      'Revenez dans Rec et appuyez sur Vérifier à nouveau.';

  @override
  String get recordHintTurnOnScreen =>
      'Activez l\'enregistrement d\'écran dans Réglages';

  @override
  String get recordHintAllowScreen =>
      'Autorisez d\'abord l\'enregistrement d\'écran';

  @override
  String get recordHintTurnOnMicrophone =>
      'Activez le microphone dans Réglages';

  @override
  String get recordHintAllowMicrophone => 'Autorisez d\'abord le microphone';

  @override
  String get recordHintPickContent => 'Choisissez le contenu à enregistrer';

  @override
  String get tapToRecord => 'Touchez pour enregistrer';

  @override
  String get tapToStop => 'Touchez pour arrêter';

  @override
  String get recordAction => 'Démarrer l\'enregistrement';

  @override
  String get stopAction => 'Arrêter l\'enregistrement';

  @override
  String get selectRecordTarget => 'Choisissez ce que vous voulez enregistrer';

  @override
  String get specificProgramRecord => 'Enregistrer une application précise';

  @override
  String get fullScreenRecord => 'Enregistrer tout l’écran';

  @override
  String get specificAreaRecord => 'Enregistrer une zone précise';

  @override
  String get selectAudioOption => 'Choisissez si vous voulez inclure l\'audio';

  @override
  String get audioIncluded => 'Enregistrer avec audio';

  @override
  String get audioExcluded => 'Enregistrer sans audio';

  @override
  String get shortcuts => 'Raccourcis';

  @override
  String get notReady => 'Pas prêt';

  @override
  String get idleState => 'EN ATTENTE';

  @override
  String get recordingState => 'ENREGISTREMENT';

  @override
  String get stoppingState => 'ARRÊT';

  @override
  String get screenOnly => 'Écran seulement';

  @override
  String get screenOnlySublabel => 'Audio système';

  @override
  String get screenAndMic => 'Écran + Micro';

  @override
  String get screenAndMicSublabel => 'Inclure le microphone';

  @override
  String get setup => 'CONFIGURATION';

  @override
  String get screen => 'Écran';

  @override
  String get microphone => 'Microphone';

  @override
  String get ready => 'Prêt';

  @override
  String get openSettings => 'Ouvrir Réglages';

  @override
  String get needsAllow => 'Autorisation requise';

  @override
  String get optional => 'Optionnel';

  @override
  String get screenPermissionDetailReady => 'La capture d\'écran est prête.';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Android demandera quoi enregistrer au démarrage de l\'enregistrement.';

  @override
  String get screenPermissionDetailDenied =>
      'Activez l\'accès à la capture d\'écran pour Rec dans Réglages.';

  @override
  String get screenPermissionDetailUnknown =>
      'Le système demandera lors de la première fois.';

  @override
  String get microphonePermissionDetailReady =>
      'La capture du microphone est activée.';

  @override
  String get microphonePermissionDetailDenied =>
      'Activez l\'accès au microphone pour Rec dans Réglages.';

  @override
  String get microphonePermissionDetailUnknown =>
      'Le système demandera l\'autorisation si vous utilisez Écran + Micro.';

  @override
  String get microphonePermissionDetailOptional =>
      'Nécessaire uniquement pour Écran + Micro.';

  @override
  String get beforeYouRecord => 'Avant d\'enregistrer';

  @override
  String get allowAccess => 'Autoriser l\'accès';

  @override
  String get pickContent => 'Choisir le contenu';

  @override
  String get contentSelected => 'Contenu sélectionné';

  @override
  String get noContentSelected => 'Aucun contenu sélectionné';

  @override
  String get clear => 'Effacer';

  @override
  String get change => 'Modifier';

  @override
  String get openInFinder => 'Ouvrir dans Finder';

  @override
  String get openSavedFolder => 'Ouvrir le dossier d\'enregistrement';

  @override
  String get video => 'Vidéo';

  @override
  String get frameRate => 'Fréquence d\'images';

  @override
  String get native => 'Par défaut';

  @override
  String get codec => 'Codec';

  @override
  String get container => 'Conteneur';

  @override
  String get quality => 'Qualité';

  @override
  String get qualityLow => 'Basse';

  @override
  String get qualityMedium => 'Moyenne';

  @override
  String get qualityHigh => 'Élevée';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'Canal alpha';

  @override
  String get nativeResolution => 'Résolution native';

  @override
  String get audio => 'Audio';

  @override
  String get systemAudio => 'Audio système';

  @override
  String get micDevice => 'Périphérique micro';

  @override
  String get systemDefault => 'Valeur par défaut du système';

  @override
  String get unknownDevice => 'Périphérique inconnu';

  @override
  String get display => 'Affichage';

  @override
  String get showCursor => 'Afficher le curseur';

  @override
  String get showWallpaper => 'Afficher le fond d\'écran';

  @override
  String get showMenuBar => 'Afficher la barre de menus';

  @override
  String get showDock => 'Afficher le Dock';

  @override
  String get showRecorderUi => 'Afficher l\'interface de l\'enregistreur';

  @override
  String get windowShadows => 'Ombres des fenêtres';

  @override
  String get presenterOverlay => 'Superposition du présentateur';

  @override
  String get enableOverlay => 'Activer la superposition';

  @override
  String get camera => 'Caméra';

  @override
  String get capabilities => 'CAPACITÉS';

  @override
  String get capabilityContentPicker => 'Sélecteur de contenu';

  @override
  String get capabilityAreaSelection => 'Sélection de zone';

  @override
  String get capabilityPresenterOverlay => 'Superposition du présentateur';

  @override
  String get capabilitySystemAudio => 'Audio système';

  @override
  String get capabilityMicrophone => 'Microphone';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'Alpha';

  @override
  String get capabilityWindowFiltering => 'Filtrage des fenêtres';

  @override
  String get settings => 'Réglages';

  @override
  String get general => 'Général';

  @override
  String get language => 'Langue';

  @override
  String get autoRefresh => 'Actualisation automatique';

  @override
  String get refreshInterval => 'Intervalle d’actualisation';

  @override
  String get recordingDefaults => 'Réglages d’enregistrement par défaut';

  @override
  String get accessAndStorage => 'Accès et stockage';

  @override
  String get advancedControls => 'Contrôles avancés';

  @override
  String get pausedState => 'EN PAUSE';

  @override
  String get pauseAction => 'Mettre en pause';

  @override
  String get resumeAction => 'Reprendre';

  @override
  String get countdown => 'Compte à rebours';

  @override
  String get countdownState => 'Débute dans';

  @override
  String get recentRecordings => 'Enregistrements récents';

  @override
  String get audioSystemOnly => 'Audio système uniquement';

  @override
  String get audioMicrophoneOnly => 'Microphone uniquement';

  @override
  String get audioSystemAndMicrophone => 'Audio système + Microphone';
}
