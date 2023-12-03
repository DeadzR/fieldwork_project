import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:io' show Platform;

class SocketClient {
  IO.Socket? socket;

  static SocketClient? _instance;
  late String ip;

  SocketClient._internal() {
    if (Platform.isAndroid) {
      ip = "http://10.0.2.2:3000";
      // Android-specific code
    } else if (Platform.isWindows) {
      ip = "http://localhost:3000";
      // iOS-specific code
    }
    socket = IO.io(ip, <String, dynamic>{
      'transports': ["websocket"],
      'autoConnect': false,
    });

    socket!.connect();
  }
  static SocketClient get instance {
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}
