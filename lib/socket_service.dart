import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  IO.Socket? _socket;

  SocketService._internal();

  IO.Socket get socket {
    if (_socket == null) {
      throw Exception("Socket not connected. Call connect() first.");
    }
    return _socket!;
  }

  void connect() {
    if (_socket != null) return;

    _socket = IO.io(
      "IP SERVER", // Change IP
      IO.OptionBuilder().setTransports(['websocket']).enableAutoConnect().enableReconnection().build(),
    );

    _socket!.onConnect((_) {
      print("✅ CONNECTED");
      print("Socket ID: ${_socket!.id}");
    });

    _socket!.onDisconnect((_) {
      print("❌ DISCONNECTED");
    });

    _socket!.onConnectError((data) {
      print("⚠ CONNECT ERROR: $data");
    });

    _socket!.connect();
  }

  bool get isConnected => _socket?.connected ?? false;
}
