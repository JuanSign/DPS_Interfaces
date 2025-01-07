import 'package:flutter/material.dart';
import 'package:hmi_control/components/joystick.dart';
import 'package:hmi_control/components/throttle.dart';

class ControlPage extends StatelessWidget {
  const ControlPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Control Page'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Throttle(),
            Throttle(),
            Joystick(),
            Throttle(),
            Throttle()
          ],
        ));
  }
}
