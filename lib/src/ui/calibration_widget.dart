import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/src/provider/gaze_tracker_provider.dart';

class CalibrationWidget extends StatelessWidget {
  const CalibrationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final consumer = Provider.of<GazeTrackerProvider>(context);
    return Container(
        color: const Color.fromARGB(80, 0, 0, 0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text('Look at the circle!',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        decoration: TextDecoration.none)),
                SizedBox(
                  height: 80,
                ),
              ],
            )),
            Positioned(
              child: CircularPercentIndicator(
                  radius: 24,
                  lineWidth: 2,
                  animation: true,
                  percent: consumer.progress,
                  center: Text('${consumer.progress * 100}%',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0))),
            ),
          ],
        ));
  }
}
