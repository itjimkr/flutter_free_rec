import AVFoundation
import Flutter
import ReplayKit
import UIKit

private func L(_ key: String, _ value: String) -> String {
  NSLocalizedString(key, tableName: nil, bundle: .main, value: value, comment: "")
}

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var recorderBridge: IOSRecorderBridge?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let bridge = IOSRecorderBridge()
    bridge.register(with: engineBridge.applicationRegistrar.messenger())
    recorderBridge = bridge
  }
}

private final class IOSRecorderBridge: NSObject {
  private enum ChannelMethod {
    static let snapshot = "snapshot"
    static let loadAppPreferences = "loadAppPreferences"
    static let saveAppPreferences = "saveAppPreferences"
    static let requestPermissions = "requestPermissions"
    static let presentPicker = "presentPicker"
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
    case stopping
  }

  private struct RecorderSettings {
    var frameRate: Int = 30
    var videoCodec = "H.264"
    var containerFormat = "mp4"
    var videoQuality = "High"
    var audioCodec = "AAC"
    var captureSystemAudio = false
    var captureMicrophone = false
    var captureAlphaChannel = false
    var captureHDR = false
    var captureNativeResolution = true
    var presenterOverlayEnabled = false
    var selectedMicrophoneID: String?
    var selectedCameraID: String?
    var showCursor = true
    var showWallpaper = true
    var showMenuBar = true
    var showDock = true
    var showRecorderUI = false
    var showWindowShadows = true

    mutating func apply(arguments: [String: Any]) {
      if let value = arguments["frameRate"] as? Int {
        frameRate = value
      }
      if let value = arguments["videoCodec"] as? String {
        videoCodec = value
      }
      if let value = arguments["containerFormat"] as? String {
        containerFormat = value
      }
      if let value = arguments["videoQuality"] as? String {
        videoQuality = value
      }
      if let value = arguments["audioCodec"] as? String {
        audioCodec = value
      }
      if let value = arguments["captureSystemAudio"] as? Bool {
        captureSystemAudio = value
      }
      if let value = arguments["captureMicrophone"] as? Bool {
        captureMicrophone = value
      }
      if let value = arguments["captureAlphaChannel"] as? Bool {
        captureAlphaChannel = value
      }
      if let value = arguments["captureHDR"] as? Bool {
        captureHDR = value
      }
      if let value = arguments["captureNativeResolution"] as? Bool {
        captureNativeResolution = value
      }
      if let value = arguments["presenterOverlayEnabled"] as? Bool {
        presenterOverlayEnabled = value
      }
      if arguments.keys.contains("selectedMicrophoneID") {
        selectedMicrophoneID = arguments["selectedMicrophoneID"] as? String
      }
      if arguments.keys.contains("selectedCameraID") {
        selectedCameraID = arguments["selectedCameraID"] as? String
      }
      if let value = arguments["showCursor"] as? Bool {
        showCursor = value
      }
      if let value = arguments["showWallpaper"] as? Bool {
        showWallpaper = value
      }
      if let value = arguments["showMenuBar"] as? Bool {
        showMenuBar = value
      }
      if let value = arguments["showDock"] as? Bool {
        showDock = value
      }
      if let value = arguments["showRecorderUI"] as? Bool {
        showRecorderUI = value
      }
      if let value = arguments["showWindowShadows"] as? Bool {
        showWindowShadows = value
      }
    }

    func toMap(outputDirectory: String) -> [String: Any] {
      [
        "frameRate": frameRate,
        "videoCodec": videoCodec,
        "containerFormat": containerFormat,
        "videoQuality": videoQuality,
        "audioCodec": audioCodec,
        "captureSystemAudio": captureSystemAudio,
        "captureMicrophone": captureMicrophone,
        "captureAlphaChannel": captureAlphaChannel,
        "captureHDR": captureHDR,
        "captureNativeResolution": captureNativeResolution,
        "presenterOverlayEnabled": presenterOverlayEnabled,
        "selectedMicrophoneID": selectedMicrophoneID as Any,
        "selectedCameraID": selectedCameraID as Any,
        "showCursor": showCursor,
        "showWallpaper": showWallpaper,
        "showMenuBar": showMenuBar,
        "showDock": showDock,
        "showRecorderUI": showRecorderUI,
        "showWindowShadows": showWindowShadows,
        "outputDirectory": outputDirectory,
      ]
    }
  }

  private struct WriterBundle {
    let writer: AVAssetWriter
    let videoInput: AVAssetWriterInput
    let audioInput: AVAssetWriterInput?
  }

