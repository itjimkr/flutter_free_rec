import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'l10n/app_localizations.dart';
import 'recorder_platform.dart';

void main() {
  runApp(const RecApp());
}

class RecApp extends StatefulWidget {
  const RecApp({super.key, this.locale});

  final Locale? locale;

  @override
  State<RecApp> createState() => _RecAppState();
}

class _RecAppState extends State<RecApp> {
  final RecorderPlatform _platform = const RecorderPlatform();
  late _AppPreferences _appPreferences;

  @override
  void initState() {
    super.initState();
    _appPreferences = widget.locale != null
        ? _AppPreferences.fromLocale(widget.locale)
        : _AppPreferences.initialFromDevice(
            WidgetsBinding.instance.platformDispatcher.locales,
          );
    if (widget.locale == null) {
      unawaited(_loadAppPreferences());
    }
  }

  @override
  void didUpdateWidget(covariant RecApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_sameLocale(oldWidget.locale, widget.locale)) {
      if (widget.locale != null) {
        _appPreferences = _AppPreferences.fromLocale(widget.locale);
      } else {
        _appPreferences = _AppPreferences.initialFromDevice(
          WidgetsBinding.instance.platformDispatcher.locales,
        );
        unawaited(_loadAppPreferences());
      }
    }
  }

  Future<void> _loadAppPreferences() async {
    Map<String, dynamic> saved;
    try {
      saved = await _platform.loadAppPreferences();
    } catch (error, stack) {
      debugPrint('[Rec] loadAppPreferences() failed: $error');
      debugPrint('[Rec] $stack');
      return;
    }
    _logFlutter('loadAppPreferences() => $saved');
    if (!mounted || widget.locale != null) {
      return;
    }

    final fallback = _AppPreferences.initialFromDevice(
      WidgetsBinding.instance.platformDispatcher.locales,
    );
    final next = _AppPreferences.fromStoredMap(saved, fallback: fallback);
    final requiredKeys = next.toMap().keys;
    final shouldSeedDefaults = requiredKeys.any((key) => !saved.containsKey(key));

    setState(() => _appPreferences = next);
    _logFlutter(
      'appPreferences resolved localeKey=${next.localeKey} autoRefresh=${next.autoRefreshEnabled} interval=${next.autoRefreshSeconds} countdown=${next.countdownSeconds} recent=${next.recentRecordingPaths.length}',
    );

    if (shouldSeedDefaults) {
      _logFlutter('appPreferences missing defaults, seeding native storage');
      unawaited(_saveAppPreferences(next));
    }
  }

  void _updateAppPreferences(_AppPreferences next) {
    setState(() => _appPreferences = next);
    _logFlutter(
      'updateAppPreferences localeKey=${next.localeKey} autoRefresh=${next.autoRefreshEnabled} interval=${next.autoRefreshSeconds} countdown=${next.countdownSeconds} recent=${next.recentRecordingPaths.length}',
    );
    if (widget.locale == null) {
      unawaited(_saveAppPreferences(next));
    }
  }

  Future<void> _saveAppPreferences(_AppPreferences preferences) async {
    try {
      await _platform.saveAppPreferences(preferences.toMap());
    } catch (error, stack) {
      debugPrint('[Rec] saveAppPreferences() failed: $error');
      debugPrint('[Rec] $stack');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      locale: _appPreferences.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE53935)),
        scaffoldBackgroundColor: const Color(0xFFF2F2F7),
        cardTheme: const CardThemeData(elevation: 0, color: Colors.white),
      ),
      home: _RecorderHomePage(
        appPreferences: _appPreferences,
        onUpdateAppPreferences: _updateAppPreferences,
      ),
    );
  }
}

class _AppPreferences {
  const _AppPreferences({
    required this.localeKey,
    this.autoRefreshEnabled = true,
    this.autoRefreshSeconds = 1,
    this.countdownSeconds = 3,
    this.recentRecordingPaths = const <String>[],
    this.shortcuts = const _ShortcutPreferences(),
  });

  final String localeKey;
  final bool autoRefreshEnabled;
  final int autoRefreshSeconds;
  final int countdownSeconds;
  final List<String> recentRecordingPaths;
  final _ShortcutPreferences shortcuts;

  factory _AppPreferences.fromLocale(Locale? locale) {
    return _AppPreferences(localeKey: _localeChoiceKey(locale));
  }

  factory _AppPreferences.initialFromDevice(List<Locale> deviceLocales) {
    return _AppPreferences(
      localeKey: _bestSupportedLocaleKeyFor(deviceLocales),
    );
  }

  factory _AppPreferences.fromStoredMap(
    Map<String, dynamic> map, {
    required _AppPreferences fallback,
  }) {
    final rawLocaleKey = map['localeKey'] as String?;
    final localeKey = _localeChoiceForKey(rawLocaleKey ?? '') == null
        ? fallback.localeKey
        : rawLocaleKey!;
    final autoRefreshEnabled =
        map['autoRefreshEnabled'] as bool? ?? fallback.autoRefreshEnabled;
    final autoRefreshSeconds = switch (map['autoRefreshSeconds']) {
      final int value
          when value == 1 || value == 2 || value == 5 || value == 10 =>
        value,
      final num value
          when value.toInt() == 1 ||
              value.toInt() == 2 ||
              value.toInt() == 5 ||
              value.toInt() == 10 =>
        value.toInt(),
      _ => fallback.autoRefreshSeconds,
    };
    final countdownSeconds = switch (map['countdownSeconds']) {
      final int value when value == 0 || value == 3 || value == 5 || value == 10 => value,
      final num value
          when value.toInt() == 0 ||
              value.toInt() == 3 ||
              value.toInt() == 5 ||
              value.toInt() == 10 =>
        value.toInt(),
      _ => fallback.countdownSeconds,
    };
    final recentRecordingPaths = _normalizeRecentRecordingPaths(
      map['recentRecordingPaths'],
    );
    final shortcutFallback = fallback.shortcuts;
    final shortcuts = _ShortcutPreferences.fromStoredMap(
      map,
      fallback: shortcutFallback,
    );

    return _AppPreferences(
      localeKey: localeKey,
      autoRefreshEnabled: autoRefreshEnabled,
      autoRefreshSeconds: autoRefreshSeconds,
      countdownSeconds: countdownSeconds,
      recentRecordingPaths: recentRecordingPaths,
      shortcuts: shortcuts,
    );
  }

  Locale? get locale => _localeChoiceForKey(localeKey)?.locale;

  _AppPreferences copyWith({
    String? localeKey,
    bool? autoRefreshEnabled,
    int? autoRefreshSeconds,
    int? countdownSeconds,
    List<String>? recentRecordingPaths,
    _ShortcutPreferences? shortcuts,
  }) {
    return _AppPreferences(
      localeKey: localeKey ?? this.localeKey,
      autoRefreshEnabled: autoRefreshEnabled ?? this.autoRefreshEnabled,
      autoRefreshSeconds: autoRefreshSeconds ?? this.autoRefreshSeconds,
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
      recentRecordingPaths:
          recentRecordingPaths ?? this.recentRecordingPaths,
      shortcuts: shortcuts ?? this.shortcuts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'localeKey': localeKey,
      'autoRefreshEnabled': autoRefreshEnabled,
      'autoRefreshSeconds': autoRefreshSeconds,
      'countdownSeconds': countdownSeconds,
      'recentRecordingPaths': recentRecordingPaths,
      ...shortcuts.toMap(),
    };
  }
}

List<String> _normalizeRecentRecordingPaths(dynamic raw) {
  if (raw is! List) {
    return const <String>[];
  }

  final unique = <String>{};
  final normalized = <String>[];
  for (final entry in raw.whereType<String>()) {
    final trimmed = entry.trim();
    if (trimmed.isEmpty || !unique.add(trimmed)) {
      continue;
    }
    normalized.add(trimmed);
    if (normalized.length == 5) {
      break;
    }
  }
  return normalized;
}

enum _ShortcutAction {
  recordApplication(
    'shortcutRecordApplication',
    'digit1',
  ),
  recordFullScreen(
    'shortcutRecordFullScreen',
    'digit2',
  ),
  recordArea(
    'shortcutRecordArea',
    'digit3',
  ),
  pauseResume(
    'shortcutPauseResume',
    'keyP',
  ),
  stop(
    'shortcutStop',
    'period',
  ),
  openSettings(
    'shortcutOpenSettings',
    'comma',
  ),
  openSavedFolder(
    'shortcutOpenSavedFolder',
    'keyO',
  );

  const _ShortcutAction(this.storageKey, this.defaultShortcutKeyId);

  final String storageKey;
  final String defaultShortcutKeyId;
}

class _ShortcutPreferences {
  const _ShortcutPreferences({
    this.recordApplicationKey = 'digit1',
    this.recordFullScreenKey = 'digit2',
    this.recordAreaKey = 'digit3',
    this.pauseResumeKey = 'keyP',
    this.stopKey = 'period',
    this.openSettingsKey = 'comma',
    this.openSavedFolderKey = 'keyO',
  });

  final String recordApplicationKey;
  final String recordFullScreenKey;
  final String recordAreaKey;
  final String pauseResumeKey;
  final String stopKey;
  final String openSettingsKey;
  final String openSavedFolderKey;

  factory _ShortcutPreferences.fromStoredMap(
    Map<String, dynamic> map, {
    required _ShortcutPreferences fallback,
  }) {
    final assigned = <String>{};

    String resolve(_ShortcutAction action) {
      final fallbackKeyId = fallback.keyFor(action);
      final raw = map[action.storageKey] as String?;
      final candidate = _shortcutKeyChoiceForId(raw) == null
          ? fallbackKeyId
          : raw!;
      if (assigned.add(candidate)) {
        return candidate;
      }
      final available = _firstAvailableShortcutKeyId(
        preferred: fallbackKeyId,
        used: assigned,
      );
      assigned.add(available);
      return available;
    }

    return _ShortcutPreferences(
      recordApplicationKey: resolve(_ShortcutAction.recordApplication),
      recordFullScreenKey: resolve(_ShortcutAction.recordFullScreen),
      recordAreaKey: resolve(_ShortcutAction.recordArea),
      pauseResumeKey: resolve(_ShortcutAction.pauseResume),
      stopKey: resolve(_ShortcutAction.stop),
      openSettingsKey: resolve(_ShortcutAction.openSettings),
      openSavedFolderKey: resolve(_ShortcutAction.openSavedFolder),
    );
  }

  String keyFor(_ShortcutAction action) {
    return switch (action) {
      _ShortcutAction.recordApplication => recordApplicationKey,
      _ShortcutAction.recordFullScreen => recordFullScreenKey,
      _ShortcutAction.recordArea => recordAreaKey,
      _ShortcutAction.pauseResume => pauseResumeKey,
      _ShortcutAction.stop => stopKey,
      _ShortcutAction.openSettings => openSettingsKey,
      _ShortcutAction.openSavedFolder => openSavedFolderKey,
    };
  }

  _ShortcutPreferences update(_ShortcutAction action, String shortcutKeyId) {
    final values = <_ShortcutAction, String>{
      for (final item in _ShortcutAction.values) item: keyFor(item),
    };
    final previous = values[action]!;
    _ShortcutAction? duplicatedAction;
    for (final entry in values.entries) {
      if (entry.key != action && entry.value == shortcutKeyId) {
        duplicatedAction = entry.key;
        break;
      }
    }
    if (duplicatedAction != null) {
      values[duplicatedAction] = previous;
    }
    values[action] = shortcutKeyId;
    return _ShortcutPreferences(
      recordApplicationKey: values[_ShortcutAction.recordApplication]!,
      recordFullScreenKey: values[_ShortcutAction.recordFullScreen]!,
      recordAreaKey: values[_ShortcutAction.recordArea]!,
      pauseResumeKey: values[_ShortcutAction.pauseResume]!,
      stopKey: values[_ShortcutAction.stop]!,
      openSettingsKey: values[_ShortcutAction.openSettings]!,
      openSavedFolderKey: values[_ShortcutAction.openSavedFolder]!,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _ShortcutAction.recordApplication.storageKey: recordApplicationKey,
      _ShortcutAction.recordFullScreen.storageKey: recordFullScreenKey,
      _ShortcutAction.recordArea.storageKey: recordAreaKey,
      _ShortcutAction.pauseResume.storageKey: pauseResumeKey,
      _ShortcutAction.stop.storageKey: stopKey,
      _ShortcutAction.openSettings.storageKey: openSettingsKey,
      _ShortcutAction.openSavedFolder.storageKey: openSavedFolderKey,
    };
  }
}

