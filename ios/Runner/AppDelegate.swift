import UIKit
import Flutter
import SeeSo

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, InitializationDelegate, GazeDelegate {
  var gazeTracker : GazeTracker? = nil
  var trackerChannel : FlutterMethodChannel? = nil
  let license : String = "dev_1ntzip9admm6g0upynw3gooycnecx0vl93hz8nox"
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    trackerChannel = FlutterMethodChannel(name: "samples.flutter.dev/tracker",
                                                  binaryMessenger: controller.binaryMessenger)
    
    trackerChannel?.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard call.method == "startTracking" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let map = call.arguments as? [String: String] else {
        return
      }
      
      self.startLogic(result : result, license : map["license"]!)
    })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  func startLogic(result : FlutterResult, license : String){
    GazeTracker.initGazeTracker(license: license, delegate: self)
    result("initializing...")
  }
  
  func onInitialized(tracker: GazeTracker?, error: InitializationError) {
    print("hi")
    if tracker != nil {
      gazeTracker = tracker
      trackerChannel?.invokeMethod("setCurrentState", arguments: "initSuccess")
      gazeTracker?.gazeDelegate = self
    }else {
      trackerChannel?.invokeMethod("setCurrentState", arguments: "init Failed : " + error.description)
      print("hey")
    }
  }
  
  func onGaze(gazeInfo: GazeInfo) {
    if gazeInfo.trackingState == .SUCCESS {
      print("\(#function)")
      trackerChannel?.invokeMethod("setGazeXY", arguments: [gazeInfo.x, gazeInfo.y])
    }
  }
  
  
}
