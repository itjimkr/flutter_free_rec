// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => 'Обновить';

  @override
  String get checkedAccess => 'Доступ проверен.';

  @override
  String turnOnRecInSettings(Object label) {
    return 'Включите Rec в настройках $label, затем вернитесь в приложение и нажмите Проверить снова.';
  }

  @override
  String get finishAccessSetup => 'Завершить настройку доступа';

  @override
  String get screenSettings => 'Настройки экрана';

  @override
  String get microphoneSettings => 'Настройки микрофона';

  @override
  String get checkAgain => 'Проверить снова';

  @override
  String get recordingStarted => 'Запись началась.';

  @override
  String get recordingStopped => 'Запись остановлена.';

  @override
  String get guideSummaryNeedsPermission =>
      'Rec всё ещё нужны разрешения, прежде чем можно будет начать запись.';

  @override
  String get guideSummaryReadyForContent =>
      'С разрешениями всё в порядке. Теперь выберите, что вы хотите записывать.';

  @override
  String get guideStepAllowScreen =>
      'Нажмите Разрешить доступ, затем разрешите захват экрана в системном запросе.';

  @override
  String get guideStepScreenSettings =>
      'Нажмите Настройки экрана и включите доступ к захвату экрана для Rec.';

  @override
  String get guideStepAllowMic =>
      'Если вы используете Экран + Микрофон, нажмите Разрешить, когда система запросит доступ к микрофону.';

  @override
  String get guideStepMicSettings =>
      'Нажмите Настройки микрофона и включите доступ к микрофону для Rec.';

  @override
  String get guideStepPickContent =>
      'Нажмите Выбрать контент и выберите экран или окно, которое хотите записывать.';

  @override
  String get guideStepCheckAgain =>
      'Вернитесь в Rec и нажмите Проверить снова.';

  @override
  String get recordHintTurnOnScreen => 'Включите Запись экрана в Настройках';

  @override
  String get recordHintAllowScreen => 'Сначала разрешите Запись экрана';

  @override
  String get recordHintTurnOnMicrophone => 'Включите Микрофон в Настройках';

  @override
  String get recordHintAllowMicrophone =>
      'Сначала разрешите доступ к микрофону';

  @override
  String get recordHintPickContent => 'Выберите контент для записи';

  @override
  String get tapToRecord => 'Нажмите, чтобы начать запись';

  @override
  String get tapToStop => 'Нажмите, чтобы остановить запись';

  @override
  String get recordAction => 'Начать запись';

  @override
  String get stopAction => 'Остановить запись';

  @override
  String get selectRecordTarget => 'Выберите, что записывать';

  @override
  String get specificProgramRecord => 'Записать отдельную программу';

  @override
  String get fullScreenRecord => 'Записать весь экран';

  @override
  String get specificAreaRecord => 'Записать выбранную область';

  @override
  String get selectAudioOption => 'Выберите, нужно ли записывать звук';

  @override
  String get audioIncluded => 'Записать со звуком';

  @override
  String get audioExcluded => 'Записать без звука';

  @override
  String get shortcuts => 'Сочетания клавиш';

  @override
  String get notReady => 'Не готово';

  @override
  String get idleState => 'ОЖИДАНИЕ';

  @override
  String get recordingState => 'ЗАПИСЬ';

  @override
  String get stoppingState => 'ОСТАНОВКА';

  @override
  String get screenOnly => 'Только экран';

  @override
  String get screenOnlySublabel => 'Системный звук';

  @override
  String get screenAndMic => 'Экран + Микрофон';

  @override
  String get screenAndMicSublabel => 'Включить микрофон';

  @override
  String get setup => 'НАСТРОЙКА';

  @override
  String get screen => 'Экран';

  @override
  String get microphone => 'Микрофон';

  @override
  String get ready => 'Готово';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get needsAllow => 'Нужно разрешение';

  @override
  String get optional => 'Необязательно';

  @override
  String get screenPermissionDetailReady => 'Захват экрана готов.';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Android спросит, что вы хотите записывать, когда вы начнёте запись.';

  @override
  String get screenPermissionDetailDenied =>
      'Включите доступ к захвату экрана для Rec в Настройках.';

  @override
  String get screenPermissionDetailUnknown =>
      'Система спросит при первом использовании.';

  @override
  String get microphonePermissionDetailReady => 'Захват микрофона включён.';

  @override
  String get microphonePermissionDetailDenied =>
      'Включите доступ к микрофону для Rec в Настройках.';

  @override
  String get microphonePermissionDetailUnknown =>
      'Система запросит разрешение, если вы используете Экран + Микрофон.';

  @override
  String get microphonePermissionDetailOptional =>
      'Нужно только для Экран + Микрофон.';

  @override
  String get beforeYouRecord => 'Перед записью';

  @override
  String get allowAccess => 'Разрешить доступ';

  @override
  String get pickContent => 'Выбрать контент';

  @override
  String get contentSelected => 'Контент выбран';

  @override
  String get noContentSelected => 'Контент не выбран';

  @override
  String get clear => 'Очистить';

  @override
  String get change => 'Изменить';

  @override
  String get openInFinder => 'Открыть в Finder';

  @override
  String get openSavedFolder => 'Открыть папку сохранения';

  @override
  String get video => 'Видео';

  @override
  String get frameRate => 'Частота кадров';

  @override
  String get native => 'По умолчанию';

  @override
  String get codec => 'Кодек';

  @override
  String get container => 'Контейнер';

  @override
  String get quality => 'Качество';

  @override
  String get qualityLow => 'Низкое';

  @override
  String get qualityMedium => 'Среднее';

  @override
  String get qualityHigh => 'Высокое';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'Альфа-канал';

  @override
  String get nativeResolution => 'Исходное разрешение';

  @override
  String get audio => 'Аудио';

  @override
  String get systemAudio => 'Системный звук';

  @override
  String get micDevice => 'Устройство микрофона';

  @override
  String get systemDefault => 'Системное по умолчанию';

  @override
  String get unknownDevice => 'Неизвестное устройство';

  @override
  String get display => 'Дисплей';

  @override
  String get showCursor => 'Показывать курсор';

  @override
  String get showWallpaper => 'Показывать обои';

  @override
  String get showMenuBar => 'Показывать строку меню';

  @override
  String get showDock => 'Показывать Dock';

  @override
  String get showRecorderUi => 'Показывать интерфейс рекордера';

  @override
  String get windowShadows => 'Тени окон';

  @override
  String get presenterOverlay => 'Наложение ведущего';

  @override
  String get enableOverlay => 'Включить наложение';

  @override
  String get camera => 'Камера';

  @override
  String get capabilities => 'ВОЗМОЖНОСТИ';

  @override
  String get capabilityContentPicker => 'Выбор контента';

  @override
  String get capabilityAreaSelection => 'Выбор области';

  @override
  String get capabilityPresenterOverlay => 'Наложение ведущего';

  @override
  String get capabilitySystemAudio => 'Системный звук';

  @override
  String get capabilityMicrophone => 'Микрофон';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'Альфа';

  @override
  String get capabilityWindowFiltering => 'Фильтрация окон';

  @override
  String get settings => 'Настройки';

  @override
  String get general => 'Общие';

  @override
  String get language => 'Язык';

  @override
  String get autoRefresh => 'Автообновление';

  @override
  String get refreshInterval => 'Интервал обновления';

  @override
  String get recordingDefaults => 'Параметры записи по умолчанию';

  @override
  String get accessAndStorage => 'Доступ и хранилище';

  @override
  String get advancedControls => 'Расширенные настройки';

  @override
  String get pausedState => 'ПАУЗА';

  @override
  String get pauseAction => 'Пауза';

  @override
  String get resumeAction => 'Продолжить';

  @override
  String get countdown => 'Обратный отсчёт';

  @override
  String get countdownState => 'Начнётся через';

  @override
  String get recentRecordings => 'Последние записи';

  @override
  String get audioSystemOnly => 'Только системный звук';

  @override
  String get audioMicrophoneOnly => 'Только микрофон';

  @override
  String get audioSystemAndMicrophone => 'Системный звук + Микрофон';
}
