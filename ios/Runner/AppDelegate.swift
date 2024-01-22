import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = self.window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "battery_channel", binaryMessenger: controller.binaryMessenger)
    let deviceInfoChannel = FlutterMethodChannel(name: "deviceInfoChannel", binaryMessenger: controller.binaryMessenger)

batteryChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "getBatteryLevel" {
        self?.getBatteryLevel(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    deviceInfoChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "getDeviceInfo" {
        self?.getDeviceInfo(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

   private func getBatteryLevel(result: FlutterResult) {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    result(Int(device.batteryLevel * 100))
  }

  private func getDeviceInfo(result: FlutterResult) {
    let device = UIDevice.current
    let deviceInfo = "\(device.model) (\(device.systemName) \(device.systemVersion))"
    result(deviceInfo)
  }
}
