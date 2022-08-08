import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:test_flutter/src/provider/gaze_tracker_provider.dart';

class GazePointWidget extends StatelessWidget {
  static const circleSize = 20.0;

  const GazePointWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final consumer = Provider.of<GazeTrackerProvider>(context);
    return Positioned(
        left: consumer.pointX - circleSize / 2.0,
        top: consumer.pointY - circleSize / 2.0,
        child: Container(
            width: circleSize,
            height: circleSize,
            decoration: const BoxDecoration(
                color: Colors.red, shape: BoxShape.circle)));
  }
}
