import UIKit
import Flutter
import SeeSo

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, InitializationDelegate, GazeDelegate, UserStatusDelegate {
  var gazeTracker : GazeTracker? = nil
  var trackerChannel : FlutterMethodChannel? = nil
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    trackerChannel = FlutterMethodChannel(name: "samples.flutter.dev/tracker",
                                                  binaryMessenger: controller.binaryMessenger)
    
    trackerChannel?.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//      guard call.method == "initGazeTracker" else {
//        result(FlutterMethodNotImplemented)
//        return
//      }
      
      
      guard let map = call.arguments as? [String: String] else {
        return
      }
      let methodName = call.method
      if methodName.elementsEqual("initGazeTracker") {
        self.initGazeTracker(result: result, license: map["license"]!, useOption: map["useOption"] == "true")
      }
      
      
    })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  func initGazeTracker(result : FlutterResult, license : String, useOption : Bool){
    let option = UserStatusOption()
    if useOption {
      option.useAll()
    }
    GazeTracker.initGazeTracker(license: license, delegate: self, option: option)
    result("initializing...")
  }
  
  func onInitialized(tracker: GazeTracker?, error: InitializationError) {
    print("hi")
    if tracker != nil {
      gazeTracker = tracker
      trackerChannel?.invokeMethod("getInitializedResult", arguments: [1])
      gazeTracker?.gazeDelegate = self
      gazeTracker?.userStatusDelegate = self
    }else {
      trackerChannel?.invokeMethod("getInitializedResult", arguments: [0, error.rawValue])
      print("hey")
    }
  }
  
  func onGaze(gazeInfo: GazeInfo) {
    if gazeInfo.trackingState == .SUCCESS {
      print("\(#function)")
      trackerChannel?.invokeMethod("setGazeXY", arguments: [gazeInfo.x, gazeInfo.y])
    }
  }
  
  func onDrowsiness(timestamp: Int, isDrowsiness: Bool) {
    
  }
  
  func onAttention(timestampBegin: Int, timestampEnd: Int, score: Double) {
    
  }
  
  func onBlink(timestamp: Int, isBlinkLeft: Bool, isBlinkRight: Bool, isBlink: Bool, eyeOpenness: Double) {
    
  }
}
