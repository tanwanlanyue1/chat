import UIKit
import Flutter
import GoogleMaps
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private let CHANNEL = "com.social.guanjia/plugin"
    private var _launchOptions = Dictionary<String,Any>();
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        launchOptions?.forEach({ (key: UIApplication.LaunchOptionsKey, value: Any) in
            _launchOptions[key.rawValue] = value
        })
        
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
        
        methodChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "getDeviceId" {
                result(UniqueIdentifier.getDeviceId())
            } else if call.method == "getAppLaunchOptions" {
                result(self._launchOptions)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        GMSServices.provideAPIKey("AIzaSyAnp77yd2SqfkSLgvY8RybPk89vMubYOHc")
        
        // This is required to make any communication available in the action isolate.
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
            GeneratedPluginRegistrant.register(with: registry)
        }

        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
