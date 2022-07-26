import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/src/model/app_stage.dart';

import 'package:test_flutter/src/provider/gaze_tracker_provider.dart';
import 'deinit_mode_widget.dart';

class TrackingModeWidget extends StatelessWidget {
  const TrackingModeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final consumer = Provider.of<GazeTrackerProvider>(context);
    return Column(
      children: <Widget>[
        const DeinitModeWidget(),
        Container(
            width: double.maxFinite,
            height: 20,
            color: const Color.fromARGB(0, 0, 0, 0)),
        const Text('Tracking is On!!',
            style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                decoration: TextDecoration.none)),
        Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: TextButton(
              onPressed: () {
                consumer.stopTracking();
              },
              child: const Text(
                'Stop tracking',
                style: TextStyle(color: Colors.white),
              )),
        ),
        Container(
            width: double.maxFinite,
            height: 20,
            color: const Color.fromARGB(0, 0, 0, 0)),
        const Text('And also you can improve accuaracy through calibration',
            style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                decoration: TextDecoration.none)),
        Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: TextButton(
              onPressed: () {
                consumer.startCalibration();
              },
              child: Text(
                (consumer.state == GazeTrackerState.calibrating)
                    ? 'Calibration started!'
                    : 'Start Calibration',
                style: const TextStyle(color: Colors.white),
              )),
        ),
        Container(
          width: double.maxFinite,
          height: 1,
          color: Colors.white24,
        ),
        Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Calibration Type',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none),
              ),
              const SizedBox(
                width: 60,
              ),
              CupertinoSegmentedControl(
                children: const {
                  1: Text(" ONE_POINT ",
                      style: TextStyle(
                          color: Colors.white24,
                          fontSize: 12,
                          decoration: TextDecoration.none)),
                  5: Text(" FIVE_POINT ",
                      style: TextStyle(
                          color: Colors.white24,
                          fontSize: 12,
                          decoration: TextDecoration.none)),
                },
                onValueChanged: (newValue) {
                  debugPrint('value changed : $newValue');
                  consumer.changeCalibrationType(newValue as int);
                },
                groupValue: consumer.calibrationType,
                unselectedColor: Colors.white12,
                selectedColor: Colors.white38,
                pressedColor: Colors.white38,
                borderColor: Colors.white12,
                padding: const EdgeInsets.all(8),
              )
            ],
          ),
        ),
        const Text(
            '(Calibration only can be done while gae tracking is activated)',
            style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                decoration: TextDecoration.none)),
      ],
    );
  }
}