class _ShortcutKeyChoice {
  const _ShortcutKeyChoice({
    required this.id,
    required this.label,
    required this.key,
  });

  final String id;
  final String label;
  final LogicalKeyboardKey key;
}

const List<_ShortcutKeyChoice> _shortcutKeyChoices = <_ShortcutKeyChoice>[
  _ShortcutKeyChoice(
    id: 'digit1',
    label: '1',
    key: LogicalKeyboardKey.digit1,
  ),
  _ShortcutKeyChoice(
    id: 'digit2',
    label: '2',
    key: LogicalKeyboardKey.digit2,
  ),
  _ShortcutKeyChoice(
    id: 'digit3',
    label: '3',
    key: LogicalKeyboardKey.digit3,
  ),
  _ShortcutKeyChoice(
    id: 'digit4',
    label: '4',
    key: LogicalKeyboardKey.digit4,
  ),
  _ShortcutKeyChoice(
    id: 'digit5',
    label: '5',
    key: LogicalKeyboardKey.digit5,
  ),
  _ShortcutKeyChoice(
    id: 'digit6',
    label: '6',
    key: LogicalKeyboardKey.digit6,
  ),
  _ShortcutKeyChoice(
    id: 'digit7',
    label: '7',
    key: LogicalKeyboardKey.digit7,
  ),
  _ShortcutKeyChoice(
    id: 'digit8',
    label: '8',
    key: LogicalKeyboardKey.digit8,
  ),
  _ShortcutKeyChoice(
    id: 'digit9',
    label: '9',
    key: LogicalKeyboardKey.digit9,
  ),
  _ShortcutKeyChoice(
    id: 'digit0',
    label: '0',
    key: LogicalKeyboardKey.digit0,
  ),
  _ShortcutKeyChoice(
    id: 'keyP',
    label: 'P',
    key: LogicalKeyboardKey.keyP,
  ),
  _ShortcutKeyChoice(
    id: 'keyO',
    label: 'O',
    key: LogicalKeyboardKey.keyO,
  ),
  _ShortcutKeyChoice(
    id: 'keyR',
    label: 'R',
    key: LogicalKeyboardKey.keyR,
  ),
  _ShortcutKeyChoice(
    id: 'keyS',
    label: 'S',
    key: LogicalKeyboardKey.keyS,
  ),
  _ShortcutKeyChoice(
    id: 'keyF',
    label: 'F',
    key: LogicalKeyboardKey.keyF,
  ),
  _ShortcutKeyChoice(
    id: 'keyG',
    label: 'G',
    key: LogicalKeyboardKey.keyG,
  ),
  _ShortcutKeyChoice(
    id: 'keyA',
    label: 'A',
    key: LogicalKeyboardKey.keyA,
  ),
  _ShortcutKeyChoice(
    id: 'comma',
    label: ',',
    key: LogicalKeyboardKey.comma,
  ),
  _ShortcutKeyChoice(
    id: 'period',
    label: '.',
    key: LogicalKeyboardKey.period,
  ),
];

_ShortcutKeyChoice? _shortcutKeyChoiceForId(String? id) {
  if (id == null) {
    return null;
  }
  for (final choice in _shortcutKeyChoices) {
    if (choice.id == id) {
      return choice;
    }
  }
  return null;
}

String _firstAvailableShortcutKeyId({
  required String preferred,
  required Set<String> used,
}) {
  if (!used.contains(preferred)) {
    return preferred;
  }
  for (final choice in _shortcutKeyChoices) {
    if (!used.contains(choice.id)) {
      return choice.id;
    }
  }
  return preferred;
}

bool _sameLocale(Locale? a, Locale? b) {
  return a?.languageCode == b?.languageCode && a?.countryCode == b?.countryCode;
}

class _LocaleChoice {
  const _LocaleChoice({required this.key, required this.label, this.locale});

  final String key;
  final String label;
  final Locale? locale;
}

const List<_LocaleChoice> _supportedLocaleChoices = <_LocaleChoice>[
  _LocaleChoice(key: 'en', label: 'English', locale: Locale('en')),
  _LocaleChoice(key: 'ko', label: '한국어', locale: Locale('ko')),
  _LocaleChoice(key: 'ja', label: '日本語', locale: Locale('ja')),
  _LocaleChoice(key: 'tr', label: 'Türkçe', locale: Locale('tr')),
  _LocaleChoice(key: 'hi', label: 'हिन्दी', locale: Locale('hi')),
  _LocaleChoice(key: 'id', label: 'Bahasa Indonesia', locale: Locale('id')),
  _LocaleChoice(key: 'vi', label: 'Tiếng Việt', locale: Locale('vi')),
  _LocaleChoice(key: 'th', label: 'ไทย', locale: Locale('th')),
  _LocaleChoice(
    key: 'pt_BR',
    label: 'Português (Brasil)',
    locale: Locale('pt', 'BR'),
  ),
  _LocaleChoice(key: 'it', label: 'Italiano', locale: Locale('it')),
  _LocaleChoice(key: 'es', label: 'Español', locale: Locale('es')),
  _LocaleChoice(key: 'de', label: 'Deutsch', locale: Locale('de')),
  _LocaleChoice(key: 'fr', label: 'Français', locale: Locale('fr')),
  _LocaleChoice(key: 'pl', label: 'Polski', locale: Locale('pl')),
  _LocaleChoice(key: 'nl', label: 'Nederlands', locale: Locale('nl')),
  _LocaleChoice(key: 'ru', label: 'Русский', locale: Locale('ru')),
  _LocaleChoice(key: 'zh_TW', label: '繁體中文', locale: Locale('zh', 'TW')),
];

String _localeChoiceKey(Locale? locale) {
  if (locale == null) {
    return 'system';
  }
  return locale.countryCode == null
      ? locale.languageCode
      : '${locale.languageCode}_${locale.countryCode}';
}

_LocaleChoice? _localeChoiceForKey(String key) {
  if (key == 'system') {
    return const _LocaleChoice(key: 'system', label: '');
  }

  for (final choice in _supportedLocaleChoices) {
    if (choice.key == key) {
      return choice;
    }
  }
  return null;
}

String _bestSupportedLocaleKeyFor(List<Locale> deviceLocales) {
  for (final locale in deviceLocales) {
    final exactKey = _localeChoiceKey(locale);
    if (_localeChoiceForKey(exactKey) != null) {
      return exactKey;
    }

    if (locale.languageCode == 'zh') {
      final country = locale.countryCode?.toUpperCase();
      final isTraditional =
          locale.scriptCode == 'Hant' ||
          country == 'TW' ||
          country == 'HK' ||
          country == 'MO';
      if (isTraditional) {
        return 'zh_TW';
      }
      continue;
    }

    for (final choice in _supportedLocaleChoices) {
      if (choice.locale?.languageCode == locale.languageCode) {
        return choice.key;
      }
    }
  }

  return 'en';
}

List<_LocaleChoice> _localizedLocaleChoices(AppLocalizations l10n) {
  return <_LocaleChoice>[
    _LocaleChoice(key: 'system', label: l10n.systemDefault),
    ..._supportedLocaleChoices.where((choice) => choice.locale != null),
  ];
}

extension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

void _logFlutter(String message) {
  if (!kDebugMode) {
    return;
  }
  debugPrint('[Rec][Flutter] $message');
}

String _screenPermissionDetail(
  AppLocalizations l10n,
  RecorderSnapshot snapshot,
) {
  final permissions = snapshot.permissions;
  if (permissions.isScreenPromptOnStart) {
    return l10n.screenPermissionDetailPromptOnStart;
  }
  if (permissions.isScreenReady) {
    return l10n.screenPermissionDetailReady;
  }
  if (permissions.isScreenDenied) {
    return l10n.screenPermissionDetailDenied;
  }
  return l10n.screenPermissionDetailUnknown;
}

String _microphonePermissionDetail(
  AppLocalizations l10n,
  RecorderSnapshot snapshot,
) {
  final permissions = snapshot.permissions;
  if (permissions.isMicrophoneGranted) {
    return l10n.microphonePermissionDetailReady;
  }
  if (permissions.isMicrophoneDenied) {
    return l10n.microphonePermissionDetailDenied;
  }
  return l10n.microphonePermissionDetailUnknown;
}

String _recordingStateLabel(AppLocalizations l10n, String state) {
  return switch (state) {
    'recording' => l10n.recordingState,
    'paused' => l10n.pausedState,
    'stopping' => l10n.stoppingState,
    _ => l10n.idleState,
  };
}

String _videoQualityLabel(AppLocalizations l10n, String value) {
  return switch (value) {
    'Low' => l10n.qualityLow,
    'Medium' => l10n.qualityMedium,
    'High' => l10n.qualityHigh,
    _ => value,
  };
}

String _deviceNameOrFallback(
  AppLocalizations l10n,
  String? id,
  List<DeviceOption> devices,
) {
  if (id == null) {
    return l10n.systemDefault;
  }

  return devices
      .firstWhere(
        (device) => device.id == id,
        orElse: () => DeviceOption(id: '', name: l10n.unknownDevice),
      )
      .name;
}

String _recordingTargetLabel(AppLocalizations l10n, _RecordingTarget target) {
  return switch (target) {
    _RecordingTarget.application => l10n.specificProgramRecord,
    _RecordingTarget.fullScreen => l10n.fullScreenRecord,
    _RecordingTarget.area => l10n.specificAreaRecord,
  };
}

String _audioChoiceLabel(AppLocalizations l10n, _RecordingAudioChoice choice) {
  return switch (choice) {
    _RecordingAudioChoice.none => l10n.audioExcluded,
    _RecordingAudioChoice.systemOnly => l10n.audioSystemOnly,
    _RecordingAudioChoice.microphoneOnly => l10n.audioMicrophoneOnly,
    _RecordingAudioChoice.systemAndMicrophone =>
      l10n.audioSystemAndMicrophone,
  };
}

String _shortcutActionLabel(AppLocalizations l10n, _ShortcutAction action) {
  return switch (action) {
    _ShortcutAction.recordApplication =>
      _recordingTargetLabel(l10n, _RecordingTarget.application),
    _ShortcutAction.recordFullScreen =>
      _recordingTargetLabel(l10n, _RecordingTarget.fullScreen),
    _ShortcutAction.recordArea =>
      _recordingTargetLabel(l10n, _RecordingTarget.area),
    _ShortcutAction.pauseResume =>
      '${l10n.pauseAction} / ${l10n.resumeAction}',
    _ShortcutAction.stop => l10n.stopAction,
    _ShortcutAction.openSettings => l10n.openSettings,
    _ShortcutAction.openSavedFolder => l10n.openSavedFolder,
  };
}

