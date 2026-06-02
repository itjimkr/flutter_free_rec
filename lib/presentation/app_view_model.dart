import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/domain/app_preferences.dart';
import 'package:rec/recorder_platform.dart';

class AppViewModel extends ChangeNotifier {
  AppViewModel(this._platform, {Locale? overrideLocale})
      : _overrideLocale = overrideLocale;

  final RecorderPlatform _platform;
  final Locale? _overrideLocale;

  late AppPreferences _preferences;
  AppPreferences get preferences => _preferences;

  Locale? get locale => _overrideLocale ?? _preferences.locale;

  void initFromDevice(List<Locale> deviceLocales) {
    _preferences = _overrideLocale != null
        ? AppPreferences.fromLocale(_overrideLocale)
        : AppPreferences.initialFromDevice(deviceLocales);
  }

  Future<void> load(List<Locale> deviceLocales) async {
    Map<String, dynamic> saved;
    try {
      saved = await _platform.loadAppPreferences();
    } catch (error, stack) {
      debugPrint('[Rec] loadAppPreferences() failed: $error\n$stack');
      return;
    }
    _log('loadAppPreferences() => $saved');
    if (_overrideLocale != null) return;

    final fallback = AppPreferences.initialFromDevice(deviceLocales);
    final next = AppPreferences.fromStoredMap(saved, fallback: fallback);
    final shouldSeedDefaults =
        next.toMap().keys.any((key) => !saved.containsKey(key));

    _preferences = next;
    notifyListeners();
    _log(
      'appPreferences resolved localeKey=${next.localeKey} '
      'autoRefresh=${next.autoRefreshEnabled} '
      'interval=${next.autoRefreshSeconds} '
      'countdown=${next.countdownSeconds} '
      'recent=${next.recentRecordingPaths.length}',
    );

    if (shouldSeedDefaults) {
      _log('appPreferences missing defaults, seeding native storage');
      unawaited(_save(next));
    }
  }

  void update(AppPreferences next) {
    _preferences = next;
    notifyListeners();
    _log(
      'updateAppPreferences localeKey=${next.localeKey} '
      'autoRefresh=${next.autoRefreshEnabled}',
    );
    if (_overrideLocale == null) unawaited(_save(next));
  }

  void rememberRecordingPath(String path) {
    if (path.isEmpty) return;
    final existing = _preferences.recentRecordingPaths;
    if (existing.isNotEmpty && existing.first == path) return;
    final next = <String>[path, ...existing.where((e) => e != path)];
    update(
      _preferences.copyWith(
        recentRecordingPaths: next.take(5).toList(growable: false),
      ),
    );
  }

  Future<void> _save(AppPreferences prefs) async {
    try {
      await _platform.saveAppPreferences(prefs.toMap());
    } catch (error, stack) {
      debugPrint('[Rec] saveAppPreferences() failed: $error\n$stack');
    }
  }
}

void _log(String message) {
  if (!kDebugMode) return;
  debugPrint('[Rec][Flutter] $message');
}
