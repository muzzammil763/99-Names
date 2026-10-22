import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "AppActions")!
    let channel = FlutterMethodChannel(name: "com.muzamil.asmaulhusna/app_actions", binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { call, result in
      let url = URL(string: "https://play.google.com/store/apps/details?id=com.muzamil.asmaulhusna")!
      switch call.method {
      case "share":
        let scene = UIApplication.shared.connectedScenes
          .compactMap { $0 as? UIWindowScene }
          .first { $0.activationState == .foregroundActive }
        guard var presenter = scene?.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
          result(FlutterError(code: "unavailable", message: "Cannot open share sheet", details: nil))
          return
        }
        while let presented = presenter.presentedViewController { presenter = presented }
        let sheet = UIActivityViewController(activityItems: ["99 Names - Asmaul Husna", url], applicationActivities: nil)
        if let popover = sheet.popoverPresentationController {
          popover.sourceView = presenter.view
          popover.sourceRect = CGRect(x: presenter.view.bounds.midX, y: presenter.view.bounds.midY, width: 0, height: 0)
          popover.permittedArrowDirections = []
        }
        presenter.present(sheet, animated: true)
        result(nil)
      case "openStore":
        guard let arguments = call.arguments as? [String: Any],
              let packageName = arguments["packageName"] as? String,
              packageName.range(of: "^[a-zA-Z0-9_]+(\\.[a-zA-Z0-9_]+)+$", options: .regularExpression) != nil,
              let storeURL = URL(string: "https://play.google.com/store/apps/details?id=\(packageName)") else {
          result(FlutterError(code: "invalid_argument", message: "Invalid package name", details: nil))
          return
        }
        UIApplication.shared.open(storeURL) { opened in
          result(opened ? nil : FlutterError(code: "unavailable", message: "Cannot open Google Play", details: nil))
        }
      case "rate":
        UIApplication.shared.open(url) { opened in
          result(opened ? nil : FlutterError(code: "unavailable", message: "Cannot open Google Play", details: nil))
        }
      default: result(FlutterMethodNotImplemented)
      }
    }
  }
}
