import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/gaze_tracker_provider.dart';

class TrackingModeWidget extends StatelessWidget {
  const TrackingModeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final consumer = Provider.of<GazeTrackerProvider>(context);
    return Column(
      children: <Widget>[
        const Text('GazeTracker is activated.',
            style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                decoration: TextDecoration.none)),
        Container(
          height: 10,
        ),
        Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: TextButton(
              onPressed: () {
                consumer.deinitGazeTracker();
              },
              child: const Text(
                'Stop GazeTracker',
                style: TextStyle(color: Colors.white),
              )),
        ),
        Container(
          width: double.maxFinite,
          height: 1,
          color: Colors.white24,
        ),
        const Text(
            'You can init GazeTracker With UserOption! \n (need to restart GazeTracker)',
            style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                decoration: TextDecoration.none)),
        Container(
            width: double.maxFinite,
            height: 20,
            color: const Color.fromARGB(0, 0, 0, 0)),
        const Text('Now You can track you gaze!',
            style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                decoration: TextDecoration.none)),
        Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: TextButton(
              onPressed: () {
                //consumer.initGazeTracker();
              },
              child: const Text(
                'Start Tracking',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }
}
