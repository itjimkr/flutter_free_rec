# Security Policy

Rec is a screen recording app and handles sensitive OS permissions. Please
report security issues carefully.

## Supported Versions

The public `master` branch is the only currently supported development line.
Tagged releases will define their own support status when release packaging is
added.

## Reporting a Vulnerability

Please do not open a public issue with exploit details, private recordings,
access tokens, crash dumps containing personal data, or other sensitive
material.

If GitHub private vulnerability reporting is enabled for this repository, use
that path. Otherwise, open a minimal public issue asking for a private contact
channel and include only a short, non-sensitive summary.

Useful report details include:

- Platform and OS version
- App version or commit SHA
- Recording mode and audio settings
- Whether the issue affects saved files, permissions, sandboxing, or data
  exposure
- Minimal reproduction steps without sensitive media

## Scope

Security-relevant areas include:

- Screen and microphone permission handling
- Saved recording file locations and sandbox access
- Native bridge method validation
- Foreground service behavior on Android
- Accidental capture of the recorder UI or unintended windows
