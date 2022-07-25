import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

// provider
import 'package:test_flutter/src/provider/gaze_tracker_provider.dart';

// model
import 'package:test_flutter/src/model/app_stage.dart';

// widget
// ignore: depend_on_referenced_packages
import 'package:test_flutter/src/ui/camera_handle_widget.dart';
import 'package:test_flutter/src/ui/gaze_point_widget.dart';
import 'package:test_flutter/src/ui/initialized_widget.dart';
import 'package:test_flutter/src/ui/title_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GazeTrackerProvider(),
      child: const MaterialApp(home: AppView()),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);
  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    final consumer = Provider.of<GazeTrackerProvider>(context);

    return Stack(
      children: <Widget>[
        SafeArea(
          child: Container(
              color: Colors.white10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const TitleWidget(),
                  Consumer<GazeTrackerProvider>(
                    builder: (context, gazetracker, child) {
                      switch (gazetracker.state) {
                        case GazeTrackerState.first:
                          return const CameraHandleWidget();
                        case GazeTrackerState.idle:
                          return const InitializedWidget();
                        default:
                          return const CameraHandleWidget();
                      }
                    },
                  ),
                ],
              )),
        ),
        if (consumer.state == GazeTrackerState.start) const GazePointWidget(),
        if (consumer.state == GazeTrackerState.initializing)
          Center(
            child: const SpinKitRotatingCircle(
              color: Colors.white60,
              size: 50.0,
            ),
          )
      ],
    );
  }
}
