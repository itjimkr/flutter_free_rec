import Cocoa
import FlutterMacOS

@MainActor
protocol RecorderBridgeRegistering: AnyObject {
  func register(with controller: FlutterViewController)
}

extension RecorderBridge: RecorderBridgeRegistering {}

@MainActor
struct RecorderBootstrapper {
  typealias Logger = (String) -> Void
  typealias PluginRegistrant = (FlutterViewController) -> Void
  typealias BridgeFactory = () -> RecorderBridgeRegistering

  var log: Logger = RecorderBootstrapper.emitLog
  var registerGeneratedPlugins: PluginRegistrant = { controller in
    RegisterGeneratedPlugins(registry: controller)
  }
  var makeBridge: BridgeFactory = { RecorderBridge() }

  static func emitLog(_ message: String) {
    NSLog("%@", "[Rec][Launch] \(message)")
  }

  @discardableResult
  func registerBridge(with controller: FlutterViewController) -> RecorderBridgeRegistering {
    log("registerGeneratedPlugins: begin")
    registerGeneratedPlugins(controller)
    log("registerGeneratedPlugins: end")

    let bridge = makeBridge()
    log("RecorderBridge.register: begin")
    bridge.register(with: controller)
    log("RecorderBridge.register: end")
    return bridge
  }
}

class MainFlutterWindow: NSWindow {
  // Bridge는 Flutter 엔진과 같은 생명주기를 가져야 하므로 window에 보관.
  private var recorderBridge: RecorderBridgeRegistering?
  private let bootstrapper = RecorderBootstrapper()

  override func awakeFromNib() {
    bootstrapper.log("MainFlutterWindow.awakeFromNib: begin")
    let flutterViewController = FlutterViewController()
    bootstrapper.log("FlutterViewController initialized")
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    recorderBridge = bootstrapper.registerBridge(with: flutterViewController)
    (recorderBridge as? RecorderBridge)?.runLaunchSelfTestIfNeeded()

    super.awakeFromNib()
    bootstrapper.log("MainFlutterWindow.awakeFromNib: end")
  }
}
