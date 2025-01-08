import 'package:flutter/material.dart';
import 'package:hmi_monitor/server/socket_server.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MonitorPageState createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  // ignore: unused_field
  late final SocketServer _server;
  // ignore: prefer_typing_uninitialized_variables
  late final _ipAddress;
  // ignore: prefer_typing_uninitialized_variables
  late final _port;
  Map<String, dynamic> _receivedData = {};

  @override
  void initState() {
    super.initState();
    _server = SocketServer(
        onDataReceived: (data) => {
              setState(() {
                _receivedData = data;
              })
            },
        onServerStarted: (address, port) => {
              setState(() {
                _ipAddress = address;
                _port = port;
              })
            });
    _server.startServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Monitor Server Data")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Server Address: $_ipAddress:$_port",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "Received Data:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildJsonDisplay(_receivedData), // Display the received data
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJsonDisplay(Map<String, dynamic> data) {
    List<Widget> widgets = [];

    data.forEach((key, value) {
      if (value is Map) {
        widgets.add(Text('$key:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
        widgets.add(_buildJsonDisplay(value as Map<String, dynamic>));
      } else if (value is List) {
        widgets.add(Text('$key:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
        for (var item in value) {
          if (item is Map) {
            widgets.add(_buildJsonDisplay(item as Map<String, dynamic>));
          } else {
            widgets.add(Text(item.toString(), style: TextStyle(fontSize: 16)));
          }
        }
      } else {
        widgets.add(Text('$key: $value', style: TextStyle(fontSize: 16)));
      }
      widgets.add(SizedBox(height: 10));
    });
    return Column(children: widgets);
  }
}
