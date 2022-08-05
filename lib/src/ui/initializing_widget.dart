import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/src/provider/gaze_tracker_provider.dart';
import 'package:test_flutter/src/ui/initialized_fail_dialog_widget.dart';

class InitializingWidget extends StatelessWidget {
  const InitializingWidget({Key? key}) : super(key: key);
  void _initializing(BuildContext context) async {
    final consumer = Provider.of<GazeTrackerProvider>(context, listen: false);
    if (consumer.failedReason != null) {
      showCupertinoDialog(
          context: context,
          builder: (_) => ChangeNotifierProvider<GazeTrackerProvider>.value(
                value: consumer,
                child: const InitializedFailDialog(),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final consumer = Provider.of<GazeTrackerProvider>(context);
    return Column(
      children: <Widget>[
        const Text('You need to init GazeTracker first',
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
                consumer.initGazeTracker();
                _initializing(context);
              },
              child: const Text(
                'Initialize   GazzeTracker',
                style: TextStyle(color: Colors.white),
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
                'With User Option',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none),
              ),
              CupertinoSwitch(
                  activeColor: Colors.white,
                  value: consumer.isUserOption,
                  onChanged: ((value) =>
                      consumer.changeUserStatusOption(value))),
            ],
          ),
        ),
      ],
    );
  }
}
