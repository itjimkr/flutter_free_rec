import 'package:flutter/material.dart';
import 'package:rec/domain/app_preferences.dart';
import 'package:rec/domain/recording.dart';
import 'package:rec/l10n/app_localizations.dart';
import 'package:rec/recorder_platform.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

// ─── Label helpers ────────────────────────────────────────────────────────────

String recordingStateLabel(AppLocalizations l10n, String state) {
  return switch (state) {
    'recording' => l10n.recordingState,
    'paused' => l10n.pausedState,
    'stopping' => l10n.stoppingState,
    _ => l10n.idleState,
  };
}

String videoQualityLabel(AppLocalizations l10n, String value) {
  return switch (value) {
    'Low' => l10n.qualityLow,
    'Medium' => l10n.qualityMedium,
    'High' => l10n.qualityHigh,
    _ => value,
  };
}

String deviceNameOrFallback(
  AppLocalizations l10n,
  String? id,
  List<DeviceOption> devices,
) {
  if (id == null) return l10n.systemDefault;
  return devices
      .firstWhere(
        (device) => device.id == id,
        orElse: () => DeviceOption(id: '', name: l10n.unknownDevice),
      )
      .name;
}

String recordingTargetLabel(AppLocalizations l10n, RecordingTarget target) {
  return switch (target) {
    RecordingTarget.application => l10n.specificProgramRecord,
    RecordingTarget.fullScreen => l10n.fullScreenRecord,
    RecordingTarget.area => l10n.specificAreaRecord,
  };
}

String audioChoiceLabel(AppLocalizations l10n, RecordingAudioChoice choice) {
  return switch (choice) {
    RecordingAudioChoice.none => l10n.audioExcluded,
    RecordingAudioChoice.systemOnly => l10n.audioSystemOnly,
    RecordingAudioChoice.microphoneOnly => l10n.audioMicrophoneOnly,
    RecordingAudioChoice.systemAndMicrophone => l10n.audioSystemAndMicrophone,
  };
}

String shortcutActionLabel(AppLocalizations l10n, ShortcutAction action) {
  return switch (action) {
    ShortcutAction.recordApplication =>
      recordingTargetLabel(l10n, RecordingTarget.application),
    ShortcutAction.recordFullScreen =>
      recordingTargetLabel(l10n, RecordingTarget.fullScreen),
    ShortcutAction.recordArea =>
      recordingTargetLabel(l10n, RecordingTarget.area),
    ShortcutAction.pauseResume =>
      '${l10n.pauseAction} / ${l10n.resumeAction}',
    ShortcutAction.stop => l10n.stopAction,
    ShortcutAction.openSettings => l10n.openSettings,
    ShortcutAction.openSavedFolder => l10n.openSavedFolder,
  };
}

String shortcutDisplayLabel(String shortcutKeyId) {
  final choice = shortcutKeyChoiceForId(shortcutKeyId);
  return choice == null ? shortcutKeyId : 'Cmd/Ctrl + ${choice.label}';
}

String screenPermissionDetail(
  AppLocalizations l10n,
  RecorderSnapshot snapshot,
) {
  final permissions = snapshot.permissions;
  if (permissions.isScreenPromptOnStart) {
    return l10n.screenPermissionDetailPromptOnStart;
  }
  if (permissions.isScreenReady) return l10n.screenPermissionDetailReady;
  if (permissions.isScreenDenied) return l10n.screenPermissionDetailDenied;
  return l10n.screenPermissionDetailUnknown;
}

String microphonePermissionDetail(
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

String fileNameFromPath(String path) {
  final normalized = path.replaceAll('\\', '/');
  final segments = normalized.split('/');
  return segments.isEmpty ? path : segments.last;
}

List<LocaleChoice> localizedLocaleChoices(AppLocalizations l10n) {
  return <LocaleChoice>[
    LocaleChoice(key: 'system', label: l10n.systemDefault),
    ...supportedLocaleChoices.where((choice) => choice.locale != null),
  ];
}

// ─── Shared display widgets ───────────────────────────────────────────────────

class AppDivider extends StatelessWidget {
  const AppDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF2F2F7));
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title});

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

class SettingsCardShell extends StatelessWidget {
  const SettingsCardShell({required this.child});

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

enum BadgeTone { ready, actionNeeded, blocked, optional }

class PermBadge extends StatelessWidget {
  const PermBadge({
    required this.label,
    required this.statusLabel,
    required this.detail,
    required this.tone,
  });

