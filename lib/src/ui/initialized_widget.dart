import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/src/ui/deinit_mode_widget.dart';

import '../provider/gaze_tracker_provider.dart';

class InitializedWidget extends StatelessWidget {
  const InitializedWidget({Key? key}) : super(key: key);

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
                consumer.startTracking();
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
