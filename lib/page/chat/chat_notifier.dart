import 'dart:async';
import 'dart:convert';

import 'package:chat_app/network/Net.dart';
import 'package:chat_app/network/network.dart';
import 'package:chat_app/page/socket_service.dart';
import 'package:chat_app/security/e2ee_services.dart';
import 'package:chat_app/state/chat/chat_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final chatProvider = StateNotifierProvider.autoDispose<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref);
});

class ChatNotifier extends StateNotifier<ChatState> {
  final Ref ref;
  late final SocketService _socket;

  StreamSubscription? _sub;

  String? _roomId;
  String? _myId;

  ChatNotifier(this.ref) : super(const ChatState()) {
    _socket = ref.read(socketProvider);
  }

  /// =========================
  /// INIT
  /// =========================
  void init({required String roomId, required String myId}) {
    _roomId = roomId;
    _myId = myId;

    _socket.joinRoom(roomId);

    _sub = _socket.stream.listen(_handleEvent);

    getMessages(roomId);
    sendRead();
  }

  /// =========================
  /// SOCKET HANDLER
  /// =========================
  void _handleEvent(String raw) {
    final data = jsonDecode(raw);

    print("🔥 CHAT EVENT: $data");
    if (data["roomId"] != _roomId) return;

    switch (data["type"]) {
      case "newMessage":
        _addMessage(data);
        break;

      case "typing":
        if (data["sender"] != _myId) {
          final isTyping = data["isTyping"] ?? false;

          state = state.copyWith(typingUser: isTyping ? data["sender"] : null);
        }
        break;

      case "messageRead":
        if (data["reader"] != _myId) {
          _markRead();
        }
        break;
    }
  }

  /// =========================
  /// API
  /// =========================
  Future<void> getMessages(String roomId) async {
    state = state.copyWith(isLoading: true);

    dynamic res;

    try {
      final encodedRoomId = Uri.encodeComponent(roomId);

      res = await Network().getApi(Net.gateway, "messages?roomId=$encodedRoomId");

      final body = json.decode(res.body);

      if (res.statusCode == 200) {
        final list = List<Map<String, dynamic>>.from(body["data"]);

        for (var msg in list) {
          try {
            msg["text"] = E2EEService.decryptMessage(msg["cipherText"], msg["iv"], msg["roomId"]);
          } catch (_) {
            msg["text"] = "[decrypt error]";
          }
        }

        state = state.copyWith(messages: list);
      }
    } catch (_) {}

    state = state.copyWith(isLoading: false);
  }

  /// =========================
  /// MESSAGE HANDLING
  /// =========================
  void _addMessage(Map<String, dynamic> msg) {
    try {
      msg["text"] = E2EEService.decryptMessage(msg["cipherText"], msg["iv"], msg["roomId"]);
    } catch (_) {
      msg["text"] = "[decrypt error]";
    }

    final exists = state.messages.any((m) => m["createdAt"] == msg["createdAt"] && m["sender"] == msg["sender"]);

    if (exists) return;

    state = state.copyWith(messages: [...state.messages, msg]);
  }

  void _markRead() {
    final updated = state.messages.map((msg) {
      return {...msg, "isRead": true};
    }).toList();

    state = state.copyWith(messages: updated);
  }

  /// =========================
  /// ACTIONS
  /// =========================
  void sendMessage({required String text, required String friend}) {
    if (text.isEmpty) return;

    final encrypted = E2EEService.encryptMessage(text, _roomId!);

    _socket.send({
      "type": "sendMessage",
      "roomId": _roomId,
      "sender": _myId,
      "receiver": friend,
      "cipherText": encrypted["cipherText"],
      "encryptedKey": encrypted["encryptedKey"],
      "iv": encrypted["iv"],
      "preview": text,
    });
  }

  void sendTyping(bool value) {
    _socket.send({"type": "typing", "roomId": _roomId, "sender": _myId, "isTyping": value});
  }

  void sendRead() {
    _socket.send({"type": "readMessage", "roomId": _roomId});
  }

  /// =========================
  /// DISPOSE
  /// =========================
  @override
  void dispose() {
    _sub?.cancel();
    _socket.leaveRoom();
    super.dispose();
  }
}
