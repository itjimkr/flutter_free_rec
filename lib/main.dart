import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'presentation/app_view_model.dart';
import 'presentation/home_page.dart';
import 'presentation/recorder_view_model.dart';
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
  late final RecorderPlatform _platform;
  late AppViewModel _appVm;
  late final RecorderViewModel _recorderVm;

  @override
  void initState() {
    super.initState();
    _platform = const RecorderPlatform();
    _appVm = AppViewModel(_platform, overrideLocale: widget.locale);
    _appVm.initFromDevice(
      WidgetsBinding.instance.platformDispatcher.locales,
    );
    _recorderVm = RecorderViewModel(_platform);
    if (widget.locale == null) {
      _appVm.load(WidgetsBinding.instance.platformDispatcher.locales);
    }
  }

  @override
  void didUpdateWidget(covariant RecApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_sameLocale(oldWidget.locale, widget.locale)) {
      setState(() {
        _appVm = AppViewModel(_platform, overrideLocale: widget.locale);
        _appVm.initFromDevice(
          WidgetsBinding.instance.platformDispatcher.locales,
        );
      });
      if (widget.locale == null) {
        _appVm.load(WidgetsBinding.instance.platformDispatcher.locales);
      }
    }
  }

  @override
  void dispose() {
    _appVm.dispose();
    _recorderVm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appVm,
      builder: (context, _) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          locale: _appVm.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFE53935),
            ),
            scaffoldBackgroundColor: const Color(0xFFF2F2F7),
            cardTheme: const CardThemeData(elevation: 0, color: Colors.white),
          ),
          home: RecorderHomePage(appVm: _appVm, recorderVm: _recorderVm),
        );
      },
    );
  }
}

bool _sameLocale(Locale? a, Locale? b) {
  return a?.languageCode == b?.languageCode && a?.countryCode == b?.countryCode;
}
