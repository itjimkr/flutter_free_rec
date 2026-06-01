import Cocoa
import FlutterMacOS
import XCTest
@testable import rec

@MainActor
final class RunnerTests: XCTestCase {
  func testBootstrapperRegistersPluginsBeforeBridge() {
    let controller = FlutterViewController()
    var events: [String] = []
    let bridge = MockRecorderBridge {
      events.append("bridge.register")
    }
    let bootstrapper = RecorderBootstrapper(
      log: { events.append("log:\($0)") },
      registerGeneratedPlugins: { _ in
        events.append("plugins.register")
      },
      makeBridge: { bridge }
    )

    let retainedBridge = bootstrapper.registerBridge(with: controller)

    XCTAssertTrue((retainedBridge as AnyObject) === bridge)
    XCTAssertEqual(
      events,
      [
        "log:registerGeneratedPlugins: begin",
        "plugins.register",
        "log:registerGeneratedPlugins: end",
        "log:RecorderBridge.register: begin",
        "bridge.register",
        "log:RecorderBridge.register: end",
      ]
    )
  }
}

@MainActor
private final class MockRecorderBridge: RecorderBridgeRegistering {
  private let onRegister: () -> Void

  init(onRegister: @escaping () -> Void) {
    self.onRegister = onRegister
  }

  func register(with controller: FlutterViewController) {
    onRegister()
  }
}
