import AppKit
import FlutterMacOS
import Foundation
import ScreenCaptureKit

private func L(_ key: String, _ value: String) -> String {
  NSLocalizedString(key, tableName: nil, bundle: .main, value: value, comment: "")
}

private func BridgeLog(_ message: String) {
  NSLog("%@", "[Rec][Bridge] \(message)")
}

@MainActor
final class RecorderBridge: NSObject {
  private enum LaunchSelfTest {
    static let enabled = "REC_SELFTEST_RECORD"
    static let includeMicrophone = "REC_SELFTEST_INCLUDE_MICROPHONE"
    static let durationSeconds = "REC_SELFTEST_DURATION_SECONDS"
    static let autoQuit = "REC_SELFTEST_AUTO_QUIT"
  }

  private enum ChannelMethod {
    static let snapshot = "snapshot"
    static let loadAppPreferences = "loadAppPreferences"
    static let saveAppPreferences = "saveAppPreferences"
    static let requestPermissions = "requestPermissions"
    static let presentPicker = "presentPicker"
    static let presentAreaSelection = "presentAreaSelection"
    static let clearSelection = "clearSelection"
    static let startRecording = "startRecording"
    static let stopRecording = "stopRecording"
    static let pauseRecording = "pauseRecording"
    static let resumeRecording = "resumeRecording"
    static let updateSettings = "updateSettings"
    static let chooseOutputDirectory = "chooseOutputDirectory"
    static let openOutputFolder = "openOutputFolder"
    static let revealRecording = "revealRecording"
    static let openScreenRecordingSettings = "openScreenRecordingSettings"
    static let openMicrophoneSettings = "openMicrophoneSettings"
  }

  private enum AppPreferenceKey {
    static let localeKey = "app.localeKey"
    static let autoRefreshEnabled = "app.autoRefreshEnabled"
    static let autoRefreshSeconds = "app.autoRefreshSeconds"
    static let countdownSeconds = "app.countdownSeconds"
    static let recentRecordingPaths = "app.recentRecordingPaths"
    static let shortcutRecordApplication = "app.shortcutRecordApplication"
    static let shortcutRecordFullScreen = "app.shortcutRecordFullScreen"
    static let shortcutRecordArea = "app.shortcutRecordArea"
    static let shortcutPauseResume = "app.shortcutPauseResume"
    static let shortcutStop = "app.shortcutStop"
    static let shortcutOpenSettings = "app.shortcutOpenSettings"
    static let shortcutOpenSavedFolder = "app.shortcutOpenSavedFolder"
  }

  private enum RecordingState: String {
    case idle
    case recording
    case paused
    case stopping
  }

  private let settings = SettingsStore()
  private let captureEngine = CaptureEngine()
  private let assetWriter = AssetWriter()
  private let permissionService = PermissionService()
  private let audioDeviceService = AudioDeviceService()
  private let cameraDeviceService = CameraDeviceService()
  private let cameraSession = CameraSession()
  private let areaSelectionOverlay = AreaSelectionOverlay()

  private var state: RecordingState = .idle
  private var selectedContentFilter: SCContentFilter?
  private var selectedSourceRect: CGRect?
  private var recordingStartTime: Date?
  private var recordingAccumulatedDuration: TimeInterval = 0
  private var videoSize: CGSize = .zero
  private var lastSavedRecordingPath: String?
  private var lastErrorMessage: String?
  private var presenterOverlayActive = false
  private var isRunningLaunchSelfTest = false
  private var lastLoggedSnapshotSummary: String?
  private var pendingAutoStartAfterPickerSelection = false

  override init() {
    super.init()
    captureEngine.delegate = self
    captureEngine.sampleBufferDelegate = assetWriter
    log("init delegate wiring complete")
  }

