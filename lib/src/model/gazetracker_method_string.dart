enum MethodString {
  initGazeTracker,
  deinitGazeTracker,
  startTracking,
  stopTracking,
  startCalibration,
  saveCalibrationData,
  startCollectSamples
}

extension MethodStringExtension on MethodString {
  String get convertedText {
    switch (this) {
      case MethodString.initGazeTracker:
        return "initGazeTracker";
      case MethodString.deinitGazeTracker:
        return "deinitGazeTracker";
      case MethodString.startTracking:
        return "startTracking";
      case MethodString.stopTracking:
        return "stopTracking";
      case MethodString.startCalibration:
        return "startCalibration";
      case MethodString.saveCalibrationData:
        return "saveCalibrationData";
      case MethodString.startCollectSamples:
        return "startCollectSamples";
    }
  }
}
