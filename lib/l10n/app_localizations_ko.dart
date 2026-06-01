// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => '새로고침';

  @override
  String get checkedAccess => '접근 권한을 확인했어요.';

  @override
  String turnOnRecInSettings(Object label) {
    return '$label 설정에서 Rec를 켠 뒤, 앱으로 돌아와 다시 확인을 눌러 주세요.';
  }

  @override
  String get finishAccessSetup => '접근 권한 마무리';

  @override
  String get screenSettings => '화면 녹화 설정';

  @override
  String get microphoneSettings => '마이크 설정';

  @override
  String get checkAgain => '다시 확인';

  @override
  String get recordingStarted => '녹화를 시작했어요.';

  @override
  String get recordingStopped => '녹화를 멈췄어요.';

  @override
  String get guideSummaryNeedsPermission => '녹화를 시작하려면 아직 권한 확인이 더 필요해요.';

  @override
  String get guideSummaryReadyForContent =>
      '권한 확인은 끝났어요. 이제 녹화할 화면이나 창을 골라 주세요.';

  @override
  String get guideStepAllowScreen => '접근 허용을 누른 뒤, 시스템 창이 뜨면 화면 캡처 허용을 눌러 주세요.';

  @override
  String get guideStepScreenSettings => '화면 녹화 설정을 눌러 Rec의 화면 캡처 접근을 켜 주세요.';

  @override
  String get guideStepAllowMic =>
      '화면 + 마이크를 쓸 때는 시스템이 묻는 마이크 허용 창에서 허용을 눌러 주세요.';

  @override
  String get guideStepMicSettings => '마이크 설정을 눌러 Rec의 마이크 접근을 켜 주세요.';

  @override
  String get guideStepPickContent => '콘텐츠 선택을 눌러 녹화할 화면이나 창을 골라 주세요.';

  @override
  String get guideStepCheckAgain => 'Rec로 돌아와 다시 확인을 눌러 주세요.';

  @override
  String get recordHintTurnOnScreen => '설정에서 화면 녹화를 켜 주세요';

  @override
  String get recordHintAllowScreen => '먼저 화면 녹화를 허용해 주세요';

  @override
  String get recordHintTurnOnMicrophone => '설정에서 마이크를 켜 주세요';

  @override
  String get recordHintAllowMicrophone => '먼저 마이크를 허용해 주세요';

  @override
  String get recordHintPickContent => '녹화할 화면이나 창을 골라 주세요';

  @override
  String get tapToRecord => '눌러서 녹화 시작';

  @override
  String get tapToStop => '눌러서 녹화 중지';

  @override
  String get recordAction => '녹화하기';

  @override
  String get stopAction => '녹화 중지';

  @override
  String get selectRecordTarget => '녹화 대상을 골라 주세요';

  @override
  String get specificProgramRecord => '특정 프로그램 녹화';

  @override
  String get fullScreenRecord => '전체 화면 녹화';

  @override
  String get specificAreaRecord => '특정 부분 녹화';

  @override
  String get selectAudioOption => '음성 포함 여부를 골라 주세요';

  @override
  String get audioIncluded => '음성 포함 녹화';

  @override
  String get audioExcluded => '음성 미포함 녹화';

  @override
  String get shortcuts => '단축키';

  @override
  String get notReady => '준비 중';

  @override
  String get idleState => '대기 중';

  @override
  String get recordingState => '녹화 중';

  @override
  String get stoppingState => '정리 중';

  @override
  String get screenOnly => '화면만';

  @override
  String get screenOnlySublabel => '시스템 오디오';

  @override
  String get screenAndMic => '화면 + 마이크';

  @override
  String get screenAndMicSublabel => '외부 목소리 포함';

  @override
  String get setup => '준비';

  @override
  String get screen => '화면';

  @override
  String get microphone => '마이크';

  @override
  String get ready => '준비 완료';

  @override
  String get openSettings => '설정 열기';

  @override
  String get needsAllow => '허용 필요';

  @override
  String get optional => '선택 사항';

  @override
  String get screenPermissionDetailReady => '화면 캡처 준비가 되었어요.';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Android에서는 녹화를 시작할 때 녹화할 화면을 고르게 돼요.';

  @override
  String get screenPermissionDetailDenied => '설정에서 Rec의 화면 캡처 접근을 켜 주세요.';

  @override
  String get screenPermissionDetailUnknown => '처음 한 번 시스템 허용 창이 떠요.';

  @override
  String get microphonePermissionDetailReady => '마이크 녹음이 활성화되어 있어요.';

  @override
  String get microphonePermissionDetailDenied => '설정에서 Rec의 마이크 접근을 켜 주세요.';

  @override
  String get microphonePermissionDetailUnknown => '화면 + 마이크를 쓰면 시스템이 허용을 물어봐요.';

  @override
  String get microphonePermissionDetailOptional => '화면 + 마이크를 쓸 때만 필요해요.';

  @override
  String get beforeYouRecord => '녹화 전에 확인할 것';

  @override
  String get allowAccess => '접근 허용';

  @override
  String get pickContent => '콘텐츠 선택';

  @override
  String get contentSelected => '콘텐츠가 선택되었어요';

  @override
  String get noContentSelected => '선택된 콘텐츠가 없어요';

  @override
  String get clear => '지우기';

  @override
  String get change => '변경';

  @override
  String get openInFinder => 'Finder에서 열기';

  @override
  String get openSavedFolder => '저장폴더 열기';

  @override
  String get video => '비디오';

  @override
  String get frameRate => '프레임 속도';

  @override
  String get native => '기본값';

  @override
  String get codec => '코덱';

  @override
  String get container => '컨테이너';

  @override
  String get quality => '화질';

  @override
  String get qualityLow => '낮음';

  @override
  String get qualityMedium => '보통';

  @override
  String get qualityHigh => '높음';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => '알파 채널';

  @override
  String get nativeResolution => '원본 해상도';

  @override
  String get audio => '오디오';

  @override
  String get systemAudio => '시스템 오디오';

  @override
  String get micDevice => '마이크 장치';

  @override
  String get systemDefault => '시스템 기본값';

  @override
  String get unknownDevice => '알 수 없는 기기';

  @override
  String get display => '화면';

  @override
  String get showCursor => '커서 표시';

  @override
  String get showWallpaper => '배경화면 표시';

  @override
  String get showMenuBar => '메뉴 막대 표시';

  @override
  String get showDock => 'Dock 표시';

  @override
  String get showRecorderUi => '레코더 UI 표시';

  @override
  String get windowShadows => '창 그림자';

  @override
  String get presenterOverlay => '발표자 오버레이';

  @override
  String get enableOverlay => '오버레이 사용';

  @override
  String get camera => '카메라';

  @override
  String get capabilities => '기능';

  @override
  String get capabilityContentPicker => '콘텐츠 선택기';

  @override
  String get capabilityAreaSelection => '영역 선택';

  @override
  String get capabilityPresenterOverlay => '발표자 오버레이';

  @override
  String get capabilitySystemAudio => '시스템 오디오';

  @override
  String get capabilityMicrophone => '마이크';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => '알파';

  @override
  String get capabilityWindowFiltering => '창 필터링';

  @override
  String get settings => '설정';

  @override
  String get general => '일반';

  @override
  String get language => '언어';

  @override
  String get autoRefresh => '자동 새로고침';

  @override
  String get refreshInterval => '새로고침 주기';

  @override
  String get recordingDefaults => '기본 녹화 설정';

  @override
  String get accessAndStorage => '권한 및 저장';

  @override
  String get advancedControls => '고급 제어';

  @override
  String get pausedState => '일시정지';

  @override
  String get pauseAction => '일시정지';

  @override
  String get resumeAction => '다시시작';

  @override
  String get countdown => '카운트다운';

  @override
  String get countdownState => '곧 시작';

  @override
  String get recentRecordings => '최근 녹화';

  @override
  String get audioSystemOnly => '시스템 오디오만';

  @override
  String get audioMicrophoneOnly => '마이크만';

  @override
  String get audioSystemAndMicrophone => '시스템 오디오 + 마이크';
}
