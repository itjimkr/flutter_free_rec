// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => 'รีเฟรช';

  @override
  String get checkedAccess => 'ตรวจสอบการเข้าถึงแล้ว';

  @override
  String turnOnRecInSettings(Object label) {
    return 'เปิด Rec ในการตั้งค่า $label แล้วกลับมาที่แอปและกดตรวจสอบอีกครั้ง';
  }

  @override
  String get finishAccessSetup => 'ตั้งค่าการเข้าถึงให้เสร็จ';

  @override
  String get screenSettings => 'การตั้งค่าหน้าจอ';

  @override
  String get microphoneSettings => 'การตั้งค่าไมโครโฟน';

  @override
  String get checkAgain => 'ตรวจสอบอีกครั้ง';

  @override
  String get recordingStarted => 'เริ่มบันทึกแล้ว';

  @override
  String get recordingStopped => 'หยุดบันทึกแล้ว';

  @override
  String get guideSummaryNeedsPermission =>
      'Rec ยังต้องขอสิทธิ์ก่อนเริ่มบันทึก';

  @override
  String get guideSummaryReadyForContent =>
      'สิทธิ์พร้อมแล้ว เลือกสิ่งที่คุณต้องการบันทึกต่อได้เลย';

  @override
  String get guideStepAllowScreen =>
      'กดอนุญาตการเข้าถึง แล้วอนุญาตการบันทึกหน้าจอในหน้าต่างของระบบ';

  @override
  String get guideStepScreenSettings =>
      'กดการตั้งค่าหน้าจอ แล้วเปิดสิทธิ์การบันทึกหน้าจอให้ Rec';

  @override
  String get guideStepAllowMic =>
      'หากใช้ หน้าจอ + ไมค์ ให้กดอนุญาตเมื่อระบบถามสิทธิ์ไมโครโฟน';

  @override
  String get guideStepMicSettings =>
      'กดการตั้งค่าไมโครโฟน แล้วเปิดสิทธิ์ไมโครโฟนให้ Rec';

  @override
  String get guideStepPickContent =>
      'กดเลือกเนื้อหา แล้วเลือกหน้าจอหรือหน้าต่างที่ต้องการบันทึก';

  @override
  String get guideStepCheckAgain => 'กลับมาที่ Rec แล้วกดตรวจสอบอีกครั้ง';

  @override
  String get recordHintTurnOnScreen => 'เปิดการบันทึกหน้าจอในตั้งค่า';

  @override
  String get recordHintAllowScreen => 'อนุญาตการบันทึกหน้าจอก่อน';

  @override
  String get recordHintTurnOnMicrophone => 'เปิดไมโครโฟนในตั้งค่า';

  @override
  String get recordHintAllowMicrophone => 'อนุญาตไมโครโฟนก่อน';

  @override
  String get recordHintPickContent => 'เลือกเนื้อหาที่จะบันทึก';

  @override
  String get tapToRecord => 'แตะเพื่อเริ่มบันทึก';

  @override
  String get tapToStop => 'แตะเพื่อหยุดบันทึก';

  @override
  String get recordAction => 'เริ่มบันทึก';

  @override
  String get stopAction => 'หยุดบันทึก';

  @override
  String get selectRecordTarget => 'เลือกสิ่งที่จะบันทึก';

  @override
  String get specificProgramRecord => 'บันทึกโปรแกรมที่ต้องการ';

  @override
  String get fullScreenRecord => 'บันทึกเต็มหน้าจอ';

  @override
  String get specificAreaRecord => 'บันทึกเฉพาะส่วนที่ต้องการ';

  @override
  String get selectAudioOption => 'เลือกว่าจะรวมเสียงหรือไม่';

  @override
  String get audioIncluded => 'บันทึกพร้อมเสียง';

  @override
  String get audioExcluded => 'บันทึกโดยไม่รวมเสียง';

  @override
  String get shortcuts => 'ปุ่มลัด';

  @override
  String get notReady => 'ยังไม่พร้อม';

  @override
  String get idleState => 'พร้อมรอ';

  @override
  String get recordingState => 'กำลังบันทึก';

  @override
  String get stoppingState => 'กำลังหยุด';

  @override
  String get screenOnly => 'เฉพาะหน้าจอ';

  @override
  String get screenOnlySublabel => 'เสียงระบบ';

  @override
  String get screenAndMic => 'หน้าจอ + ไมค์';

  @override
  String get screenAndMicSublabel => 'รวมไมโครโฟน';

  @override
  String get setup => 'การตั้งค่า';

  @override
  String get screen => 'หน้าจอ';

  @override
  String get microphone => 'ไมโครโฟน';

  @override
  String get ready => 'พร้อม';

  @override
  String get openSettings => 'เปิดการตั้งค่า';

  @override
  String get needsAllow => 'ต้องอนุญาต';

  @override
  String get optional => 'ไม่บังคับ';

  @override
  String get screenPermissionDetailReady => 'พร้อมบันทึกหน้าจอแล้ว';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Android จะถามว่าต้องการบันทึกอะไรเมื่อเริ่มบันทึก';

  @override
  String get screenPermissionDetailDenied =>
      'เปิดสิทธิ์บันทึกหน้าจอให้ Rec ในการตั้งค่า';

  @override
  String get screenPermissionDetailUnknown => 'ระบบจะถามในครั้งแรก';

  @override
  String get microphonePermissionDetailReady => 'เปิดการบันทึกไมโครโฟนแล้ว';

  @override
  String get microphonePermissionDetailDenied =>
      'เปิดสิทธิ์ไมโครโฟนให้ Rec ในการตั้งค่า';

  @override
  String get microphonePermissionDetailUnknown =>
      'ระบบจะถามหากคุณใช้ หน้าจอ + ไมค์';

  @override
  String get microphonePermissionDetailOptional =>
      'จำเป็นเฉพาะเมื่อใช้ หน้าจอ + ไมค์';

  @override
  String get beforeYouRecord => 'ก่อนเริ่มบันทึก';

  @override
  String get allowAccess => 'อนุญาตการเข้าถึง';

  @override
  String get pickContent => 'เลือกเนื้อหา';

  @override
  String get contentSelected => 'เลือกเนื้อหาแล้ว';

  @override
  String get noContentSelected => 'ยังไม่ได้เลือกเนื้อหา';

  @override
  String get clear => 'ล้าง';

  @override
  String get change => 'เปลี่ยน';

  @override
  String get openInFinder => 'เปิดใน Finder';

  @override
  String get openSavedFolder => 'เปิดโฟลเดอร์จัดเก็บ';

  @override
  String get video => 'วิดีโอ';

  @override
  String get frameRate => 'อัตราเฟรม';

  @override
  String get native => 'ค่าเริ่มต้น';

  @override
  String get codec => 'โคเด็ก';

  @override
  String get container => 'คอนเทนเนอร์';

  @override
  String get quality => 'คุณภาพ';

  @override
  String get qualityLow => 'ต่ำ';

  @override
  String get qualityMedium => 'กลาง';

  @override
  String get qualityHigh => 'สูง';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'ช่องอัลฟา';

  @override
  String get nativeResolution => 'ความละเอียดเดิม';

  @override
  String get audio => 'เสียง';

  @override
  String get systemAudio => 'เสียงระบบ';

  @override
  String get micDevice => 'อุปกรณ์ไมโครโฟน';

  @override
  String get systemDefault => 'ค่าเริ่มต้นของระบบ';

  @override
  String get unknownDevice => 'อุปกรณ์ไม่รู้จัก';

  @override
  String get display => 'จอภาพ';

  @override
  String get showCursor => 'แสดงเคอร์เซอร์';

  @override
  String get showWallpaper => 'แสดงภาพพื้นหลัง';

  @override
  String get showMenuBar => 'แสดงแถบเมนู';

  @override
  String get showDock => 'แสดง Dock';

  @override
  String get showRecorderUi => 'แสดง UI เครื่องบันทึก';

  @override
  String get windowShadows => 'เงาหน้าต่าง';

  @override
  String get presenterOverlay => 'โอเวอร์เลย์ผู้นำเสนอ';

  @override
  String get enableOverlay => 'เปิดใช้งานโอเวอร์เลย์';

  @override
  String get camera => 'กล้อง';

  @override
  String get capabilities => 'ความสามารถ';

  @override
  String get capabilityContentPicker => 'ตัวเลือกเนื้อหา';

  @override
  String get capabilityAreaSelection => 'การเลือกพื้นที่';

  @override
  String get capabilityPresenterOverlay => 'โอเวอร์เลย์ผู้นำเสนอ';

  @override
  String get capabilitySystemAudio => 'เสียงระบบ';

  @override
  String get capabilityMicrophone => 'ไมโครโฟน';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'อัลฟา';

  @override
  String get capabilityWindowFiltering => 'การกรองหน้าต่าง';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get general => 'ทั่วไป';

  @override
  String get language => 'ภาษา';

  @override
  String get autoRefresh => 'รีเฟรชอัตโนมัติ';

  @override
  String get refreshInterval => 'ช่วงเวลารีเฟรช';

  @override
  String get recordingDefaults => 'ค่าเริ่มต้นการบันทึก';

  @override
  String get accessAndStorage => 'การเข้าถึงและที่จัดเก็บ';

  @override
  String get advancedControls => 'การควบคุมขั้นสูง';

  @override
  String get pausedState => 'หยุดชั่วคราว';

  @override
  String get pauseAction => 'หยุดชั่วคราว';

  @override
  String get resumeAction => 'ดำเนินการต่อ';

  @override
  String get countdown => 'นับถอยหลัง';

  @override
  String get countdownState => 'จะเริ่มใน';

  @override
  String get recentRecordings => 'การบันทึกล่าสุด';

  @override
  String get audioSystemOnly => 'เฉพาะเสียงระบบ';

  @override
  String get audioMicrophoneOnly => 'เฉพาะไมโครโฟน';

  @override
  String get audioSystemAndMicrophone => 'เสียงระบบ + ไมโครโฟน';
}
