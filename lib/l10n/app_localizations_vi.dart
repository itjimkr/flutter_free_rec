// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => 'Làm mới';

  @override
  String get checkedAccess => 'Đã kiểm tra quyền truy cập.';

  @override
  String turnOnRecInSettings(Object label) {
    return 'Bật Rec trong cài đặt $label, sau đó quay lại ứng dụng và nhấn Kiểm tra lại.';
  }

  @override
  String get finishAccessSetup => 'Hoàn tất thiết lập quyền truy cập';

  @override
  String get screenSettings => 'Cài đặt Màn hình';

  @override
  String get microphoneSettings => 'Cài đặt Micrô';

  @override
  String get checkAgain => 'Kiểm tra lại';

  @override
  String get recordingStarted => 'Đã bắt đầu ghi.';

  @override
  String get recordingStopped => 'Đã dừng ghi.';

  @override
  String get guideSummaryNeedsPermission =>
      'Rec vẫn cần quyền trước khi có thể bắt đầu ghi.';

  @override
  String get guideSummaryReadyForContent =>
      'Quyền đã sẵn sàng. Hãy chọn nội dung bạn muốn ghi tiếp theo.';

  @override
  String get guideStepAllowScreen =>
      'Nhấn Cho phép truy cập, rồi cho phép ghi màn hình trong hộp thoại hệ thống.';

  @override
  String get guideStepScreenSettings =>
      'Nhấn Cài đặt Màn hình và bật quyền ghi màn hình cho Rec.';

  @override
  String get guideStepAllowMic =>
      'Nếu bạn dùng Màn hình + Micrô, hãy nhấn Cho phép khi hệ thống hỏi quyền truy cập micrô.';

  @override
  String get guideStepMicSettings =>
      'Nhấn Cài đặt Micrô và bật quyền truy cập micrô cho Rec.';

  @override
  String get guideStepPickContent =>
      'Nhấn Chọn nội dung và chọn màn hình hoặc cửa sổ bạn muốn ghi.';

  @override
  String get guideStepCheckAgain => 'Quay lại Rec và nhấn Kiểm tra lại.';

  @override
  String get recordHintTurnOnScreen => 'Bật Ghi màn hình trong Cài đặt';

  @override
  String get recordHintAllowScreen => 'Trước tiên hãy cho phép Ghi màn hình';

  @override
  String get recordHintTurnOnMicrophone => 'Bật Micrô trong Cài đặt';

  @override
  String get recordHintAllowMicrophone => 'Trước tiên hãy cho phép Micrô';

  @override
  String get recordHintPickContent => 'Chọn nội dung để ghi';

  @override
  String get tapToRecord => 'Nhấn để bắt đầu ghi';

  @override
  String get tapToStop => 'Nhấn để dừng ghi';

  @override
  String get recordAction => 'Bắt đầu ghi';

  @override
  String get stopAction => 'Dừng ghi';

  @override
  String get selectRecordTarget => 'Chọn nội dung cần ghi';

  @override
  String get specificProgramRecord => 'Ghi một ứng dụng cụ thể';

  @override
  String get fullScreenRecord => 'Ghi toàn màn hình';

  @override
  String get specificAreaRecord => 'Ghi một vùng cụ thể';

  @override
  String get selectAudioOption => 'Chọn có bao gồm âm thanh hay không';

  @override
  String get audioIncluded => 'Ghi kèm âm thanh';

  @override
  String get audioExcluded => 'Ghi không kèm âm thanh';

  @override
  String get shortcuts => 'Phím tắt';

  @override
  String get notReady => 'Chưa sẵn sàng';

  @override
  String get idleState => 'NHÀN RỖI';

  @override
  String get recordingState => 'ĐANG GHI';

  @override
  String get stoppingState => 'ĐANG DỪNG';

  @override
  String get screenOnly => 'Chỉ Màn hình';

  @override
  String get screenOnlySublabel => 'Âm thanh hệ thống';

  @override
  String get screenAndMic => 'Màn hình + Micrô';

  @override
  String get screenAndMicSublabel => 'Bao gồm micrô';

  @override
  String get setup => 'THIẾT LẬP';

  @override
  String get screen => 'Màn hình';

  @override
  String get microphone => 'Micrô';

  @override
  String get ready => 'Sẵn sàng';

  @override
  String get openSettings => 'Mở Cài đặt';

  @override
  String get needsAllow => 'Cần cho phép';

  @override
  String get optional => 'Tùy chọn';

  @override
  String get screenPermissionDetailReady => 'Ghi màn hình đã sẵn sàng.';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Android sẽ hỏi bạn muốn ghi lại nội dung nào khi bắt đầu ghi.';

  @override
  String get screenPermissionDetailDenied =>
      'Bật quyền ghi màn hình cho Rec trong Cài đặt.';

  @override
  String get screenPermissionDetailUnknown => 'Hệ thống sẽ hỏi ở lần đầu tiên.';

  @override
  String get microphonePermissionDetailReady => 'Ghi micrô đã được bật.';

  @override
  String get microphonePermissionDetailDenied =>
      'Bật quyền truy cập micrô cho Rec trong Cài đặt.';

  @override
  String get microphonePermissionDetailUnknown =>
      'Hệ thống sẽ hỏi nếu bạn dùng Màn hình + Micrô.';

  @override
  String get microphonePermissionDetailOptional =>
      'Chỉ cần cho Màn hình + Micrô.';

  @override
  String get beforeYouRecord => 'Trước khi ghi';

  @override
  String get allowAccess => 'Cho phép truy cập';

  @override
  String get pickContent => 'Chọn nội dung';

  @override
  String get contentSelected => 'Đã chọn nội dung';

  @override
  String get noContentSelected => 'Chưa chọn nội dung nào';

  @override
  String get clear => 'Xóa';

  @override
  String get change => 'Thay đổi';

  @override
  String get openInFinder => 'Mở trong Finder';

  @override
  String get openSavedFolder => 'Mở thư mục lưu';

  @override
  String get video => 'Video';

  @override
  String get frameRate => 'Tốc độ khung hình';

  @override
  String get native => 'Mặc định';

  @override
  String get codec => 'Codec';

  @override
  String get container => 'Vùng chứa';

  @override
  String get quality => 'Chất lượng';

  @override
  String get qualityLow => 'Thấp';

  @override
  String get qualityMedium => 'Trung bình';

  @override
  String get qualityHigh => 'Cao';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'Kênh alpha';

  @override
  String get nativeResolution => 'Độ phân giải gốc';

  @override
  String get audio => 'Âm thanh';

  @override
  String get systemAudio => 'Âm thanh hệ thống';

  @override
  String get micDevice => 'Thiết bị micrô';

  @override
  String get systemDefault => 'Mặc định hệ thống';

  @override
  String get unknownDevice => 'Thiết bị không xác định';

  @override
  String get display => 'Màn hình';

  @override
  String get showCursor => 'Hiện con trỏ';

  @override
  String get showWallpaper => 'Hiện hình nền';

  @override
  String get showMenuBar => 'Hiện thanh menu';

  @override
  String get showDock => 'Hiện Dock';

  @override
  String get showRecorderUi => 'Hiện giao diện ghi';

  @override
  String get windowShadows => 'Bóng cửa sổ';

  @override
  String get presenterOverlay => 'Lớp phủ người thuyết trình';

  @override
  String get enableOverlay => 'Bật lớp phủ';

  @override
  String get camera => 'Camera';

  @override
  String get capabilities => 'TÍNH NĂNG';

  @override
  String get capabilityContentPicker => 'Chọn nội dung';

  @override
  String get capabilityAreaSelection => 'Chọn vùng';

  @override
  String get capabilityPresenterOverlay => 'Lớp phủ người thuyết trình';

  @override
  String get capabilitySystemAudio => 'Âm thanh hệ thống';

  @override
  String get capabilityMicrophone => 'Micrô';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'Alpha';

  @override
  String get capabilityWindowFiltering => 'Lọc cửa sổ';

  @override
  String get settings => 'Cài đặt';

  @override
  String get general => 'Chung';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get autoRefresh => 'Tự động làm mới';

  @override
  String get refreshInterval => 'Khoảng làm mới';

  @override
  String get recordingDefaults => 'Mặc định ghi';

  @override
  String get accessAndStorage => 'Quyền truy cập và lưu trữ';

  @override
  String get advancedControls => 'Điều khiển nâng cao';

  @override
  String get pausedState => 'TẠM DỪNG';

  @override
  String get pauseAction => 'Tạm dừng';

  @override
  String get resumeAction => 'Tiếp tục';

  @override
  String get countdown => 'Đếm ngược';

  @override
  String get countdownState => 'Sắp bắt đầu';

  @override
  String get recentRecordings => 'Bản ghi gần đây';

  @override
  String get audioSystemOnly => 'Chỉ âm thanh hệ thống';

  @override
  String get audioMicrophoneOnly => 'Chỉ micrô';

  @override
  String get audioSystemAndMicrophone => 'Âm thanh hệ thống + Micrô';
}
