import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:permission_handler/permission_handler.dart';
import 'package:test_flutter/src/model/app_stage.dart';
import 'package:test_flutter/src/model/gazetracker_method_string.dart';

class GazeTrackerProvider with ChangeNotifier {
  dynamic state;
  static const licenseKey = 'dev_1ntzip9admm6g0upynw3gooycnecx0vl93hz8nox';
  final _channel = const MethodChannel('samples.flutter.dev/tracker');
  String? failedReason;
  // gaze X,Y
  var point_x = 0.0;
  var point_y = 0.0;

  // calibration
  double progress = 0.0;
  var caliX = 0.0;
  var caliY = 0.0;
  bool hasCaliData = false;
  double attention = 0.0;
  bool isUserOption = false;

  int calibrationType = 5;
  bool isDrowsiness = false;
  bool isBlink = false;
  bool savedCalibrationData = false;
  GazeTrackerProvider() {
    state = GazeTrackerState.first;
    setMessageHandler();
    checkCamera();
  }

  void setMessageHandler() {
    _channel.setMethodCallHandler((call) async {
      debugPrint("setMessageHandler : ${call.method}");
      if (call.method == "setGazeXY") {
        final xy = call.arguments;
        _setGazeXY(xy[0] as double, xy[1] as double);
      } else if (call.method == "setCurrentState") {
        _setGazeTrackerStateString(call.arguments as String);
      } else if (call.method == "getInitializedResult") {
        debugPrint("argument : ${call.arguments}");
        _getInitializedResult(call.arguments);
      }
    });
  }

  void changeUserStatusOption(bool isOption) {
    isUserOption = isOption;
    notifyListeners();
  }

  void changeCalibrationType(int cType) {
    calibrationType = cType;
    notifyListeners();
  }

  void _setGazeXY(double x, double y) {
    point_x = x;
    point_y = y;
  }

  void _getInitializedResult(dynamic result) {
    debugPrint("_getInitializedResult result = ${result[0]}");
    if (result[0] == 1) {
      _setTrackerState(GazeTrackerState.initialized);
    } else {
      failedReason = "Init Failed error code ${result[1]}";
      notifyListeners();
    }
  }

  void _setGazeTrackerStateString(String stateString) {
    if (stateString == "initSuccess") {
    } else if (stateString == "startTracking") {
      _setTrackerState(GazeTrackerState.start);
    }
    debugPrint('state : $stateString');
  }

  Future<void> checkCamera() async {
    final isGrated = await Permission.camera.isGranted;
    if (isGrated) {
      _setTrackerState(GazeTrackerState.idle);
    }
  }

  Future<void> handleCamera() async {
    final status = await Permission.camera.request();
    debugPrint(status.isGranted.toString());
    if (status.isGranted) {
      _setTrackerState(GazeTrackerState.idle);
    }
  }

  Future<void> initGazeTracker() async {
    failedReason = null;
    _setTrackerState(GazeTrackerState.initializing);
    final String result = await _channel.invokeMethod(
        MethodString.initGazeTracker.convertedText, {
      'license': licenseKey,
      'useStatusOption': isUserOption ? "true" : "false"
    });
    debugPrint('result : $result');
  }

  void _setTrackerState(GazeTrackerState state) {
    this.state = state;
    notifyListeners();
  }

  void startTracking() {
    _channel.invokeMethod("startTracking");
    _setTrackerState(GazeTrackerState.start);
  }

  void stopTracking() {
    //_channel.invokeMethod("stopTracking");
    _setTrackerState(GazeTrackerState.initialized);
  }

  void chageIdleState() {
    failedReason = null;
    _setTrackerState(GazeTrackerState.idle);
  }

  Future<void> deinitGazeTracker() async {
    _setTrackerState(GazeTrackerState.idle);
  }

  void startCalibration() {
    final pixelRatio = window.devicePixelRatio;
    //Size in logical pixels
    final logicalScreenSize = window.physicalSize / pixelRatio;
    final logicalWidth = logicalScreenSize.width;
    final logicalHeight = logicalScreenSize.height;
    _setTrackerState(GazeTrackerState.calibrating);
    Future.delayed(Duration(milliseconds: 1500), () {
      caliX = logicalWidth / 2;
      caliY = logicalHeight / 2;
      notifyListeners();
      _setProgress();
    });
  }

  void _setProgress() {
    Future.delayed(Duration(milliseconds: 1500), () {
      progress = 0.5;
      notifyListeners();
      _finishedCalibration();
    });
  }

  void _finishedCalibration() {
    Future.delayed(Duration(milliseconds: 1500), () {
      hasCaliData = true;
      _setTrackerState(GazeTrackerState.start);
    });
  }

  void saveCalibrationData() {
    hasCaliData = false;
    savedCalibrationData = true;
    notifyListeners();
  }
}