  final String label;
  final String statusLabel;
  final String detail;
  final BadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final (color, background, icon) = switch (tone) {
      BadgeTone.ready => (
        const Color(0xFF34C759),
        const Color(0xFF34C759).withValues(alpha: 0.08),
        Icons.check_circle_outline,
      ),
      BadgeTone.actionNeeded => (
        const Color(0xFFFF9500),
        const Color(0xFFFF9500).withValues(alpha: 0.08),
        Icons.warning_amber_outlined,
      ),
      BadgeTone.blocked => (
        const Color(0xFFC62828),
        const Color(0xFFFFEBEE),
        Icons.settings_outlined,
      ),
      BadgeTone.optional => (
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

class CapabilityRow extends StatelessWidget {
  const CapabilityRow({required this.capabilities});

  final RecorderCapabilities capabilities;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = <MapEntry<String, bool>>[
      MapEntry(l10n.capabilityContentPicker, capabilities.contentPicker),
      MapEntry(l10n.capabilityAreaSelection, capabilities.areaSelection),
      MapEntry(l10n.capabilityPresenterOverlay, capabilities.presenterOverlay),
      MapEntry(l10n.capabilitySystemAudio, capabilities.systemAudio),
      MapEntry(l10n.capabilityMicrophone, capabilities.microphone),
      MapEntry(l10n.capabilityHdr, capabilities.hdr),
      MapEntry(l10n.capabilityAlpha, capabilities.alpha),
      MapEntry(l10n.capabilityWindowFiltering, capabilities.windowFiltering),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            l10n.capabilities,
            style: const TextStyle(
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
              .map((e) => CapBadge(label: e.key, available: e.value))
              .toList(growable: false),
        ),
      ],
    );
  }
}

class CapBadge extends StatelessWidget {
  const CapBadge({required this.label, required this.available});

  final String label;
  final bool available;