  private let recorder = RPScreenRecorder.shared()
  private let captureQueue = DispatchQueue(label: "com.example.rec.ios.capture")
  private var settings = RecorderSettings()
  private var state: RecordingState = .idle
  private var recordingStartTime: Date?
  private var writer: AVAssetWriter?
  private var videoInput: AVAssetWriterInput?
  private var audioInput: AVAssetWriterInput?
  private var outputURL: URL?
  private var didStartSession = false
  private var lastSavedRecordingPath: String?
  private var lastErrorMessage: String?

  func register(with messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "rec/platform", binaryMessenger: messenger)
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
        result(self.loadAppPreferences())

      case ChannelMethod.saveAppPreferences:
        if let arguments = call.arguments as? [String: Any] {
          self.saveAppPreferences(arguments)
        }
        result(nil)

      case ChannelMethod.requestPermissions:
        Task {
          if self.settings.captureMicrophone {
            _ = await self.requestMicrophoneAccessIfNeeded()
          }
          result(self.makeSnapshot())
        }

      case ChannelMethod.presentPicker,
        ChannelMethod.clearSelection,
        ChannelMethod.chooseOutputDirectory,
        ChannelMethod.openOutputFolder,
        ChannelMethod.revealRecording:
        result(self.makeSnapshot())

      case ChannelMethod.pauseRecording,
        ChannelMethod.resumeRecording:
        result(
          self.flutterError(
            from: RecorderBridgeError.pauseResumeUnavailable
          )
        )

      case ChannelMethod.openScreenRecordingSettings,
        ChannelMethod.openMicrophoneSettings:
        self.openAppSettings()
        result(self.makeSnapshot())

      case ChannelMethod.updateSettings:
        if let arguments = call.arguments as? [String: Any] {
          self.settings.apply(arguments: arguments)
        }
        result(self.makeSnapshot())

      case ChannelMethod.startRecording:
        Task {
          do {
            if let arguments = call.arguments as? [String: Any] {
              self.settings.apply(arguments: arguments)
            }
            try await self.startRecording()
            result(self.makeSnapshot())
          } catch {
            result(self.flutterError(from: error))
          }
        }

