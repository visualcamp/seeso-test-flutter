import 'package:flutter/material.dart';

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
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 24),
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
