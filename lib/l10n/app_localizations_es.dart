// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => 'Actualizar';

  @override
  String get checkedAccess => 'Acceso verificado.';

  @override
  String turnOnRecInSettings(Object label) {
    return 'Activa Rec en la configuración de $label, luego vuelve a la app y pulsa Volver a comprobar.';
  }

  @override
  String get finishAccessSetup => 'Completar configuración de acceso';

  @override
  String get screenSettings => 'Ajustes de Pantalla';

  @override
  String get microphoneSettings => 'Ajustes de Micrófono';

  @override
  String get checkAgain => 'Volver a comprobar';

  @override
  String get recordingStarted => 'Grabación iniciada.';

  @override
  String get recordingStopped => 'Grabación detenida.';

  @override
  String get guideSummaryNeedsPermission =>
      'Rec aún necesita permisos antes de poder iniciar la grabación.';

  @override
  String get guideSummaryReadyForContent =>
      'Los permisos están listos. Ahora elige lo que quieres grabar.';

  @override
  String get guideStepAllowScreen =>
      'Pulsa Permitir acceso y luego permite la captura de pantalla en el aviso del sistema.';

  @override
  String get guideStepScreenSettings =>
      'Pulsa Ajustes de Pantalla y activa el acceso a la captura de pantalla para Rec.';

  @override
  String get guideStepAllowMic =>
      'Si usas Pantalla + Micrófono, pulsa Permitir cuando el sistema pida acceso al micrófono.';

  @override
  String get guideStepMicSettings =>
      'Pulsa Ajustes de Micrófono y activa el acceso al micrófono para Rec.';

  @override
  String get guideStepPickContent =>
      'Pulsa Elegir contenido y selecciona la pantalla o ventana que quieres grabar.';

  @override
  String get guideStepCheckAgain => 'Vuelve a Rec y pulsa Volver a comprobar.';

  @override
  String get recordHintTurnOnScreen =>
      'Activa la Grabación de pantalla en Ajustes';

  @override
  String get recordHintAllowScreen =>
      'Primero permite la Grabación de pantalla';

  @override
  String get recordHintTurnOnMicrophone => 'Activa el Micrófono en Ajustes';

  @override
  String get recordHintAllowMicrophone => 'Primero permite el Micrófono';

  @override
  String get recordHintPickContent => 'Elige el contenido que quieres grabar';

  @override
  String get tapToRecord => 'Toca para grabar';

  @override
  String get tapToStop => 'Toca para detener';

  @override
  String get recordAction => 'Iniciar grabación';

  @override
  String get stopAction => 'Detener grabación';

  @override
  String get selectRecordTarget => 'Elige qué quieres grabar';

  @override
  String get specificProgramRecord => 'Grabar una app específica';

  @override
  String get fullScreenRecord => 'Grabar toda la pantalla';

  @override
  String get specificAreaRecord => 'Grabar un área específica';

  @override
  String get selectAudioOption => 'Elige si quieres incluir audio';

  @override
  String get audioIncluded => 'Grabar con audio';

  @override
  String get audioExcluded => 'Grabar sin audio';

  @override
  String get shortcuts => 'Atajos';

  @override
  String get notReady => 'No listo';

  @override
  String get idleState => 'EN ESPERA';

  @override
  String get recordingState => 'GRABANDO';

  @override
  String get stoppingState => 'DETENIENDO';

  @override
  String get screenOnly => 'Solo Pantalla';

  @override
  String get screenOnlySublabel => 'Audio del sistema';

  @override
  String get screenAndMic => 'Pantalla + Micrófono';

  @override
  String get screenAndMicSublabel => 'Incluir micrófono';

  @override
  String get setup => 'CONFIGURACIÓN';

  @override
  String get screen => 'Pantalla';

  @override
  String get microphone => 'Micrófono';

  @override
  String get ready => 'Listo';

  @override
  String get openSettings => 'Abrir Ajustes';

  @override
  String get needsAllow => 'Necesita permiso';

  @override
  String get optional => 'Opcional';

  @override
  String get screenPermissionDetailReady =>
      'La captura de pantalla está lista.';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Android preguntará qué quieres grabar al iniciar la grabación.';

  @override
  String get screenPermissionDetailDenied =>
      'Activa el acceso a la captura de pantalla para Rec en Ajustes.';

  @override
  String get screenPermissionDetailUnknown =>
      'El sistema preguntará la primera vez.';

  @override
  String get microphonePermissionDetailReady =>
      'La captura del micrófono está activada.';

  @override
  String get microphonePermissionDetailDenied =>
      'Activa el acceso al micrófono para Rec en Ajustes.';

  @override
  String get microphonePermissionDetailUnknown =>
      'El sistema pedirá permiso si usas Pantalla + Micrófono.';

  @override
  String get microphonePermissionDetailOptional =>
      'Solo es necesario para Pantalla + Micrófono.';

  @override
  String get beforeYouRecord => 'Antes de grabar';

  @override
  String get allowAccess => 'Permitir acceso';

  @override
  String get pickContent => 'Elegir contenido';

  @override
  String get contentSelected => 'Contenido seleccionado';

  @override
  String get noContentSelected => 'No hay contenido seleccionado';

  @override
  String get clear => 'Borrar';

  @override
  String get change => 'Cambiar';

  @override
  String get openInFinder => 'Abrir en Finder';

  @override
  String get openSavedFolder => 'Abrir carpeta de guardado';

  @override
  String get video => 'Vídeo';

  @override
  String get frameRate => 'Frecuencia de fotogramas';

  @override
  String get native => 'Predeterminado';

  @override
  String get codec => 'Códec';

  @override
  String get container => 'Contenedor';

  @override
  String get quality => 'Calidad';

  @override
  String get qualityLow => 'Baja';

  @override
  String get qualityMedium => 'Media';

  @override
  String get qualityHigh => 'Alta';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'Canal alfa';

  @override
  String get nativeResolution => 'Resolución nativa';

  @override
  String get audio => 'Audio';

  @override
  String get systemAudio => 'Audio del sistema';

  @override
  String get micDevice => 'Dispositivo de micrófono';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get unknownDevice => 'Dispositivo desconocido';

  @override
  String get display => 'Pantalla';

  @override
  String get showCursor => 'Mostrar cursor';

  @override
  String get showWallpaper => 'Mostrar fondo de pantalla';

  @override
  String get showMenuBar => 'Mostrar barra de menús';

  @override
  String get showDock => 'Mostrar Dock';

  @override
  String get showRecorderUi => 'Mostrar interfaz del grabador';

  @override
  String get windowShadows => 'Sombras de ventana';

  @override
  String get presenterOverlay => 'Superposición del presentador';

  @override
  String get enableOverlay => 'Activar superposición';

  @override
  String get camera => 'Cámara';

  @override
  String get capabilities => 'CAPACIDADES';

  @override
  String get capabilityContentPicker => 'Selector de contenido';

  @override
  String get capabilityAreaSelection => 'Selección de área';

  @override
  String get capabilityPresenterOverlay => 'Superposición del presentador';

  @override
  String get capabilitySystemAudio => 'Audio del sistema';

  @override
  String get capabilityMicrophone => 'Micrófono';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'Alfa';

  @override
  String get capabilityWindowFiltering => 'Filtrado de ventanas';

  @override
  String get settings => 'Ajustes';

  @override
  String get general => 'General';

  @override
  String get language => 'Idioma';

  @override
  String get autoRefresh => 'Actualización automática';

  @override
  String get refreshInterval => 'Intervalo de actualización';

  @override
  String get recordingDefaults => 'Ajustes de grabación predeterminados';

  @override
  String get accessAndStorage => 'Acceso y almacenamiento';

  @override
  String get advancedControls => 'Controles avanzados';

  @override
  String get pausedState => 'EN PAUSA';

  @override
  String get pauseAction => 'Pausar';

  @override
  String get resumeAction => 'Reanudar';

  @override
  String get countdown => 'Cuenta regresiva';

  @override
  String get countdownState => 'Empieza en';

  @override
  String get recentRecordings => 'Grabaciones recientes';

  @override
  String get audioSystemOnly => 'Solo audio del sistema';

  @override
  String get audioMicrophoneOnly => 'Solo micrófono';

  @override
  String get audioSystemAndMicrophone => 'Audio del sistema + Micrófono';
}
