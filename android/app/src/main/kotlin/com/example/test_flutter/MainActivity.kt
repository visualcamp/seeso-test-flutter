package com.example.test_flutter

import android.os.Handler
import android.os.Looper
import camp.visual.gazetracker.GazeTracker
import camp.visual.gazetracker.callback.GazeCallback
import camp.visual.gazetracker.callback.InitializationCallback
import camp.visual.gazetracker.constant.InitializationErrorType
import camp.visual.gazetracker.gaze.GazeInfo
import camp.visual.gazetracker.state.TrackingState
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(), InitializationCallback, GazeCallback {
    private val CHANNEL = "samples.flutter.dev/tracker"
    var density : Double = 0.0
    private var tracker : GazeTracker? = null
    private var methodChannel : MethodChannel? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        density = resources.displayMetrics.density.toDouble()
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        this.methodChannel?.setMethodCallHandler {
            call, result ->
            if (call.method == "startTracking") {
                GazeTracker.initGazeTracker(context,call.argument("license"),this)
                result.success("initialized")
            }else {
                result.notImplemented()
            }
        }
    }

    override fun onInitialized(p0: GazeTracker?, p1: InitializationErrorType?) {
        if (p0 != null){
            this.tracker = p0
            this.tracker?.setGazeCallback(this)
            this.tracker?.startTracking()
            Handler(Looper.getMainLooper()).post {
                methodChannel?.invokeMethod("setCurrentState", "init success")
            }

        }else {
            Handler(Looper.getMainLooper()).post {
                methodChannel?.invokeMethod("setCurrentState", p1?.name)
            }
        }
    }

    override fun onGaze(gazeInfo: GazeInfo?) {

        if (gazeInfo != null && gazeInfo.trackingState == TrackingState.SUCCESS) {
            Handler(Looper.getMainLooper()).post {

                methodChannel?.invokeMethod("setGazeXY", arrayListOf<Double>(gazeInfo.gazePoint.x.toDouble() / density, gazeInfo.gazePoint.y.toDouble()/ density))
            }
        }

    }

}



