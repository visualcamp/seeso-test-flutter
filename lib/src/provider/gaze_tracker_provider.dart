import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:permission_handler/permission_handler.dart';
import 'package:test_flutter/src/model/app_stage.dart';

class GazeTrackerProvider with ChangeNotifier {
  dynamic state;
  final _channel = const MethodChannel('samples.flutter.dev/tracker');
  var point_x = 0.0;
  var point_y = 0.0;
  bool isUserOption = false;

  GazeTrackerProvider() {
    state = GazeTrackerState.first;
    setMessageHandler();
    checkCamera();
  }

  void setMessageHandler() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == "setGazeXY") {
        final xy = call.arguments;
        _setGazeXY(xy[0] as double, xy[1] as double);
      } else if (call.method == "setCurrentState") {
        _setGazeTrackerStateString(call.arguments as String);
      }
    });
  }

  void changeUserStatusOption(bool isOption) {
    isUserOption = isOption;
    notifyListeners();
  }

  void _setGazeXY(double x, double y) {
    point_x = x;
    point_y = y;
  }

  void _setGazeTrackerStateString(String stateString) {
    if (stateString == "initSuccess") {
      state = GazeTrackerState.initialized;
      notifyListeners();
    }
    debugPrint('state : $stateString');
  }

  Future<void> checkCamera() async {
    final isGrated = await Permission.camera.isGranted;
    if (isGrated) {
      state = GazeTrackerState.idle;
      notifyListeners();
    }
  }

  Future<void> handleCamera() async {
    final status = await Permission.camera.request();
    debugPrint(status.isGranted.toString());
    if (status.isGranted) {
      state = GazeTrackerState.idle;
      notifyListeners();
    }
  }

  Future<void> initGazeTracker() async {
    state = GazeTrackerState.initializing;
    notifyListeners();
    final String result = await _channel.invokeMethod("startTracking",
        {'license': 'dev_1ntzip9admm6g0upynw3gooycnecx0vl93hz8nox'});

    if (result == "initSuccess") {
      state = GazeTrackerState.initialized;
      notifyListeners();
    } else {
      debugPrint('debug: $result');
    }
  }

  Future<void> deinitGazeTracker() async {
    state = GazeTrackerState.idle;
    notifyListeners();
  }
}
