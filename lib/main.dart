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
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class GazeTrcking extends StatefulWidget {
  const GazeTrcking({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GazeTrackingState();
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

class _RandomWordsState extends State<RandomWords> {
  static const plaform = MethodChannel('samples.flutter.dev/tracker');

  _RandomWordsState() {
    debugPrint('init');
    plaform.setMethodCallHandler((call) async {
      if (call.method == "setCurrentState") {
        final result = call.arguments as String;
        debugPrint('state : $result');
      }
    });
  }

  Future<void> _startLogic() async {
    final String result = await plaform.invokeMethod("startTracking",
        {'license': 'dev_1ntzip9admm6g0upynw3gooycnecx0vl93hz8nox'});
    debugPrint('debug: $result');
  }

  Future<void> _handleCameraAndMic() async {
    final status = await Permission.camera.request();
    print(status);
    if (status.isGranted) {
      _startLogic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          constraints: const BoxConstraints.expand(),
          child: Container(
              padding: const EdgeInsets.all(20),
              child: OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
                ),
                onPressed: () {
                  _handleCameraAndMic();
                },
                child: const Text('start'),
              )),
        ),
        const GazeTrcking(),
      ],
    );
  }
}
