import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppPreferences {
  const AppPreferences({
    required this.localeKey,
    this.autoRefreshEnabled = true,
    this.autoRefreshSeconds = 1,
    this.countdownSeconds = 3,
    this.recentRecordingPaths = const <String>[],
    this.shortcuts = const ShortcutPreferences(),
  });

  final String localeKey;
  final bool autoRefreshEnabled;
  final int autoRefreshSeconds;
  final int countdownSeconds;
  final List<String> recentRecordingPaths;
  final ShortcutPreferences shortcuts;

  factory AppPreferences.fromLocale(Locale? locale) {
    return AppPreferences(localeKey: localeChoiceKey(locale));
  }

  factory AppPreferences.initialFromDevice(List<Locale> deviceLocales) {
    return AppPreferences(localeKey: bestSupportedLocaleKeyFor(deviceLocales));
  }

  factory AppPreferences.fromStoredMap(
    Map<String, dynamic> map, {
    required AppPreferences fallback,
  }) {
    final rawLocaleKey = map['localeKey'] as String?;
    final localeKey = localeChoiceForKey(rawLocaleKey ?? '') == null
        ? fallback.localeKey
        : rawLocaleKey!;
    final autoRefreshEnabled =
        map['autoRefreshEnabled'] as bool? ?? fallback.autoRefreshEnabled;
    final autoRefreshSeconds = switch (map['autoRefreshSeconds']) {
      final int v when v == 1 || v == 2 || v == 5 || v == 10 => v,
      final num v
          when v.toInt() == 1 ||
              v.toInt() == 2 ||
              v.toInt() == 5 ||
              v.toInt() == 10 =>
        v.toInt(),
      _ => fallback.autoRefreshSeconds,
    };
    final countdownSeconds = switch (map['countdownSeconds']) {
      final int v when v == 0 || v == 3 || v == 5 || v == 10 => v,
      final num v
          when v.toInt() == 0 ||
              v.toInt() == 3 ||
              v.toInt() == 5 ||
              v.toInt() == 10 =>
        v.toInt(),
      _ => fallback.countdownSeconds,
    };
    final recentRecordingPaths =
        normalizeRecentRecordingPaths(map['recentRecordingPaths']);
    final shortcuts = ShortcutPreferences.fromStoredMap(
      map,
      fallback: fallback.shortcuts,
    );

    return AppPreferences(
      localeKey: localeKey,
      autoRefreshEnabled: autoRefreshEnabled,
      autoRefreshSeconds: autoRefreshSeconds,
      countdownSeconds: countdownSeconds,
      recentRecordingPaths: recentRecordingPaths,
      shortcuts: shortcuts,
    );
  }

  Locale? get locale => localeChoiceForKey(localeKey)?.locale;

  AppPreferences copyWith({
    String? localeKey,
    bool? autoRefreshEnabled,
    int? autoRefreshSeconds,
    int? countdownSeconds,
    List<String>? recentRecordingPaths,
    ShortcutPreferences? shortcuts,
  }) {
    return AppPreferences(
      localeKey: localeKey ?? this.localeKey,
      autoRefreshEnabled: autoRefreshEnabled ?? this.autoRefreshEnabled,
      autoRefreshSeconds: autoRefreshSeconds ?? this.autoRefreshSeconds,
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
      recentRecordingPaths: recentRecordingPaths ?? this.recentRecordingPaths,
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

List<String> normalizeRecentRecordingPaths(dynamic raw) {
  if (raw is! List) return const <String>[];
  final unique = <String>{};
  final normalized = <String>[];
  for (final entry in raw.whereType<String>()) {
    final trimmed = entry.trim();
    if (trimmed.isEmpty || !unique.add(trimmed)) continue;
    normalized.add(trimmed);
    if (normalized.length == 5) break;
  }
  return normalized;
}

// ─── Shortcut domain ───────────────────────────────────────────────────────────

enum ShortcutAction {
  recordApplication('shortcutRecordApplication', 'digit1'),
  recordFullScreen('shortcutRecordFullScreen', 'digit2'),
  recordArea('shortcutRecordArea', 'digit3'),
  pauseResume('shortcutPauseResume', 'keyP'),
  stop('shortcutStop', 'period'),
  openSettings('shortcutOpenSettings', 'comma'),
  openSavedFolder('shortcutOpenSavedFolder', 'keyO');

  const ShortcutAction(this.storageKey, this.defaultShortcutKeyId);

  final String storageKey;
  final String defaultShortcutKeyId;
}

class ShortcutPreferences {
  const ShortcutPreferences({
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

  factory ShortcutPreferences.fromStoredMap(
    Map<String, dynamic> map, {
    required ShortcutPreferences fallback,
  }) {
    final assigned = <String>{};

    String resolve(ShortcutAction action) {
      final fallbackKeyId = fallback.keyFor(action);
      final raw = map[action.storageKey] as String?;
      final candidate =
          shortcutKeyChoiceForId(raw) == null ? fallbackKeyId : raw!;
      if (assigned.add(candidate)) return candidate;
      final available = firstAvailableShortcutKeyId(
        preferred: fallbackKeyId,
        used: assigned,
      );
      assigned.add(available);
      return available;
    }

    return ShortcutPreferences(
      recordApplicationKey: resolve(ShortcutAction.recordApplication),
      recordFullScreenKey: resolve(ShortcutAction.recordFullScreen),
      recordAreaKey: resolve(ShortcutAction.recordArea),
      pauseResumeKey: resolve(ShortcutAction.pauseResume),
      stopKey: resolve(ShortcutAction.stop),
      openSettingsKey: resolve(ShortcutAction.openSettings),
      openSavedFolderKey: resolve(ShortcutAction.openSavedFolder),
    );
  }

  String keyFor(ShortcutAction action) {
    return switch (action) {
      ShortcutAction.recordApplication => recordApplicationKey,
      ShortcutAction.recordFullScreen => recordFullScreenKey,
      ShortcutAction.recordArea => recordAreaKey,
      ShortcutAction.pauseResume => pauseResumeKey,
      ShortcutAction.stop => stopKey,
      ShortcutAction.openSettings => openSettingsKey,
      ShortcutAction.openSavedFolder => openSavedFolderKey,
    };
  }

  ShortcutPreferences update(ShortcutAction action, String shortcutKeyId) {
    final values = <ShortcutAction, String>{
      for (final item in ShortcutAction.values) item: keyFor(item),
    };
    final previous = values[action]!;
    ShortcutAction? duplicatedAction;
    for (final entry in values.entries) {
      if (entry.key != action && entry.value == shortcutKeyId) {
        duplicatedAction = entry.key;
        break;
      }
    }
    if (duplicatedAction != null) values[duplicatedAction] = previous;
    values[action] = shortcutKeyId;
    return ShortcutPreferences(
      recordApplicationKey: values[ShortcutAction.recordApplication]!,
      recordFullScreenKey: values[ShortcutAction.recordFullScreen]!,
      recordAreaKey: values[ShortcutAction.recordArea]!,
      pauseResumeKey: values[ShortcutAction.pauseResume]!,
      stopKey: values[ShortcutAction.stop]!,
      openSettingsKey: values[ShortcutAction.openSettings]!,
      openSavedFolderKey: values[ShortcutAction.openSavedFolder]!,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ShortcutAction.recordApplication.storageKey: recordApplicationKey,
      ShortcutAction.recordFullScreen.storageKey: recordFullScreenKey,
      ShortcutAction.recordArea.storageKey: recordAreaKey,
      ShortcutAction.pauseResume.storageKey: pauseResumeKey,
      ShortcutAction.stop.storageKey: stopKey,
      ShortcutAction.openSettings.storageKey: openSettingsKey,
      ShortcutAction.openSavedFolder.storageKey: openSavedFolderKey,
    };
  }
}

class ShortcutKeyChoice {
  const ShortcutKeyChoice({
    required this.id,
    required this.label,
    required this.key,
  });

  final String id;
  final String label;
  final LogicalKeyboardKey key;
}

const List<ShortcutKeyChoice> shortcutKeyChoices = <ShortcutKeyChoice>[
  ShortcutKeyChoice(id: 'digit1', label: '1', key: LogicalKeyboardKey.digit1),
  ShortcutKeyChoice(id: 'digit2', label: '2', key: LogicalKeyboardKey.digit2),
  ShortcutKeyChoice(id: 'digit3', label: '3', key: LogicalKeyboardKey.digit3),
  ShortcutKeyChoice(id: 'digit4', label: '4', key: LogicalKeyboardKey.digit4),
  ShortcutKeyChoice(id: 'digit5', label: '5', key: LogicalKeyboardKey.digit5),
  ShortcutKeyChoice(id: 'digit6', label: '6', key: LogicalKeyboardKey.digit6),
  ShortcutKeyChoice(id: 'digit7', label: '7', key: LogicalKeyboardKey.digit7),
  ShortcutKeyChoice(id: 'digit8', label: '8', key: LogicalKeyboardKey.digit8),
  ShortcutKeyChoice(id: 'digit9', label: '9', key: LogicalKeyboardKey.digit9),
  ShortcutKeyChoice(id: 'digit0', label: '0', key: LogicalKeyboardKey.digit0),
  ShortcutKeyChoice(id: 'keyP', label: 'P', key: LogicalKeyboardKey.keyP),
  ShortcutKeyChoice(id: 'keyO', label: 'O', key: LogicalKeyboardKey.keyO),
  ShortcutKeyChoice(id: 'keyR', label: 'R', key: LogicalKeyboardKey.keyR),
  ShortcutKeyChoice(id: 'keyS', label: 'S', key: LogicalKeyboardKey.keyS),
  ShortcutKeyChoice(id: 'keyF', label: 'F', key: LogicalKeyboardKey.keyF),
  ShortcutKeyChoice(id: 'keyG', label: 'G', key: LogicalKeyboardKey.keyG),
  ShortcutKeyChoice(id: 'keyA', label: 'A', key: LogicalKeyboardKey.keyA),
  ShortcutKeyChoice(id: 'comma', label: ',', key: LogicalKeyboardKey.comma),
  ShortcutKeyChoice(id: 'period', label: '.', key: LogicalKeyboardKey.period),
];

ShortcutKeyChoice? shortcutKeyChoiceForId(String? id) {
  if (id == null) return null;
  for (final choice in shortcutKeyChoices) {
    if (choice.id == id) return choice;
  }
  return null;
}

String firstAvailableShortcutKeyId({
  required String preferred,
  required Set<String> used,
}) {
  if (!used.contains(preferred)) return preferred;
  for (final choice in shortcutKeyChoices) {
    if (!used.contains(choice.id)) return choice.id;
  }
  return preferred;
}

// ─── Locale domain ────────────────────────────────────────────────────────────

bool sameLocale(Locale? a, Locale? b) {
  return a?.languageCode == b?.languageCode && a?.countryCode == b?.countryCode;
}

class LocaleChoice {
  const LocaleChoice({required this.key, required this.label, this.locale});

  final String key;
  final String label;
  final Locale? locale;
}

const List<LocaleChoice> supportedLocaleChoices = <LocaleChoice>[
  LocaleChoice(key: 'en', label: 'English', locale: Locale('en')),
  LocaleChoice(key: 'ko', label: '한국어', locale: Locale('ko')),
  LocaleChoice(key: 'ja', label: '日本語', locale: Locale('ja')),
  LocaleChoice(key: 'tr', label: 'Türkçe', locale: Locale('tr')),
  LocaleChoice(key: 'hi', label: 'हिन्दी', locale: Locale('hi')),
  LocaleChoice(key: 'id', label: 'Bahasa Indonesia', locale: Locale('id')),
  LocaleChoice(key: 'vi', label: 'Tiếng Việt', locale: Locale('vi')),
  LocaleChoice(key: 'th', label: 'ไทย', locale: Locale('th')),
  LocaleChoice(
    key: 'pt_BR',
    label: 'Português (Brasil)',
    locale: Locale('pt', 'BR'),
  ),
  LocaleChoice(key: 'it', label: 'Italiano', locale: Locale('it')),
  LocaleChoice(key: 'es', label: 'Español', locale: Locale('es')),
  LocaleChoice(key: 'de', label: 'Deutsch', locale: Locale('de')),
  LocaleChoice(key: 'fr', label: 'Français', locale: Locale('fr')),
  LocaleChoice(key: 'pl', label: 'Polski', locale: Locale('pl')),
  LocaleChoice(key: 'nl', label: 'Nederlands', locale: Locale('nl')),
  LocaleChoice(key: 'ru', label: 'Русский', locale: Locale('ru')),
  LocaleChoice(key: 'zh_TW', label: '繁體中文', locale: Locale('zh', 'TW')),
];

String localeChoiceKey(Locale? locale) {
  if (locale == null) return 'system';
  return locale.countryCode == null
      ? locale.languageCode
      : '${locale.languageCode}_${locale.countryCode}';
}

LocaleChoice? localeChoiceForKey(String key) {
  if (key == 'system') return const LocaleChoice(key: 'system', label: '');
  for (final choice in supportedLocaleChoices) {
    if (choice.key == key) return choice;
  }
  return null;
}

String bestSupportedLocaleKeyFor(List<Locale> deviceLocales) {
  for (final locale in deviceLocales) {
    final exactKey = localeChoiceKey(locale);
    if (localeChoiceForKey(exactKey) != null) return exactKey;

    if (locale.languageCode == 'zh') {
      final country = locale.countryCode?.toUpperCase();
      final isTraditional =
          locale.scriptCode == 'Hant' ||
          country == 'TW' ||
          country == 'HK' ||
          country == 'MO';
      if (isTraditional) return 'zh_TW';
      continue;
    }

    for (final choice in supportedLocaleChoices) {
      if (choice.locale?.languageCode == locale.languageCode) return choice.key;
    }
  }
  return 'en';
}
