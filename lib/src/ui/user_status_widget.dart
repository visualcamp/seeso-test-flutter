import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/src/provider/gaze_tracker_provider.dart';
import 'package:test_flutter/src/provider/user_extand_provider.dart';

class UserSatatusWidget extends StatelessWidget {
  const UserSatatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final extandConsumer = Provider.of<UserExtandProvider>(context);
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
              extandConsumer.changeIsExtand();
            },
            label: const Text('User Options Info', style: style),
            // ignore: dead_code
            icon: extandConsumer.isExtand
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
      if (extandConsumer.isExtand) const UserStatusExtendWidget()
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
                  "${consumer.attention * 100}%",
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