  func register(with controller: FlutterViewController) {
    let channel = FlutterMethodChannel(
      name: "rec/platform",
      binaryMessenger: controller.engine.binaryMessenger
    )

    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else {
        result(
          FlutterError(
            code: "bridge_unavailable",
            message: L("bridge.unavailable", "Recorder bridge is unavailable."),
            details: nil
          )
        )
        return
      }

      switch call.method {
      case ChannelMethod.snapshot:
        result(self.makeSnapshot())

      case ChannelMethod.loadAppPreferences:
        let preferences = self.loadAppPreferences()
        self.log("loadAppPreferences => \(preferences)")
        result(preferences)

      case ChannelMethod.saveAppPreferences:
        if let arguments = call.arguments as? [String: Any] {
          self.log("saveAppPreferences args=\(self.describeArguments(arguments))")
          self.saveAppPreferences(arguments)
        }
        result(nil)

      case ChannelMethod.requestPermissions:
        self.log("requestPermissions includeMicrophone=\(self.settings.captureMicrophone)")
        Task {
          await self.permissionService.requestPermissions(includeMicrophone: self.settings.captureMicrophone)
          result(self.makeSnapshot())
        }

      case ChannelMethod.presentPicker:
        let arguments = call.arguments as? [String: Any]
        let autoStartRecording =
          arguments?["autoStartRecording"] as? Bool ?? false
        let selectionMode =
          self.pickerSelectionMode(from: arguments?["selectionMode"] as? String)
        self.pendingAutoStartAfterPickerSelection = autoStartRecording
        self.selectedSourceRect = nil
        self.log(
          "presentPicker autoStartRecording=\(autoStartRecording) selectionMode=\(arguments?["selectionMode"] as? String ?? "any")"
        )
        self.captureEngine.presentPicker(selectionMode: selectionMode)
        result(self.makeSnapshot())

      case ChannelMethod.presentAreaSelection:
        let autoStartRecording =
          (call.arguments as? [String: Any])?["autoStartRecording"] as? Bool ?? false
        self.log("presentAreaSelection autoStartRecording=\(autoStartRecording)")
        Task {
          await self.presentAreaSelection(autoStartRecording: autoStartRecording)
          result(self.makeSnapshot())
        }

      case ChannelMethod.clearSelection:
        self.log("clearSelection")
        self.pendingAutoStartAfterPickerSelection = false
        self.selectedContentFilter = nil
        self.selectedSourceRect = nil
        self.captureEngine.clearSelection()
        result(self.makeSnapshot())

      case ChannelMethod.startRecording:
        self.log("startRecording requested args=\(self.describeArguments(call.arguments))")
        Task {
          do {
            if let arguments = call.arguments as? [String: Any] {
              self.applySettings(from: arguments)
            }

            try await self.startRecording()
            result(self.makeSnapshot())
          } catch {
            self.log("startRecording failed error=\(error.localizedDescription)")
            result(self.flutterError(from: error))
          }
        }

      case ChannelMethod.stopRecording:
        self.log("stopRecording requested")
        Task {
          do {
            let outputPath = try await self.stopRecording()
            var snapshot = self.makeSnapshot()
            snapshot["stoppedRecordingPath"] = outputPath
            result(snapshot)
          } catch {
            self.log("stopRecording failed error=\(error.localizedDescription)")
            result(self.flutterError(from: error))
          }
        }

      case ChannelMethod.pauseRecording:
        self.log("pauseRecording requested")
        do {
          try self.pauseRecording()
          result(self.makeSnapshot())
        } catch {
          result(self.flutterError(from: error))
        }

      case ChannelMethod.resumeRecording:
        self.log("resumeRecording requested")
        do {
          try self.resumeRecording()
          result(self.makeSnapshot())
        } catch {
          result(self.flutterError(from: error))
        }

      case ChannelMethod.updateSettings:
        if let arguments = call.arguments as? [String: Any] {
          self.log("updateSettings args=\(self.describeArguments(arguments))")
          self.applySettings(from: arguments)
        }
        result(self.makeSnapshot())

      case ChannelMethod.chooseOutputDirectory:
        self.log("chooseOutputDirectory")
        self.chooseOutputDirectory()
        result(self.makeSnapshot())

      case ChannelMethod.openOutputFolder:
        self.log("openOutputFolder path=\(self.settings.outputDirectory.path)")
        let didStart = self.settings.startAccessingOutputDirectory()
        defer {
          if didStart {
            self.settings.stopAccessingOutputDirectory()
          }
        }
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: self.settings.outputDirectory.path)
        result(self.makeSnapshot())

      case ChannelMethod.revealRecording:
        let path = (call.arguments as? [String: Any])?["path"] as? String
        self.log("revealRecording path=\(path ?? "nil")")
        if let path, !path.isEmpty {
          NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: path)])
        }
        result(self.makeSnapshot())

      case ChannelMethod.openScreenRecordingSettings:
        self.log("openScreenRecordingSettings")
        self.permissionService.openScreenRecordingSettings()
        result(self.makeSnapshot())

      case ChannelMethod.openMicrophoneSettings:
        self.log("openMicrophoneSettings")
        self.permissionService.openMicrophoneSettings()
        result(self.makeSnapshot())

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func loadAppPreferences() -> [String: Any] {
    let defaults = UserDefaults.standard
    var preferences: [String: Any] = [:]

    if let localeKey = defaults.string(forKey: AppPreferenceKey.localeKey) {
      preferences["localeKey"] = localeKey
    }
    if defaults.object(forKey: AppPreferenceKey.autoRefreshEnabled) != nil {
      preferences["autoRefreshEnabled"] = defaults.bool(forKey: AppPreferenceKey.autoRefreshEnabled)
    }
    if defaults.object(forKey: AppPreferenceKey.autoRefreshSeconds) != nil {
      preferences["autoRefreshSeconds"] = defaults.integer(forKey: AppPreferenceKey.autoRefreshSeconds)
    }
    if defaults.object(forKey: AppPreferenceKey.countdownSeconds) != nil {
      preferences["countdownSeconds"] = defaults.integer(forKey: AppPreferenceKey.countdownSeconds)
    }
    if let recentRecordingPaths = defaults.array(forKey: AppPreferenceKey.recentRecordingPaths) as? [String]
    {
      preferences["recentRecordingPaths"] = recentRecordingPaths
    }
    if let value = defaults.string(forKey: AppPreferenceKey.shortcutRecordApplication) {
      preferences["shortcutRecordApplication"] = value
    }
    if let value = defaults.string(forKey: AppPreferenceKey.shortcutRecordFullScreen) {
      preferences["shortcutRecordFullScreen"] = value
    }
    if let value = defaults.string(forKey: AppPreferenceKey.shortcutRecordArea) {
      preferences["shortcutRecordArea"] = value
    }
    if let value = defaults.string(forKey: AppPreferenceKey.shortcutPauseResume) {
      preferences["shortcutPauseResume"] = value
    }
    if let value = defaults.string(forKey: AppPreferenceKey.shortcutStop) {
      preferences["shortcutStop"] = value
    }
    if let value = defaults.string(forKey: AppPreferenceKey.shortcutOpenSettings) {
      preferences["shortcutOpenSettings"] = value
    }
    if let value = defaults.string(forKey: AppPreferenceKey.shortcutOpenSavedFolder) {
      preferences["shortcutOpenSavedFolder"] = value
    }

    return preferences
  }

  private func saveAppPreferences(_ arguments: [String: Any]) {
    let defaults = UserDefaults.standard

    if let localeKey = arguments["localeKey"] as? String {
      defaults.set(localeKey, forKey: AppPreferenceKey.localeKey)
    }
    if let autoRefreshEnabled = arguments["autoRefreshEnabled"] as? Bool {
      defaults.set(autoRefreshEnabled, forKey: AppPreferenceKey.autoRefreshEnabled)
    }
    if let autoRefreshSeconds = arguments["autoRefreshSeconds"] as? Int {
      defaults.set(autoRefreshSeconds, forKey: AppPreferenceKey.autoRefreshSeconds)
    }
    if let countdownSeconds = arguments["countdownSeconds"] as? Int {
      defaults.set(countdownSeconds, forKey: AppPreferenceKey.countdownSeconds)
    }
    if let recentRecordingPaths = arguments["recentRecordingPaths"] as? [String] {
      defaults.set(recentRecordingPaths, forKey: AppPreferenceKey.recentRecordingPaths)
    }
    if let value = arguments["shortcutRecordApplication"] as? String {
      defaults.set(value, forKey: AppPreferenceKey.shortcutRecordApplication)
    }
    if let value = arguments["shortcutRecordFullScreen"] as? String {
      defaults.set(value, forKey: AppPreferenceKey.shortcutRecordFullScreen)
    }
    if let value = arguments["shortcutRecordArea"] as? String {
      defaults.set(value, forKey: AppPreferenceKey.shortcutRecordArea)
    }
    if let value = arguments["shortcutPauseResume"] as? String {
      defaults.set(value, forKey: AppPreferenceKey.shortcutPauseResume)
    }
    if let value = arguments["shortcutStop"] as? String {
      defaults.set(value, forKey: AppPreferenceKey.shortcutStop)
    }
    if let value = arguments["shortcutOpenSettings"] as? String {
      defaults.set(value, forKey: AppPreferenceKey.shortcutOpenSettings)
    }
    if let value = arguments["shortcutOpenSavedFolder"] as? String {
      defaults.set(value, forKey: AppPreferenceKey.shortcutOpenSavedFolder)
    }

    log("saveAppPreferences persisted")
  }

  func runLaunchSelfTestIfNeeded() {
    guard !isRunningLaunchSelfTest else {
      return
    }

    let environment = ProcessInfo.processInfo.environment
    guard environment[LaunchSelfTest.enabled] == "1" else {
      return
    }

    isRunningLaunchSelfTest = true
    Task { @MainActor in
      await runLaunchSelfTest(environment: environment)
    }
  }

  private func startRecording() async throws {
    pendingAutoStartAfterPickerSelection = false
    log(
      "startRecording begin state=\(state.rawValue) hasSelection=\(selectedContentFilter != nil) settings={\(settingsSummary())}"
    )
    guard state == .idle else {
      throw CaptureError.captureAlreadyRunning
    }

    guard let filter = selectedContentFilter else {
      throw CaptureError.noContentFilterSelected
    }

    state = .recording
    lastErrorMessage = nil
    lastSavedRecordingPath = nil
    recordingAccumulatedDuration = 0

    videoSize = await getContentSize(from: filter, sourceRect: selectedSourceRect)
    log("startRecording filter={\(filterSummary(filter))} videoSize=\(Int(videoSize.width))x\(Int(videoSize.height))")

    _ = settings.startAccessingOutputDirectory()
    let outputURL = settings.generateOutputURL()
    log("startRecording outputURL=\(outputURL.path)")

    do {
      try assetWriter.setup(url: outputURL, settings: settings, videoSize: videoSize)
      try assetWriter.startWriting()

      if settings.presenterOverlayEnabled {
        await cameraSession.start(deviceID: settings.selectedCameraID)
      }

      try await captureEngine.startCapture(
        with: settings,
        videoSize: videoSize,
        sourceRect: selectedSourceRect
      )
      recordingStartTime = .now
      log("startRecording succeeded")
    } catch {
      state = .idle
      recordingStartTime = nil
      recordingAccumulatedDuration = 0
      cameraSession.stop()
      settings.stopAccessingOutputDirectory()
      assetWriter.cancel()
      log("startRecording rolled back error=\(error.localizedDescription)")
      throw error
    }
  }

  private func pauseRecording() throws {
    guard state == .recording else {
      throw FlutterBridgeError.notRecording
    }

    if let recordingStartTime {
      recordingAccumulatedDuration += Date().timeIntervalSince(recordingStartTime)
    }
    recordingStartTime = nil
    assetWriter.pauseWriting()
    state = .paused
    log("pauseRecording succeeded duration=\(formattedDuration)")
  }

  private func resumeRecording() throws {
    guard state == .paused else {
      throw FlutterBridgeError.notPaused
    }

    recordingStartTime = .now
    assetWriter.resumeWriting()
    state = .recording
    log("resumeRecording succeeded")
  }

  private func runLaunchSelfTest(environment: [String: String]) async {
    let includeMicrophone = environment[LaunchSelfTest.includeMicrophone] == "1"
    let autoQuit = environment[LaunchSelfTest.autoQuit] == "1"
    let durationSeconds =
      Double(environment[LaunchSelfTest.durationSeconds] ?? "3") ?? 3

    RecorderBootstrapper.emitLog(
      "SelfTest: begin includeMicrophone=\(includeMicrophone) duration=\(durationSeconds)s"
    )

    settings.captureMicrophone = includeMicrophone

    await permissionService.requestPermissions(includeMicrophone: includeMicrophone)

    do {
      try await selectMainDisplayForSelfTest()
      RecorderBootstrapper.emitLog("SelfTest: content selected")

      try await startRecording()
      RecorderBootstrapper.emitLog("SelfTest: recording started")

      try await Task.sleep(nanoseconds: UInt64(durationSeconds * 1_000_000_000))

      let outputPath = try await stopRecording()
      RecorderBootstrapper.emitLog("SelfTest: recording stopped path=\(outputPath)")
    } catch {
      lastErrorMessage = error.localizedDescription
      RecorderBootstrapper.emitLog("SelfTest: failed error=\(error.localizedDescription)")
    }

    if autoQuit {
      RecorderBootstrapper.emitLog("SelfTest: auto quit")
      NSApplication.shared.terminate(nil)
    }

    isRunningLaunchSelfTest = false
  }

  private func selectMainDisplayForSelfTest() async throws {
    let content = try await SCShareableContent.current

    let mainDisplayID =
      (NSScreen.main?.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")]
      as? CGDirectDisplayID)
      ?? (NSScreen.screens.first?.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")]
      as? CGDirectDisplayID)

    guard let display =
      content.displays.first(where: { $0.displayID == mainDisplayID })
      ?? content.displays.first
    else {
      throw FlutterBridgeError.noDisplayAvailable
    }

    let filter = SCContentFilter(display: display, excludingWindows: [])
    selectedContentFilter = filter
    selectedSourceRect = nil
    try await captureEngine.updateFilter(filter)
  }

  private func presentAreaSelection(autoStartRecording: Bool) async {
    pendingAutoStartAfterPickerSelection = false
    selectedContentFilter = nil
    selectedSourceRect = nil
    captureEngine.clearSelection()

    guard let result = await areaSelectionOverlay.present() else {
      log("presentAreaSelection cancelled")
      return
    }

    do {
      let content = try await SCShareableContent.current
      let screenNumber =
        result.screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID

      guard let display = content.displays.first(where: { $0.displayID == screenNumber }) else {
        throw FlutterBridgeError.noDisplayAvailable
      }

      let filter = SCContentFilter(display: display, excludingWindows: [])
      let displayHeight = CGFloat(display.height)
      let screenOrigin = result.screen.frame.origin
      let localX = result.screenRect.origin.x - screenOrigin.x
      let localY = result.screenRect.origin.y - screenOrigin.y
      let flippedY = displayHeight - localY - result.screenRect.height
      let scale = result.screen.backingScaleFactor
      let pixelWidth = result.screenRect.width * scale
      let pixelHeight = result.screenRect.height * scale
      let evenPixelWidth = ceil(pixelWidth / 2) * 2
      let evenPixelHeight = ceil(pixelHeight / 2) * 2

      let sourceRect = CGRect(
        origin: CGPoint(x: CGFloat(localX), y: CGFloat(flippedY)),
        size: CGSize(
          width: CGFloat(evenPixelWidth / scale),
          height: CGFloat(evenPixelHeight / scale)
        )
      )

      selectedContentFilter = filter
      selectedSourceRect = sourceRect
      try await captureEngine.updateFilter(filter)
      log(
        "presentAreaSelection selected sourceRect=\(sourceRect.origin.x),\(sourceRect.origin.y) \(sourceRect.width)x\(sourceRect.height)"
      )

      guard autoStartRecording, state == .idle else {
        return
      }

      let screenGranted = permissionService.screenRecordingState == .granted
      let microphoneGranted =
        !settings.captureMicrophone || permissionService.microphoneState == .granted

      guard screenGranted, microphoneGranted else {
        log(
          "autoStartAfterAreaSelection aborted screen=\(screenGranted) mic=\(microphoneGranted)"
        )
        return
      }

      do {
        log("autoStartAfterAreaSelection starting recording")
        try await startRecording()
      } catch {
        lastErrorMessage = error.localizedDescription
        log("autoStartAfterAreaSelection failed error=\(error.localizedDescription)")
      }
    } catch {
      lastErrorMessage = error.localizedDescription
      log("presentAreaSelection failed error=\(error.localizedDescription)")
    }
  }

  private func stopRecording() async throws -> String {
    pendingAutoStartAfterPickerSelection = false
    log("stopRecording begin state=\(state.rawValue)")
    guard state == .recording || state == .paused else {
      throw FlutterBridgeError.notRecording
    }

    if state == .recording, let recordingStartTime {
      recordingAccumulatedDuration += Date().timeIntervalSince(recordingStartTime)
    }

    state = .stopping

    do {
      try await captureEngine.stopCapture()
      cameraSession.stop()
      presenterOverlayActive = false

      let outputURL = try await assetWriter.finishWriting()
      lastSavedRecordingPath = outputURL.path
      state = .idle
      recordingStartTime = nil
      recordingAccumulatedDuration = 0
      settings.stopAccessingOutputDirectory()
      log("stopRecording succeeded path=\(outputURL.path)")
      return outputURL.path
    } catch {
      state = .idle
      recordingStartTime = nil
      recordingAccumulatedDuration = 0
      settings.stopAccessingOutputDirectory()
      assetWriter.cancel()
      log("stopRecording rolled back error=\(error.localizedDescription)")
      throw error
    }
  }

  private func getContentSize(from filter: SCContentFilter, sourceRect: CGRect? = nil) async -> CGSize {
    let applyScale = settings.captureNativeResolution
    let scale = CGFloat(filter.pointPixelScale)

    if let sourceRect, sourceRect.width > 0, sourceRect.height > 0 {
      return CGSize(
        width: applyScale ? sourceRect.width * scale : sourceRect.width,
        height: applyScale ? sourceRect.height * scale : sourceRect.height
      )
    }

    let rect = filter.contentRect

    if rect.width > 0 && rect.height > 0 {
      return CGSize(
        width: applyScale ? rect.width * scale : rect.width,
        height: applyScale ? rect.height * scale : rect.height
      )
    }

    if let screen = NSScreen.main {
      return CGSize(
        width: applyScale ? screen.frame.width * screen.backingScaleFactor : screen.frame.width,
        height: applyScale ? screen.frame.height * screen.backingScaleFactor : screen.frame.height
      )
    }

    return CGSize(width: 1920, height: 1080)
  }

  private func chooseOutputDirectory() {
    let previousPath = settings.outputDirectory.path
    let panel = NSOpenPanel()
    panel.title = L("outputDirectory.selectTitle", "Select Output Directory")
    panel.message = L(
      "outputDirectory.selectMessage",
      "Choose where recordings will be saved"
    )
    panel.canChooseFiles = false
    panel.canChooseDirectories = true
    panel.canCreateDirectories = true
    panel.allowsMultipleSelection = false
    panel.directoryURL = settings.outputDirectory

    if panel.runModal() == .OK, let url = panel.url {
      settings.setCustomOutputDirectory(url)
      log("chooseOutputDirectory selected=\(url.path)")
    } else {
      log("chooseOutputDirectory cancelled current=\(previousPath)")
    }
  }

  private func applySettings(from arguments: [String: Any]) {
    if let frameRate = arguments["frameRate"] as? Int,
      let value = FrameRate(rawValue: frameRate)
    {
      settings.frameRate = value
    }

    if let videoCodec = arguments["videoCodec"] as? String,
      let value = VideoCodec(rawValue: videoCodec)
    {
      settings.videoCodec = value
    }

    if let containerFormat = arguments["containerFormat"] as? String,
      let value = ContainerFormat(rawValue: containerFormat)
    {
      settings.containerFormat = value
    }

    if let videoQuality = arguments["videoQuality"] as? String,
      let value = VideoQuality(rawValue: videoQuality)
    {
      settings.videoQuality = value
    }

    if let audioCodec = arguments["audioCodec"] as? String,
      let value = AudioCodec(rawValue: audioCodec)
    {
      settings.audioCodec = value
    }

    if let selectedMicrophoneID = arguments["selectedMicrophoneID"] as? String? {
      settings.selectedMicrophoneID = selectedMicrophoneID
    }

    if let selectedCameraID = arguments["selectedCameraID"] as? String? {
      settings.selectedCameraID = selectedCameraID
    }

    if let captureSystemAudio = arguments["captureSystemAudio"] as? Bool {
      settings.captureSystemAudio = captureSystemAudio
    }
    if let captureMicrophone = arguments["captureMicrophone"] as? Bool {
      settings.captureMicrophone = captureMicrophone
    }
    if let captureAlphaChannel = arguments["captureAlphaChannel"] as? Bool {
      settings.captureAlphaChannel = captureAlphaChannel
    }
    if let captureHDR = arguments["captureHDR"] as? Bool {
      settings.captureHDR = captureHDR
    }
    if let captureNativeResolution = arguments["captureNativeResolution"] as? Bool {
      settings.captureNativeResolution = captureNativeResolution
    }
    if let presenterOverlayEnabled = arguments["presenterOverlayEnabled"] as? Bool {
      settings.presenterOverlayEnabled = presenterOverlayEnabled
    }
    if let showCursor = arguments["showCursor"] as? Bool {
      settings.showCursor = showCursor
    }
    if let showWallpaper = arguments["showWallpaper"] as? Bool {
      settings.showWallpaper = showWallpaper
    }
    if let showMenuBar = arguments["showMenuBar"] as? Bool {
      settings.showMenuBar = showMenuBar
    }
    if let showDock = arguments["showDock"] as? Bool {
      settings.showDock = showDock
    }
    if let showRecorderUI = arguments["showRecorderUI"] as? Bool {
      settings.showBetterCapture = showRecorderUI
    }
    if let showWindowShadows = arguments["showWindowShadows"] as? Bool {
      settings.showWindowShadows = showWindowShadows
    }

    log("applySettings => {\(settingsSummary())}")
  }

  private func makeSnapshot() -> [String: Any] {
    permissionService.updatePermissionStates()
    audioDeviceService.refreshDevices()
    cameraDeviceService.refreshDevices()

    let screenGranted = permissionService.screenRecordingState == .granted
    let microphoneGranted =
      !settings.captureMicrophone || permissionService.microphoneState == .granted

    let snapshot: [String: Any] = [
      "platform": "macos",
      "state": state.rawValue,
      "canStartRecording":
        selectedContentFilter != nil
        && state == .idle
        && screenGranted
        && microphoneGranted,
      "hasContentSelected": selectedContentFilter != nil,
      "isRecording": state == .recording || state == .paused,
      "formattedDuration": formattedDuration,
      "recordingDuration": currentDuration,
      "lastSavedRecordingPath": lastSavedRecordingPath as Any,
      "lastErrorMessage": lastErrorMessage as Any,
      "presenterOverlayActive": presenterOverlayActive,
      "permissions": [
        "screenRecording": permissionStateValue(permissionService.screenRecordingState),
        "microphone": permissionStateValue(permissionService.microphoneState),
      ],
      "settings": [
        "frameRate": settings.frameRate.rawValue,
        "videoCodec": settings.videoCodec.rawValue,
        "containerFormat": settings.containerFormat.rawValue,
        "videoQuality": settings.videoQuality.rawValue,
        "audioCodec": settings.audioCodec.rawValue,
        "captureSystemAudio": settings.captureSystemAudio,
        "captureMicrophone": settings.captureMicrophone,
        "captureAlphaChannel": settings.captureAlphaChannel,
        "captureHDR": settings.captureHDR,
        "captureNativeResolution": settings.captureNativeResolution,
        "presenterOverlayEnabled": settings.presenterOverlayEnabled,
        "selectedMicrophoneID": settings.selectedMicrophoneID as Any,
        "selectedCameraID": settings.selectedCameraID as Any,
        "showCursor": settings.showCursor,
        "showWallpaper": settings.showWallpaper,
        "showMenuBar": settings.showMenuBar,
        "showDock": settings.showDock,
        "showRecorderUI": settings.showBetterCapture,
        "showWindowShadows": settings.showWindowShadows,
        "outputDirectory": settings.outputDirectory.path,
      ],
      "capabilities": [
        "contentPicker": true,
        "areaSelection": true,
        "presenterOverlay": true,
        "systemAudio": true,
        "microphone": true,
        "pauseResume": true,
        "hdr": true,
        "alpha": true,
        "windowFiltering": true,
      ],
      "audioDevices": audioDeviceService.availableDevices.map { device in
        [
          "id": device.id,
          "name": device.name,
          "isDefault": device.isDefault,
        ]
      },
      "cameraDevices": cameraDeviceService.availableDevices.map { device in
        [
          "id": device.id,
          "name": device.name,
        ]
      },
    ]

    logSnapshotIfNeeded(
      canStartRecording:
        selectedContentFilter != nil
        && state == .idle
        && screenGranted
        && microphoneGranted
    )
    return snapshot
  }

  private var currentDuration: Double {
    switch state {
    case .recording:
      guard let recordingStartTime else {
        return recordingAccumulatedDuration
      }
      return recordingAccumulatedDuration + Date().timeIntervalSince(recordingStartTime)
    case .paused:
      return recordingAccumulatedDuration
    default:
      return 0
    }
  }

  private var formattedDuration: String {
    let duration = Int(currentDuration)
    let hours = duration / 3600
    let minutes = (duration % 3600) / 60
    let seconds = duration % 60

    if hours > 0 {
      return "\(hours):" + String(format: "%02d:%02d", minutes, seconds)
    }
    return String(format: "%02d:%02d", minutes, seconds)
  }

  private func permissionStateValue(_ state: PermissionService.PermissionState) -> String {
    switch state {
    case .unknown:
      return "unknown"
    case .granted:
      return "granted"
    case .denied:
      return "denied"
    }
  }

  private func flutterError(from error: Error) -> FlutterError {
    lastErrorMessage = error.localizedDescription
    log("flutterError error=\(error.localizedDescription)")
    return FlutterError(
      code: "recorder_error",
      message: error.localizedDescription,
      details: nil
    )
  }

  private func log(_ message: String) {
    BridgeLog(message)
  }

  private func describeArguments(_ arguments: Any?) -> String {
    guard let arguments else {
      return "none"
    }

    if let values = arguments as? [String: Any] {
      return values.keys.sorted().map { key in
        "\(key)=\(String(describing: values[key]!))"
      }.joined(separator: ", ")
    }

    return String(describing: arguments)
  }

  private func pickerSelectionMode(from rawValue: String?) -> CaptureEngine.PickerSelectionMode {
    switch rawValue {
    case "display":
      return .display
    case "application":
      return .application
    default:
      return .any
    }
  }

  private func settingsSummary() -> String {
    [
      "frameRate=\(settings.frameRate.rawValue)",
      "videoCodec=\(settings.videoCodec.rawValue)",
      "container=\(settings.containerFormat.rawValue)",
      "quality=\(settings.videoQuality.rawValue)",
      "systemAudio=\(settings.captureSystemAudio)",
      "microphone=\(settings.captureMicrophone)",
      "output=\(settings.outputDirectory.path)",
    ].joined(separator: ", ")
  }

  private func filterSummary(_ filter: SCContentFilter) -> String {
    let rect = filter.contentRect
    return "rect=\(Int(rect.width))x\(Int(rect.height)) scale=\(filter.pointPixelScale)"
  }

  private func logSnapshotIfNeeded(canStartRecording: Bool) {
    var parts = [
      "state=\(state.rawValue)",
      "canStart=\(canStartRecording)",
      "selected=\(selectedContentFilter != nil)",
      "screen=\(permissionStateValue(permissionService.screenRecordingState))",
      "mic=\(permissionStateValue(permissionService.microphoneState))",
      "duration=\(formattedDuration)",
    ]

    if let lastSavedRecordingPath = lastSavedRecordingPath {
      parts.append("saved=\(lastSavedRecordingPath)")
    }
    if let lastErrorMessage = lastErrorMessage {
      parts.append("error=\(lastErrorMessage)")
    }

    let summary = parts.joined(separator: ", ")

    if lastLoggedSnapshotSummary == summary {
      return
    }

    lastLoggedSnapshotSummary = summary
    log("snapshot => \(summary)")
  }
}