String _shortcutDisplayLabel(String shortcutKeyId) {
  final choice = _shortcutKeyChoiceForId(shortcutKeyId);
  return choice == null ? shortcutKeyId : 'Cmd/Ctrl + ${choice.label}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────────────────────────────────────

class _RecorderHomePage extends StatefulWidget {
  const _RecorderHomePage({
    required this.appPreferences,
    required this.onUpdateAppPreferences,
  });

  final _AppPreferences appPreferences;
  final ValueChanged<_AppPreferences> onUpdateAppPreferences;

  @override
  State<_RecorderHomePage> createState() => _RecorderHomePageState();
}

class _RecorderHomePageState extends State<_RecorderHomePage> {
  static const List<int> _frameRates = <int>[0, 24, 30, 60];
  static const List<String> _videoCodecs = <String>[
    'H.264',
    'H.265',
    'ProRes 422',
    'ProRes 4444',
  ];
  static const List<String> _containerFormats = <String>['mov', 'mp4'];
  static const List<String> _videoQualities = <String>['Low', 'Medium', 'High'];
  static const List<String> _audioCodecs = <String>['AAC', 'PCM'];

  final RecorderPlatform _platform = const RecorderPlatform();

  RecorderSnapshot? _snapshot;
  Timer? _refreshTimer;
  bool _loading = true;
  String? _actionError;
  int? _countdownValue;

  @override
  void initState() {
    super.initState();
    _snapshot = RecorderSnapshot.fallback(defaultTargetPlatform);
    _loading = defaultTargetPlatform == TargetPlatform.macOS;
    _refresh();
    _restartRefreshTimer();
  }

  @override
  void didUpdateWidget(covariant _RecorderHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.appPreferences.autoRefreshEnabled !=
            widget.appPreferences.autoRefreshEnabled ||
        oldWidget.appPreferences.autoRefreshSeconds !=
            widget.appPreferences.autoRefreshSeconds) {
      _restartRefreshTimer();
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _restartRefreshTimer() {
    _refreshTimer?.cancel();
    if (!widget.appPreferences.autoRefreshEnabled) {
      _refreshTimer = null;
      return;
    }

    _refreshTimer = Timer.periodic(
      Duration(seconds: widget.appPreferences.autoRefreshSeconds),
      (_) => _refresh(silent: true),
    );
  }

  Future<void> _refresh({bool silent = false}) async {
    if (!silent) setState(() => _loading = true);
    try {
      final snapshot = await _platform.snapshot();
      if (!mounted) return;
      _rememberRecentRecording(snapshot.lastSavedRecordingPath);
      setState(() {
        _snapshot = snapshot;
        _loading = false;
        _actionError = null;
      });
    } catch (error, stack) {
      debugPrint('[Rec] snapshot() failed: $error');
      debugPrint('[Rec] $stack');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _actionError = error.toString();
      });
    }
  }

  Future<void> _runAction(
    Future<RecorderSnapshot> Function() action, {
    String? successMessage,
  }) async {
    await _runActionForSnapshot(action, successMessage: successMessage);
  }

  Future<RecorderSnapshot?> _runActionForSnapshot(
    Future<RecorderSnapshot> Function() action, {
    String? successMessage,
  }) async {
    try {
      final snapshot = await action();
      if (!mounted) return null;
      _rememberRecentRecording(snapshot.lastSavedRecordingPath);
      setState(() {
        _snapshot = snapshot;
        _actionError = null;
      });
      final message =
          successMessage ??
          snapshot.lastSavedRecordingPath ??
          snapshot.lastErrorMessage;
      if (message != null && message.isNotEmpty) _showMessage(message);
      return snapshot;
    } catch (error, stack) {
      debugPrint('[Rec] action failed: $error');
      debugPrint('[Rec] $stack');
      if (!mounted) return null;
      setState(() => _actionError = error.toString());
      _showMessage(error.toString());
      return null;
    }
  }

  Future<RecorderSnapshot?> _handlePermissionRequest() async {
    return _requestPermissions(showFollowupDialog: true);
  }

  Future<RecorderSnapshot?> _requestPermissions({
    required bool showFollowupDialog,
  }) async {
    final snapshot = _snapshot;
    if (snapshot == null) return null;
    final l10n = context.l10n;
    _logFlutter(
      'requestPermissions(showFollowupDialog=$showFollowupDialog, captureMicrophone=${snapshot.settings.captureMicrophone})',
    );

    final updated = await _runActionForSnapshot(
      _platform.requestPermissions,
      successMessage: l10n.checkedAccess,
    );
    if (!mounted || updated == null) return null;

    final guide = _RecordingPreparationGuide.fromSnapshot(updated);
    if (!guide.hasPermissionAttention || !showFollowupDialog) {
      _logFlutter(
        'permission request finished; attention=${guide.hasPermissionAttention}',
      );
      return updated;
    }

    _logFlutter(
      'permission request still needs attention; opening help dialog',
    );
    await _showPermissionHelpDialog(updated);
    return updated;
  }

  Future<RecorderSnapshot?> _openPermissionSettings(
    _PermissionTarget target,
  ) async {
    final l10n = context.l10n;
    final action = target == _PermissionTarget.screen
        ? _platform.openScreenRecordingSettings
        : _platform.openMicrophoneSettings;
    final updated = await _runActionForSnapshot(action);
    if (!mounted || updated == null) return null;

    final label = target == _PermissionTarget.screen
        ? l10n.screenSettings
        : l10n.microphoneSettings;
    _logFlutter('opened native permission settings target=$target');
    _showMessage(l10n.turnOnRecInSettings(label));
    return updated;
  }

  Future<void> _openSettingsPage() async {
    final snapshot = _snapshot;
    if (snapshot == null) return;

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => _SettingsPage(
          initialSnapshot: snapshot,
          appPreferences: widget.appPreferences,
          frameRates: _frameRates,
          videoCodecs: _videoCodecs,
          containerFormats: _containerFormats,
          videoQualities: _videoQualities,
          audioCodecs: _audioCodecs,
          onUpdateAppPreferences: widget.onUpdateAppPreferences,
          onUpdateSetting: (changes) =>
              _runActionForSnapshot(() => _platform.updateSettings(changes)),
          onRequestPermissions: _handlePermissionRequest,
          onOpenScreenRecordingSettings: () =>
              _openPermissionSettings(_PermissionTarget.screen),
          onOpenMicrophoneSettings: () =>
              _openPermissionSettings(_PermissionTarget.microphone),
          onRefreshSnapshot: () => _runActionForSnapshot(_platform.snapshot),
          onChooseOutputDirectory: snapshot.isMacRecorder
              ? () => _runActionForSnapshot(_platform.chooseOutputDirectory)
              : null,
          onOpenOutputFolder: snapshot.isMacRecorder
              ? () => _runActionForSnapshot(_platform.openOutputFolder)
              : null,
        ),
      ),
    );
  }

  void _rememberRecentRecording(String? path) {
    if (path == null || path.isEmpty) {
      return;
    }
    final existing = widget.appPreferences.recentRecordingPaths;
    if (existing.isNotEmpty && existing.first == path) {
      return;
    }
    final next = <String>[
      path,
      ...existing.where((entry) => entry != path),
    ];
    widget.onUpdateAppPreferences(
      widget.appPreferences.copyWith(
        recentRecordingPaths: next.take(5).toList(growable: false),
      ),
    );
  }

  Future<bool> _runCountdownIfNeeded() async {
    final seconds = widget.appPreferences.countdownSeconds;
    if (seconds <= 0) {
      return true;
    }

    _logFlutter('countdown begin seconds=$seconds');
    for (var remaining = seconds; remaining > 0; remaining--) {
      if (!mounted) {
        return false;
      }
      setState(() => _countdownValue = remaining);
      await Future<void>.delayed(const Duration(seconds: 1));
    }
    if (!mounted) {
      return false;
    }
    setState(() => _countdownValue = null);
    _logFlutter('countdown finished');
    return true;
  }

  Future<void> _startRecordingWithCountdown(RecorderSnapshot snapshot) async {
    final ready = await _runCountdownIfNeeded();
    if (!mounted || !ready) {
      return;
    }
    await _runAction(
      () => _platform.startRecording(snapshot.settings.toMap()),
      successMessage: context.l10n.recordingStarted,
    );
  }

  Future<void> _handlePauseOrResumeAction() async {
    if (_countdownValue != null) {
      return;
    }
    final snapshot = await _runActionForSnapshot(_platform.snapshot);
    if (!mounted ||
        snapshot == null ||
        !snapshot.hasActiveRecording ||
        !snapshot.capabilities.pauseResume) {
      return;
    }

    if (snapshot.isPaused) {
      _logFlutter('resume action requested');
      await _runAction(_platform.resumeRecording);
      return;
    }

    _logFlutter('pause action requested');
    await _runAction(_platform.pauseRecording);
  }

  Future<void> _openRecentRecording(String path) async {
    await _runAction(() => _platform.revealRecording(path));
  }

  Future<void> _showPermissionHelpDialog(RecorderSnapshot snapshot) {
    final guide = _RecordingPreparationGuide.fromSnapshot(snapshot);
    final l10n = context.l10n;
    final steps = guide.steps(l10n);
    _logFlutter(
      'showPermissionHelpDialog(screenDenied=${guide.screenDenied}, micDenied=${guide.microphoneDenied}, steps=${steps.length})',
    );
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.finishAccessSetup),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(guide.summary(l10n)),
              const SizedBox(height: 12),
              for (var index = 0; index < steps.length; index++) ...<Widget>[
                Text('${index + 1}. ${steps[index]}'),
                if (index != steps.length - 1) const SizedBox(height: 8),
              ],
            ],
          ),
          actions: <Widget>[
            if (guide.screenDenied)
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _openPermissionSettings(_PermissionTarget.screen);
                },
                child: Text(l10n.screenSettings),
              ),
            if (guide.microphoneDenied)
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _openPermissionSettings(_PermissionTarget.microphone);
                },
                child: Text(l10n.microphoneSettings),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _refresh();
              },
              child: Text(l10n.checkAgain),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handlePrimaryRecordAction() async {
    if (_countdownValue != null) {
      return;
    }
    _logFlutter('primary action tapped');
    final initialSnapshot = await _runActionForSnapshot(_platform.snapshot);
    if (!mounted || initialSnapshot == null) return;
    _logFlutter(
      'primary action snapshot state=${initialSnapshot.state} canStart=${initialSnapshot.canStartRecording} selected=${initialSnapshot.hasContentSelected}',
    );

    if (initialSnapshot.hasActiveRecording) {
      await _handleStopShortcut();
      return;
    }

    if (initialSnapshot.isSimpleMobileRecorder) {
      await _handleMobileRecordAction(initialSnapshot);
      return;
    }

    final target = await _showRecordingTargetDialog();
    if (!mounted || target == null) {
      _logFlutter('recording target dialog dismissed');
      return;
    }

    final audioChoice = await _showAudioChoiceDialog(initialSnapshot);
    if (!mounted || audioChoice == null) {
      _logFlutter('audio choice dialog dismissed');
      return;
    }

    await _beginRecordingFlow(target: target, audioChoice: audioChoice);
  }

  Future<void> _handleMobileRecordAction(RecorderSnapshot snapshot) async {
    _logFlutter('mobile record flow requested platform=${snapshot.platform}');
    final audioChoice = await _showAudioChoiceDialog(snapshot);
    if (!mounted || audioChoice == null) {
      _logFlutter('audio choice dialog dismissed for mobile flow');
      return;
    }

    await _beginMobileRecordingFlow(audioChoice: audioChoice);
  }

  Future<void> _handleShortcutRecording(_RecordingTarget target) async {
    if (_countdownValue != null) {
      return;
    }
    _logFlutter('shortcut recording requested target=$target');
    final snapshot = await _runActionForSnapshot(_platform.snapshot);
    if (!mounted || snapshot == null) return;
    if (snapshot.hasActiveRecording) {
      _logFlutter('shortcut recording ignored because recording is active');
      return;
    }

    final audioChoice = await _showAudioChoiceDialog(snapshot);
    if (!mounted || audioChoice == null) {
      _logFlutter('audio choice dialog dismissed for shortcut');
      return;
    }

    await _beginRecordingFlow(target: target, audioChoice: audioChoice);
  }

  Future<void> _handleStopShortcut() async {
    if (_countdownValue != null) {
      return;
    }
    final snapshot = await _runActionForSnapshot(_platform.snapshot);
    if (!mounted || snapshot == null || !snapshot.hasActiveRecording) {
      return;
    }

    _logFlutter('stop shortcut requested');
    await _runAction(
      _platform.stopRecording,
      successMessage: context.l10n.recordingStopped,
    );
  }

  Future<void> _beginRecordingFlow({
    required _RecordingTarget target,
    required _RecordingAudioChoice audioChoice,
  }) async {
    final l10n = context.l10n;
    final initialSnapshot = await _runActionForSnapshot(_platform.snapshot);
    if (!mounted || initialSnapshot == null) return;

    RecorderSnapshot snapshot = initialSnapshot;
    _logFlutter(
      'beginRecordingFlow target=$target audioChoice=$audioChoice state=${snapshot.state} selected=${snapshot.hasContentSelected}',
    );

    if (snapshot.hasContentSelected) {
      final cleared = await _runActionForSnapshot(_platform.clearSelection);
      if (!mounted || cleared == null) return;
      snapshot = cleared;
    }

    final captureSystemAudio = audioChoice.captureSystemAudio;
    final captureMicrophone = audioChoice.captureMicrophone;
    if (snapshot.settings.captureSystemAudio != captureSystemAudio ||
        snapshot.settings.captureMicrophone != captureMicrophone) {
      final updated = await _runActionForSnapshot(
        () => _platform.updateSettings(<String, dynamic>{
          'captureSystemAudio': captureSystemAudio,
          'captureMicrophone': captureMicrophone,
        }),
      );
      if (!mounted || updated == null) return;
      snapshot = updated;
    }

    while (mounted) {
      final guide = _RecordingPreparationGuide.fromSnapshot(snapshot);
      if (!guide.hasPermissionAttention) {
        break;
      }

      final action = await _showRecordingPreparationDialog(snapshot);
      if (!mounted || action == null) {
        _logFlutter('preparation dialog dismissed without action');
        return;
      }
      _logFlutter('preparation dialog action=$action');

      switch (action) {
        case _PreparationDialogAction.allowAccess:
          final updated = await _requestPermissions(showFollowupDialog: false);
          if (!mounted || updated == null) return;
          snapshot = updated;
          break;
        case _PreparationDialogAction.screenSettings:
          await _openPermissionSettings(_PermissionTarget.screen);
          return;
        case _PreparationDialogAction.microphoneSettings:
          await _openPermissionSettings(_PermissionTarget.microphone);
          return;
        case _PreparationDialogAction.checkAgain:
          final updated = await _runActionForSnapshot(
            _platform.snapshot,
            successMessage: l10n.checkedAccess,
          );
          if (!mounted || updated == null) return;
          snapshot = updated;
          break;
      }
    }

    final selectedSnapshot = await _selectRecordingTarget(target);
    if (!mounted || selectedSnapshot == null) {
      return;
    }

    if (selectedSnapshot.isRecording) {
      _logFlutter('recording started natively after target selection');
      return;
    }

    if (selectedSnapshot.canStartRecording) {
      _logFlutter(
        'target selected and ready; starting recording from Flutter with countdown=${widget.appPreferences.countdownSeconds}',
      );
      await _startRecordingWithCountdown(selectedSnapshot);
      return;
    }

    if (!selectedSnapshot.hasContentSelected) {
      _logFlutter('target selection finished without content');
      return;
    }

    _logFlutter('snapshot still not ready after target selection');
    _showMessage(
      _RecordingPreparationGuide.fromSnapshot(
        selectedSnapshot,
      ).recordHint(l10n, selectedSnapshot),
    );
  }

  Future<void> _beginMobileRecordingFlow({
    required _RecordingAudioChoice audioChoice,
  }) async {
    final l10n = context.l10n;
    final initialSnapshot = await _runActionForSnapshot(_platform.snapshot);
    if (!mounted || initialSnapshot == null) {
      return;
    }

    RecorderSnapshot snapshot = initialSnapshot;
    _logFlutter(
      'beginMobileRecordingFlow audioChoice=$audioChoice state=${snapshot.state}',
    );

    final captureSystemAudio = audioChoice.captureSystemAudio;
    final captureMicrophone = audioChoice.captureMicrophone;
    if (snapshot.settings.captureSystemAudio != captureSystemAudio ||
        snapshot.settings.captureMicrophone != captureMicrophone) {
      final updated = await _runActionForSnapshot(
        () => _platform.updateSettings(<String, dynamic>{
          'captureSystemAudio': captureSystemAudio,
          'captureMicrophone': captureMicrophone,
        }),
      );
      if (!mounted || updated == null) {
        return;
      }
      snapshot = updated;
    }

    while (mounted) {
      final guide = _RecordingPreparationGuide.fromSnapshot(snapshot);
      if (!guide.hasPermissionAttention) {
        break;
      }

      final action = await _showRecordingPreparationDialog(snapshot);
      if (!mounted || action == null) {
        _logFlutter('mobile preparation dialog dismissed without action');
        return;
      }
      _logFlutter('mobile preparation dialog action=$action');

      switch (action) {
        case _PreparationDialogAction.allowAccess:
          final updated = await _requestPermissions(showFollowupDialog: false);
          if (!mounted || updated == null) {
            return;
          }
          snapshot = updated;
          break;
        case _PreparationDialogAction.screenSettings:
          await _openPermissionSettings(_PermissionTarget.screen);
          return;
        case _PreparationDialogAction.microphoneSettings:
          await _openPermissionSettings(_PermissionTarget.microphone);
          return;
        case _PreparationDialogAction.checkAgain:
          final updated = await _runActionForSnapshot(
            _platform.snapshot,
            successMessage: l10n.checkedAccess,
          );
          if (!mounted || updated == null) {
            return;
          }
          snapshot = updated;
          break;
      }
    }

    await _startRecordingWithCountdown(snapshot);
  }

  Future<RecorderSnapshot?> _selectRecordingTarget(_RecordingTarget target) {
    _logFlutter('selectRecordingTarget target=$target');
    return switch (target) {
      _RecordingTarget.application => _runActionForSnapshot(
        () => _platform.presentPicker(
          autoStartRecording: false,
          selectionMode: PickerSelectionMode.application,
        ),
      ),
      _RecordingTarget.fullScreen => _runActionForSnapshot(
        () => _platform.presentPicker(
          autoStartRecording: false,
          selectionMode: PickerSelectionMode.display,
        ),
      ),
      _RecordingTarget.area => _runActionForSnapshot(
        () => _platform.presentAreaSelection(autoStartRecording: false),
      ),
    };
  }

  Future<_RecordingTarget?> _showRecordingTargetDialog() {
    final l10n = context.l10n;
    return showDialog<_RecordingTarget>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          key: const ValueKey<String>('record_target_dialog'),
          title: Text(l10n.selectRecordTarget),
          children: <Widget>[
            SimpleDialogOption(
              key: const ValueKey<String>('record_target_application'),
              onPressed: () =>
                  Navigator.of(dialogContext).pop(_RecordingTarget.application),
              child: Text(
                _recordingTargetLabel(l10n, _RecordingTarget.application),
              ),
            ),
            SimpleDialogOption(
              key: const ValueKey<String>('record_target_full_screen'),
              onPressed: () =>
                  Navigator.of(dialogContext).pop(_RecordingTarget.fullScreen),
              child: Text(
                _recordingTargetLabel(l10n, _RecordingTarget.fullScreen),
              ),
            ),
            SimpleDialogOption(
              key: const ValueKey<String>('record_target_area'),
              onPressed: () =>
                  Navigator.of(dialogContext).pop(_RecordingTarget.area),
              child: Text(_recordingTargetLabel(l10n, _RecordingTarget.area)),
            ),
          ],
        );
      },
    );
  }

  Future<_RecordingAudioChoice?> _showAudioChoiceDialog(
    RecorderSnapshot snapshot,
  ) {
    final l10n = context.l10n;
    final options = _availableAudioChoices(snapshot);
    if (options.length == 1) {
      return Future<_RecordingAudioChoice?>.value(options.single);
    }
    return showDialog<_RecordingAudioChoice>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          key: const ValueKey<String>('audio_choice_dialog'),
          title: Text(l10n.selectAudioOption),
          children: options
              .map(
                (choice) => SimpleDialogOption(
                  key: ValueKey<String>('audio_choice_${choice.storageKey}'),
                  onPressed: () => Navigator.of(dialogContext).pop(choice),
                  child: Text(_audioChoiceLabel(l10n, choice)),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }

  Future<void> _showShortcutsDialog() {
    final l10n = context.l10n;
    final material = MaterialLocalizations.of(context);
    var shortcuts = widget.appPreferences.shortcuts;

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              key: const ValueKey<String>('shortcuts_dialog'),
              title: Text(l10n.shortcuts),
              content: SizedBox(
                width: 460,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _ShortcutAction.values
                      .map(
                        (action) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(_shortcutActionLabel(l10n, action)),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 150,
                                child: DropdownButtonFormField<String>(
                                  key: ValueKey<String>(
                                    '${action.storageKey}_${shortcuts.keyFor(action)}',
                                  ),
                                  initialValue: shortcuts.keyFor(action),
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  items: _shortcutKeyChoices
                                      .map(
                                        (choice) => DropdownMenuItem<String>(
                                          value: choice.id,
                                          child: Text(
                                            _shortcutDisplayLabel(choice.id),
                                          ),
                                        ),
                                      )
                                      .toList(growable: false),
                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }
                                    final updated = shortcuts.update(
                                      action,
                                      value,
                                    );
                                    setDialogState(() => shortcuts = updated);
                                    widget.onUpdateAppPreferences(
                                      widget.appPreferences.copyWith(
                                        shortcuts: updated,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(material.okButtonLabel),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<_PreparationDialogAction?> _showRecordingPreparationDialog(
    RecorderSnapshot snapshot,
  ) {
    final guide = _RecordingPreparationGuide.fromSnapshot(snapshot);
    final l10n = context.l10n;
    final steps = guide.steps(l10n);
    _logFlutter(
      'showRecordingPreparationDialog(screenDenied=${guide.screenDenied}, micDenied=${guide.microphoneDenied}, needsContentSelection=${guide.needsContentSelection})',
    );

    return showDialog<_PreparationDialogAction>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.beforeYouRecord),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(guide.summary(l10n)),
                const SizedBox(height: 12),
                for (var index = 0; index < steps.length; index++) ...<Widget>[
                  Text('${index + 1}. ${steps[index]}'),
                  if (index != steps.length - 1) const SizedBox(height: 8),
                ],
              ],
            ),
          ),
          actions: <Widget>[
            if (guide.hasUnknownPermissions)
              TextButton(
                key: const ValueKey<String>('permission_dialog_allow_access'),
                onPressed: () => Navigator.of(
                  dialogContext,
                ).pop(_PreparationDialogAction.allowAccess),
                child: Text(l10n.allowAccess),
              ),
            if (guide.screenDenied)
              TextButton(
                key: const ValueKey<String>(
                  'permission_dialog_screen_settings',
                ),
                onPressed: () => Navigator.of(
                  dialogContext,
                ).pop(_PreparationDialogAction.screenSettings),
                child: Text(l10n.screenSettings),
              ),
            if (guide.microphoneDenied)
              TextButton(
                key: const ValueKey<String>(
                  'permission_dialog_microphone_settings',
                ),
                onPressed: () => Navigator.of(
                  dialogContext,
                ).pop(_PreparationDialogAction.microphoneSettings),
                child: Text(l10n.microphoneSettings),
              ),
            TextButton(
              key: const ValueKey<String>('permission_dialog_check_again'),
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(_PreparationDialogAction.checkAgain),
              child: Text(l10n.checkAgain),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMinimalHome(RecorderSnapshot snapshot) {
    if (snapshot.isSimpleMobileRecorder) {
      return _buildMinimalMobileHome(snapshot);
    }

    return _buildMinimalDesktopHome(snapshot);
  }

  Widget _buildMinimalDesktopHome(RecorderSnapshot snapshot) {
    final l10n = context.l10n;
    final isRecording = snapshot.hasActiveRecording;
    final isPaused = snapshot.isPaused;
    final isStopping = snapshot.state == 'stopping';
    final controlsLocked = isStopping || _countdownValue != null;
    final primaryLabel = switch (snapshot.state) {
      'stopping' => l10n.stoppingState,
      _ when isRecording => l10n.stopAction,
      _ => l10n.recordAction,
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _MinimalRecordingStatus(
                snapshot: snapshot,
                countdownValue: _countdownValue,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 72,
                child: ElevatedButton.icon(
                  key: ValueKey<String>(
                    isRecording ? 'primary_stop' : 'primary_record',
                  ),
                  onPressed: controlsLocked ? null : _handlePrimaryRecordAction,
                  icon: Icon(
                    isRecording
                        ? Icons.stop_circle_outlined
                        : Icons.fiber_manual_record,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRecording
                        ? const Color(0xFFB71C1C)
                        : const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  label: Text(primaryLabel),
                ),
              ),
              if (snapshot.capabilities.pauseResume && isRecording) ...<Widget>[
                const SizedBox(height: 12),
                SizedBox(
                  height: 56,
                  child: OutlinedButton.icon(
                    key: const ValueKey<String>('pause_resume_button'),
                    onPressed: controlsLocked ? null : _handlePauseOrResumeAction,
                    icon: Icon(
                      isPaused
                          ? Icons.play_arrow_outlined
                          : Icons.pause_circle_outline,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1C1C1E),
                      side: const BorderSide(color: Color(0xFFD1D1D6)),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    label: Text(isPaused ? l10n.resumeAction : l10n.pauseAction),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              SizedBox(
                height: 60,
                child: OutlinedButton.icon(
                  key: const ValueKey<String>('open_output_folder'),
                  onPressed: controlsLocked
                      ? null
                      : () => _runAction(_platform.openOutputFolder),
                  icon: const Icon(Icons.folder_open_outlined),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1C1C1E),
                    side: const BorderSide(color: Color(0xFFD1D1D6)),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  label: Text(l10n.openSavedFolder),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: <Widget>[
                  Expanded(
                  child: SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        key: const ValueKey<String>('open_app_settings'),
                        onPressed: controlsLocked ? null : _openSettingsPage,
                        icon: const Icon(Icons.tune_outlined),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1C1C1E),
                          side: const BorderSide(color: Color(0xFFD1D1D6)),
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        label: Text(l10n.settings),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                  child: SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        key: const ValueKey<String>('open_shortcuts'),
                        onPressed: controlsLocked ? null : _showShortcutsDialog,
                        icon: const Icon(Icons.keyboard_command_key_outlined),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1C1C1E),
                          side: const BorderSide(color: Color(0xFFD1D1D6)),
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        label: Text(l10n.shortcuts),
                      ),
                    ),
                  ),
                ],
              ),
              if (snapshot.isMacRecorder &&
                  widget.appPreferences.recentRecordingPaths.isNotEmpty) ...<
                Widget
              >[
                const SizedBox(height: 18),
                _RecentRecordingsCard(
                  title: l10n.recentRecordings,
                  paths: widget.appPreferences.recentRecordingPaths,
                  onOpen: _openRecentRecording,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalMobileHome(RecorderSnapshot snapshot) {
    final isRecording = snapshot.hasActiveRecording;
    final isStopping = snapshot.state == 'stopping';
    final controlsLocked = isStopping || _countdownValue != null;
    final primaryLabel = switch (snapshot.state) {
      'stopping' => context.l10n.stoppingState,
      _ when isRecording => context.l10n.stopAction,
      _ => context.l10n.recordAction,
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _MinimalRecordingStatus(
                snapshot: snapshot,
                countdownValue: _countdownValue,
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 72,
                child: ElevatedButton.icon(
                  key: ValueKey<String>(
                    isRecording ? 'primary_stop' : 'primary_record',
                  ),
                  onPressed: controlsLocked ? null : _handlePrimaryRecordAction,
                  icon: Icon(
                    isRecording
                        ? Icons.stop_circle_outlined
                        : Icons.fiber_manual_record,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRecording
                        ? const Color(0xFFB71C1C)
                        : const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  label: Text(primaryLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHiddenLegacyPanels(RecorderSnapshot snapshot) {
    return Offstage(
      offstage: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _PlatformBadge(platform: snapshot.platform),
          if (snapshot.note.isNotEmpty) _NoteBanner(note: snapshot.note),
          if (_actionError != null)
            _ErrorBanner(
              message: _actionError!,
              onDismiss: () => setState(() => _actionError = null),
            ),
          _RecordingCard(
            snapshot: snapshot,
            onRequestPermissions: _handlePermissionRequest,
            onOpenScreenRecordingSettings: () =>
                _openPermissionSettings(_PermissionTarget.screen),
            onOpenMicrophoneSettings: () =>
                _openPermissionSettings(_PermissionTarget.microphone),
            onCheckPermissions: () => _refresh(),
            onPickContent: snapshot.capabilities.contentPicker
                ? () => _runAction(_platform.presentPicker)
                : null,
            onClearSelection: snapshot.capabilities.contentPicker
                ? () => _runAction(_platform.clearSelection)
                : null,
            onStart: snapshot.canStartRecording
                ? () => _runAction(
                    () => _platform.startRecording(snapshot.settings.toMap()),
                    successMessage: context.l10n.recordingStarted,
                  )
                : null,
            onStop: snapshot.isRecording
                ? () => _runAction(
                    _platform.stopRecording,
                    successMessage: context.l10n.recordingStopped,
                  )
                : null,
            onChooseOutputDirectory: snapshot.isMacRecorder
                ? () => _runAction(_platform.chooseOutputDirectory)
                : null,
            onOpenOutputFolder: snapshot.isMacRecorder
                ? () => _runAction(_platform.openOutputFolder)
                : null,
            onUpdateSetting: (changes) =>
                _runAction(() => _platform.updateSettings(changes)),
          ),
          _SettingsAccordion(
            snapshot: snapshot,
            frameRates: _frameRates,
            videoCodecs: _videoCodecs,
            containerFormats: _containerFormats,
            videoQualities: _videoQualities,
            audioCodecs: _audioCodecs,
            onUpdateSetting: (changes) =>
                _runAction(() => _platform.updateSettings(changes)),
          ),
          _CapabilityRow(capabilities: snapshot.capabilities),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    _logFlutter('snackbar: $message');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = _snapshot;
    final bindings = <ShortcutActivator, VoidCallback>{};
    final shortcuts = widget.appPreferences.shortcuts;

    void bindShortcut(String keyId, VoidCallback callback) {
      final keyChoice = _shortcutKeyChoiceForId(keyId);
      if (keyChoice == null) {
        return;
      }
      bindings[SingleActivator(keyChoice.key, meta: true)] = callback;
      bindings[SingleActivator(keyChoice.key, control: true)] = callback;
    }

    if (snapshot?.isMacRecorder ?? false) {
      bindShortcut(
        shortcuts.recordApplicationKey,
        () => unawaited(_handleShortcutRecording(_RecordingTarget.application)),
      );
      bindShortcut(
        shortcuts.recordFullScreenKey,
        () => unawaited(_handleShortcutRecording(_RecordingTarget.fullScreen)),
      );
      bindShortcut(
        shortcuts.recordAreaKey,
        () => unawaited(_handleShortcutRecording(_RecordingTarget.area)),
      );
      if (snapshot?.capabilities.pauseResume ?? false) {
        bindShortcut(shortcuts.pauseResumeKey, () {
          unawaited(_handlePauseOrResumeAction());
        });
      }
      bindShortcut(shortcuts.stopKey, () {
        unawaited(_handleStopShortcut());
      });
      bindShortcut(shortcuts.openSettingsKey, _openSettingsPage);
      bindShortcut(shortcuts.openSavedFolderKey, () {
        unawaited(_runActionForSnapshot(_platform.openOutputFolder));
      });
    }

    return CallbackShortcuts(
      bindings: bindings,
      child: Focus(
        autofocus: true,
        child: Scaffold(
          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: snapshot == null
                      ? const SizedBox.shrink()
                      : Stack(
                          children: <Widget>[
                            _buildMinimalHome(snapshot),
                            _buildHiddenLegacyPanels(snapshot),
                          ],
                        ),
                ),
        ),
      ),
    );
  }
}

enum _PermissionTarget { screen, microphone }

enum _PreparationDialogAction {
  allowAccess,
  screenSettings,
  microphoneSettings,
  checkAgain,
}

enum _RecordingTarget { application, fullScreen, area }

enum _RecordingAudioChoice {
  none('none', captureSystemAudio: false, captureMicrophone: false),
  systemOnly('system_only', captureSystemAudio: true, captureMicrophone: false),
  microphoneOnly(
    'microphone_only',
    captureSystemAudio: false,
    captureMicrophone: true,
  ),
  systemAndMicrophone(
    'system_and_microphone',
    captureSystemAudio: true,
    captureMicrophone: true,
  );

  const _RecordingAudioChoice(
    this.storageKey, {
    required this.captureSystemAudio,
    required this.captureMicrophone,
  });

  final String storageKey;
  final bool captureSystemAudio;
  final bool captureMicrophone;
}

List<_RecordingAudioChoice> _availableAudioChoices(RecorderSnapshot snapshot) {
  final supportsSystemAudio = snapshot.capabilities.systemAudio;
  final supportsMicrophone = snapshot.capabilities.microphone;

  return <_RecordingAudioChoice>[
    if (supportsSystemAudio) _RecordingAudioChoice.systemOnly,
    if (supportsMicrophone) _RecordingAudioChoice.microphoneOnly,
    if (supportsSystemAudio && supportsMicrophone)
      _RecordingAudioChoice.systemAndMicrophone,
    _RecordingAudioChoice.none,
  ];
}

class _MinimalRecordingStatus extends StatelessWidget {
  const _MinimalRecordingStatus({
    required this.snapshot,
    required this.countdownValue,
  });

  final RecorderSnapshot snapshot;
  final int? countdownValue;

  @override
  Widget build(BuildContext context) {
    final isRecording = snapshot.hasActiveRecording;
    final isPaused = snapshot.isPaused;
    final isStopping = snapshot.state == 'stopping';
    final isCountingDown = countdownValue != null;
    final accent = isCountingDown
        ? const Color(0xFFFF9500)
        : isPaused
        ? const Color(0xFFFF9500)
        : isRecording
        ? const Color(0xFFE53935)
        : isStopping
        ? const Color(0xFFFF9500)
        : const Color(0xFF6E6E73);
    final background = isCountingDown
        ? const Color(0xFFFFF4E5)
        : isPaused
        ? const Color(0xFFFFF4E5)
        : isRecording
        ? const Color(0xFFFFEBEE)
        : isStopping
        ? const Color(0xFFFFF4E5)
        : Colors.white;
    final statusLabel = isCountingDown
        ? context.l10n.countdownState
        : _recordingStateLabel(context.l10n, snapshot.state);
    final durationLabel = isCountingDown
        ? '$countdownValue'
        : snapshot.formattedDuration;

    return Container(
      key: const ValueKey<String>('minimal_status_card'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.14)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                  boxShadow: isRecording
                      ? <BoxShadow>[
                          BoxShadow(
                            color: accent.withValues(alpha: 0.28),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                statusLabel,
                key: const ValueKey<String>('minimal_status_label'),
                style: TextStyle(
                  color: accent,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            durationLabel,
            key: const ValueKey<String>('minimal_duration_text'),
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w300,
              letterSpacing: 3,
              color: isRecording || isCountingDown
                  ? accent
                  : const Color(0xFF1C1C1E),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentRecordingsCard extends StatelessWidget {
  const _RecentRecordingsCard({
    required this.title,
    required this.paths,
    required this.onOpen,
  });

  final String title;
  final List<String> paths;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E5EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 8),
          for (final path in paths)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.movie_outlined),
              title: Text(
                _fileNameFromPath(path),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                path,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                key: ValueKey<String>('recent_recording_${_fileNameFromPath(path)}'),
                onPressed: () => onOpen(path),
                icon: const Icon(Icons.open_in_new),
                tooltip: context.l10n.openInFinder,
              ),
            ),
        ],
      ),
    );
  }
}

String _fileNameFromPath(String path) {
  final normalized = path.replaceAll('\\', '/');
  final segments = normalized.split('/');
  return segments.isEmpty ? path : segments.last;
}

class _RecordingPreparationGuide {
  const _RecordingPreparationGuide({
    required this.needsScreenPermission,
    required this.screenDenied,
    required this.requestScreenPermissionInApp,
    required this.needsMicrophonePermission,
    required this.microphoneDenied,
    required this.requestMicrophonePermissionInApp,
    required this.needsContentSelection,
  });

  final bool needsScreenPermission;
  final bool screenDenied;
  final bool requestScreenPermissionInApp;
  final bool needsMicrophonePermission;
  final bool microphoneDenied;
  final bool requestMicrophonePermissionInApp;
  final bool needsContentSelection;

  bool get hasUnknownPermissions =>
      requestScreenPermissionInApp || requestMicrophonePermissionInApp;

  bool get hasPermissionAttention =>
      needsScreenPermission ||
      screenDenied ||
      needsMicrophonePermission ||
      microphoneDenied ||
      hasUnknownPermissions;

  bool get requiresSetup => hasPermissionAttention || needsContentSelection;

  String summary(AppLocalizations l10n) {
    return hasPermissionAttention
        ? l10n.guideSummaryNeedsPermission
        : l10n.guideSummaryReadyForContent;
  }

  List<String> steps(AppLocalizations l10n) {
    return <String>[
      if (requestScreenPermissionInApp) l10n.guideStepAllowScreen,
      if (screenDenied) l10n.guideStepScreenSettings,
      if (requestMicrophonePermissionInApp) l10n.guideStepAllowMic,
      if (microphoneDenied) l10n.guideStepMicSettings,
      if (needsContentSelection) l10n.guideStepPickContent,
      if (hasPermissionAttention) l10n.guideStepCheckAgain,
    ];
  }

  String recordHint(AppLocalizations l10n, RecorderSnapshot snapshot) {
    return needsScreenPermission
        ? (screenDenied
              ? l10n.recordHintTurnOnScreen
              : l10n.recordHintAllowScreen)
        : needsMicrophonePermission
        ? (microphoneDenied
              ? l10n.recordHintTurnOnMicrophone
              : l10n.recordHintAllowMicrophone)
        : needsContentSelection
        ? l10n.recordHintPickContent
        : snapshot.canStartRecording
        ? l10n.tapToRecord
        : l10n.notReady;
  }

  factory _RecordingPreparationGuide.fromSnapshot(RecorderSnapshot snapshot) {
    final requestScreenPermissionInApp =
        snapshot.permissions.canAskForScreenAccessInApp;
    final screenDenied = snapshot.permissions.isScreenDenied;
    final needsScreenPermission = requestScreenPermissionInApp || screenDenied;
    final microphoneRequired = snapshot.settings.captureMicrophone;
    final requestMicrophonePermissionInApp =
        microphoneRequired &&
        snapshot.permissions.canAskForMicrophoneAccessInApp;
    final microphoneDenied =
        microphoneRequired && snapshot.permissions.isMicrophoneDenied;
    final needsMicrophonePermission =
        microphoneRequired &&
        (microphoneDenied ||
            (snapshot.isMacRecorder && requestMicrophonePermissionInApp));
    final needsContentSelection = !snapshot.hasContentSelected;

    return _RecordingPreparationGuide(
      needsScreenPermission: needsScreenPermission,
      screenDenied: screenDenied,
      requestScreenPermissionInApp: requestScreenPermissionInApp,
      needsMicrophonePermission: needsMicrophonePermission,
      microphoneDenied: microphoneDenied,
      requestMicrophonePermissionInApp: requestMicrophonePermissionInApp,
      needsContentSelection: needsContentSelection,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// App bar components
// ─────────────────────────────────────────────────────────────────────────────

class _PlatformBadge extends StatelessWidget {
  const _PlatformBadge({required this.platform});

  final String platform;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        platform.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6E6E73),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Banners
// ─────────────────────────────────────────────────────────────────────────────

class _NoteBanner extends StatelessWidget {
  const _NoteBanner({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFCB47).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.info_outline, size: 18, color: Color(0xFF856404)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(note, style: const TextStyle(color: Color(0xFF856404))),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE57373).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.error_outline, size: 18, color: Color(0xFFC62828)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFC62828)),
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            child: const Icon(Icons.close, size: 16, color: Color(0xFFC62828)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Recording card
// ─────────────────────────────────────────────────────────────────────────────

class _RecordingCard extends StatelessWidget {
  const _RecordingCard({
    required this.snapshot,
    required this.onRequestPermissions,
    required this.onOpenScreenRecordingSettings,
    required this.onOpenMicrophoneSettings,
    required this.onCheckPermissions,
    required this.onPickContent,
    required this.onClearSelection,
    required this.onStart,
    required this.onStop,
    required this.onChooseOutputDirectory,
    required this.onOpenOutputFolder,
    required this.onUpdateSetting,
  });

  final RecorderSnapshot snapshot;
  final VoidCallback onRequestPermissions;
  final VoidCallback onOpenScreenRecordingSettings;
  final VoidCallback onOpenMicrophoneSettings;
  final VoidCallback onCheckPermissions;
  final VoidCallback? onPickContent;
  final VoidCallback? onClearSelection;
  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final VoidCallback? onChooseOutputDirectory;
  final VoidCallback? onOpenOutputFolder;
  final ValueChanged<Map<String, dynamic>> onUpdateSetting;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          _RecordingModeSelector(
            captureMicrophone: snapshot.settings.captureMicrophone,
            enabled: !snapshot.isRecording,
            onChanged: (mic) =>
                onUpdateSetting(<String, dynamic>{'captureMicrophone': mic}),
          ),
          const _Divider(),
          _SetupSection(
            snapshot: snapshot,
            onRequestPermissions: onRequestPermissions,
            onOpenScreenRecordingSettings: onOpenScreenRecordingSettings,
            onOpenMicrophoneSettings: onOpenMicrophoneSettings,
            onCheckPermissions: onCheckPermissions,
            onPickContent: onPickContent,
            onClearSelection: onClearSelection,
          ),
          const _Divider(),
          _RecordingControl(
            snapshot: snapshot,
            onStart: onStart,
            onStop: onStop,
          ),
          if (onChooseOutputDirectory != null ||
              onOpenOutputFolder != null) ...<Widget>[
            const _Divider(),
            _OutputRow(
              outputDirectory: snapshot.settings.outputDirectory,
              onChoose: onChooseOutputDirectory,
              onOpen: onOpenOutputFolder,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Recording mode selector ───────────────────────────

class _RecordingModeSelector extends StatelessWidget {
  const _RecordingModeSelector({
    required this.captureMicrophone,
    required this.enabled,
    required this.onChanged,
  });

  final bool captureMicrophone;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _ModeButton(
              icon: Icons.desktop_windows_outlined,
              label: l10n.screenOnly,
              sublabel: l10n.screenOnlySublabel,
              selected: !captureMicrophone,
              enabled: enabled,
              onTap: () => onChanged(false),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ModeButton(
              icon: Icons.mic,
              label: l10n.screenAndMic,
              sublabel: l10n.screenAndMicSublabel,
              selected: captureMicrophone,
              enabled: enabled,
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String sublabel;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFE53935);
    final borderColor = selected ? red : const Color(0xFFE5E5EA);
    final bg = selected ? red.withValues(alpha: 0.06) : Colors.transparent;
    final iconColor = selected ? red : const Color(0xFF8E8E93);
    final labelColor = selected
        ? const Color(0xFF1C1C1E)
        : const Color(0xFF6E6E73);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                    ),
                  ),
                  Text(
                    sublabel,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: red,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Setup section ─────────────────────────────────────

class _SetupSection extends StatelessWidget {
  const _SetupSection({
    required this.snapshot,
    required this.onRequestPermissions,
    required this.onOpenScreenRecordingSettings,
    required this.onOpenMicrophoneSettings,
    required this.onCheckPermissions,
    required this.onPickContent,
    required this.onClearSelection,
  });

  final RecorderSnapshot snapshot;
  final VoidCallback onRequestPermissions;
  final VoidCallback onOpenScreenRecordingSettings;
  final VoidCallback onOpenMicrophoneSettings;
  final VoidCallback onCheckPermissions;
  final VoidCallback? onPickContent;
  final VoidCallback? onClearSelection;

  bool get _screenOk => snapshot.permissions.isScreenReady;

  bool get _micRequired => snapshot.settings.captureMicrophone;

  bool get _micOk => !_micRequired || snapshot.permissions.isMicrophoneGranted;

  @override
  Widget build(BuildContext context) {
    final guide = _RecordingPreparationGuide.fromSnapshot(snapshot);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.setup,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Color(0xFF6E6E73),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _PermBadge(
                  label: l10n.screen,
                  statusLabel: _screenOk
                      ? l10n.ready
                      : snapshot.permissions.isScreenDenied
                      ? l10n.openSettings
                      : l10n.needsAllow,
                  detail: _screenPermissionDetail(l10n, snapshot),
                  tone: _screenOk
                      ? _BadgeTone.ready
                      : snapshot.permissions.isScreenDenied
                      ? _BadgeTone.blocked
                      : _BadgeTone.actionNeeded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PermBadge(
                  label: l10n.microphone,
                  statusLabel: _micRequired
                      ? (_micOk
                            ? l10n.ready
                            : snapshot.permissions.isMicrophoneDenied
                            ? l10n.openSettings
                            : l10n.needsAllow)
                      : l10n.optional,
                  detail: _micRequired
                      ? _microphonePermissionDetail(l10n, snapshot)
                      : l10n.microphonePermissionDetailOptional,
                  tone: !_micRequired
                      ? _BadgeTone.optional
                      : (_micOk
                            ? _BadgeTone.ready
                            : snapshot.permissions.isMicrophoneDenied
                            ? _BadgeTone.blocked
                            : _BadgeTone.actionNeeded),
                ),
              ),
            ],
          ),
          if (guide.requiresSetup) ...<Widget>[
            const SizedBox(height: 12),
            _SetupGuideCard(
              guide: guide,
              onRequestPermissions: onRequestPermissions,
              onOpenScreenRecordingSettings: onOpenScreenRecordingSettings,
              onOpenMicrophoneSettings: onOpenMicrophoneSettings,
              onCheckPermissions: onCheckPermissions,
              onPickContent: onPickContent,
            ),
          ],
          if (onPickContent != null) ...<Widget>[
            const SizedBox(height: 10),
            _ContentRow(
              hasSelection: snapshot.hasContentSelected,
              onPick: onPickContent,
              onClear: onClearSelection,
            ),
          ],
        ],
      ),
    );
  }
}

enum _BadgeTone { ready, actionNeeded, blocked, optional }

class _PermBadge extends StatelessWidget {
  const _PermBadge({
    required this.label,
    required this.statusLabel,
    required this.detail,
    required this.tone,
  });

  final String label;
  final String statusLabel;
  final String detail;
  final _BadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final (color, background, icon) = switch (tone) {
      _BadgeTone.ready => (
        const Color(0xFF34C759),
        const Color(0xFF34C759).withValues(alpha: 0.08),
        Icons.check_circle_outline,
      ),
      _BadgeTone.actionNeeded => (
        const Color(0xFFFF9500),
        const Color(0xFFFF9500).withValues(alpha: 0.08),
        Icons.warning_amber_outlined,
      ),
      _BadgeTone.blocked => (
        const Color(0xFFC62828),
        const Color(0xFFFFEBEE),
        Icons.settings_outlined,
      ),
      _BadgeTone.optional => (
        const Color(0xFF6E6E73),
        const Color(0xFFF2F2F7),
        Icons.info_outline,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6E6E73),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupGuideCard extends StatelessWidget {
  const _SetupGuideCard({
    required this.guide,
    required this.onRequestPermissions,
    required this.onOpenScreenRecordingSettings,
    required this.onOpenMicrophoneSettings,
    required this.onCheckPermissions,
    required this.onPickContent,
  });

  final _RecordingPreparationGuide guide;
  final VoidCallback onRequestPermissions;
  final VoidCallback onOpenScreenRecordingSettings;
  final VoidCallback onOpenMicrophoneSettings;
  final VoidCallback onCheckPermissions;
  final VoidCallback? onPickContent;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = guide.steps(l10n);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F3E8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE6C98A).withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.assistant_navigation,
                size: 18,
                color: Color(0xFF8A5A00),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.beforeYouRecord,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      guide.summary(l10n),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6E6E73),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < steps.length; index++) ...<Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8A5A00).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8A5A00),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    steps[index],
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: Color(0xFF3C3C43),
                    ),
                  ),
                ),
              ],
            ),
            if (index != steps.length - 1) const SizedBox(height: 8),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              if (guide.hasUnknownPermissions)
                FilledButton(
                  key: const ValueKey<String>('guide_allow_access'),
                  onPressed: onRequestPermissions,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                  ),
                  child: Text(l10n.allowAccess),
                ),
              if (guide.screenDenied)
                OutlinedButton(
                  key: const ValueKey<String>('guide_screen_settings'),
                  onPressed: onOpenScreenRecordingSettings,
                  child: Text(l10n.screenSettings),
                ),
              if (guide.microphoneDenied)
                OutlinedButton(
                  key: const ValueKey<String>('guide_microphone_settings'),
                  onPressed: onOpenMicrophoneSettings,
                  child: Text(l10n.microphoneSettings),
                ),
              if (guide.needsContentSelection && onPickContent != null)
                FilledButton.tonal(
                  key: const ValueKey<String>('guide_pick_content'),
                  onPressed: onPickContent,
                  child: Text(l10n.pickContent),
                ),
              TextButton(
                key: const ValueKey<String>('guide_check_again'),
                onPressed: onCheckPermissions,
                child: Text(l10n.checkAgain),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContentRow extends StatelessWidget {
  const _ContentRow({
    required this.hasSelection,
    required this.onPick,
    required this.onClear,
  });

  final bool hasSelection;
  final VoidCallback? onPick;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = hasSelection
        ? const Color(0xFF34C759)
        : const Color(0xFF6E6E73);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: hasSelection
            ? const Color(0xFF34C759).withValues(alpha: 0.08)
            : const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasSelection
              ? const Color(0xFF34C759).withValues(alpha: 0.2)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            hasSelection
                ? Icons.check_circle_outline
                : Icons.desktop_windows_outlined,
            size: 15,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              hasSelection ? l10n.contentSelected : l10n.noContentSelected,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
          if (hasSelection && onClear != null)
            TextButton(
              key: const ValueKey<String>('clear_content'),
              onPressed: onClear,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: const TextStyle(fontSize: 12),
              ),
              child: Text(l10n.clear),
            ),
          FilledButton.tonal(
            key: const ValueKey<String>('content_pick'),
            onPressed: onPick,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: Text(hasSelection ? l10n.change : l10n.pickContent),
          ),
        ],
      ),
    );
  }
}

// ── Recording control ─────────────────────────────────

class _RecordingControl extends StatelessWidget {
  const _RecordingControl({
    required this.snapshot,
    required this.onStart,
    required this.onStop,
  });

  final RecorderSnapshot snapshot;
  final VoidCallback? onStart;
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    final isRecording = snapshot.isRecording;
    final isActive = isRecording || onStart != null;
    final guide = _RecordingPreparationGuide.fromSnapshot(snapshot);
    final l10n = context.l10n;
    const red = Color(0xFFE53935);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      child: Column(
        children: <Widget>[
          Text(
            snapshot.formattedDuration,
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w200,
              letterSpacing: 6,
              color: isRecording ? red : const Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _recordingStateLabel(l10n, snapshot.state),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: isRecording ? red : const Color(0xFF6E6E73),
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: isRecording ? onStop : onStart,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: isActive ? red : const Color(0xFFD1D1D6),
                shape: BoxShape.circle,
                boxShadow: isActive
                    ? <BoxShadow>[
                        BoxShadow(
                          color: red.withValues(alpha: 0.35),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: isRecording
                      ? const Icon(
                          Icons.stop_rounded,
                          key: ValueKey<String>('stop'),
                          color: Colors.white,
                          size: 38,
                        )
                      : const Icon(
                          Icons.fiber_manual_record,
                          key: ValueKey<String>('rec'),
                          color: Colors.white,
                          size: 38,
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            isRecording ? l10n.tapToStop : guide.recordHint(l10n, snapshot),
            style: const TextStyle(fontSize: 13, color: Color(0xFF6E6E73)),
          ),
        ],
      ),
    );
  }
}

// ── Output row ────────────────────────────────────────

class _OutputRow extends StatelessWidget {
  const _OutputRow({
    required this.outputDirectory,
    required this.onChoose,
    required this.onOpen,
  });

  final String outputDirectory;
  final VoidCallback? onChoose;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: <Widget>[
          const Icon(Icons.folder_outlined, size: 17, color: Color(0xFF6E6E73)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              outputDirectory,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6E6E73)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onChoose != null)
            TextButton(
              onPressed: onChoose,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: const TextStyle(fontSize: 12),
              ),
              child: Text(l10n.change),
            ),
          if (onOpen != null)
            IconButton(
              icon: const Icon(Icons.open_in_new, size: 16),
              tooltip: l10n.openInFinder,
              onPressed: onOpen,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Settings page
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsPage extends StatefulWidget {
  const _SettingsPage({
    required this.initialSnapshot,
    required this.appPreferences,
    required this.frameRates,
    required this.videoCodecs,
    required this.containerFormats,
    required this.videoQualities,
    required this.audioCodecs,
    required this.onUpdateAppPreferences,
    required this.onUpdateSetting,
    required this.onRequestPermissions,
    required this.onOpenScreenRecordingSettings,
    required this.onOpenMicrophoneSettings,
    required this.onRefreshSnapshot,
    this.onChooseOutputDirectory,
    this.onOpenOutputFolder,
  });

  final RecorderSnapshot initialSnapshot;
  final _AppPreferences appPreferences;
  final List<int> frameRates;
  final List<String> videoCodecs;
  final List<String> containerFormats;
  final List<String> videoQualities;
  final List<String> audioCodecs;
  final ValueChanged<_AppPreferences> onUpdateAppPreferences;
  final Future<RecorderSnapshot?> Function(Map<String, dynamic>)
  onUpdateSetting;
  final Future<RecorderSnapshot?> Function() onRequestPermissions;
  final Future<RecorderSnapshot?> Function() onOpenScreenRecordingSettings;
  final Future<RecorderSnapshot?> Function() onOpenMicrophoneSettings;
  final Future<RecorderSnapshot?> Function() onRefreshSnapshot;
  final Future<RecorderSnapshot?> Function()? onChooseOutputDirectory;
  final Future<RecorderSnapshot?> Function()? onOpenOutputFolder;

  @override
  State<_SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<_SettingsPage> {
  late RecorderSnapshot _snapshot;
  late _AppPreferences _appPreferences;

  @override
  void initState() {
    super.initState();
    _snapshot = widget.initialSnapshot;
    _appPreferences = widget.appPreferences;
  }

  Future<void> _updateSnapshot(
    Future<RecorderSnapshot?> Function() action,
  ) async {
    final updated = await action();
    if (!mounted || updated == null) return;
    setState(() => _snapshot = updated);
  }

  Future<void> _updateSetting(Map<String, dynamic> changes) async {
    await _updateSnapshot(() => widget.onUpdateSetting(changes));
  }

  void _updateAppPreferences(_AppPreferences next) {
    widget.onUpdateAppPreferences(next);
    setState(() => _appPreferences = next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeChoices = _localizedLocaleChoices(l10n);
    final localeKey = _appPreferences.localeKey;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(l10n.settings),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _SectionHeader(title: l10n.general),
                  _SettingsCardShell(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                          child: Column(
                            children: <Widget>[
                              _DropRow<String>(
                                key: const ValueKey<String>(
                                  'settings_language',
                                ),
                                label: l10n.language,
                                value: localeKey,
                                items: localeChoices
                                    .map((choice) => choice.key)
                                    .toList(growable: false),
                                enabled: true,
                                itemLabel: (value) => localeChoices
                                    .firstWhere((choice) => choice.key == value)
                                    .label,
                                onChanged: (value) {
                                  if (value == null) return;
                                  _updateAppPreferences(
                                    _appPreferences.copyWith(localeKey: value),
                                  );
                                },
                              ),
                              _SwitchRow(
                                key: const ValueKey<String>(
                                  'settings_auto_refresh',
                                ),
                                label: l10n.autoRefresh,
                                value: _appPreferences.autoRefreshEnabled,
                                enabled: true,
                                onChanged: (value) {
                                  _updateAppPreferences(
                                    _appPreferences.copyWith(
                                      autoRefreshEnabled: value,
                                    ),
                                  );
                                },
                              ),
                              if (_appPreferences.autoRefreshEnabled)
                                _DropRow<int>(
                                  key: const ValueKey<String>(
                                    'settings_refresh_interval',
                                  ),
                                  label: l10n.refreshInterval,
                                  value: _appPreferences.autoRefreshSeconds,
                                  items: const <int>[1, 2, 5, 10],
                                  enabled: true,
                                  itemLabel: (value) => '${value}s',
                                  onChanged: (value) {
                                    if (value == null) return;
                                    _updateAppPreferences(
                                      _appPreferences.copyWith(
                                        autoRefreshSeconds: value,
                                      ),
                                    );
                                  },
                                ),
                              _DropRow<int>(
                                key: const ValueKey<String>(
                                  'settings_countdown_seconds',
                                ),
                                label: l10n.countdown,
                                value: _appPreferences.countdownSeconds,
                                items: const <int>[0, 3, 5, 10],
                                enabled: true,
                                itemLabel: (value) =>
                                    value == 0 ? '0s' : '${value}s',
                                onChanged: (value) {
                                  if (value == null) return;
                                  _updateAppPreferences(
                                    _appPreferences.copyWith(
                                      countdownSeconds: value,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const _Divider(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FilledButton.tonalIcon(
                              onPressed: () =>
                                  _updateSnapshot(widget.onRefreshSnapshot),
                              icon: const Icon(Icons.refresh),
                              label: Text(l10n.refresh),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SectionHeader(title: l10n.recordingDefaults),
                  _SettingsCardShell(
                    child: Column(
                      children: <Widget>[
                        _RecordingModeSelector(
                          captureMicrophone:
                              _snapshot.settings.captureMicrophone,
                          enabled: !_snapshot.isRecording,
                          onChanged: (mic) => _updateSetting(<String, dynamic>{
                            'captureMicrophone': mic,
                          }),
                        ),
                        const _Divider(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                          child: Column(
                            children: <Widget>[
                              _DropRow<int>(
                                label: l10n.frameRate,
                                value: _snapshot.settings.frameRate,
                                items: widget.frameRates,
                                enabled: !_snapshot.isRecording,
                                itemLabel: (value) =>
                                    value == 0 ? l10n.native : '$value fps',
                                onChanged: (value) {
                                  if (value == null) return;
                                  _updateSetting(<String, dynamic>{
                                    'frameRate': value,
                                  });
                                },
                              ),
                              _DropRow<String>(
                                label: l10n.quality,
                                value: _snapshot.settings.videoQuality,
                                items: widget.videoQualities,
                                enabled: !_snapshot.isRecording,
                                itemLabel: (value) =>
                                    _videoQualityLabel(l10n, value),
                                onChanged: (value) {
                                  if (value == null) return;
                                  _updateSetting(<String, dynamic>{
                                    'videoQuality': value,
                                  });
                                },
                              ),
                              _SwitchRow(
                                label: l10n.systemAudio,
                                value: _snapshot.settings.captureSystemAudio,
                                enabled: !_snapshot.isRecording,
                                onChanged: (value) =>
                                    _updateSetting(<String, dynamic>{
                                      'captureSystemAudio': value,
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SectionHeader(title: l10n.accessAndStorage),
                  _SettingsCardShell(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: _PermBadge(
                                  label: l10n.screen,
                                  statusLabel:
                                      _snapshot.permissions.isScreenReady
                                      ? l10n.ready
                                      : _snapshot.permissions.isScreenDenied
                                      ? l10n.openSettings
                                      : l10n.needsAllow,
                                  detail: _screenPermissionDetail(
                                    l10n,
                                    _snapshot,
                                  ),
                                  tone: _snapshot.permissions.isScreenReady
                                      ? _BadgeTone.ready
                                      : _snapshot.permissions.isScreenDenied
                                      ? _BadgeTone.blocked
                                      : _BadgeTone.actionNeeded,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _PermBadge(
                                  label: l10n.microphone,
                                  statusLabel:
                                      _snapshot.settings.captureMicrophone
                                      ? (_snapshot
                                                .permissions
                                                .isMicrophoneGranted
                                            ? l10n.ready
                                            : _snapshot
                                                  .permissions
                                                  .isMicrophoneDenied
                                            ? l10n.openSettings
                                            : l10n.needsAllow)
                                      : l10n.optional,
                                  detail: _snapshot.settings.captureMicrophone
                                      ? _microphonePermissionDetail(
                                          l10n,
                                          _snapshot,
                                        )
                                      : l10n.microphonePermissionDetailOptional,
                                  tone: !_snapshot.settings.captureMicrophone
                                      ? _BadgeTone.optional
                                      : _snapshot
                                            .permissions
                                            .isMicrophoneGranted
                                      ? _BadgeTone.ready
                                      : _snapshot.permissions.isMicrophoneDenied
                                      ? _BadgeTone.blocked
                                      : _BadgeTone.actionNeeded,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: <Widget>[
                              FilledButton(
                                onPressed: () => _updateSnapshot(
                                  widget.onRequestPermissions,
                                ),
                                child: Text(l10n.allowAccess),
                              ),
                              OutlinedButton(
                                onPressed: () => _updateSnapshot(
                                  widget.onOpenScreenRecordingSettings,
                                ),
                                child: Text(l10n.screenSettings),
                              ),
                              OutlinedButton(
                                onPressed: () => _updateSnapshot(
                                  widget.onOpenMicrophoneSettings,
                                ),
                                child: Text(l10n.microphoneSettings),
                              ),
                              TextButton(
                                onPressed: () =>
                                    _updateSnapshot(widget.onRefreshSnapshot),
                                child: Text(l10n.checkAgain),
                              ),
                            ],
                          ),
                          if (widget.onChooseOutputDirectory != null ||
                              widget.onOpenOutputFolder != null) ...<Widget>[
                            const SizedBox(height: 10),
                            const _Divider(),
                            _OutputRow(
                              outputDirectory:
                                  _snapshot.settings.outputDirectory,
                              onChoose: widget.onChooseOutputDirectory == null
                                  ? null
                                  : () => _updateSnapshot(
                                      widget.onChooseOutputDirectory!,
                                    ),
                              onOpen: widget.onOpenOutputFolder == null
                                  ? null
                                  : () => _updateSnapshot(
                                      widget.onOpenOutputFolder!,
                                    ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SectionHeader(title: l10n.advancedControls),
                  _SettingsAccordion(
                    snapshot: _snapshot,
                    frameRates: widget.frameRates,
                    videoCodecs: widget.videoCodecs,
                    containerFormats: widget.containerFormats,
                    videoQualities: widget.videoQualities,
                    audioCodecs: widget.audioCodecs,
                    onUpdateSetting: _updateSetting,
                  ),
                  const SizedBox(height: 18),
                  _CapabilityRow(capabilities: _snapshot.capabilities),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: Color(0xFF6E6E73),
        ),
      ),
    );
  }
}

class _SettingsCardShell extends StatelessWidget {
  const _SettingsCardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Settings accordion
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsAccordion extends StatelessWidget {
  const _SettingsAccordion({
    required this.snapshot,
    required this.frameRates,
    required this.videoCodecs,
    required this.containerFormats,
    required this.videoQualities,
    required this.audioCodecs,
    required this.onUpdateSetting,
  });

  final RecorderSnapshot snapshot;
  final List<int> frameRates;
  final List<String> videoCodecs;
  final List<String> containerFormats;
  final List<String> videoQualities;
  final List<String> audioCodecs;
  final ValueChanged<Map<String, dynamic>> onUpdateSetting;

  @override
  Widget build(BuildContext context) {
    final settings = snapshot.settings;
    final enabled = !snapshot.isRecording;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: <Widget>[
            _SettingsSection(
              title: l10n.video,
              icon: Icons.videocam_outlined,
              children: <Widget>[
                _DropRow<int>(
                  label: l10n.frameRate,
                  value: settings.frameRate,
                  items: frameRates,
                  enabled: enabled,
                  itemLabel: (v) => v == 0 ? l10n.native : '$v fps',
                  onChanged: (v) {
                    if (v != null) {
                      onUpdateSetting(<String, dynamic>{'frameRate': v});
                    }
                  },
                ),
                _DropRow<String>(
                  label: l10n.codec,
                  value: settings.videoCodec,
                  items: videoCodecs,
                  enabled: enabled,
                  onChanged: (v) {
                    if (v != null) {
                      onUpdateSetting(<String, dynamic>{'videoCodec': v});
                    }
                  },
                ),
                _DropRow<String>(
                  label: l10n.container,
                  value: settings.containerFormat,
                  items: containerFormats,
                  enabled: enabled,
                  onChanged: (v) {
                    if (v != null) {
                      onUpdateSetting(<String, dynamic>{'containerFormat': v});
                    }
                  },
                ),
                _DropRow<String>(
                  label: l10n.quality,
                  value: settings.videoQuality,
                  items: videoQualities,
                  enabled: enabled,
                  itemLabel: (v) => _videoQualityLabel(l10n, v),
                  onChanged: (v) {
                    if (v != null) {
                      onUpdateSetting(<String, dynamic>{'videoQuality': v});
                    }
                  },
                ),
                _SwitchRow(
                  label: l10n.hdr,
                  value: settings.captureHDR,
                  enabled: enabled,
                  onChanged: (v) =>
                      onUpdateSetting(<String, dynamic>{'captureHDR': v}),
                ),
                _SwitchRow(
                  label: l10n.alphaChannel,
                  value: settings.captureAlphaChannel,
                  enabled: enabled,
                  onChanged: (v) => onUpdateSetting(<String, dynamic>{
                    'captureAlphaChannel': v,
                  }),
                ),
                _SwitchRow(
                  label: l10n.nativeResolution,
                  value: settings.captureNativeResolution,
                  enabled: enabled,
                  onChanged: (v) => onUpdateSetting(<String, dynamic>{
                    'captureNativeResolution': v,
                  }),
                ),
              ],
            ),
            const _Divider(),
            _SettingsSection(
              title: l10n.audio,
              icon: Icons.mic_outlined,
              children: <Widget>[
                _DropRow<String>(
                  label: l10n.codec,
                  value: settings.audioCodec,
                  items: audioCodecs,
                  enabled: enabled,
                  onChanged: (v) {
                    if (v != null) {
                      onUpdateSetting(<String, dynamic>{'audioCodec': v});
                    }
                  },
                ),
                _SwitchRow(
                  label: l10n.systemAudio,
                  value: settings.captureSystemAudio,
                  enabled: enabled,
                  onChanged: (v) => onUpdateSetting(<String, dynamic>{
                    'captureSystemAudio': v,
                  }),
                ),
                _SwitchRow(
                  label: l10n.microphone,
                  value: settings.captureMicrophone,
                  enabled: enabled,
                  onChanged: (v) => onUpdateSetting(<String, dynamic>{
                    'captureMicrophone': v,
                  }),
                ),
                _DropRow<String?>(
                  label: l10n.micDevice,
                  value: settings.selectedMicrophoneID,
                  items: <String?>[
                    null,
                    ...snapshot.audioDevices.map((d) => d.id),
                  ],
                  enabled: enabled,
                  itemLabel: (v) =>
                      _deviceNameOrFallback(l10n, v, snapshot.audioDevices),
                  onChanged: (v) => onUpdateSetting(<String, dynamic>{
                    'selectedMicrophoneID': v,
                  }),
                ),
              ],
            ),
            const _Divider(),
            _SettingsSection(
              title: l10n.display,
              icon: Icons.display_settings_outlined,
              children: <Widget>[
                _SwitchRow(
                  label: l10n.showCursor,
                  value: settings.showCursor,
                  enabled: enabled,
                  onChanged: (v) =>
                      onUpdateSetting(<String, dynamic>{'showCursor': v}),
                ),
                _SwitchRow(
                  label: l10n.showWallpaper,
                  value: settings.showWallpaper,
                  enabled: enabled,
                  onChanged: (v) =>
                      onUpdateSetting(<String, dynamic>{'showWallpaper': v}),
                ),
                _SwitchRow(
                  label: l10n.showMenuBar,
                  value: settings.showMenuBar,
                  enabled: enabled,
                  onChanged: (v) =>
                      onUpdateSetting(<String, dynamic>{'showMenuBar': v}),
                ),
                _SwitchRow(
                  label: l10n.showDock,
                  value: settings.showDock,
                  enabled: enabled,
                  onChanged: (v) =>
                      onUpdateSetting(<String, dynamic>{'showDock': v}),
                ),
                _SwitchRow(
                  label: l10n.showRecorderUi,
                  value: settings.showRecorderUI,
                  enabled: enabled,
                  onChanged: (v) =>
                      onUpdateSetting(<String, dynamic>{'showRecorderUI': v}),
                ),
                _SwitchRow(
                  label: l10n.windowShadows,
                  value: settings.showWindowShadows,
                  enabled: enabled,
                  onChanged: (v) => onUpdateSetting(<String, dynamic>{
                    'showWindowShadows': v,
                  }),
                ),
              ],
            ),
            const _Divider(),
            _SettingsSection(
              title: l10n.presenterOverlay,
              icon: Icons.person_outlined,
              children: <Widget>[
                _SwitchRow(
                  label: l10n.enableOverlay,
                  value: settings.presenterOverlayEnabled,
                  enabled: enabled,
                  onChanged: (v) => onUpdateSetting(<String, dynamic>{
                    'presenterOverlayEnabled': v,
                  }),
                ),
                _DropRow<String?>(
                  label: l10n.camera,
                  value: settings.selectedCameraID,
                  items: <String?>[
                    null,
                    ...snapshot.cameraDevices.map((d) => d.id),
                  ],
                  enabled: enabled,
                  itemLabel: (v) =>
                      _deviceNameOrFallback(l10n, v, snapshot.cameraDevices),
                  onChanged: (v) =>
                      onUpdateSetting(<String, dynamic>{'selectedCameraID': v}),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatefulWidget {
  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  State<_SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<_SettingsSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: <Widget>[
                Icon(widget.icon, size: 20, color: const Color(0xFF6E6E73)),
                const SizedBox(width: 12),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFF6E6E73),
                ),
              ],
            ),
          ),
        ),
        if (_expanded) ...<Widget>[
          const _Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Column(children: widget.children),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Setting row primitives
// ─────────────────────────────────────────────────────────────────────────────

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    super.key,
    required this.label,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(label, style: const TextStyle(fontSize: 14)),
      value: value,
      onChanged: enabled ? onChanged : null,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}

class _DropRow<T> extends StatelessWidget {
  const _DropRow({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.enabled,
    required this.onChanged,
    this.itemLabel,
  });

  final String label;
  final T? value;
  final List<T> items;
  final bool enabled;
  final ValueChanged<T?> onChanged;
  final String Function(T value)? itemLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Color(0xFF3A3A3C)),
            ),
          ),
          Expanded(
            child: DropdownButtonFormField<T>(
              initialValue: items.contains(value) ? value : null,
              isExpanded: true,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E5EA)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E5EA)),
                ),
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(
                        itemLabel?.call(item) ?? item.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  )
                  .toList(growable: false),
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Capability row
// ─────────────────────────────────────────────────────────────────────────────

class _CapabilityRow extends StatelessWidget {
  const _CapabilityRow({required this.capabilities});

  final RecorderCapabilities capabilities;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = <MapEntry<String, bool>>[
      MapEntry<String, bool>(
        l10n.capabilityContentPicker,
        capabilities.contentPicker,
      ),
      MapEntry<String, bool>(
        l10n.capabilityAreaSelection,
        capabilities.areaSelection,
      ),
      MapEntry<String, bool>(
        l10n.capabilityPresenterOverlay,
        capabilities.presenterOverlay,
      ),
      MapEntry<String, bool>(
        l10n.capabilitySystemAudio,
        capabilities.systemAudio,
      ),
      MapEntry<String, bool>(
        l10n.capabilityMicrophone,
        capabilities.microphone,
      ),
      MapEntry<String, bool>(l10n.capabilityHdr, capabilities.hdr),
      MapEntry<String, bool>(l10n.capabilityAlpha, capabilities.alpha),
      MapEntry<String, bool>(
        l10n.capabilityWindowFiltering,
        capabilities.windowFiltering,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            l10n.capabilities,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Color(0xFF6E6E73),
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map((e) => _CapBadge(label: e.key, available: e.value))
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _CapBadge extends StatelessWidget {
  const _CapBadge({required this.label, required this.available});

  final String label;
  final bool available;

  @override
  Widget build(BuildContext context) {
    final color = available ? const Color(0xFF34C759) : const Color(0xFFD1D1D6);
    final textColor = available
        ? const Color(0xFF1A7A37)
        : const Color(0xFF6E6E73);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared
// ─────────────────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF2F2F7));
  }
}
