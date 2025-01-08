import 'package:flutter/material.dart';
import 'package:hmi_control/components/joystick.dart';
import 'package:hmi_control/components/throttle.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  Map<String, double> content = {
    'angle': 0,
    'throttle1': 0,
    'throttle2': 0,
    'throttle3': 0,
    'throttle4': 0
  };

  void _display() {
    print(content['angle']);
    print(content['throttle1']);
    print(content['throttle2']);
    print(content['throttle3']);
    print(content['throttle4']);
  }

  void _handleChange(double value, String name) {
    setState(() {
      content[name] = value;
    });
    _display();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Control Page'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Throttle(
              callback: _handleChange,
              name: 'throttle1',
            ),
            Throttle(
              callback: _handleChange,
              name: 'throttle2',
            ),
            Joystick(
              callback: _handleChange,
              name: 'angle',
            ),
            Throttle(
              callback: _handleChange,
              name: 'throttle3',
            ),
            Throttle(
              callback: _handleChange,
              name: 'throttle4',
            )
          ],
        ));
  }
}
