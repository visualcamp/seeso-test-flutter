import UIKit
import Flutter
import SeeSo

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var gazeTracker : GazeTracker? = nil
    var trackerChannel : FlutterMethodChannel? = nil
    var calibrationData : [Double] = []
    
    override func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupFlutter()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
extension AppDelegate {
    func setupFlutter() {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        trackerChannel = FlutterMethodChannel(name: "samples.flutter.dev/tracker",
                                              binaryMessenger: controller.binaryMessenger)
        
        trackerChannel?.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            let methodName = call.method
            switch methodName {
            case "initGazeTracker":
                guard let map = call.arguments as? [String: String] else { return }
                self.initGazeTracker(result: result, license: map["license"]!, useOption:map["useStatusOption"] == "true")
                break
            case "deinitGazeTrackr":
                GazeTracker.deinitGazeTracker(tracker: self.gazeTracker)
                self.gazeTracker = nil
                break
            case "startTracking":
                self.gazeTracker?.startTracking()
                break
            case "stopTracking":
                self.gazeTracker?.stopTracking()
                break
            case "startCalibration":
                if let value : Int = call.arguments as? Int, let mode = CalibrationMode(rawValue: value) {
                    let _ = self.gazeTracker?.startCalibration(mode: mode)
                }
                break
            case "startCollectSamples":
                let _ = self.gazeTracker?.startCollectSamples()
                break
            case "saveCalibartionData":
                let _ = self.gazeTracker?.setCalibrationData(calibrationData: self.calibrationData)
                break
            default:break
            }
            
        }
        GeneratedPluginRegistrant.register(with: self)
    }
    
    func initGazeTracker(result : FlutterResult, license : String, useOption : Bool){
        let option = UserStatusOption()
        if useOption {
            option.useAll()
        }
        GazeTracker.initGazeTracker(license: license, delegate: self, option: option)
        result("initializing...")
    }
}

extension AppDelegate:InitializationDelegate {
    func onInitialized(tracker: GazeTracker?, error: InitializationError) {
        if tracker != nil {
            gazeTracker = tracker
            trackerChannel?.invokeMethod("getInitializedResult", arguments: [1])
            gazeTracker?.setAttentionInterval(interval: 10)
            gazeTracker?.setDelegates(statusDelegate: self, gazeDelegate: self, calibrationDelegate: self, imageDelegate: nil)
            gazeTracker?.userStatusDelegate = self
            
        } else {
            trackerChannel?.invokeMethod("getInitializedResult", arguments: [0, error.rawValue])
        }
    }
}
extension AppDelegate: StatusDelegate {
    func onStarted() {
        trackerChannel?.invokeMethod("onStatus", arguments: nil)
    }
    func onStopped(error: StatusError) {
        trackerChannel?.invokeMethod("onStatus", arguments: [error.description])
    }
}
extension AppDelegate: GazeDelegate {
    func onGaze(gazeInfo: GazeInfo) {
        if gazeInfo.trackingState == .SUCCESS {
            print("\(#function)")
            trackerChannel?.invokeMethod("onGaze", arguments: [gazeInfo.x, gazeInfo.y])
        }
    }
}
extension AppDelegate: CalibrationDelegate {
    func onCalibrationNextPoint(x: Double, y: Double) {
        trackerChannel?.invokeMethod("onCalibrationNext", arguments: [x,y])
    }
    
    func onCalibrationProgress(progress: Double) {
        trackerChannel?.invokeMethod("onCalibrationProgress", arguments: [progress])
    }
    
    func onCalibrationFinished(calibrationData: [Double]) {
        trackerChannel?.invokeMethod("onCalibrationFinished", arguments: nil)
        self.calibrationData = calibrationData
    }
}
extension AppDelegate: UserStatusDelegate {
    func onDrowsiness(timestamp: Int, isDrowsiness: Bool) {
        trackerChannel?.invokeMethod("onDrowsiness", arguments : [isDrowsiness])
    }
    
    func onAttention(timestampBegin: Int, timestampEnd: Int, score: Double) {
        trackerChannel?.invokeMethod("onAttention", arguments : [score])
    }
    
    func onBlink(timestamp: Int, isBlinkLeft: Bool, isBlinkRight: Bool, isBlink: Bool, eyeOpenness: Double) {
        trackerChannel?.invokeMethod("onBlink", arguments : [isBlink])
    }
}
