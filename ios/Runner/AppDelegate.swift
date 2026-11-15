import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let messenger = registrar(forPlugin: "PdfShare")?.messenger() {
      PdfShare.register(with: messenger)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

/// Offers a PDF in the share sheet. The sheet needs a file, which is deleted as soon as the sheet closes.
enum PdfShare {
  private static let directory = FileManager.default.temporaryDirectory.appendingPathComponent("pdf_share")

  static func register(with messenger: FlutterBinaryMessenger) {
    // A file is left behind only if the app was killed while the sheet was open.
    try? FileManager.default.removeItem(at: directory)

    FlutterMethodChannel(name: "app_core/pdf_share", binaryMessenger: messenger).setMethodCallHandler { call, result in
      guard call.method == "sharePdf" else { return result(FlutterMethodNotImplemented) }
      guard
        let arguments = call.arguments as? [String: Any],
        let name = arguments["name"] as? String,
        let bytes = arguments["bytes"] as? FlutterStandardTypedData
      else {
        return result(FlutterError(code: "bad_arguments", message: "sharePdf needs a name and bytes", details: nil))
      }
      share(bytes.data, named: name, result: result)
    }
  }

  private static func share(_ data: Data, named name: String, result: @escaping FlutterResult) {
    let presenter = UIApplication.shared.connectedScenes
      .compactMap { ($0 as? UIWindowScene)?.windows.first(where: \.isKeyWindow)?.rootViewController }
      .first
    guard let presenter else {
      return result(FlutterError(code: "no_window", message: "There is no window to show the share sheet in", details: nil))
    }

    let file = directory.appendingPathComponent(name)
    do {
      try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
      try data.write(to: file, options: [.atomic, .completeFileProtection])
    } catch {
      try? FileManager.default.removeItem(at: directory)
      return result(FlutterError(code: "write_failed", message: error.localizedDescription, details: nil))
    }

    let sheet = UIActivityViewController(activityItems: [file], applicationActivities: nil)
    sheet.completionWithItemsHandler = { _, _, _, _ in
      try? FileManager.default.removeItem(at: directory)
      result(nil)
    }
    // An iPad shows the sheet as a popover, which has to be anchored.
    sheet.popoverPresentationController?.sourceView = presenter.view
    sheet.popoverPresentationController?.sourceRect = CGRect(
      x: presenter.view.bounds.midX, y: presenter.view.bounds.midY, width: 0, height: 0)
    sheet.popoverPresentationController?.permittedArrowDirections = []
    presenter.present(sheet, animated: true)
  }
}
