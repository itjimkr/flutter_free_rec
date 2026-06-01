// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => 'Yenile';

  @override
  String get checkedAccess => 'Erişim kontrol edildi.';

  @override
  String turnOnRecInSettings(Object label) {
    return '$label ayarlarında Rec\'i açın, sonra uygulamaya dönüp Tekrar Kontrol Et\'e basın.';
  }

  @override
  String get finishAccessSetup => 'Erişim kurulumunu tamamla';

  @override
  String get screenSettings => 'Ekran Ayarları';

  @override
  String get microphoneSettings => 'Mikrofon Ayarları';

  @override
  String get checkAgain => 'Tekrar Kontrol Et';

  @override
  String get recordingStarted => 'Kayıt başladı.';

  @override
  String get recordingStopped => 'Kayıt durduruldu.';

  @override
  String get guideSummaryNeedsPermission =>
      'Kaydı başlatmadan önce Rec\'in hâlâ izinlere ihtiyacı var.';

  @override
  String get guideSummaryReadyForContent =>
      'İzinler hazır görünüyor. Şimdi neyi kaydedeceğinizi seçin.';

  @override
  String get guideStepAllowScreen =>
      'Erişime İzin Ver\'e basın, sonra sistem isteminde ekran yakalamaya izin verin.';

  @override
  String get guideStepScreenSettings =>
      'Ekran Ayarları\'na basın ve Rec için ekran yakalama erişimini açın.';

  @override
  String get guideStepAllowMic =>
      'Ekran + Mikrofon kullanıyorsanız, sistem mikrofon erişimi istediğinde İzin Ver\'e basın.';

  @override
  String get guideStepMicSettings =>
      'Mikrofon Ayarları\'na basın ve Rec için mikrofon erişimini açın.';

  @override
  String get guideStepPickContent =>
      'İçerik Seç\'e basın ve kaydetmek istediğiniz ekranı veya pencereyi seçin.';

  @override
  String get guideStepCheckAgain =>
      'Rec\'e geri dönün ve Tekrar Kontrol Et\'e basın.';

  @override
  String get recordHintTurnOnScreen => 'Ayarlar\'da Ekran Kaydı\'nı açın';

  @override
  String get recordHintAllowScreen => 'Önce Ekran Kaydı\'na izin verin';

  @override
  String get recordHintTurnOnMicrophone => 'Ayarlar\'da Mikrofon\'u açın';

  @override
  String get recordHintAllowMicrophone => 'Önce Mikrofona izin verin';

  @override
  String get recordHintPickContent => 'Kaydedilecek içeriği seçin';

  @override
  String get tapToRecord => 'Kaydı başlatmak için dokunun';

  @override
  String get tapToStop => 'Kaydı durdurmak için dokunun';

  @override
  String get recordAction => 'Kaydı Başlat';

  @override
  String get stopAction => 'Kaydı Durdur';

  @override
  String get selectRecordTarget => 'Neyi kaydedeceğinizi seçin';

  @override
  String get specificProgramRecord => 'Belirli bir programı kaydet';

  @override
  String get fullScreenRecord => 'Tam ekranı kaydet';

  @override
  String get specificAreaRecord => 'Belirli bir alanı kaydet';

  @override
  String get selectAudioOption => 'Sesin dahil edilip edilmeyeceğini seçin';

  @override
  String get audioIncluded => 'Sesli kaydet';

  @override
  String get audioExcluded => 'Ses olmadan kaydet';

  @override
  String get shortcuts => 'Kısayollar';

  @override
  String get notReady => 'Hazır değil';

  @override
  String get idleState => 'BOŞTA';

  @override
  String get recordingState => 'KAYITTA';

  @override
  String get stoppingState => 'DURDURULUYOR';

  @override
  String get screenOnly => 'Yalnızca Ekran';

  @override
  String get screenOnlySublabel => 'Sistem sesi';

  @override
  String get screenAndMic => 'Ekran + Mikrofon';

  @override
  String get screenAndMicSublabel => 'Mikrofonu dahil et';

  @override
  String get setup => 'KURULUM';

  @override
  String get screen => 'Ekran';

  @override
  String get microphone => 'Mikrofon';

  @override
  String get ready => 'Hazır';

  @override
  String get openSettings => 'Ayarları Aç';

  @override
  String get needsAllow => 'İzin gerekli';

  @override
  String get optional => 'İsteğe bağlı';

  @override
  String get screenPermissionDetailReady => 'Ekran yakalama hazır.';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Android, kaydı başlattığınızda neyi kaydetmek istediğinizi sorar.';

  @override
  String get screenPermissionDetailDenied =>
      'Ayarlar\'da Rec için ekran yakalama erişimini açın.';

  @override
  String get screenPermissionDetailUnknown => 'Sistem ilk seferde soracaktır.';

  @override
  String get microphonePermissionDetailReady => 'Mikrofon yakalama etkin.';

  @override
  String get microphonePermissionDetailDenied =>
      'Ayarlar\'da Rec için mikrofon erişimini açın.';

  @override
  String get microphonePermissionDetailUnknown =>
      'Ekran + Mikrofon kullanırsanız sistem izin ister.';

  @override
  String get microphonePermissionDetailOptional =>
      'Yalnızca Ekran + Mikrofon için gerekir.';

  @override
  String get beforeYouRecord => 'Kayda başlamadan önce';

  @override
  String get allowAccess => 'Erişime İzin Ver';

  @override
  String get pickContent => 'İçerik Seç';

  @override
  String get contentSelected => 'İçerik seçildi';

  @override
  String get noContentSelected => 'Seçili içerik yok';

  @override
  String get clear => 'Temizle';

  @override
  String get change => 'Değiştir';

  @override
  String get openInFinder => 'Finder\'da Aç';

  @override
  String get openSavedFolder => 'Kayıt Klasörünü Aç';

  @override
  String get video => 'Video';

  @override
  String get frameRate => 'Kare Hızı';

  @override
  String get native => 'Varsayılan';

  @override
  String get codec => 'Kodek';

  @override
  String get container => 'Kapsayıcı';

  @override
  String get quality => 'Kalite';

  @override
  String get qualityLow => 'Düşük';

  @override
  String get qualityMedium => 'Orta';

  @override
  String get qualityHigh => 'Yüksek';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'Alfa Kanalı';

  @override
  String get nativeResolution => 'Yerel Çözünürlük';

  @override
  String get audio => 'Ses';

  @override
  String get systemAudio => 'Sistem Sesi';

  @override
  String get micDevice => 'Mikrofon Aygıtı';

  @override
  String get systemDefault => 'Sistem Varsayılanı';

  @override
  String get unknownDevice => 'Bilinmeyen aygıt';

  @override
  String get display => 'Ekran';

  @override
  String get showCursor => 'İmleci Göster';

  @override
  String get showWallpaper => 'Duvar Kâğıdını Göster';

  @override
  String get showMenuBar => 'Menü Çubuğunu Göster';

  @override
  String get showDock => 'Dock\'u Göster';

  @override
  String get showRecorderUi => 'Kaydedici Arayüzünü Göster';

  @override
  String get windowShadows => 'Pencere Gölgeleri';

  @override
  String get presenterOverlay => 'Sunucu Katmanı';

  @override
  String get enableOverlay => 'Katmanı Etkinleştir';

  @override
  String get camera => 'Kamera';

  @override
  String get capabilities => 'ÖZELLİKLER';

  @override
  String get capabilityContentPicker => 'İçerik Seçici';

  @override
  String get capabilityAreaSelection => 'Alan Seçimi';

  @override
  String get capabilityPresenterOverlay => 'Sunucu Katmanı';

  @override
  String get capabilitySystemAudio => 'Sistem Sesi';

  @override
  String get capabilityMicrophone => 'Mikrofon';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'Alfa';

  @override
  String get capabilityWindowFiltering => 'Pencere Filtreleme';

  @override
  String get settings => 'Ayarlar';

  @override
  String get general => 'Genel';

  @override
  String get language => 'Dil';

  @override
  String get autoRefresh => 'Otomatik Yenileme';

  @override
  String get refreshInterval => 'Yenileme Aralığı';

  @override
  String get recordingDefaults => 'Kayıt Varsayılanları';

  @override
  String get accessAndStorage => 'Erişim ve Depolama';

  @override
  String get advancedControls => 'Gelişmiş Kontroller';

  @override
  String get pausedState => 'DURAKLATILDI';

  @override
  String get pauseAction => 'Duraklat';

  @override
  String get resumeAction => 'Sürdür';

  @override
  String get countdown => 'Geri Sayım';

  @override
  String get countdownState => 'Başlamasına';

  @override
  String get recentRecordings => 'Son Kayıtlar';

  @override
  String get audioSystemOnly => 'Yalnızca Sistem Sesi';

  @override
  String get audioMicrophoneOnly => 'Yalnızca Mikrofon';

  @override
  String get audioSystemAndMicrophone => 'Sistem Sesi + Mikrofon';
}
