import Flutter
import UIKit

public class SwiftEraserPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "eraser", binaryMessenger: registrar.messenger())
    let instance = SwiftEraserPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method  == "clearAllAppNotifications") {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
        result(nil)
    } else if(call.method == "clearAppNotificationsByTag") {
        if #available(iOS 10.0, *) {
            let args = call.arguments as! Dictionary<String, String>
            let tag = args["tag"]! as String
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [tag])
        }
        result(nil)
    } else if(call.method == "resetBadgeCountAndRemoveNotificationsFromCenter") {
        UIApplication.shared.applicationIconBadgeNumber = 0
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
        result(nil)
    } else if(call.method == "resetBadgeCountButKeepNotificationsInCenter") {
        UIApplication.shared.applicationIconBadgeNumber = -1
        result(nil)
    } else {
        result(FlutterMethodNotImplemented)
    }
  }
}
