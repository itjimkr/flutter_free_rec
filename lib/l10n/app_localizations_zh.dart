// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => '重新整理';

  @override
  String get checkedAccess => '已检查访问权限。';

  @override
  String turnOnRecInSettings(Object label) {
    return '请在 $label 设置中开启 Rec，然后返回应用并点击再次检查。';
  }

  @override
  String get finishAccessSetup => '完成访问设置';

  @override
  String get screenSettings => '屏幕设置';

  @override
  String get microphoneSettings => '麦克风设置';

  @override
  String get checkAgain => '再次检查';

  @override
  String get recordingStarted => '已开始录制。';

  @override
  String get recordingStopped => '已停止录制。';

  @override
  String get guideSummaryNeedsPermission => 'Rec 仍需要权限，才能开始录制。';

  @override
  String get guideSummaryReadyForContent => '权限已准备好。接下来请选择要录制的内容。';

  @override
  String get guideStepAllowScreen => '点击允许访问，然后在系统提示中允许屏幕捕获。';

  @override
  String get guideStepScreenSettings => '点击屏幕设置，并为 Rec 开启屏幕捕获权限。';

  @override
  String get guideStepAllowMic => '如果你使用屏幕 + 麦克风，当系统请求麦克风权限时请点击允许。';

  @override
  String get guideStepMicSettings => '点击麦克风设置，并为 Rec 开启麦克风权限。';

  @override
  String get guideStepPickContent => '点击选择内容，然后选择要录制的屏幕或窗口。';

  @override
  String get guideStepCheckAgain => '返回 Rec 后点击再次检查。';

  @override
  String get recordHintTurnOnScreen => '请在设置中开启屏幕录制';

  @override
  String get recordHintAllowScreen => '请先允许屏幕录制';

  @override
  String get recordHintTurnOnMicrophone => '请在设置中开启麦克风';

  @override
  String get recordHintAllowMicrophone => '请先允许麦克风';

  @override
  String get recordHintPickContent => '请选择要录制的内容';

  @override
  String get tapToRecord => '点击开始录制';

  @override
  String get tapToStop => '点击停止录制';

  @override
  String get recordAction => '开始录制';

  @override
  String get stopAction => '停止录制';

  @override
  String get selectRecordTarget => '选择要录制的内容';

  @override
  String get specificProgramRecord => '录制指定程序';

  @override
  String get fullScreenRecord => '录制整个屏幕';

  @override
  String get specificAreaRecord => '录制指定区域';

  @override
  String get selectAudioOption => '选择是否包含音频';

  @override
  String get audioIncluded => '录制并包含音频';

  @override
  String get audioExcluded => '录制但不包含音频';

  @override
  String get shortcuts => '快捷键';

  @override
  String get notReady => '尚未就绪';

  @override
  String get idleState => '待机中';

  @override
  String get recordingState => '录制中';

  @override
  String get stoppingState => '停止中';

  @override
  String get screenOnly => '仅屏幕';

  @override
  String get screenOnlySublabel => '系统音频';

  @override
  String get screenAndMic => '屏幕 + 麦克风';

  @override
  String get screenAndMicSublabel => '包含麦克风';

  @override
  String get setup => '设置';

  @override
  String get screen => '屏幕';

  @override
  String get microphone => '麦克风';

  @override
  String get ready => '就绪';

  @override
  String get openSettings => '打开设置';

  @override
  String get needsAllow => '需要允许';

  @override
  String get optional => '可选';

  @override
  String get screenPermissionDetailReady => '屏幕捕获已准备就绪。';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Android 会在开始录制时询问你要录制什么内容。';

  @override
  String get screenPermissionDetailDenied => '请在设置中为 Rec 开启屏幕捕获权限。';

  @override
  String get screenPermissionDetailUnknown => '系统会在首次使用时询问。';

  @override
  String get microphonePermissionDetailReady => '麦克风录音已启用。';

  @override
  String get microphonePermissionDetailDenied => '请在设置中为 Rec 开启麦克风权限。';

  @override
  String get microphonePermissionDetailUnknown => '如果你使用屏幕 + 麦克风，系统会请求权限。';

  @override
  String get microphonePermissionDetailOptional => '仅在使用屏幕 + 麦克风时需要。';

  @override
  String get beforeYouRecord => '录制前请先确认';

  @override
  String get allowAccess => '允许访问';

  @override
  String get pickContent => '选择内容';

  @override
  String get contentSelected => '已选择内容';

  @override
  String get noContentSelected => '尚未选择内容';

  @override
  String get clear => '清除';

  @override
  String get change => '更改';

  @override
  String get openInFinder => '在 Finder 中打开';

  @override
  String get openSavedFolder => '打开保存文件夹';

  @override
  String get video => '视频';

  @override
  String get frameRate => '帧率';

  @override
  String get native => '默认';

  @override
  String get codec => '编解码器';

  @override
  String get container => '容器';

  @override
  String get quality => '画质';

  @override
  String get qualityLow => '低';

  @override
  String get qualityMedium => '中';

  @override
  String get qualityHigh => '高';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'Alpha 通道';

  @override
  String get nativeResolution => '原生分辨率';

  @override
  String get audio => '音频';

  @override
  String get systemAudio => '系统音频';

  @override
  String get micDevice => '麦克风设备';

  @override
  String get systemDefault => '系统默认';

  @override
  String get unknownDevice => '未知设备';

  @override
  String get display => '显示器';

  @override
  String get showCursor => '显示光标';

  @override
  String get showWallpaper => '显示壁纸';

  @override
  String get showMenuBar => '显示菜单栏';

  @override
  String get showDock => '显示 Dock';

  @override
  String get showRecorderUi => '显示录制界面';

  @override
  String get windowShadows => '窗口阴影';

  @override
  String get presenterOverlay => '演示者叠层';

  @override
  String get enableOverlay => '启用叠层';

  @override
  String get camera => '相机';

  @override
  String get capabilities => '功能';

  @override
  String get capabilityContentPicker => '内容选择器';

  @override
  String get capabilityAreaSelection => '区域选择';

  @override
  String get capabilityPresenterOverlay => '演示者叠层';

  @override
  String get capabilitySystemAudio => '系统音频';

  @override
  String get capabilityMicrophone => '麦克风';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'Alpha';

  @override
  String get capabilityWindowFiltering => '窗口过滤';

  @override
  String get settings => '设置';

  @override
  String get general => '常规';

  @override
  String get language => '语言';

  @override
  String get autoRefresh => '自动刷新';

  @override
  String get refreshInterval => '刷新间隔';

  @override
  String get recordingDefaults => '默认录制设置';

  @override
  String get accessAndStorage => '权限与存储';

  @override
  String get advancedControls => '高级控制';

  @override
  String get pausedState => '已暂停';

  @override
  String get pauseAction => '暂停';

  @override
  String get resumeAction => '继续';

  @override
  String get countdown => '倒计时';

  @override
  String get countdownState => '即将开始';

  @override
  String get recentRecordings => '最近录制';

  @override
  String get audioSystemOnly => '仅系统音频';

  @override
  String get audioMicrophoneOnly => '仅麦克风';

  @override
  String get audioSystemAndMicrophone => '系统音频 + 麦克风';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => '重新整理';

  @override
  String get checkedAccess => '已檢查存取權限。';

  @override
  String turnOnRecInSettings(Object label) {
    return '請在 $label 設定中開啟 Rec，然後回到 App 再按一次重新檢查。';
  }

  @override
  String get finishAccessSetup => '完成存取設定';

  @override
  String get screenSettings => '螢幕設定';

  @override
  String get microphoneSettings => '麥克風設定';

  @override
  String get checkAgain => '重新檢查';

  @override
  String get recordingStarted => '已開始錄影。';

  @override
  String get recordingStopped => '已停止錄影。';

  @override
  String get guideSummaryNeedsPermission => 'Rec 仍需要權限，才能開始錄影。';

  @override
  String get guideSummaryReadyForContent => '權限已就緒。接下來請選擇要錄製的內容。';

  @override
  String get guideStepAllowScreen => '按下允許存取，然後在系統提示中允許螢幕擷取。';

  @override
  String get guideStepScreenSettings => '按下螢幕設定，並為 Rec 開啟螢幕擷取權限。';

  @override
  String get guideStepAllowMic => '如果你使用螢幕 + 麥克風，當系統詢問麥克風權限時請按允許。';

  @override
  String get guideStepMicSettings => '按下麥克風設定，並為 Rec 開啟麥克風權限。';

  @override
  String get guideStepPickContent => '按下選擇內容，然後選擇要錄製的螢幕或視窗。';

  @override
  String get guideStepCheckAgain => '回到 Rec 後按重新檢查。';

  @override
  String get recordHintTurnOnScreen => '請在設定中開啟螢幕錄製';

  @override
  String get recordHintAllowScreen => '請先允許螢幕錄製';

  @override
  String get recordHintTurnOnMicrophone => '請在設定中開啟麥克風';

  @override
  String get recordHintAllowMicrophone => '請先允許麥克風';

  @override
  String get recordHintPickContent => '請選擇要錄製的內容';

  @override
  String get tapToRecord => '點一下開始錄影';

  @override
  String get tapToStop => '點一下停止錄影';

  @override
  String get recordAction => '開始錄影';

  @override
  String get stopAction => '停止錄影';

  @override
  String get selectRecordTarget => '選擇要錄製的內容';

  @override
  String get specificProgramRecord => '錄製指定程式';

  @override
  String get fullScreenRecord => '錄製整個畫面';

  @override
  String get specificAreaRecord => '錄製指定區域';

  @override
  String get selectAudioOption => '選擇是否包含音訊';

  @override
  String get audioIncluded => '錄製並包含音訊';

  @override
  String get audioExcluded => '錄製但不包含音訊';

  @override
  String get shortcuts => '快捷鍵';

  @override
  String get notReady => '尚未就緒';

  @override
  String get idleState => '待命中';

  @override
  String get recordingState => '錄影中';

  @override
  String get stoppingState => '停止中';

  @override
  String get screenOnly => '僅螢幕';

  @override
  String get screenOnlySublabel => '系統音訊';

  @override
  String get screenAndMic => '螢幕 + 麥克風';

  @override
  String get screenAndMicSublabel => '包含麥克風';

  @override
  String get setup => '設定';

  @override
  String get screen => '螢幕';

  @override
  String get microphone => '麥克風';

  @override
  String get ready => '就緒';

  @override
  String get openSettings => '開啟設定';

  @override
  String get needsAllow => '需要允許';

  @override
  String get optional => '選用';

  @override
  String get screenPermissionDetailReady => '螢幕擷取已準備完成。';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Android 會在開始錄影時詢問你要錄製什麼內容。';

  @override
  String get screenPermissionDetailDenied => '請在設定中為 Rec 開啟螢幕擷取權限。';

  @override
  String get screenPermissionDetailUnknown => '系統會在第一次使用時詢問。';

  @override
  String get microphonePermissionDetailReady => '麥克風錄音已啟用。';

  @override
  String get microphonePermissionDetailDenied => '請在設定中為 Rec 開啟麥克風權限。';

  @override
  String get microphonePermissionDetailUnknown => '如果你使用螢幕 + 麥克風，系統會詢問權限。';

  @override
  String get microphonePermissionDetailOptional => '只有在使用螢幕 + 麥克風時才需要。';

  @override
  String get beforeYouRecord => '錄影前請先確認';

  @override
  String get allowAccess => '允許存取';

  @override
  String get pickContent => '選擇內容';

  @override
  String get contentSelected => '已選擇內容';

  @override
  String get noContentSelected => '尚未選擇內容';

  @override
  String get clear => '清除';

  @override
  String get change => '變更';

  @override
  String get openInFinder => '在 Finder 中開啟';

  @override
  String get openSavedFolder => '開啟儲存資料夾';

  @override
  String get video => '影片';

  @override
  String get frameRate => '影格率';

  @override
  String get native => '預設';

  @override
  String get codec => '編解碼器';

  @override
  String get container => '容器';

  @override
  String get quality => '畫質';

  @override
  String get qualityLow => '低';

  @override
  String get qualityMedium => '中';

  @override
  String get qualityHigh => '高';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'Alpha 通道';

  @override
  String get nativeResolution => '原生解析度';

  @override
  String get audio => '音訊';

  @override
  String get systemAudio => '系統音訊';

  @override
  String get micDevice => '麥克風裝置';

  @override
  String get systemDefault => '系統預設';

  @override
  String get unknownDevice => '未知裝置';

  @override
  String get display => '顯示器';

  @override
  String get showCursor => '顯示游標';

  @override
  String get showWallpaper => '顯示桌布';

  @override
  String get showMenuBar => '顯示選單列';

  @override
  String get showDock => '顯示 Dock';

  @override
  String get showRecorderUi => '顯示錄影介面';

  @override
  String get windowShadows => '視窗陰影';

  @override
  String get presenterOverlay => '簡報者覆蓋層';

  @override
  String get enableOverlay => '啟用覆蓋層';

  @override
  String get camera => '相機';

  @override
  String get capabilities => '功能';

  @override
  String get capabilityContentPicker => '內容選擇器';

  @override
  String get capabilityAreaSelection => '區域選擇';

  @override
  String get capabilityPresenterOverlay => '簡報者覆蓋層';

  @override
  String get capabilitySystemAudio => '系統音訊';

  @override
  String get capabilityMicrophone => '麥克風';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'Alpha';

  @override
  String get capabilityWindowFiltering => '視窗篩選';

  @override
  String get settings => '設定';

  @override
  String get general => '一般';

  @override
  String get language => '語言';

  @override
  String get autoRefresh => '自動重新整理';

  @override
  String get refreshInterval => '重新整理間隔';

  @override
  String get recordingDefaults => '預設錄影設定';

  @override
  String get accessAndStorage => '權限與儲存';

  @override
  String get advancedControls => '進階控制';

  @override
  String get pausedState => '已暫停';

  @override
  String get pauseAction => '暫停';

  @override
  String get resumeAction => '繼續';

  @override
  String get countdown => '倒數計時';

  @override
  String get countdownState => '即將開始';

  @override
  String get recentRecordings => '最近錄製';

  @override
  String get audioSystemOnly => '僅系統音訊';

  @override
  String get audioMicrophoneOnly => '僅麥克風';

  @override
  String get audioSystemAndMicrophone => '系統音訊 + 麥克風';
}
