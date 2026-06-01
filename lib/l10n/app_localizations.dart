import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
    Locale('ja'),
    Locale('tr'),
    Locale('hi'),
    Locale('id'),
    Locale('vi'),
    Locale('th'),
    Locale('pt', 'BR'),
    Locale('it'),
    Locale('es'),
    Locale('de'),
    Locale('fr'),
    Locale('pl'),
    Locale('nl'),
    Locale('ru'),
    Locale('zh', 'TW'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Rec'**
  String get appTitle;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @checkedAccess.
  ///
  /// In en, this message translates to:
  /// **'Checked access.'**
  String get checkedAccess;

  /// No description provided for @turnOnRecInSettings.
  ///
  /// In en, this message translates to:
  /// **'Turn on Rec in {label} settings, then come back and press Check Again.'**
  String turnOnRecInSettings(Object label);

  /// No description provided for @finishAccessSetup.
  ///
  /// In en, this message translates to:
  /// **'Finish access setup'**
  String get finishAccessSetup;

  /// No description provided for @screenSettings.
  ///
  /// In en, this message translates to:
  /// **'Screen Settings'**
  String get screenSettings;

  /// No description provided for @microphoneSettings.
  ///
  /// In en, this message translates to:
  /// **'Microphone Settings'**
  String get microphoneSettings;

  /// No description provided for @checkAgain.
  ///
  /// In en, this message translates to:
  /// **'Check Again'**
  String get checkAgain;

  /// No description provided for @recordingStarted.
  ///
  /// In en, this message translates to:
  /// **'Recording started.'**
  String get recordingStarted;

  /// No description provided for @recordingStopped.
  ///
  /// In en, this message translates to:
  /// **'Recording stopped.'**
  String get recordingStopped;

  /// No description provided for @guideSummaryNeedsPermission.
  ///
  /// In en, this message translates to:
  /// **'Rec still needs permission before recording can start.'**
  String get guideSummaryNeedsPermission;

  /// No description provided for @guideSummaryReadyForContent.
  ///
  /// In en, this message translates to:
  /// **'Permissions look good. Choose what you want to record next.'**
  String get guideSummaryReadyForContent;

  /// No description provided for @guideStepAllowScreen.
  ///
  /// In en, this message translates to:
  /// **'Press Allow Access, then allow screen capture in the system prompt.'**
  String get guideStepAllowScreen;

  /// No description provided for @guideStepScreenSettings.
  ///
  /// In en, this message translates to:
  /// **'Press Screen Settings and turn on screen capture access for Rec.'**
  String get guideStepScreenSettings;

  /// No description provided for @guideStepAllowMic.
  ///
  /// In en, this message translates to:
  /// **'If you use Screen + Mic, press Allow when the system asks for microphone access.'**
  String get guideStepAllowMic;

  /// No description provided for @guideStepMicSettings.
  ///
  /// In en, this message translates to:
  /// **'Press Microphone Settings and turn on microphone access for Rec.'**
  String get guideStepMicSettings;

  /// No description provided for @guideStepPickContent.
  ///
  /// In en, this message translates to:
  /// **'Press Pick Content and choose the screen or window you want to record.'**
  String get guideStepPickContent;

  /// No description provided for @guideStepCheckAgain.
  ///
  /// In en, this message translates to:
  /// **'Come back to Rec and press Check Again.'**
  String get guideStepCheckAgain;

  /// No description provided for @recordHintTurnOnScreen.
  ///
  /// In en, this message translates to:
  /// **'Turn on Screen Recording in Settings'**
  String get recordHintTurnOnScreen;

  /// No description provided for @recordHintAllowScreen.
  ///
  /// In en, this message translates to:
  /// **'Allow Screen Recording first'**
  String get recordHintAllowScreen;

  /// No description provided for @recordHintTurnOnMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Turn on Microphone in Settings'**
  String get recordHintTurnOnMicrophone;

  /// No description provided for @recordHintAllowMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Allow Microphone first'**
  String get recordHintAllowMicrophone;

  /// No description provided for @recordHintPickContent.
  ///
  /// In en, this message translates to:
  /// **'Pick content to record'**
  String get recordHintPickContent;

  /// No description provided for @tapToRecord.
  ///
  /// In en, this message translates to:
  /// **'Tap to record'**
  String get tapToRecord;

  /// No description provided for @tapToStop.
  ///
  /// In en, this message translates to:
  /// **'Tap to stop'**
  String get tapToStop;

  /// No description provided for @recordAction.
  ///
  /// In en, this message translates to:
  /// **'Start Recording'**
  String get recordAction;

  /// No description provided for @stopAction.
  ///
  /// In en, this message translates to:
  /// **'Stop Recording'**
  String get stopAction;

  /// No description provided for @selectRecordTarget.
  ///
  /// In en, this message translates to:
  /// **'Choose what to record'**
  String get selectRecordTarget;

  /// No description provided for @specificProgramRecord.
  ///
  /// In en, this message translates to:
  /// **'Record a Specific App'**
  String get specificProgramRecord;

  /// No description provided for @fullScreenRecord.
  ///
  /// In en, this message translates to:
  /// **'Record Full Screen'**
  String get fullScreenRecord;

  /// No description provided for @specificAreaRecord.
  ///
  /// In en, this message translates to:
  /// **'Record a Specific Area'**
  String get specificAreaRecord;

  /// No description provided for @selectAudioOption.
  ///
  /// In en, this message translates to:
  /// **'Choose whether to include audio'**
  String get selectAudioOption;

  /// No description provided for @audioIncluded.
  ///
  /// In en, this message translates to:
  /// **'Record with Audio'**
  String get audioIncluded;

  /// No description provided for @audioExcluded.
  ///
  /// In en, this message translates to:
  /// **'Record without Audio'**
  String get audioExcluded;

  /// No description provided for @shortcuts.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get shortcuts;

  /// No description provided for @notReady.
  ///
  /// In en, this message translates to:
  /// **'Not ready'**
  String get notReady;

  /// No description provided for @idleState.
  ///
  /// In en, this message translates to:
  /// **'IDLE'**
  String get idleState;

  /// No description provided for @recordingState.
  ///
  /// In en, this message translates to:
  /// **'RECORDING'**
  String get recordingState;

  /// No description provided for @stoppingState.
  ///
  /// In en, this message translates to:
  /// **'STOPPING'**
  String get stoppingState;

  /// No description provided for @screenOnly.
  ///
  /// In en, this message translates to:
  /// **'Screen Only'**
  String get screenOnly;

  /// No description provided for @screenOnlySublabel.
  ///
  /// In en, this message translates to:
  /// **'System audio'**
  String get screenOnlySublabel;

  /// No description provided for @screenAndMic.
  ///
  /// In en, this message translates to:
  /// **'Screen + Mic'**
  String get screenAndMic;

  /// No description provided for @screenAndMicSublabel.
  ///
  /// In en, this message translates to:
  /// **'Include microphone'**
  String get screenAndMicSublabel;

  /// No description provided for @setup.
  ///
  /// In en, this message translates to:
  /// **'SETUP'**
  String get setup;

  /// No description provided for @screen.
  ///
  /// In en, this message translates to:
  /// **'Screen'**
  String get screen;

  /// No description provided for @microphone.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get microphone;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @needsAllow.
  ///
  /// In en, this message translates to:
  /// **'Needs Allow'**
  String get needsAllow;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @screenPermissionDetailReady.
  ///
  /// In en, this message translates to:
  /// **'Screen capture is ready.'**
  String get screenPermissionDetailReady;

  /// No description provided for @screenPermissionDetailPromptOnStart.
  ///
  /// In en, this message translates to:
  /// **'Android will ask what to record when you start recording.'**
  String get screenPermissionDetailPromptOnStart;

  /// No description provided for @screenPermissionDetailDenied.
  ///
  /// In en, this message translates to:
  /// **'Turn on screen capture access for Rec in Settings.'**
  String get screenPermissionDetailDenied;

  /// No description provided for @screenPermissionDetailUnknown.
  ///
  /// In en, this message translates to:
  /// **'The system will ask the first time.'**
  String get screenPermissionDetailUnknown;

  /// No description provided for @microphonePermissionDetailReady.
  ///
  /// In en, this message translates to:
  /// **'Microphone capture is enabled.'**
  String get microphonePermissionDetailReady;

  /// No description provided for @microphonePermissionDetailDenied.
  ///
  /// In en, this message translates to:
  /// **'Turn on microphone access for Rec in Settings.'**
  String get microphonePermissionDetailDenied;

  /// No description provided for @microphonePermissionDetailUnknown.
  ///
  /// In en, this message translates to:
  /// **'The system will ask if you use Screen + Mic.'**
  String get microphonePermissionDetailUnknown;

  /// No description provided for @microphonePermissionDetailOptional.
  ///
  /// In en, this message translates to:
  /// **'Needed only for Screen + Mic.'**
  String get microphonePermissionDetailOptional;

  /// No description provided for @beforeYouRecord.
  ///
  /// In en, this message translates to:
  /// **'Before you record'**
  String get beforeYouRecord;

  /// No description provided for @allowAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow Access'**
  String get allowAccess;

  /// No description provided for @pickContent.
  ///
  /// In en, this message translates to:
  /// **'Pick Content'**
  String get pickContent;

  /// No description provided for @contentSelected.
  ///
  /// In en, this message translates to:
  /// **'Content selected'**
  String get contentSelected;

  /// No description provided for @noContentSelected.
  ///
  /// In en, this message translates to:
  /// **'No content selected'**
  String get noContentSelected;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @openInFinder.
  ///
  /// In en, this message translates to:
  /// **'Open in Finder'**
  String get openInFinder;

  /// No description provided for @openSavedFolder.
  ///
  /// In en, this message translates to:
  /// **'Open Saved Folder'**
  String get openSavedFolder;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @frameRate.
  ///
  /// In en, this message translates to:
  /// **'Frame Rate'**
  String get frameRate;

  /// No description provided for @native.
  ///
  /// In en, this message translates to:
  /// **'Native'**
  String get native;

  /// No description provided for @codec.
  ///
  /// In en, this message translates to:
  /// **'Codec'**
  String get codec;

  /// No description provided for @container.
  ///
  /// In en, this message translates to:
  /// **'Container'**
  String get container;

  /// No description provided for @quality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get quality;

  /// No description provided for @qualityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get qualityLow;

  /// No description provided for @qualityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get qualityMedium;

  /// No description provided for @qualityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get qualityHigh;

  /// No description provided for @hdr.
  ///
  /// In en, this message translates to:
  /// **'HDR'**
  String get hdr;

  /// No description provided for @alphaChannel.
  ///
  /// In en, this message translates to:
  /// **'Alpha Channel'**
  String get alphaChannel;

  /// No description provided for @nativeResolution.
  ///
  /// In en, this message translates to:
  /// **'Native Resolution'**
  String get nativeResolution;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @systemAudio.
  ///
  /// In en, this message translates to:
  /// **'System Audio'**
  String get systemAudio;

  /// No description provided for @micDevice.
  ///
  /// In en, this message translates to:
  /// **'Mic Device'**
  String get micDevice;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @unknownDevice.
  ///
  /// In en, this message translates to:
  /// **'Unknown device'**
  String get unknownDevice;

  /// No description provided for @display.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get display;

  /// No description provided for @showCursor.
  ///
  /// In en, this message translates to:
  /// **'Show Cursor'**
  String get showCursor;

  /// No description provided for @showWallpaper.
  ///
  /// In en, this message translates to:
  /// **'Show Wallpaper'**
  String get showWallpaper;

  /// No description provided for @showMenuBar.
  ///
  /// In en, this message translates to:
  /// **'Show Menu Bar'**
  String get showMenuBar;

  /// No description provided for @showDock.
  ///
  /// In en, this message translates to:
  /// **'Show Dock'**
  String get showDock;

  /// No description provided for @showRecorderUi.
  ///
  /// In en, this message translates to:
  /// **'Show Recorder UI'**
  String get showRecorderUi;

  /// No description provided for @windowShadows.
  ///
  /// In en, this message translates to:
  /// **'Window Shadows'**
  String get windowShadows;

  /// No description provided for @presenterOverlay.
  ///
  /// In en, this message translates to:
  /// **'Presenter Overlay'**
  String get presenterOverlay;

  /// No description provided for @enableOverlay.
  ///
  /// In en, this message translates to:
  /// **'Enable Overlay'**
  String get enableOverlay;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @capabilities.
  ///
  /// In en, this message translates to:
  /// **'CAPABILITIES'**
  String get capabilities;

  /// No description provided for @capabilityContentPicker.
  ///
  /// In en, this message translates to:
  /// **'Content Picker'**
  String get capabilityContentPicker;

  /// No description provided for @capabilityAreaSelection.
  ///
  /// In en, this message translates to:
  /// **'Area Selection'**
  String get capabilityAreaSelection;

  /// No description provided for @capabilityPresenterOverlay.
  ///
  /// In en, this message translates to:
  /// **'Presenter Overlay'**
  String get capabilityPresenterOverlay;

  /// No description provided for @capabilitySystemAudio.
  ///
  /// In en, this message translates to:
  /// **'System Audio'**
  String get capabilitySystemAudio;

  /// No description provided for @capabilityMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get capabilityMicrophone;

  /// No description provided for @capabilityHdr.
  ///
  /// In en, this message translates to:
  /// **'HDR'**
  String get capabilityHdr;

  /// No description provided for @capabilityAlpha.
  ///
  /// In en, this message translates to:
  /// **'Alpha'**
  String get capabilityAlpha;

  /// No description provided for @capabilityWindowFiltering.
  ///
  /// In en, this message translates to:
  /// **'Window Filtering'**
  String get capabilityWindowFiltering;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @autoRefresh.
  ///
  /// In en, this message translates to:
  /// **'Auto Refresh'**
  String get autoRefresh;

  /// No description provided for @refreshInterval.
  ///
  /// In en, this message translates to:
  /// **'Refresh Interval'**
  String get refreshInterval;

  /// No description provided for @recordingDefaults.
  ///
  /// In en, this message translates to:
  /// **'Recording Defaults'**
  String get recordingDefaults;

  /// No description provided for @accessAndStorage.
  ///
  /// In en, this message translates to:
  /// **'Access & Storage'**
  String get accessAndStorage;

  /// No description provided for @advancedControls.
  ///
  /// In en, this message translates to:
  /// **'Advanced Controls'**
  String get advancedControls;

  /// No description provided for @pausedState.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get pausedState;

  /// No description provided for @pauseAction.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseAction;

  /// No description provided for @resumeAction.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeAction;

  /// No description provided for @countdown.
  ///
  /// In en, this message translates to:
  /// **'Countdown'**
  String get countdown;

  /// No description provided for @countdownState.
  ///
  /// In en, this message translates to:
  /// **'STARTING IN'**
  String get countdownState;

  /// No description provided for @recentRecordings.
  ///
  /// In en, this message translates to:
  /// **'Recent Recordings'**
  String get recentRecordings;

  /// No description provided for @audioSystemOnly.
  ///
  /// In en, this message translates to:
  /// **'System Audio Only'**
  String get audioSystemOnly;

  /// No description provided for @audioMicrophoneOnly.
  ///
  /// In en, this message translates to:
  /// **'Microphone Only'**
  String get audioMicrophoneOnly;

  /// No description provided for @audioSystemAndMicrophone.
  ///
  /// In en, this message translates to:
  /// **'System Audio + Microphone'**
  String get audioSystemAndMicrophone;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'nl',
    'pl',
    'pt',
    'ru',
    'th',
    'tr',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