      case ChannelMethod.stopRecording:
        Task {
          do {
            let outputPath = try await self.stopRecording()
            var snapshot = self.makeSnapshot()
            snapshot["stoppedRecordingPath"] = outputPath
            result(snapshot)
          } catch {
            result(self.flutterError(from: error))
          }
        }

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
  }

  private func startRecording() async throws {
    guard state == .idle else {
      throw RecorderBridgeError.captureAlreadyRunning
    }

    if settings.captureMicrophone {
      let granted = await requestMicrophoneAccessIfNeeded()
      guard granted else {
        throw RecorderBridgeError.microphonePermissionDenied
      }
    }

    recorder.isMicrophoneEnabled = settings.captureMicrophone

    let outputURL = try nextOutputURL()
    let writerBundle = try makeWriterBundle(outputURL: outputURL)

    writer = writerBundle.writer
    videoInput = writerBundle.videoInput
    audioInput = writerBundle.audioInput
    self.outputURL = outputURL
    didStartSession = false
    lastErrorMessage = nil
    lastSavedRecordingPath = nil

    do {
      try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
        recorder.startCapture(handler: { [weak self] sampleBuffer, sampleType, error in
          guard let self else {
            return
          }

          if let error {
            Task { @MainActor in
              self.lastErrorMessage = error.localizedDescription
            }
            return
          }

          self.captureQueue.async {
            self.process(sampleBuffer: sampleBuffer, sampleType: sampleType)
          }
        }, completionHandler: { error in
          if let error {
            continuation.resume(throwing: error)
          } else {
            continuation.resume(returning: ())
          }
        })
      }
      state = .recording
      recordingStartTime = Date()
    } catch {
      resetWriterState(deleteOutput: true)
      throw error
    }
  }

  private func stopRecording() async throws -> String {
    guard state == .recording else {
      throw RecorderBridgeError.notRecording
    }

    state = .stopping

    return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, Error>) in
      recorder.stopCapture { [weak self] error in
        guard let self else {
          continuation.resume(throwing: RecorderBridgeError.bridgeUnavailable)
          return
        }

        if let error {
          Task { @MainActor in
            self.lastErrorMessage = error.localizedDescription
            self.resetWriterState(deleteOutput: true)
            continuation.resume(throwing: error)
          }
          return
        }

        self.captureQueue.async {
          guard let writer = self.writer, let outputURL = self.outputURL else {
            Task { @MainActor in
              self.resetWriterState(deleteOutput: false)
              continuation.resume(throwing: RecorderBridgeError.writerUnavailable)
            }
            return
          }

          guard self.didStartSession else {
            writer.cancelWriting()
            Task { @MainActor in
              self.lastErrorMessage = L(
                "error.recordingEndedBeforeFrames",
                "Recording ended before any frames were written."
              )
              self.resetWriterState(deleteOutput: true)
              continuation.resume(throwing: RecorderBridgeError.emptyCapture)
            }
            return
          }

          self.videoInput?.markAsFinished()
          self.audioInput?.markAsFinished()

          writer.finishWriting {
            Task { @MainActor in
              if writer.status == .completed {
                self.lastSavedRecordingPath = outputURL.path
                self.resetWriterState(deleteOutput: false)
                continuation.resume(returning: outputURL.path)
              } else {
                self.lastErrorMessage =
                  writer.error?.localizedDescription
                  ?? L(
                    "error.finishWritingFailed",
                    "Failed to finish writing the recording."
                  )
                self.resetWriterState(deleteOutput: true)
                continuation.resume(throwing: writer.error ?? RecorderBridgeError.finishFailed)
              }
            }
          }
        }
      }
    }
  }

  private func process(sampleBuffer: CMSampleBuffer, sampleType: RPSampleBufferType) {
    guard CMSampleBufferDataIsReady(sampleBuffer), let writer else {
      return
    }

    if writer.status == .failed || writer.status == .cancelled {
      return
    }

    switch sampleType {
    case .video:
      if !didStartSession {
        writer.startWriting()
        writer.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
        didStartSession = true
      }

      guard let videoInput, videoInput.isReadyForMoreMediaData else {
        return
      }
      _ = videoInput.append(sampleBuffer)

    case .audioMic:
      guard settings.captureMicrophone,
        didStartSession,
        let audioInput,
        audioInput.isReadyForMoreMediaData
      else {
        return
      }
      _ = audioInput.append(sampleBuffer)

    case .audioApp:
      break

    @unknown default:
      break
    }
  }

  private func makeWriterBundle(outputURL: URL) throws -> WriterBundle {
    let fileType: AVFileType = settings.containerFormat.lowercased() == "mov" ? .mov : .mp4
    let writer = try AVAssetWriter(outputURL: outputURL, fileType: fileType)
    let videoSize = videoDimensions()

    let videoSettings: [String: Any] = [
      AVVideoCodecKey: videoCodecType(),
      AVVideoWidthKey: videoSize.width,
      AVVideoHeightKey: videoSize.height,
      AVVideoCompressionPropertiesKey: [
        AVVideoAverageBitRateKey: estimatedVideoBitrate(for: videoSize),
        AVVideoExpectedSourceFrameRateKey: normalizedFrameRate,
      ],
    ]

    let videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
    videoInput.expectsMediaDataInRealTime = true
    if writer.canAdd(videoInput) {
      writer.add(videoInput)
    } else {
      throw RecorderBridgeError.videoInputUnavailable
    }

    var audioInput: AVAssetWriterInput?
    if settings.captureMicrophone {
      let audioSettings: [String: Any] = [
        AVFormatIDKey: kAudioFormatMPEG4AAC,
        AVNumberOfChannelsKey: 1,
        AVSampleRateKey: 44_100,
        AVEncoderBitRateKey: 128_000,
      ]
      let input = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
      input.expectsMediaDataInRealTime = true
      if writer.canAdd(input) {
        writer.add(input)
        audioInput = input
      }
    }

    return WriterBundle(writer: writer, videoInput: videoInput, audioInput: audioInput)
  }

  private func videoDimensions() -> CGSize {
    let bounds = UIScreen.main.bounds
    let scale = settings.captureNativeResolution ? UIScreen.main.scale : 1
    let width = max(2, Int(bounds.width * scale) & ~1)
    let height = max(2, Int(bounds.height * scale) & ~1)
    return CGSize(width: width, height: height)
  }

  private func estimatedVideoBitrate(for size: CGSize) -> Int {
    let pixels = Int(size.width * size.height)
    let frameRate = normalizedFrameRate
    let multiplier: Double
    switch settings.videoQuality.lowercased() {
    case "low":
      multiplier = 3.0
    case "medium":
      multiplier = 5.0
    default:
      multiplier = 7.5
    }
    return max(4_000_000, Int(Double(pixels * frameRate) * multiplier / 8.0))
  }

  private var normalizedFrameRate: Int {
    switch settings.frameRate {
    case let value where value >= 60:
      return 60
    case let value where value >= 30:
      return 30
    case let value where value >= 24:
      return 24
    default:
      return 30
    }
  }

  private func videoCodecType() -> AVVideoCodecType {
    if settings.videoCodec == "H.265" {
      return .hevc
    }
    return .h264
  }

  private func nextOutputURL() throws -> URL {
    let directory = recordingsDirectory()
    try FileManager.default.createDirectory(
      at: directory,
      withIntermediateDirectories: true,
      attributes: nil
    )
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd-HHmmss"
    let fileExtension = settings.containerFormat.lowercased() == "mov" ? "mov" : "mp4"
    return directory.appendingPathComponent("Rec-\(formatter.string(from: Date())).\(fileExtension)")
  }

  private func recordingsDirectory() -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      .appendingPathComponent("Recordings", isDirectory: true)
  }

  private func requestMicrophoneAccessIfNeeded() async -> Bool {
    switch AVAudioSession.sharedInstance().recordPermission {
    case .granted:
      return true
    case .denied:
      return false
    case .undetermined:
      return await withCheckedContinuation { continuation in
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
          continuation.resume(returning: granted)
        }
      }
    @unknown default:
      return false
    }
  }

  private func microphonePermissionState() -> String {
    switch AVAudioSession.sharedInstance().recordPermission {
    case .granted:
      return "granted"
    case .denied:
      return "denied"
    case .undetermined:
      return "prompt"
    @unknown default:
      return "unknown"
    }
  }

  private func openAppSettings() {
    guard let url = URL(string: UIApplication.openSettingsURLString),
      UIApplication.shared.canOpenURL(url)
    else {
      return
    }

    UIApplication.shared.open(url)
  }

  private func makeSnapshot() -> [String: Any] {
    [
      "platform": "ios",
      "state": state.rawValue,
      "canStartRecording": state == .idle,
      "hasContentSelected": true,
      "isRecording": state == .recording,
      "formattedDuration": formattedDuration,
      "recordingDuration": currentDuration,
      "presenterOverlayActive": false,
      "permissions": [
        "screenRecording": "granted",
        "microphone": microphonePermissionState(),
      ],
      "settings": settings.toMap(outputDirectory: recordingsDirectory().path),
      "capabilities": [
        "contentPicker": false,
        "areaSelection": false,
        "presenterOverlay": false,
        "systemAudio": false,
        "microphone": true,
        "pauseResume": false,
        "hdr": false,
        "alpha": false,
        "windowFiltering": false,
      ],
      "audioDevices": [],
      "cameraDevices": [],
      "note": L(
        "note.ios",
        "iOS uses ReplayKit for in-app screen capture. Window picking, system audio routing, and macOS-style overlays are not available."
      ),
      "lastSavedRecordingPath": lastSavedRecordingPath as Any,
      "lastErrorMessage": lastErrorMessage as Any,
    ]
  }

  private var currentDuration: Double {
    guard let recordingStartTime else {
      return 0
    }
    return max(0, Date().timeIntervalSince(recordingStartTime))
  }

  private var formattedDuration: String {
    let totalSeconds = Int(currentDuration.rounded(.down))
    let minutes = totalSeconds / 60
    let seconds = totalSeconds % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }

  private func resetWriterState(deleteOutput: Bool) {
    let path = outputURL?.path
    writer = nil
    videoInput = nil
    audioInput = nil
    outputURL = nil
    didStartSession = false
    recordingStartTime = nil
    state = .idle

    if deleteOutput, let path {
      try? FileManager.default.removeItem(atPath: path)
    }
  }

  private func flutterError(from error: Error) -> FlutterError {
    lastErrorMessage = error.localizedDescription
    return FlutterError(code: "recording_failed", message: error.localizedDescription, details: nil)
  }
}

