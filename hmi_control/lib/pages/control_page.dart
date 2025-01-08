import 'dart:convert';
import 'dart:io';

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
  late Map<String, dynamic> content;
  late Socket socket;
  bool connected = false;

  @override
  void initState() {
    super.initState();
    content = {
      'angle': 0,
      'throttle1': 0,
      'throttle2': 0,
      'throttle3': 0,
      'throttle4': 0
    };
  }

  Future<void> _connect() async {
    socket = await Socket.connect('172.20.10.6', 8080);
    connected = true;
  }

  void _send() async {
    if (!connected) {
      await _connect();
    }
    socket.write(json.encode(content));
  }

  void _handleChange(double value, String name) {
    setState(() {
      content[name] = value;
    });
    _send();
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
