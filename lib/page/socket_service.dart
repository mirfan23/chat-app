import 'dart:async';
import 'dart:convert';
import 'package:chat_app/network/network.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  WebSocketChannel? _channel;

  final StreamController<String> _controller = StreamController<String>.broadcast();

  Stream<String> get stream => _controller.stream;

  bool _isConnected = false;
  bool _isConnecting = false;

  String? _lastLoginUser;
  String? _activeRoom;

  // =========================
  // CONNECT
  // =========================
  void connect() {
    if (_isConnected || _isConnecting) return;

    _isConnecting = true;

    print("🔄 Connecting to server...");

    _channel = WebSocketChannel.connect(Uri.parse("ws://10.1.158.108:3000/ws?token=${Network().token}"));

    _channel!.stream.listen(
      (message) {
        _controller.add(message);
      },
      onDone: () {
        print("❌ Socket disconnected");
        _isConnected = false;
        _isConnecting = false;
        _reconnect();
      },
      onError: (error) {
        print("⚠️ Socket error: $error");
        _isConnected = false;
        _isConnecting = false;
        _reconnect();
      },
    );

    _isConnected = true;
    _isConnecting = false;

    print("✅ Connected to Go server");

    // 🔥 AUTO LOGIN ULANG
    if (_lastLoginUser != null) {
      login(_lastLoginUser!);
    }

    // 🔥 AUTO JOIN ROOM ULANG
    if (_activeRoom != null) {
      joinRoom(_activeRoom!);
    }
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 2), () {
      print("🔁 Reconnecting...");
      connect();
    });
  }

  // =========================
  // LOGIN
  // =========================
  void login(String username) {
    _lastLoginUser = username;

    send({"type": "login", "sender": username});
  }

  // =========================
  // JOIN ROOM
  // =========================
  void joinRoom(String roomId) {
    _activeRoom = roomId;

    send({"type": "joinRoom", "roomId": roomId});
  }

  void leaveRoom() {
    _activeRoom = null;
  }

  // =========================
  // SEND
  // =========================
  void send(Map<String, dynamic> data) {
    if (!_isConnected) {
      print("⚠️ Cannot send, socket not connected");
      return;
    }

    final encoded = jsonEncode(data);
    print("📤 SEND: $encoded");
    _channel?.sink.add(encoded);
  }

  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
  }
}
