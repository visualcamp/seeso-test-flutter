import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

// provider
import 'package:test_flutter/src/provider/gaze_tracker_provider.dart';

// model
import 'package:test_flutter/src/model/app_stage.dart';
import 'package:test_flutter/src/provider/user_extend_provider.dart';
import 'package:test_flutter/src/ui/calibration_widget.dart';

// widget
// ignore: depend_on_referenced_packages
import 'package:test_flutter/src/ui/camera_handle_widget.dart';
import 'package:test_flutter/src/ui/gaze_point_widget.dart';
import 'package:test_flutter/src/ui/initialized_fail_dialog_widget.dart';
import 'package:test_flutter/src/ui/initializing_widget.dart';
import 'package:test_flutter/src/ui/loading_circle_widget.dart';
import 'package:test_flutter/src/ui/title_widget.dart';
import 'package:test_flutter/src/ui/initialized_widget.dart';
import 'package:test_flutter/src/ui/tracking_mode_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (BuildContext context) => GazeTrackerProvider()),
      ChangeNotifierProvider(
          create: (BuildContext context) => UserExtendProvider())
    ], child: const AppView()));
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
            child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                  color: Colors.white10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const TitleWidget(),
                      Consumer<GazeTrackerProvider>(
                        builder: (context, gazeTracker, child) {
                          switch (gazeTracker.state) {
                            case GazeTrackerState.first:
                              return const CameraHandleWidget();
                            case GazeTrackerState.idle:
                              return const InitializingWidget();
                            case GazeTrackerState.initialized:
                              return const InitializedWidget();
                            case GazeTrackerState.start:
                            case GazeTrackerState.calibrating:
                              return const TrackingModeWidget();
                            default:
                              return const InitializingWidget();
                          }
                        },
                      ),
                    ],
                  )),
            ),
            if (consumer.state == GazeTrackerState.start)
              const GazePointWidget(),
            if (consumer.state == GazeTrackerState.initializing)
              const LoadingCircleWidget(),
            if (consumer.state == GazeTrackerState.calibrating)
              const CalibrationWidget(),
            if (consumer.failedReason != null) const InitializedFailDialog()
          ],
        )));
  }
}