  @override
  Widget build(BuildContext context) {
    final color =
        available ? const Color(0xFF34C759) : const Color(0xFFD1D1D6);
    final textColor =
        available ? const Color(0xFF1A7A37) : const Color(0xFF6E6E73);

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

// ─── Settings row primitives ──────────────────────────────────────────────────

class SwitchRow extends StatelessWidget {
  const SwitchRow({
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

class DropRow<T> extends StatelessWidget {
  const DropRow({
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

// ─── Recording card widgets ───────────────────────────────────────────────────

class RecordingModeSelector extends StatelessWidget {
  const RecordingModeSelector({
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
            child: ModeButton(
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
            child: ModeButton(
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

class ModeButton extends StatelessWidget {
  const ModeButton({
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
    final labelColor =
        selected ? const Color(0xFF1C1C1E) : const Color(0xFF6E6E73);

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

class SetupSection extends StatelessWidget {
  const SetupSection({
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
    final guide = RecordingPreparationGuide.fromSnapshot(snapshot);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'SETUP',
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
                child: PermBadge(
                  label: l10n.screen,
                  statusLabel: _screenOk
                      ? l10n.ready
                      : snapshot.permissions.isScreenDenied
                      ? l10n.openSettings
                      : l10n.needsAllow,
                  detail: screenPermissionDetail(l10n, snapshot),
                  tone: _screenOk
                      ? BadgeTone.ready
                      : snapshot.permissions.isScreenDenied
                      ? BadgeTone.blocked
                      : BadgeTone.actionNeeded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PermBadge(
                  label: l10n.microphone,
                  statusLabel: _micRequired
                      ? (_micOk
                            ? l10n.ready
                            : snapshot.permissions.isMicrophoneDenied
                            ? l10n.openSettings
                            : l10n.needsAllow)
                      : l10n.optional,
                  detail: _micRequired
                      ? microphonePermissionDetail(l10n, snapshot)
                      : l10n.microphonePermissionDetailOptional,
                  tone: !_micRequired
                      ? BadgeTone.optional
                      : (_micOk
                            ? BadgeTone.ready
                            : snapshot.permissions.isMicrophoneDenied
                            ? BadgeTone.blocked
                            : BadgeTone.actionNeeded),
                ),
              ),
            ],
          ),
          if (guide.requiresSetup) ...<Widget>[
            const SizedBox(height: 12),
            SetupGuideCard(
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
            ContentRow(
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

class SetupGuideCard extends StatelessWidget {
  const SetupGuideCard({
    required this.guide,
    required this.onRequestPermissions,
    required this.onOpenScreenRecordingSettings,
    required this.onOpenMicrophoneSettings,
    required this.onCheckPermissions,
    required this.onPickContent,
  });

  final RecordingPreparationGuide guide;
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
                      style: const TextStyle(
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

class ContentRow extends StatelessWidget {
  const ContentRow({
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
    final color =
        hasSelection ? const Color(0xFF34C759) : const Color(0xFF6E6E73);
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

class RecordingControl extends StatelessWidget {
  const RecordingControl({
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
    final guide = RecordingPreparationGuide.fromSnapshot(snapshot);
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
            recordingStateLabel(l10n, snapshot.state),
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

class OutputRow extends StatelessWidget {
  const OutputRow({
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

class RecordingCard extends StatelessWidget {
  const RecordingCard({
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
          RecordingModeSelector(
            captureMicrophone: snapshot.settings.captureMicrophone,
            enabled: !snapshot.isRecording,
            onChanged: (mic) =>
                onUpdateSetting(<String, dynamic>{'captureMicrophone': mic}),
          ),
          const AppDivider(),
          SetupSection(
            snapshot: snapshot,
            onRequestPermissions: onRequestPermissions,
            onOpenScreenRecordingSettings: onOpenScreenRecordingSettings,
            onOpenMicrophoneSettings: onOpenMicrophoneSettings,
            onCheckPermissions: onCheckPermissions,
            onPickContent: onPickContent,
            onClearSelection: onClearSelection,
          ),
          const AppDivider(),
          RecordingControl(
            snapshot: snapshot,
            onStart: onStart,
            onStop: onStop,
          ),
          if (onChooseOutputDirectory != null ||
              onOpenOutputFolder != null) ...<Widget>[
            const AppDivider(),
            OutputRow(
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

// ─── Settings accordion ───────────────────────────────────────────────────────

class SettingsAccordion extends StatelessWidget {
  const SettingsAccordion({
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
            SettingsSection(
              title: l10n.video,
              icon: Icons.videocam_outlined,
              children: <Widget>[
                DropRow<int>(
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
                DropRow<String>(
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
                DropRow<String>(
                  label: l10n.container,
                  value: settings.containerFormat,
                  items: containerFormats,
                  enabled: enabled,
                  onChanged: (v) {
                    if (v != null) {
                      onUpdateSetting(
                        <String, dynamic>{'containerFormat': v},
                      );
                    }
                  },
                ),
                DropRow<String>(
                  label: l10n.quality,
                  value: settings.videoQuality,
                  items: videoQualities,
                  enabled: enabled,
                  itemLabel: (v) => videoQualityLabel(l10n, v),
                  onChanged: (v) {
                    if (v != null) {
                      onUpdateSetting(<String, dynamic>{'videoQuality': v});
                    }
                  },
                ),
                SwitchRow(
                  label: l10n.hdr,
                  value: settings.captureHDR,
                  enabled: enabled,
                  onChanged: (v) =>
                      onUpdateSetting(<String, dynamic>{'captureHDR': v}),
                ),
                SwitchRow(
                  label: l10n.alphaChannel,
                  value: settings.captureAlphaChannel,
                  enabled: enabled,
                  onChanged: (v) => onUpdateSetting(
                    <String, dynamic>{'captureAlphaChannel': v},
                  ),
                ),
                SwitchRow(
                  label: l10n.nativeResolution,
                  value: settings.captureNativeResolution,
                  enabled: enabled,
                  onChanged: (v) => onUpdateSetting(
                    <String, dynamic>{'captureNativeResolution': v},
                  ),
                ),
              ],
            ),
            const AppDivider(),
            SettingsSection(
              title: l10n.audio,
              icon: Icons.mic_outlined,
              children: <Widget>[
                DropRow<String>(
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
                SwitchRow(
                  label: l10n.systemAudio,
                  value: settings.captureSystemAudio,
                  enabled: enabled,
                  onChanged: (v) => onUpdateSetting(
                    <String, dynamic>{'captureSystemAudio': v},
                  ),
                ),
                SwitchRow(
                  label: l10n.microphone,
                  value: settings.captureMicrophone,
                  enabled: enabled,
                  onChanged: (v) => onUpdateSetting(
                    <String, dynamic>{'captureMicrophone': v},
                  ),
                ),
                DropRow<String?>(
                  label: l10n.micDevice,
                  value: settings.selectedMicrophoneID,
                  items: <String?>[
                    null,
                    ...snapshot.audioDevices.map((d) => d.id),
                  ],
                  enabled: enabled,
                  itemLabel: (v) =>
                      deviceNameOrFallback(l10n, v, snapshot.audioDevices),
                  onChanged: (v) => onUpdateSetting(
                    <String, dynamic>{'selectedMicrophoneID': v},
                  ),
                ),
              ],
            ),
            const AppDivider(),
            SettingsSection(
              title: l10n.display,
              icon: Icons.display_settings_outlined,
              children: <Widget>[
                SwitchRow(
                  label: l10n.showCursor,
                  value: settings.showCursor,
                  enabled: enabled,
                  onChanged: (v) =>
                      onUpdateSetting(<String, dynamic>{'showCursor': v}),
                ),
                SwitchRow(
                  label: l10n.showWallpaper,
                  value: settings.showWallpaper,
                  enabled: enabled,
                  onChanged: (v) =>
                      onUpdateSetting(<String, dynamic>{'showWallpaper': v}),
                ),
                SwitchRow(
                  label: l10n.showMenuBar,
                  value: settings.showMenuBar,
                  enabled: enabled,
                  onChanged: (v) =>
                      onUpdateSetting(<String, dynamic>{'showMenuBar': v}),
                ),
                SwitchRow(
                  label: l10n.showDock,
                  value: settings.showDock,
                  enabled: enabled,
                  onChanged: (v) =>
                      onUpdateSetting(<String, dynamic>{'showDock': v}),
                ),
                SwitchRow(
                  label: l10n.showRecorderUi,
                  value: settings.showRecorderUI,
                  enabled: enabled,
                  onChanged: (v) =>
                      onUpdateSetting(<String, dynamic>{'showRecorderUI': v}),
                ),
                SwitchRow(
                  label: l10n.windowShadows,
                  value: settings.showWindowShadows,
                  enabled: enabled,
                  onChanged: (v) => onUpdateSetting(
                    <String, dynamic>{'showWindowShadows': v},
                  ),
                ),
              ],
            ),
            const AppDivider(),
            SettingsSection(
              title: l10n.presenterOverlay,
              icon: Icons.person_outlined,
              children: <Widget>[
                SwitchRow(
                  label: l10n.enableOverlay,
                  value: settings.presenterOverlayEnabled,
                  enabled: enabled,
                  onChanged: (v) => onUpdateSetting(
                    <String, dynamic>{'presenterOverlayEnabled': v},
                  ),
                ),
                DropRow<String?>(
                  label: l10n.camera,
                  value: settings.selectedCameraID,
                  items: <String?>[
                    null,
                    ...snapshot.cameraDevices.map((d) => d.id),
                  ],
                  enabled: enabled,
                  itemLabel: (v) =>
                      deviceNameOrFallback(l10n, v, snapshot.cameraDevices),
                  onChanged: (v) => onUpdateSetting(
                    <String, dynamic>{'selectedCameraID': v},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsSection extends StatefulWidget {
  const SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
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
          const AppDivider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Column(children: widget.children),
          ),
        ],
      ],
    );
  }
}

// ─── Home-specific widgets ────────────────────────────────────────────────────

class MinimalRecordingStatus extends StatelessWidget {
  const MinimalRecordingStatus({
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
        : recordingStateLabel(context.l10n, snapshot.state);
    final durationLabel =
        isCountingDown ? '$countdownValue' : snapshot.formattedDuration;

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

class RecentRecordingsCard extends StatelessWidget {
  const RecentRecordingsCard({
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
                fileNameFromPath(path),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                path,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                key: ValueKey<String>(
                  'recent_recording_${fileNameFromPath(path)}',
                ),
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

// ─── Legacy hidden panels ─────────────────────────────────────────────────────

class PlatformBadge extends StatelessWidget {
  const PlatformBadge({required this.platform});

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

class NoteBanner extends StatelessWidget {
  const NoteBanner({required this.note});

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
            child: Text(
              note,
              style: const TextStyle(color: Color(0xFF856404)),
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({required this.message, required this.onDismiss});

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
