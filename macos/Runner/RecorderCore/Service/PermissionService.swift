//
//  PermissionService.swift
//  BetterCapture
//
//  Created by Joshua Sattler on 07.02.26.
//

import Foundation
import ScreenCaptureKit
import AVFoundation
import OSLog
import CoreGraphics
import AppKit

/// Service responsible for checking and requesting system permissions
@MainActor
@Observable
final class PermissionService {
    private enum StorageKey {
        static let didRequestScreenRecordingPermission = "PermissionService.didRequestScreenRecordingPermission"
    }

    // MARK: - Permission States

    enum PermissionState {
        case unknown
        case granted
        case denied
    }

    private(set) var screenRecordingState: PermissionState = .unknown
    private(set) var microphoneState: PermissionState = .unknown

    var allPermissionsGranted: Bool {
        screenRecordingState == .granted && microphoneState == .granted
    }

    var hasAnyPermissionDenied: Bool {
        screenRecordingState == .denied || microphoneState == .denied
    }

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "BetterCapture",
        category: "PermissionService"
    )
    private var lastLoggedStateSignature: String?

    private var didRequestScreenRecordingPermission: Bool {
        get { UserDefaults.standard.bool(forKey: StorageKey.didRequestScreenRecordingPermission) }
        set { UserDefaults.standard.set(newValue, forKey: StorageKey.didRequestScreenRecordingPermission) }
    }

    // MARK: - Initialization

    init() {
        updatePermissionStates()
    }

    // MARK: - Permission Checking

    /// Updates all permission states
    func updatePermissionStates() {
        screenRecordingState = checkScreenRecordingPermission()
        microphoneState = checkMicrophonePermission()

        logger.info("Permission states - Screen: \(String(describing: self.screenRecordingState)), Microphone: \(String(describing: self.microphoneState))")
        logStateIfNeeded(source: "update")
    }

    private func checkScreenRecordingPermission() -> PermissionState {
        if CGPreflightScreenCaptureAccess() {
            return .granted
        }

        return didRequestScreenRecordingPermission ? .denied : .unknown
    }

    private func checkMicrophonePermission() -> PermissionState {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            return .granted
        case .notDetermined:
            return .unknown
        case .denied, .restricted:
            return .denied
        @unknown default:
            return .unknown
        }
    }

    // MARK: - Permission Requests

    /// Requests required permissions on app launch
    /// - Parameter includeMicrophone: Whether to also request microphone permission
    func requestPermissions(includeMicrophone: Bool) async {
        logger.info("Requesting permissions (includeMicrophone: \(includeMicrophone))...")
        emitTerminalLog("requestPermissions begin includeMicrophone=\(includeMicrophone)")

        // Request screen recording permission first (synchronous)
        requestScreenRecordingPermission()

        // Request microphone permission only if needed (asynchronous)
        if includeMicrophone {
            await requestMicrophonePermission()
        }

        // Update states after requests
        updatePermissionStates()
        emitTerminalLog("requestPermissions end")
    }

    /// Requests screen recording permission
    /// - Note: This will open System Settings if permission was previously denied
    func requestScreenRecordingPermission() {
        didRequestScreenRecordingPermission = true
        let wasGranted = CGRequestScreenCaptureAccess()
        screenRecordingState = wasGranted ? .granted : .denied
        logger.info("Screen recording permission request result: \(wasGranted)")
        emitTerminalLog("screenPermission result granted=\(wasGranted)")
    }

    /// Requests microphone permission
    func requestMicrophonePermission() async {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)

        switch status {
        case .authorized:
            microphoneState = .granted
            emitTerminalLog("microphonePermission already authorized")
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .audio)
            microphoneState = granted ? .granted : .denied
            logger.info("Microphone permission request result: \(granted)")
            emitTerminalLog("microphonePermission requested granted=\(granted)")
        case .denied, .restricted:
            microphoneState = .denied
            emitTerminalLog("microphonePermission deniedOrRestricted")
        @unknown default:
            microphoneState = .unknown
            emitTerminalLog("microphonePermission unknownDefault")
        }
    }

    /// Opens System Settings to the Screen Recording preferences pane
    func openScreenRecordingSettings() {
        let opened = openSystemSettings(
            candidates: [
                "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture",
                "x-apple.systempreferences:com.apple.preference.security",
            ]
        )
        emitTerminalLog("openScreenRecordingSettings opened=\(opened)")
    }

    /// Opens System Settings to the Microphone preferences pane
    func openMicrophoneSettings() {
        let opened = openSystemSettings(
            candidates: [
                "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone",
                "x-apple.systempreferences:com.apple.preference.security",
            ]
        )
        emitTerminalLog("openMicrophoneSettings opened=\(opened)")
    }

    @discardableResult
    private func openSystemSettings(candidates: [String]) -> Bool {
        for candidate in candidates {
            guard let url = URL(string: candidate) else {
                continue
            }

            if NSWorkspace.shared.open(url) {
                return true
            }
        }

        let fallbackURL = URL(fileURLWithPath: "/System/Applications/System Settings.app")
        if NSWorkspace.shared.open(fallbackURL) {
            return true
        }

        return false
    }

    private func emitTerminalLog(_ message: String) {
        NSLog("%@", "[Rec][Permission] \(message)")
    }

    private func describe(_ state: PermissionState) -> String {
        switch state {
        case .unknown:
            return "unknown"
        case .granted:
            return "granted"
        case .denied:
            return "denied"
        }
    }

    private func logStateIfNeeded(source: String) {
        let signature = "screen=\(describe(screenRecordingState)), mic=\(describe(microphoneState))"
        guard lastLoggedStateSignature != signature else {
            return
        }

        lastLoggedStateSignature = signature
        emitTerminalLog("\(source) states \(signature)")
    }
}
