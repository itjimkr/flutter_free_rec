// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => '更新';

  @override
  String get checkedAccess => 'アクセスを確認しました。';

  @override
  String turnOnRecInSettings(Object label) {
    return '$label設定でRecを有効にしてから、アプリに戻ってもう一度確認を押してください。';
  }

  @override
  String get finishAccessSetup => 'アクセス設定を完了';

  @override
  String get screenSettings => '画面収録設定';

  @override
  String get microphoneSettings => 'マイク設定';

  @override
  String get checkAgain => '再確認';

  @override
  String get recordingStarted => '録画を開始しました。';

  @override
  String get recordingStopped => '録画を停止しました。';

  @override
  String get guideSummaryNeedsPermission => '録画を開始するには、まだ権限の確認が必要です。';

  @override
  String get guideSummaryReadyForContent =>
      '権限の準備ができました。次に録画する画面やウィンドウを選んでください。';

  @override
  String get guideStepAllowScreen => 'アクセスを許可を押して、システムの確認画面で画面収録を許可してください。';

  @override
  String get guideStepScreenSettings => '画面収録設定を押して、Recの画面キャプチャアクセスを有効にしてください。';

  @override
  String get guideStepAllowMic =>
      '画面 + マイクを使う場合は、システムがマイクアクセスを尋ねたときに許可を押してください。';

  @override
  String get guideStepMicSettings => 'マイク設定を押して、Recのマイクアクセスを有効にしてください。';

  @override
  String get guideStepPickContent => 'コンテンツを選択を押して、録画する画面やウィンドウを選んでください。';

  @override
  String get guideStepCheckAgain => 'Recに戻って再確認を押してください。';

  @override
  String get recordHintTurnOnScreen => '設定で画面収録を有効にしてください';

  @override
  String get recordHintAllowScreen => '先に画面収録を許可してください';

  @override
  String get recordHintTurnOnMicrophone => '設定でマイクを有効にしてください';

  @override
  String get recordHintAllowMicrophone => '先にマイクを許可してください';

  @override
  String get recordHintPickContent => '録画する内容を選んでください';

  @override
  String get tapToRecord => 'タップして録画開始';

  @override
  String get tapToStop => 'タップして録画停止';

  @override
  String get recordAction => '録画する';

  @override
  String get stopAction => '録画を停止';

  @override
  String get selectRecordTarget => '録画する対象を選んでください';

  @override
  String get specificProgramRecord => '特定のアプリを録画';

  @override
  String get fullScreenRecord => '画面全体を録画';

  @override
  String get specificAreaRecord => '特定の範囲を録画';

  @override
  String get selectAudioOption => '音声を含めるか選んでください';

  @override
  String get audioIncluded => '音声ありで録画';

  @override
  String get audioExcluded => '音声なしで録画';

  @override
  String get shortcuts => 'ショートカット';

  @override
  String get notReady => '未準備';

  @override
  String get idleState => '待機中';

  @override
  String get recordingState => '録画中';

  @override
  String get stoppingState => '停止中';

  @override
  String get screenOnly => '画面のみ';

  @override
  String get screenOnlySublabel => 'システム音声';

  @override
  String get screenAndMic => '画面 + マイク';

  @override
  String get screenAndMicSublabel => 'マイク音声を含む';

  @override
  String get setup => '設定';

  @override
  String get screen => '画面';

  @override
  String get microphone => 'マイク';

  @override
  String get ready => '準備完了';

  @override
  String get openSettings => '設定を開く';

  @override
  String get needsAllow => '許可が必要';

  @override
  String get optional => '任意';

  @override
  String get screenPermissionDetailReady => '画面キャプチャの準備ができています。';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Androidでは録画開始時に録画する画面を選択します。';

  @override
  String get screenPermissionDetailDenied => '設定でRecの画面キャプチャアクセスを有効にしてください。';

  @override
  String get screenPermissionDetailUnknown => '初回のみシステムが確認します。';

  @override
  String get microphonePermissionDetailReady => 'マイク録音が有効です。';

  @override
  String get microphonePermissionDetailDenied => '設定でRecのマイクアクセスを有効にしてください。';

  @override
  String get microphonePermissionDetailUnknown => '画面 + マイクを使うと、システムが許可を求めます。';

  @override
  String get microphonePermissionDetailOptional => '画面 + マイクを使うときだけ必要です。';

  @override
  String get beforeYouRecord => '録画前の確認事項';

  @override
  String get allowAccess => 'アクセスを許可';

  @override
  String get pickContent => 'コンテンツを選択';

  @override
  String get contentSelected => 'コンテンツが選択されました';

  @override
  String get noContentSelected => '選択されたコンテンツがありません';

  @override
  String get clear => 'クリア';

  @override
  String get change => '変更';

  @override
  String get openInFinder => 'Finderで開く';

  @override
  String get openSavedFolder => '保存フォルダを開く';

  @override
  String get video => 'ビデオ';

  @override
  String get frameRate => 'フレームレート';

  @override
  String get native => '標準';

  @override
  String get codec => 'コーデック';

  @override
  String get container => 'コンテナ';

  @override
  String get quality => '画質';

  @override
  String get qualityLow => '低';

  @override
  String get qualityMedium => '中';

  @override
  String get qualityHigh => '高';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'アルファチャンネル';

  @override
  String get nativeResolution => '元の解像度';

  @override
  String get audio => 'オーディオ';

  @override
  String get systemAudio => 'システム音声';

  @override
  String get micDevice => 'マイクデバイス';

  @override
  String get systemDefault => 'システムデフォルト';

  @override
  String get unknownDevice => '不明なデバイス';

  @override
  String get display => '画面';

  @override
  String get showCursor => 'カーソルを表示';

  @override
  String get showWallpaper => '壁紙を表示';

  @override
  String get showMenuBar => 'メニューバーを表示';

  @override
  String get showDock => 'Dockを表示';

  @override
  String get showRecorderUi => 'レコーダーUIを表示';

  @override
  String get windowShadows => 'ウィンドウの影';

  @override
  String get presenterOverlay => 'プレゼンターオーバーレイ';

  @override
  String get enableOverlay => 'オーバーレイを有効化';

  @override
  String get camera => 'カメラ';

  @override
  String get capabilities => '機能';

  @override
  String get capabilityContentPicker => 'コンテンツ選択';

  @override
  String get capabilityAreaSelection => '領域選択';

  @override
  String get capabilityPresenterOverlay => 'プレゼンターオーバーレイ';

  @override
  String get capabilitySystemAudio => 'システム音声';

  @override
  String get capabilityMicrophone => 'マイク';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'アルファ';

  @override
  String get capabilityWindowFiltering => 'ウィンドウフィルタリング';

  @override
  String get settings => '設定';

  @override
  String get general => '一般';

  @override
  String get language => '言語';

  @override
  String get autoRefresh => '自動更新';

  @override
  String get refreshInterval => '更新間隔';

  @override
  String get recordingDefaults => '録画の基本設定';

  @override
  String get accessAndStorage => '権限と保存';

  @override
  String get advancedControls => '詳細設定';

  @override
  String get pausedState => '一時停止';

  @override
  String get pauseAction => '一時停止';

  @override
  String get resumeAction => '再開';

  @override
  String get countdown => 'カウントダウン';

  @override
  String get countdownState => '開始まで';

  @override
  String get recentRecordings => '最近の録画';

  @override
  String get audioSystemOnly => 'システム音声のみ';

  @override
  String get audioMicrophoneOnly => 'マイクのみ';

  @override
  String get audioSystemAndMicrophone => 'システム音声 + マイク';
}
