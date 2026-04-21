import 'dart:async';
import 'dart:convert';
import 'package:chat_app/network/Net.dart';
import 'package:chat_app/network/network.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum SocketStatus { disconnected, connecting, connected }

final socketProvider = Provider<SocketService>((ref) {
  final socket = SocketService(ref);

  ref.onDispose(() {
    socket.dispose();
  });

  return socket;
});

class SocketService {
  final Ref ref;

  SocketService(this.ref);

  WebSocketChannel? _channel;

  final _controller = StreamController<String>.broadcast();
  Stream<String> get stream => _controller.stream;

  SocketStatus _status = SocketStatus.disconnected;
  SocketStatus get status => _status;

  String? _lastLoginUser;
  String? _activeRoom;

  bool get isConnected => _status == SocketStatus.connected;

  /// =========================
  /// CONNECT
  /// =========================
  void connect() {
    if (_status == SocketStatus.connected || _status == SocketStatus.connecting) return;

    _status = SocketStatus.connecting;

    final token = Network().token;

    _channel = WebSocketChannel.connect(Uri.parse("${Network().getDomainName(Net.websocket)}?token=$token"));

    _channel!.stream.listen(_onMessage, onDone: _handleDisconnect, onError: (_) => _handleDisconnect());

    _status = SocketStatus.connected;

    _restoreSession();
  }

  void _onMessage(dynamic message) {
    _controller.add(message);
  }

  void _handleDisconnect() {
    _status = SocketStatus.disconnected;

    Future.delayed(const Duration(seconds: 2), connect);
  }

  void _restoreSession() {
    if (_lastLoginUser != null) login(_lastLoginUser!);
    if (_activeRoom != null) joinRoom(_activeRoom!);
  }

  /// =========================
  /// ACTIONS
  /// =========================
  void login(String username) {
    _lastLoginUser = username;

    send({"type": "login", "sender": username});
  }

  void joinRoom(String roomId) {
    _activeRoom = roomId;

    send({"type": "joinRoom", "roomId": roomId});
  }

  void leaveRoom() {
    _activeRoom = null;
  }

  void send(Map<String, dynamic> data) {
    if (!isConnected) return;

    _channel?.sink.add(jsonEncode(data));
  }

  void getChatList() {
    send({"type": "chatList"});
  }

  /// =========================
  /// DISPOSE
  /// =========================
  void disconnect() {
    _channel?.sink.close();
    _status = SocketStatus.disconnected;
  }

  void dispose() {
    disconnect();
    _controller.close();
  }
}
// class SocketService {
//   static final SocketService _instance = SocketService._internal();
//   factory SocketService() => _instance;
//   SocketService._internal();

//   WebSocketChannel? _channel;

//   final StreamController<String> _controller = StreamController<String>.broadcast();

//   Stream<String> get stream => _controller.stream;

//   bool _isConnected = false;
//   bool _isConnecting = false;

//   String? _lastLoginUser;
//   String? _activeRoom;

//   // =========================
//   // CONNECT
//   // =========================
//   void connect() {
//     if (_isConnected || _isConnecting) return;

//     _isConnecting = true;

//     print("🔄 Connecting to server...");

//     print("🔥 TOKEN: ${Network().token}");

//     _channel = WebSocketChannel.connect(
//       Uri.parse("${Network().getDomainName(Net.websocket)}?token=${Network().token}"),
//     );

//     _channel!.stream.listen(
//       (message) {
//         print("📥 SOCKET RECEIVE: $message");
//         _controller.add(message);
//       },
//       onDone: () {
//         print("❌ Socket disconnected");
//         _isConnected = false;
//         _isConnecting = false;
//         _reconnect();
//       },
//       onError: (error) {
//         print("⚠️ Socket error: $error");
//         _isConnected = false;
//         _isConnecting = false;
//         _reconnect();
//       },
//     );

//     _isConnected = true;
//     _isConnecting = false;

//     print("✅ Connected to Go server");

//     // 🔥 AUTO LOGIN ULANG
//     if (_lastLoginUser != null) {
//       login(_lastLoginUser!);
//     }

//     // 🔥 AUTO JOIN ROOM ULANG
//     if (_activeRoom != null) {
//       joinRoom(_activeRoom!);
//     }
//   }

//   void _reconnect() {
//     Future.delayed(const Duration(seconds: 2), () {
//       print("🔁 Reconnecting...");
//       connect();
//     });
//   }

//   // =========================
//   // LOGIN
//   // =========================
//   void login(String username) {
//     _lastLoginUser = username;

//     send({"type": "login", "sender": username});
//   }

//   // =========================
//   // JOIN ROOM
//   // =========================
//   void joinRoom(String roomId) {
//     _activeRoom = roomId;

//     send({"type": "joinRoom", "roomId": roomId});
//   }

//   void leaveRoom() {
//     _activeRoom = null;
//   }

//   // =========================
//   // SEND
//   // =========================
//   void send(Map<String, dynamic> data) {
//     if (!_isConnected) {
//       print("⚠️ Cannot send, socket not connected");
//       return;
//     }

//     final encoded = jsonEncode(data);
//     print("📤 SEND: $encoded");
//     _channel?.sink.add(encoded);
//   }

//   void disconnect() {
//     _channel?.sink.close();
//     _isConnected = false;
//   }

//   void getChatList() {
//     send({"type": "chatList"});
//   }
// }
