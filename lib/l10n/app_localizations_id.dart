// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => 'Segarkan';

  @override
  String get checkedAccess => 'Akses sudah diperiksa.';

  @override
  String turnOnRecInSettings(Object label) {
    return 'Aktifkan Rec di setelan $label, lalu kembali ke aplikasi dan tekan Periksa Lagi.';
  }

  @override
  String get finishAccessSetup => 'Selesaikan pengaturan akses';

  @override
  String get screenSettings => 'Setelan Layar';

  @override
  String get microphoneSettings => 'Setelan Mikrofon';

  @override
  String get checkAgain => 'Periksa Lagi';

  @override
  String get recordingStarted => 'Perekaman dimulai.';

  @override
  String get recordingStopped => 'Perekaman dihentikan.';

  @override
  String get guideSummaryNeedsPermission =>
      'Rec masih memerlukan izin sebelum perekaman bisa dimulai.';

  @override
  String get guideSummaryReadyForContent =>
      'Izin sudah siap. Pilih apa yang ingin Anda rekam berikutnya.';

  @override
  String get guideStepAllowScreen =>
      'Tekan Izinkan Akses, lalu izinkan perekaman layar di prompt sistem.';

  @override
  String get guideStepScreenSettings =>
      'Tekan Setelan Layar dan aktifkan akses perekaman layar untuk Rec.';

  @override
  String get guideStepAllowMic =>
      'Jika Anda memakai Layar + Mikrofon, tekan Izinkan saat sistem meminta akses mikrofon.';

  @override
  String get guideStepMicSettings =>
      'Tekan Setelan Mikrofon dan aktifkan akses mikrofon untuk Rec.';

  @override
  String get guideStepPickContent =>
      'Tekan Pilih Konten dan pilih layar atau jendela yang ingin direkam.';

  @override
  String get guideStepCheckAgain => 'Kembali ke Rec dan tekan Periksa Lagi.';

  @override
  String get recordHintTurnOnScreen => 'Aktifkan Perekaman Layar di Setelan';

  @override
  String get recordHintAllowScreen => 'Izinkan Perekaman Layar terlebih dahulu';

  @override
  String get recordHintTurnOnMicrophone => 'Aktifkan Mikrofon di Setelan';

  @override
  String get recordHintAllowMicrophone => 'Izinkan Mikrofon terlebih dahulu';

  @override
  String get recordHintPickContent => 'Pilih konten untuk direkam';

  @override
  String get tapToRecord => 'Ketuk untuk mulai merekam';

  @override
  String get tapToStop => 'Ketuk untuk menghentikan rekaman';

  @override
  String get recordAction => 'Mulai Rekam';

  @override
  String get stopAction => 'Hentikan Rekaman';

  @override
  String get selectRecordTarget => 'Pilih apa yang ingin direkam';

  @override
  String get specificProgramRecord => 'Rekam aplikasi tertentu';

  @override
  String get fullScreenRecord => 'Rekam seluruh layar';

  @override
  String get specificAreaRecord => 'Rekam area tertentu';

  @override
  String get selectAudioOption => 'Pilih apakah audio akan disertakan';

  @override
  String get audioIncluded => 'Rekam dengan audio';

  @override
  String get audioExcluded => 'Rekam tanpa audio';

  @override
  String get shortcuts => 'Pintasan';

  @override
  String get notReady => 'Belum siap';

  @override
  String get idleState => 'SIAGA';

  @override
  String get recordingState => 'MEREKAM';

  @override
  String get stoppingState => 'MENGHENTIKAN';

  @override
  String get screenOnly => 'Layar Saja';

  @override
  String get screenOnlySublabel => 'Audio sistem';

  @override
  String get screenAndMic => 'Layar + Mikrofon';

  @override
  String get screenAndMicSublabel => 'Sertakan mikrofon';

  @override
  String get setup => 'PENGATURAN';

  @override
  String get screen => 'Layar';

  @override
  String get microphone => 'Mikrofon';

  @override
  String get ready => 'Siap';

  @override
  String get openSettings => 'Buka Setelan';

  @override
  String get needsAllow => 'Perlu izin';

  @override
  String get optional => 'Opsional';

  @override
  String get screenPermissionDetailReady => 'Perekaman layar siap.';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Android akan menanyakan apa yang ingin direkam saat Anda mulai merekam.';

  @override
  String get screenPermissionDetailDenied =>
      'Aktifkan akses perekaman layar untuk Rec di Setelan.';

  @override
  String get screenPermissionDetailUnknown =>
      'Sistem akan meminta izin pertama kali.';

  @override
  String get microphonePermissionDetailReady => 'Perekaman mikrofon aktif.';

  @override
  String get microphonePermissionDetailDenied =>
      'Aktifkan akses mikrofon untuk Rec di Setelan.';

  @override
  String get microphonePermissionDetailUnknown =>
      'Sistem akan meminta izin jika Anda memakai Layar + Mikrofon.';

  @override
  String get microphonePermissionDetailOptional =>
      'Hanya diperlukan untuk Layar + Mikrofon.';

  @override
  String get beforeYouRecord => 'Sebelum merekam';

  @override
  String get allowAccess => 'Izinkan Akses';

  @override
  String get pickContent => 'Pilih Konten';

  @override
  String get contentSelected => 'Konten dipilih';

  @override
  String get noContentSelected => 'Belum ada konten dipilih';

  @override
  String get clear => 'Hapus';

  @override
  String get change => 'Ubah';

  @override
  String get openInFinder => 'Buka di Finder';

  @override
  String get openSavedFolder => 'Buka Folder Penyimpanan';

  @override
  String get video => 'Video';

  @override
  String get frameRate => 'Laju Bingkai';

  @override
  String get native => 'Bawaan';

  @override
  String get codec => 'Codec';

  @override
  String get container => 'Kontainer';

  @override
  String get quality => 'Kualitas';

  @override
  String get qualityLow => 'Rendah';

  @override
  String get qualityMedium => 'Sedang';

  @override
  String get qualityHigh => 'Tinggi';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'Kanal Alfa';

  @override
  String get nativeResolution => 'Resolusi Asli';

  @override
  String get audio => 'Audio';

  @override
  String get systemAudio => 'Audio Sistem';

  @override
  String get micDevice => 'Perangkat Mikrofon';

  @override
  String get systemDefault => 'Default Sistem';

  @override
  String get unknownDevice => 'Perangkat tidak dikenal';

  @override
  String get display => 'Tampilan';

  @override
  String get showCursor => 'Tampilkan Kursor';

  @override
  String get showWallpaper => 'Tampilkan Wallpaper';

  @override
  String get showMenuBar => 'Tampilkan Bilah Menu';

  @override
  String get showDock => 'Tampilkan Dock';

  @override
  String get showRecorderUi => 'Tampilkan UI Perekam';

  @override
  String get windowShadows => 'Bayangan Jendela';

  @override
  String get presenterOverlay => 'Overlay Presenter';

  @override
  String get enableOverlay => 'Aktifkan Overlay';

  @override
  String get camera => 'Kamera';

  @override
  String get capabilities => 'KEMAMPUAN';

  @override
  String get capabilityContentPicker => 'Pemilih Konten';

  @override
  String get capabilityAreaSelection => 'Pemilihan Area';

  @override
  String get capabilityPresenterOverlay => 'Overlay Presenter';

  @override
  String get capabilitySystemAudio => 'Audio Sistem';

  @override
  String get capabilityMicrophone => 'Mikrofon';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'Alfa';

  @override
  String get capabilityWindowFiltering => 'Penyaringan Jendela';

  @override
  String get settings => 'Setelan';

  @override
  String get general => 'Umum';

  @override
  String get language => 'Bahasa';

  @override
  String get autoRefresh => 'Penyegaran Otomatis';

  @override
  String get refreshInterval => 'Interval Penyegaran';

  @override
  String get recordingDefaults => 'Default Perekaman';

  @override
  String get accessAndStorage => 'Akses dan Penyimpanan';

  @override
  String get advancedControls => 'Kontrol Lanjutan';

  @override
  String get pausedState => 'Dijeda';

  @override
  String get pauseAction => 'Jeda';

  @override
  String get resumeAction => 'Lanjutkan';

  @override
  String get countdown => 'Hitung Mundur';

  @override
  String get countdownState => 'Mulai dalam';

  @override
  String get recentRecordings => 'Rekaman Terbaru';

  @override
  String get audioSystemOnly => 'Audio Sistem Saja';

  @override
  String get audioMicrophoneOnly => 'Mikrofon Saja';

  @override
  String get audioSystemAndMicrophone => 'Audio Sistem + Mikrofon';
}
