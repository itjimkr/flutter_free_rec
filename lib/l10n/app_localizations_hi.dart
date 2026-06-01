// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => 'रीफ़्रेश';

  @override
  String get checkedAccess => 'एक्सेस जांच लिया गया।';

  @override
  String turnOnRecInSettings(Object label) {
    return '$label सेटिंग्स में Rec चालू करें, फिर ऐप में वापस आकर दोबारा जांचें दबाएं।';
  }

  @override
  String get finishAccessSetup => 'एक्सेस सेटअप पूरा करें';

  @override
  String get screenSettings => 'स्क्रीन सेटिंग्स';

  @override
  String get microphoneSettings => 'माइक्रोफ़ोन सेटिंग्स';

  @override
  String get checkAgain => 'फिर जांचें';

  @override
  String get recordingStarted => 'रिकॉर्डिंग शुरू हो गई।';

  @override
  String get recordingStopped => 'रिकॉर्डिंग बंद हो गई।';

  @override
  String get guideSummaryNeedsPermission =>
      'रिकॉर्डिंग शुरू करने से पहले Rec को अभी भी अनुमति चाहिए।';

  @override
  String get guideSummaryReadyForContent =>
      'अनुमतियां ठीक हैं। अब चुनें कि आपको क्या रिकॉर्ड करना है।';

  @override
  String get guideStepAllowScreen =>
      'पहले एक्सेस की अनुमति दें दबाएं, फिर सिस्टम प्रॉम्प्ट में स्क्रीन कैप्चर की अनुमति दें।';

  @override
  String get guideStepScreenSettings =>
      'स्क्रीन सेटिंग्स दबाएं और Rec के लिए स्क्रीन कैप्चर एक्सेस चालू करें।';

  @override
  String get guideStepAllowMic =>
      'अगर आप स्क्रीन + माइक इस्तेमाल करते हैं, तो सिस्टम माइक्रोफ़ोन एक्सेस मांगे तो अनुमति दें दबाएं।';

  @override
  String get guideStepMicSettings =>
      'माइक्रोफ़ोन सेटिंग्स दबाएं और Rec के लिए माइक्रोफ़ोन एक्सेस चालू करें।';

  @override
  String get guideStepPickContent =>
      'सामग्री चुनें दबाएं और वह स्क्रीन या विंडो चुनें जिसे आप रिकॉर्ड करना चाहते हैं।';

  @override
  String get guideStepCheckAgain => 'Rec में वापस आएं और फिर जांचें दबाएं।';

  @override
  String get recordHintTurnOnScreen =>
      'सेटिंग्स में स्क्रीन रिकॉर्डिंग चालू करें';

  @override
  String get recordHintAllowScreen => 'पहले स्क्रीन रिकॉर्डिंग की अनुमति दें';

  @override
  String get recordHintTurnOnMicrophone => 'सेटिंग्स में माइक्रोफ़ोन चालू करें';

  @override
  String get recordHintAllowMicrophone => 'पहले माइक्रोफ़ोन की अनुमति दें';

  @override
  String get recordHintPickContent => 'रिकॉर्ड करने के लिए सामग्री चुनें';

  @override
  String get tapToRecord => 'रिकॉर्डिंग शुरू करने के लिए टैप करें';

  @override
  String get tapToStop => 'रिकॉर्डिंग रोकने के लिए टैप करें';

  @override
  String get recordAction => 'रिकॉर्डिंग शुरू करें';

  @override
  String get stopAction => 'रिकॉर्डिंग रोकें';

  @override
  String get selectRecordTarget => 'चुनें कि क्या रिकॉर्ड करना है';

  @override
  String get specificProgramRecord => 'किसी खास प्रोग्राम को रिकॉर्ड करें';

  @override
  String get fullScreenRecord => 'पूरी स्क्रीन रिकॉर्ड करें';

  @override
  String get specificAreaRecord => 'किसी खास हिस्से को रिकॉर्ड करें';

  @override
  String get selectAudioOption => 'चुनें कि ऑडियो शामिल करना है या नहीं';

  @override
  String get audioIncluded => 'ऑडियो सहित रिकॉर्ड करें';

  @override
  String get audioExcluded => 'ऑडियो के बिना रिकॉर्ड करें';

  @override
  String get shortcuts => 'शॉर्टकट';

  @override
  String get notReady => 'तैयार नहीं';

  @override
  String get idleState => 'निष्क्रिय';

  @override
  String get recordingState => 'रिकॉर्डिंग';

  @override
  String get stoppingState => 'रोक रहा है';

  @override
  String get screenOnly => 'केवल स्क्रीन';

  @override
  String get screenOnlySublabel => 'सिस्टम ऑडियो';

  @override
  String get screenAndMic => 'स्क्रीन + माइक';

  @override
  String get screenAndMicSublabel => 'माइक्रोफ़ोन शामिल करें';

  @override
  String get setup => 'सेटअप';

  @override
  String get screen => 'स्क्रीन';

  @override
  String get microphone => 'माइक्रोफ़ोन';

  @override
  String get ready => 'तैयार';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get needsAllow => 'अनुमति आवश्यक';

  @override
  String get optional => 'वैकल्पिक';

  @override
  String get screenPermissionDetailReady => 'स्क्रीन कैप्चर तैयार है।';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'Android रिकॉर्डिंग शुरू करते समय पूछेगा कि क्या रिकॉर्ड करना है।';

  @override
  String get screenPermissionDetailDenied =>
      'सेटिंग्स में Rec के लिए स्क्रीन कैप्चर एक्सेस चालू करें।';

  @override
  String get screenPermissionDetailUnknown => 'सिस्टम पहली बार पूछेगा।';

  @override
  String get microphonePermissionDetailReady => 'माइक्रोफ़ोन कैप्चर चालू है।';

  @override
  String get microphonePermissionDetailDenied =>
      'सेटिंग्स में Rec के लिए माइक्रोफ़ोन एक्सेस चालू करें।';

  @override
  String get microphonePermissionDetailUnknown =>
      'अगर आप स्क्रीन + माइक इस्तेमाल करते हैं, तो सिस्टम अनुमति मांगेगा।';

  @override
  String get microphonePermissionDetailOptional =>
      'सिर्फ स्क्रीन + माइक के लिए आवश्यक है।';

  @override
  String get beforeYouRecord => 'रिकॉर्डिंग से पहले';

  @override
  String get allowAccess => 'एक्सेस की अनुमति दें';

  @override
  String get pickContent => 'सामग्री चुनें';

  @override
  String get contentSelected => 'सामग्री चुनी गई';

  @override
  String get noContentSelected => 'कोई सामग्री नहीं चुनी गई';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get change => 'बदलें';

  @override
  String get openInFinder => 'Finder में खोलें';

  @override
  String get openSavedFolder => 'सेव फ़ोल्डर खोलें';

  @override
  String get video => 'वीडियो';

  @override
  String get frameRate => 'फ़्रेम दर';

  @override
  String get native => 'डिफ़ॉल्ट';

  @override
  String get codec => 'कोडेक';

  @override
  String get container => 'कंटेनर';

  @override
  String get quality => 'गुणवत्ता';

  @override
  String get qualityLow => 'कम';

  @override
  String get qualityMedium => 'मध्यम';

  @override
  String get qualityHigh => 'उच्च';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'अल्फ़ा चैनल';

  @override
  String get nativeResolution => 'मूल रिज़ॉल्यूशन';

  @override
  String get audio => 'ऑडियो';

  @override
  String get systemAudio => 'सिस्टम ऑडियो';

  @override
  String get micDevice => 'माइक्रोफ़ोन डिवाइस';

  @override
  String get systemDefault => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get unknownDevice => 'अज्ञात डिवाइस';

  @override
  String get display => 'डिस्प्ले';

  @override
  String get showCursor => 'कर्सर दिखाएं';

  @override
  String get showWallpaper => 'वॉलपेपर दिखाएं';

  @override
  String get showMenuBar => 'मेन्यू बार दिखाएं';

  @override
  String get showDock => 'Dock दिखाएं';

  @override
  String get showRecorderUi => 'रिकॉर्डर UI दिखाएं';

  @override
  String get windowShadows => 'विंडो शैडो';

  @override
  String get presenterOverlay => 'प्रेज़ेंटर ओवरले';

  @override
  String get enableOverlay => 'ओवरले सक्षम करें';

  @override
  String get camera => 'कैमरा';

  @override
  String get capabilities => 'क्षमताएं';

  @override
  String get capabilityContentPicker => 'सामग्री चयनकर्ता';

  @override
  String get capabilityAreaSelection => 'क्षेत्र चयन';

  @override
  String get capabilityPresenterOverlay => 'प्रेज़ेंटर ओवरले';

  @override
  String get capabilitySystemAudio => 'सिस्टम ऑडियो';

  @override
  String get capabilityMicrophone => 'माइक्रोफ़ोन';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'अल्फ़ा';

  @override
  String get capabilityWindowFiltering => 'विंडो फ़िल्टरिंग';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get general => 'सामान्य';

  @override
  String get language => 'भाषा';

  @override
  String get autoRefresh => 'ऑटो रीफ़्रेश';

  @override
  String get refreshInterval => 'रीफ़्रेश अंतराल';

  @override
  String get recordingDefaults => 'रिकॉर्डिंग डिफ़ॉल्ट';

  @override
  String get accessAndStorage => 'एक्सेस और स्टोरेज';

  @override
  String get advancedControls => 'उन्नत नियंत्रण';

  @override
  String get pausedState => 'रुका हुआ';

  @override
  String get pauseAction => 'रोकें';

  @override
  String get resumeAction => 'जारी रखें';

  @override
  String get countdown => 'काउंटडाउन';

  @override
  String get countdownState => 'शुरू होने में';

  @override
  String get recentRecordings => 'हाल की रिकॉर्डिंग';

  @override
  String get audioSystemOnly => 'केवल सिस्टम ऑडियो';

  @override
  String get audioMicrophoneOnly => 'केवल माइक्रोफ़ोन';

  @override
  String get audioSystemAndMicrophone => 'सिस्टम ऑडियो + माइक्रोफ़ोन';
}
