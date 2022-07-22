import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'GazeTracking Demo',
      home: AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class GazeTrcking extends StatefulWidget {
  const GazeTrcking({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GazeTrackingState();
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Title(
                  color: const Color(0xFF000000),
                  child: const Text(
                    'SeeSo Sample',
                    style: TextStyle(
                        color: Colors.white, decoration: TextDecoration.none),
                  )),
              Divider(
                color: Colors.grey[800],
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Follow steps below to experience gaze tracking",
                  style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
              ),
            ]));
  }
}

class Initialized extends StatefulWidget {
  const Initialized({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _InitializedState();
}

class _InitializedState extends State<Initialized> {
  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
              child: const Text(
                'Initialized',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }
}

class _GazeTrackingState extends State<GazeTrcking> {
  static const plaform = MethodChannel('samples.flutter.dev/tracker');
  static const circleSize = 20.0;
  var _pointX = 0.0;
  var _pointY = 0.0;

  _GazeTrackingState() {
    plaform.setMethodCallHandler((call) async {
      if (call.method == "setGazeXY") {
        debugPrint('setGazeXy');
        final xy = call.arguments;
        debugPrint('xy $xy.count');
        setState(() {
          _pointX = xy[0] as double;
          _pointY = xy[1] as double;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: _pointX - circleSize / 2.0,
        top: _pointY - circleSize / 2.0,
        child: Container(
            width: circleSize,
            height: circleSize,
            decoration: const BoxDecoration(
                color: Colors.red, shape: BoxShape.circle)));
  }
}

class _AppViewState extends State<AppView> {
  static const plaform = MethodChannel('samples.flutter.dev/tracker');
  var isTracking = false;
  _AppViewState() {
    debugPrint('init');
    plaform.setMethodCallHandler((call) async {
      if (call.method == "setCurrentState") {
        final result = call.arguments as String;
        if (result == "initSuccess") {
          setState(() {
            isTracking = true;
          });
        }
        debugPrint('state : $result');
      }
    });
  }

  Future<void> _startLogic() async {
    final String result = await plaform.invokeMethod("startTracking",
        {'license': 'dev_1ntzip9admm6g0upynw3gooycnecx0vl93hz8nox'});
    debugPrint('debug: $result');
  }

  Future<void> _handleCamera() async {
    final status = await Permission.camera.request();
    debugPrint(status.isGranted.toString());
    if (status.isGranted) {
      _startLogic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SafeArea(
          child: Container(
              color: Colors.white10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const TitleWidget(),
                  const Initialized(),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            width: 1.0, color: Colors.white70)),
                    onPressed: () {
                      if (!isTracking) _handleCamera();
                    },
                    child: const Text(
                      'start',
                      style: TextStyle(color: Colors.white70, fontSize: 24),
                    ),
                  )
                ],
              )),
        ),
        if (isTracking) const GazeTrcking(),
      ],
    );
  }
}
