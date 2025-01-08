import 'dart:convert'; // For JSON decoding
import 'dart:io';

class SocketServer {
  final Function(Map<String, dynamic>) onDataReceived;
  final Function(String, String) onServerStarted;

  late ServerSocket _serverSocket;
  final String address;
  final int port;

  SocketServer({
    required this.onDataReceived,
    required this.onServerStarted,
    this.address = '0.0.0.0',
    this.port = 8080,
  });

  Future<void> startServer() async {
    try {
      String bindAddress =
          address == '0.0.0.0' ? await _getLocalIpAddress() : address;

      _serverSocket =
          await ServerSocket.bind(InternetAddress(bindAddress), port);

      onServerStarted(bindAddress, port.toString());

      _serverSocket.listen((Socket client) {
        client.listen((data) {
          String jsonData = String.fromCharCodes(data);
          Map<String, dynamic> parsedData = jsonDecode(jsonData);

          onDataReceived(parsedData);

          client.write('Data received');
        });
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> stopServer() async {
    await _serverSocket.close();
  }

  Future<String> _getLocalIpAddress() async {
    try {
      var interfaces = await NetworkInterface.list();

      for (var interface in interfaces) {
        for (var address in interface.addresses) {
          if (address.type == InternetAddressType.IPv4) {
            return address.address;
          }
        }
      }
      throw Exception('No IPv4 address found');
    } catch (e) {
      rethrow;
    }
  }
}
