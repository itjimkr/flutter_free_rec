import 'package:flutter/material.dart';
import 'package:rec/presentation/app_view_model.dart';
import 'package:rec/presentation/recorder_view_model.dart';
import 'package:rec/presentation/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.appVm,
    required this.recorderVm,
    required this.frameRates,
    required this.videoCodecs,
    required this.containerFormats,
    required this.videoQualities,
    required this.audioCodecs,
  });

  final AppViewModel appVm;
  final RecorderViewModel recorderVm;
  final List<int> frameRates;
  final List<String> videoCodecs;
  final List<String> containerFormats;
  final List<String> videoQualities;
  final List<String> audioCodecs;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([appVm, recorderVm]),
      builder: (context, _) {
        final l10n = context.l10n;
        final snapshot = recorderVm.snapshot;
        final prefs = appVm.preferences;
        final localeChoices = localizedLocaleChoices(l10n);

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
                      SectionHeader(title: l10n.general),
                      SettingsCardShell(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                              child: Column(
                                children: <Widget>[
                                  DropRow<String>(
                                    key: const ValueKey<String>(
                                      'settings_language',
                                    ),
                                    label: l10n.language,
                                    value: prefs.localeKey,
                                    items: localeChoices
                                        .map((c) => c.key)
                                        .toList(growable: false),
                                    enabled: true,
                                    itemLabel: (value) => localeChoices
                                        .firstWhere((c) => c.key == value)
                                        .label,
                                    onChanged: (value) {
                                      if (value == null) return;
                                      appVm.update(
                                        prefs.copyWith(localeKey: value),
                                      );
                                    },
                                  ),
                                  SwitchRow(
                                    key: const ValueKey<String>(
                                      'settings_auto_refresh',
                                    ),
                                    label: l10n.autoRefresh,
                                    value: prefs.autoRefreshEnabled,
                                    enabled: true,
                                    onChanged: (value) {
                                      appVm.update(
                                        prefs.copyWith(
                                          autoRefreshEnabled: value,
                                        ),
                                      );
                                    },
                                  ),
                                  if (prefs.autoRefreshEnabled)
                                    DropRow<int>(
                                      key: const ValueKey<String>(
                                        'settings_refresh_interval',
                                      ),
                                      label: l10n.refreshInterval,
                                      value: prefs.autoRefreshSeconds,
                                      items: const <int>[1, 2, 5, 10],
                                      enabled: true,
                                      itemLabel: (value) => '${value}s',
                                      onChanged: (value) {
                                        if (value == null) return;
                                        appVm.update(
                                          prefs.copyWith(
                                            autoRefreshSeconds: value,
                                          ),
                                        );
                                      },
                                    ),
                                  DropRow<int>(
                                    key: const ValueKey<String>(
                                      'settings_countdown_seconds',
                                    ),
                                    label: l10n.countdown,
                                    value: prefs.countdownSeconds,
                                    items: const <int>[0, 3, 5, 10],
                                    enabled: true,
                                    itemLabel: (value) =>
                                        value == 0 ? '0s' : '${value}s',
                                    onChanged: (value) {
                                      if (value == null) return;
                                      appVm.update(
                                        prefs.copyWith(
                                          countdownSeconds: value,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const AppDivider(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FilledButton.tonalIcon(
                                  onPressed: () => recorderVm.refresh(),
                                  icon: const Icon(Icons.refresh),
                                  label: Text(l10n.refresh),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (snapshot != null) ...<Widget>[
                        const SizedBox(height: 18),
                        SectionHeader(title: l10n.recordingDefaults),
                        SettingsCardShell(
                          child: Column(
                            children: <Widget>[
                              RecordingModeSelector(
                                captureMicrophone:
                                    snapshot.settings.captureMicrophone,
                                enabled: !snapshot.isRecording,
                                onChanged: (mic) => recorderVm.updateSettings(
                                  <String, dynamic>{'captureMicrophone': mic},
                                ),
                              ),
                              const AppDivider(),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                                child: Column(
                                  children: <Widget>[
                                    DropRow<int>(
                                      label: l10n.frameRate,
                                      value: snapshot.settings.frameRate,
                                      items: frameRates,
                                      enabled: !snapshot.isRecording,
                                      itemLabel: (value) =>
                                          value == 0 ? l10n.native : '$value fps',
                                      onChanged: (value) {
                                        if (value == null) return;
                                        recorderVm.updateSettings(
                                          <String, dynamic>{'frameRate': value},
                                        );
                                      },
                                    ),
                                    DropRow<String>(
                                      label: l10n.quality,
                                      value: snapshot.settings.videoQuality,
                                      items: videoQualities,
                                      enabled: !snapshot.isRecording,
                                      itemLabel: (value) =>
                                          videoQualityLabel(l10n, value),
                                      onChanged: (value) {
                                        if (value == null) return;
                                        recorderVm.updateSettings(
                                          <String, dynamic>{'videoQuality': value},
                                        );
                                      },
                                    ),
                                    SwitchRow(
                                      label: l10n.systemAudio,
                                      value: snapshot.settings.captureSystemAudio,
                                      enabled: !snapshot.isRecording,
                                      onChanged: (value) =>
                                          recorderVm.updateSettings(
                                        <String, dynamic>{
                                          'captureSystemAudio': value,
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        SectionHeader(title: l10n.accessAndStorage),
                        SettingsCardShell(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: PermBadge(
                                        label: l10n.screen,
                                        statusLabel:
                                            snapshot.permissions.isScreenReady
                                            ? l10n.ready
                                            : snapshot
                                                  .permissions
                                                  .isScreenDenied
                                            ? l10n.openSettings
                                            : l10n.needsAllow,
                                        detail: screenPermissionDetail(
                                          l10n,
                                          snapshot,
                                        ),
                                        tone: snapshot.permissions.isScreenReady
                                            ? BadgeTone.ready
                                            : snapshot
                                                  .permissions
                                                  .isScreenDenied
                                            ? BadgeTone.blocked
                                            : BadgeTone.actionNeeded,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: PermBadge(
                                        label: l10n.microphone,
                                        statusLabel:
                                            snapshot.settings.captureMicrophone
                                            ? (snapshot
                                                      .permissions
                                                      .isMicrophoneGranted
                                                  ? l10n.ready
                                                  : snapshot
                                                        .permissions
                                                        .isMicrophoneDenied
                                                  ? l10n.openSettings
                                                  : l10n.needsAllow)
                                            : l10n.optional,
                                        detail:
                                            snapshot.settings.captureMicrophone
                                            ? microphonePermissionDetail(
                                                l10n,
                                                snapshot,
                                              )
                                            : l10n
                                                .microphonePermissionDetailOptional,
                                        tone:
                                            !snapshot
                                                .settings
                                                .captureMicrophone
                                            ? BadgeTone.optional
                                            : snapshot
                                                  .permissions
                                                  .isMicrophoneGranted
                                            ? BadgeTone.ready
                                            : snapshot
                                                  .permissions
                                                  .isMicrophoneDenied
                                            ? BadgeTone.blocked
                                            : BadgeTone.actionNeeded,
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
                                      onPressed: () =>
                                          recorderVm.requestPermissions(),
                                      child: Text(l10n.allowAccess),
                                    ),
                                    OutlinedButton(
                                      onPressed: () => recorderVm
                                          .openScreenRecordingSettings(),
                                      child: Text(l10n.screenSettings),
                                    ),
                                    OutlinedButton(
                                      onPressed: () =>
                                          recorderVm.openMicrophoneSettings(),
                                      child: Text(l10n.microphoneSettings),
                                    ),
                                    TextButton(
                                      onPressed: () => recorderVm.refresh(),
                                      child: Text(l10n.checkAgain),
                                    ),
                                  ],
                                ),
                                if (snapshot.isMacRecorder) ...<Widget>[
                                  const SizedBox(height: 10),
                                  const AppDivider(),
                                  OutputRow(
                                    outputDirectory:
                                        snapshot.settings.outputDirectory,
                                    onChoose: () =>
                                        recorderVm.chooseOutputDirectory(),
                                    onOpen: () => recorderVm.openOutputFolder(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        SectionHeader(title: l10n.advancedControls),
                        SettingsAccordion(
                          snapshot: snapshot,
                          frameRates: frameRates,
                          videoCodecs: videoCodecs,
                          containerFormats: containerFormats,
                          videoQualities: videoQualities,
                          audioCodecs: audioCodecs,
                          onUpdateSetting: (changes) =>
                              recorderVm.updateSettings(changes),
                        ),
                        const SizedBox(height: 18),
                        CapabilityRow(capabilities: snapshot.capabilities),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
