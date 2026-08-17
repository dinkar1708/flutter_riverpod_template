import Flutter
import UIKit

// TODO: When ready to use Google Maps, add `google_maps_flutter` dependency and uncomment:
// import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private static let nativeConfigChannel = "com.example.app/native_config"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    // Fallback: If window rootViewController is available, register channel here too
    if let controller = window?.rootViewController as? FlutterViewController {
      AppDelegate.setupChannel(messenger: controller.binaryMessenger)
    }

    return result
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // Primary: Register channel with the implicit engine's plugin registry
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "NativeConfigPlugin") {
      AppDelegate.setupChannel(messenger: registrar.messenger())
    }
  }

  private static func setupChannel(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: nativeConfigChannel, binaryMessenger: messenger)
    
    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "initGoogleMaps" {
        guard let args = call.arguments as? [String: Any] else {
          result(FlutterError(
            code: "INVALID_ARGUMENT",
            message: "Arguments must be a valid key-value map",
            details: "Received: \(String(describing: call.arguments))"
          ))
          return
        }

        guard let apiKey = args["apiKey"] as? String else {
          result(FlutterError(
            code: "MISSING_KEY",
            message: "The 'apiKey' field is missing or not a String",
            details: "Arguments received: \(args)"
          ))
          return
        }

        let trimmedKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedKey.isEmpty else {
          result(FlutterError(
            code: "EMPTY_KEY",
            message: "The Google Maps API Key provided is empty",
            details: nil
          ))
          return
        }

        // TODO: Uncomment the line below once GoogleMaps dependency is added:
        // GMSServices.provideAPIKey(trimmedKey)
        
        #if DEBUG
        print("🗺️ [iOS Native] Google Maps API Key initialized securely via MethodChannel: \(trimmedKey) (For debug and testing only)")
        #endif
        result(true)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }
}