private enum RecorderBridgeError: LocalizedError {
  case bridgeUnavailable
  case captureAlreadyRunning
  case microphonePermissionDenied
  case notRecording
  case writerUnavailable
  case emptyCapture
  case finishFailed
  case videoInputUnavailable
  case pauseResumeUnavailable

  var errorDescription: String? {
    switch self {
    case .bridgeUnavailable:
      return L("error.bridgeUnavailable", "The iOS recorder bridge is unavailable.")
    case .captureAlreadyRunning:
      return L("error.captureAlreadyRunning", "A recording is already running.")
    case .microphonePermissionDenied:
      return L(
        "error.microphonePermissionDenied",
        "Microphone permission is required for microphone capture."
      )
    case .notRecording:
      return L("error.notRecording", "There is no active recording to stop.")
    case .writerUnavailable:
      return L("error.writerUnavailable", "The recording writer was not initialized.")
    case .emptyCapture:
      return L(
        "error.emptyCapture",
        "The recording ended before any frames were captured."
      )
    case .finishFailed:
      return L("error.finishFailed", "The recording could not be finalized.")
    case .videoInputUnavailable:
      return L(
        "error.videoInputUnavailable",
        "The video input could not be attached to the writer."
      )
    case .pauseResumeUnavailable:
      return L(
        "error.pauseResumeUnavailable",
        "Pause and resume are not available on this platform."
      )
    }
  }
}
