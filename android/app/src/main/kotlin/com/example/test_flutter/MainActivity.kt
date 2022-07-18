package com.example.test_flutter

import android.os.Handler
import android.os.Looper
import camp.visual.gazetracker.GazeTracker
import camp.visual.gazetracker.callback.*
import camp.visual.gazetracker.constant.CalibrationModeType
import camp.visual.gazetracker.constant.InitializationErrorType
import camp.visual.gazetracker.constant.StatusErrorType
import camp.visual.gazetracker.constant.UserStatusOption
import camp.visual.gazetracker.gaze.GazeInfo
import camp.visual.gazetracker.state.TrackingState
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(), InitializationCallback, GazeCallback, StatusCallback,
    CalibrationCallback, UserStatusCallback {
    private val channel = "samples.flutter.dev/tracker"
    private var density : Double = 0.0
    private var tracker : GazeTracker? = null
    private var methodChannel : MethodChannel? = null
    private var calibrationData : DoubleArray = DoubleArray(0)

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        density = resources.displayMetrics.density.toDouble()
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
        this.methodChannel?.setMethodCallHandler {
            call, result ->
            val methodName = call.method
            if (methodName == "initGazeTracker") {
                val useStatusOption = call.argument<String>("useStatusOption")
                val license = call.argument<String>("license")
                if (license != null){
                    initGazeTracker(result, license, useStatusOption == "true")
                }
            } else if (methodName == "deinitGazeTracker") {
                tracker?.removeStatusCallback()
                GazeTracker.deinitGazeTracker(tracker)
                tracker = null
            } else if (methodName == "startTracking") {
                tracker?.startTracking()
            } else if (methodName == "stopTracking") {
                tracker?.stopTracking()
            } else if (methodName == "startCalibration") {
                val value = call.arguments<Int>()
                var mode = CalibrationModeType.DEFAULT
                if (value != null) {
                    if (value == CalibrationModeType.ONE_POINT.ordinal){
                        mode = CalibrationModeType.ONE_POINT
                    }else if (value == CalibrationModeType.SIX_POINT.ordinal){
                        mode = CalibrationModeType.SIX_POINT
                    }
                }
                tracker?.startCalibration(mode)
            } else if (methodName == "startCollectSamples") {
                tracker?.startCollectSamples()
            } else if (methodName == "saveCalibrationData") {
                tracker?.setCalibrationData(this.calibrationData)
            } else {
                result.notImplemented()
            }

        }
    }

    private fun initGazeTracker(result: MethodChannel.Result, license: String, useOption: Boolean){
        val option = UserStatusOption()
        if (useOption){
            option.useAll()
        }
        GazeTracker.initGazeTracker(context, license, this, option)
        result.success("initializing...")
    }

    override fun onInitialized(tracker: GazeTracker?, error: InitializationErrorType?) {
        if (tracker != null){
            this.tracker = tracker
            this.tracker?.setAttentionInterval(10)
            this.tracker?.setGazeCallback(this)
            this.tracker?.setStatusCallback(this)
            this.tracker?.setCalibrationCallback(this)
            this.tracker?.setUserStatusCallback(this)

            Handler(Looper.getMainLooper()).post {
                methodChannel?.invokeMethod("getInitializedResult", arrayListOf<Int>(1))
            }
        }else {
            if(error != null){
                Handler(Looper.getMainLooper()).post {
                    methodChannel?.invokeMethod("getInitializedResult",
                        arrayListOf<Int>(0,error.ordinal))
                }
            }

        }
    }

    override fun onGaze(gazeInfo: GazeInfo?) {
        if (gazeInfo != null && gazeInfo.trackingState == TrackingState.SUCCESS) {
            val x = gazeInfo.gazePoint.x.toDouble() / density
            val y = gazeInfo.gazePoint.y.toDouble() / density
            Handler(Looper.getMainLooper()).post {
                methodChannel?.invokeMethod("onGaze", arrayListOf<Double>(x,y))
            }
        }

    }

    override fun onStarted() {
        Handler(Looper.getMainLooper()).post {
            methodChannel?.invokeMethod("onStatus", null)
        }
    }

    override fun onStopped(error: StatusErrorType?) {
        Handler(Looper.getMainLooper()).post {
            if (error != null) {
                methodChannel?.invokeMethod("onStatus", arrayListOf<String>(error.name))
            }
        }
    }

    override fun onCalibrationProgress(progress: Float) {
        Handler(Looper.getMainLooper()).post {
            methodChannel?.invokeMethod("onCalibrationProgress",
                arrayListOf<Double>(progress.toDouble()))
        }
    }

    override fun onCalibrationNextPoint(x: Float, y: Float) {
        val nextX = x.toDouble() / density
        val nextY = y.toDouble() / density
        Handler(Looper.getMainLooper()).post {
            methodChannel?.invokeMethod("onCalibrationNext",
                arrayListOf<Double>(nextX, nextY))
        }
    }

    override fun onCalibrationFinished(calibrationData: DoubleArray?) {
        if (calibrationData != null){
            this.calibrationData = calibrationData;
        }
        Handler(Looper.getMainLooper()).post {
            methodChannel?.invokeMethod("onCalibrationFinished", null)
        }
    }

    override fun onAttention(timestampBegin: Long, timestampEnd: Long, score: Float) {
        Handler(Looper.getMainLooper()).post {
            methodChannel?.invokeMethod("onAttention",
                arrayListOf<Double>(score.toDouble()))
        }
    }

    override fun onBlink(timestamp: Long, isBlinkLeft: Boolean, isBlinkRight: Boolean,
                         isBlink: Boolean, openness: Float) {
        Handler(Looper.getMainLooper()).post {
            methodChannel?.invokeMethod("onBlink", arrayListOf<Boolean>(isBlink))
        }
    }

    override fun onDrowsiness(timestamp: Long, isDrowsiness: Boolean) {
        Handler(Looper.getMainLooper()).post {
            methodChannel?.invokeMethod("onDrowsiness", arrayListOf<Boolean>(isDrowsiness))
        }
    }

}



