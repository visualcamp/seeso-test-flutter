import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/src/provider/gaze_tracker_provider.dart';
import 'package:test_flutter/src/provider/user_extend_provider.dart';

class UserStatusWidget extends StatelessWidget {
  const UserStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final extendConsumer = Provider.of<UserExtendProvider>(context);
    const style = TextStyle(
        color: Colors.white,
        decoration: TextDecoration.none,
        fontSize: 14,
        fontWeight: FontWeight.normal);
    return Column(children: [
      Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: TextButton.icon(
            onPressed: () {
              extendConsumer.changeIsExtend();
            },
            label: const Text('User Options Info', style: style),
            // ignore: dead_code
            icon: extendConsumer.isExtend
                ? const Icon(
                    Icons.keyboard_arrow_up_sharp,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: Colors.white,
                  ),
          ),
        ),
      ),
      Container(
        height: 1,
        color: Colors.white24,
      ),
      if (extendConsumer.isExtend) const UserStatusExtendWidget()
    ]);
  }
}

class UserStatusExtendWidget extends StatelessWidget {
  const UserStatusExtendWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final consumer = Provider.of<GazeTrackerProvider>(context);
    const style = TextStyle(
        color: Colors.white,
        decoration: TextDecoration.none,
        fontSize: 14,
        fontWeight: FontWeight.normal);
    return Column(
      children: [
        Container(
            width: double.maxFinite,
            height: 48,
            color: Colors.white12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "User Options Info",
                  style: style,
                ),
                Text(
                  "${(consumer.attention * 100).toInt()}%",
                  style: style,
                )
              ],
            )),
        Container(
          height: 1,
          color: Colors.white24,
        ),
        Container(
            width: double.maxFinite,
            height: 48,
            color: Colors.white12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Blink State",
                  style: style,
                ),
                Text(
                  consumer.isBlink ? "Ȍ _ Ő" : "Ȕ _ Ű",
                  style: style,
                )
              ],
            )),
        Container(
          height: 1,
          color: Colors.white24,
        ),
        Container(
            width: double.maxFinite,
            height: 48,
            color: Colors.white12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Do i look seepy now..?",
                  style: style,
                ),
                Text(
                  consumer.isDrowsiness ? "Yes.." : "NOPE !",
                  style: style,
                )
              ],
            ))
      ],
    );
  }
}