extension RecorderBridge: CaptureEngineDelegate {
  func captureEngine(_ engine: CaptureEngine, didUpdateFilter filter: SCContentFilter) {
    selectedContentFilter = filter
    selectedSourceRect = nil
    log("captureEngine didUpdateFilter {\(filterSummary(filter))}")

    guard pendingAutoStartAfterPickerSelection, state == .idle else {
      return
    }

    pendingAutoStartAfterPickerSelection = false
    let screenGranted = permissionService.screenRecordingState == .granted
    let microphoneGranted =
      !settings.captureMicrophone || permissionService.microphoneState == .granted

    guard screenGranted, microphoneGranted else {
      log(
        "autoStartAfterPicker aborted screen=\(screenGranted) mic=\(microphoneGranted)"
      )
      return
    }

    log("autoStartAfterPicker starting recording")
    Task {
      do {
        try await startRecording()
      } catch {
        lastErrorMessage = error.localizedDescription
        log("autoStartAfterPicker failed error=\(error.localizedDescription)")
      }
    }
  }

  func captureEngine(_ engine: CaptureEngine, didStopWithError error: Error?) {
    log("captureEngine didStopWithError error=\(error?.localizedDescription ?? "none")")
    guard state == .recording || state == .paused else {
      return
    }

    if let error {
      lastErrorMessage = error.localizedDescription
    }

    Task {
      _ = try? await stopRecording()
    }
  }

  func captureEngineDidCancelPicker(_ engine: CaptureEngine) {
    pendingAutoStartAfterPickerSelection = false
    selectedContentFilter = nil
    selectedSourceRect = nil
    log("captureEngineDidCancelPicker")
  }

  func captureEngine(_ engine: CaptureEngine, presenterOverlayDidChange isActive: Bool) {
    presenterOverlayActive = isActive
    log("presenterOverlayDidChange active=\(isActive)")
  }
}

private enum FlutterBridgeError: LocalizedError {
  case notRecording
  case notPaused
  case noDisplayAvailable

  var errorDescription: String? {
    switch self {
    case .notRecording:
      return L("error.notRecording", "No recording is currently in progress.")
    case .notPaused:
      return L("error.notPaused", "No paused recording is available to resume.")
    case .noDisplayAvailable:
      return L(
        "error.noDisplayAvailable",
        "No display is available for recording."
      )
    }
  }
}
