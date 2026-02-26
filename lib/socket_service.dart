// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class SocketService {
//   static final SocketService _instance = SocketService._internal();
//   factory SocketService() => _instance;

//   IO.Socket? _socket;

//   SocketService._internal();

//   IO.Socket get socket {
//     if (_socket == null) {
//       throw Exception("Socket not connected. Call connect() first.");
//     }
//     return _socket!;
//   }

//   void connect() {
//     if (_socket != null) return;

//     _socket = IO.io(
//       "IP SERVER", // Change IP
//       IO.OptionBuilder().setTransports(['websocket']).enableAutoConnect().enableReconnection().build(),
//     );

//     _socket!.onConnect((_) {
//       print("✅ CONNECTED");
//       print("Socket ID: ${_socket!.id}");
//     });

//     _socket!.onDisconnect((_) {
//       print("❌ DISCONNECTED");
//     });

//     _socket!.onConnectError((data) {
//       print("⚠ CONNECT ERROR: $data");
//     });

//     _socket!.connect();
//   }

//   bool get isConnected => _socket?.connected ?? false;
// }
// 10.211.34.133

// import 'dart:async';
// import 'dart:convert';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class SocketService {
//   static final SocketService _instance = SocketService._internal();
//   factory SocketService() => _instance;

//   late WebSocketChannel _channel;
//   late StreamController _controller;

//   bool isConnected = false;

//   SocketService._internal();

//   void connect() {
//     _channel = WebSocketChannel.connect(
//       Uri.parse('ws://10.1.158.55:3000/ws'),
//       // 🔥 Android Emulator = 10.0.2.2
//       // 🔥 HP fisik = IP laptop (192.168.x.x)
//     );

//     _controller = StreamController.broadcast();

//     _channel.stream.listen(
//       (data) {
//         print("📩 RAW: $data");
//         _controller.add(data);
//       },
//       onDone: () {
//         isConnected = false;
//         print("❌ Disconnected");
//       },
//       onError: (error) {
//         isConnected = false;
//         print("⚠️ Connection error: $error");
//       },
//     );

//     isConnected = true;
//     print("✅ Connected to Go server");
//   }

//   Stream get stream => _controller.stream;

//   void send(Map<String, dynamic> data) {
//     if (!isConnected) {
//       print("❌ Not connected");
//       return;
//     }

//     final jsonData = jsonEncode(data);
//     print("📤 SEND: $jsonData");

//     _channel.sink.add(jsonData);
//   }

//   void disconnect() {
//     _channel.sink.close();
//     _controller.close();
//     isConnected = false;
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late WebSocketChannel _channel;
  late Stream _broadcastStream;

  bool isConnected = false;

  SocketService._internal();

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse('ws://10.1.158.55:3000/ws'));

    // 🔥 INI YANG BENAR
    _broadcastStream = _channel.stream.asBroadcastStream();

    _broadcastStream.listen(
      (data) {
        print("📩 RAW FROM SERVER: $data");
      },
      onDone: () {
        isConnected = false;
        print("❌ Disconnected");
      },
      onError: (error) {
        isConnected = false;
        print("⚠️ Error: $error");
      },
    );

    isConnected = true;
    print("✅ Connected to Go server");
  }

  Stream get stream => _broadcastStream;

  void send(Map<String, dynamic> data) {
    if (!isConnected) {
      print("❌ Not connected");
      return;
    }

    final jsonData = jsonEncode(data);
    print("📤 SEND: $jsonData");

    _channel.sink.add(jsonData);
  }

  void disconnect() {
    _channel.sink.close();
    isConnected = false;
  }
}
