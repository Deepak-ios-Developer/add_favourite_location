import UIKit
import Flutter
import GoogleMaps  // 👈 Import Google Maps SDK

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // ✅ Register Google Maps API Key
    GMSServices.provideAPIKey("AIzaSyCWI4wl_5DO1nKe762HojgI9hw7gTChfcU")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
