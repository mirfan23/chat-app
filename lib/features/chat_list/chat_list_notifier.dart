import 'dart:convert';

import 'package:chat_app/features/chat_list/models/chat_list_model.dart';
import 'package:chat_app/core/services/socket_service.dart';
import 'package:chat_app/features/chat_list/chat_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final chatListProvider = StateNotifierProvider<ChatListNotifier, ChatListState>((ref) {
  return ChatListNotifier(ref);
});

class ChatListNotifier extends StateNotifier<ChatListState> {
  final Ref ref;
  late final SocketService _socket;

  bool _initialized = false;

  ChatListNotifier(this.ref) : super(const ChatListState()) {
    _socket = ref.read(socketProvider);
  }

  void init(String userId) {
    if (_initialized) return;

    state = state.copyWith(myUserId: userId);

    _socket.connect();
    _socket.login(userId);

    _socket.stream.listen((event) {
      final data = json.decode(event);

      switch (data["type"]) {
        case "chatList":
          _handleChatList(data);
          break;
        case "newMessage":
          _handleNewMessage(data);
          break;
      }
    });

    _initialized = true;
  }

  void _handleChatList(Map<String, dynamic> data) {
    final list = (data["data"] as List).map((e) => ChatListModel.fromJson(e)).toList();

    state = state.copyWith(chatList: list);
  }

  void _handleNewMessage(Map<String, dynamic> data) {
    final sender = data["sender"];
    final text = data["text"];

    final index = state.chatList.indexWhere((e) => e.friend == sender);

    if (index == -1) return;

    final old = state.chatList[index];

    final updated = old.copyWith(lastMessage: text, unreadCount: old.unreadCount + 1);

    final newList = [...state.chatList];
    newList.removeAt(index);
    newList.insert(0, updated);

    state = state.copyWith(chatList: newList);
  }

  void refresh() {
    _socket.getChatList();
  }
}
