import 'dart:convert';

import 'package:chat_app/models/all_user_response.dart';
import 'package:chat_app/models/chat_list_model.dart';
import 'package:chat_app/network/Net.dart';
import 'package:chat_app/network/network.dart';
import 'package:chat_app/page/chat/chat_provider.dart';
import 'package:chat_app/page/login/login_page.dart';
import 'package:chat_app/page/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:fx_helper/network/fx_network.dart';
import 'package:fx_helper/secure_storage.dart';
import 'package:fx_helper/widgets/net_msg_dialog.dart';
import 'package:provider/provider.dart';

class ChatListProvider extends ChangeNotifier {
  bool isLoading = false;

  bool _initialized = false;
  final SocketService _socket = SocketService();

  List<AllUserModel> users = [];
  List<ChatListModel> _chatList = [];
  List<ChatListModel> get chatList => _chatList;

  final Map<String, bool> _onlineUsers = {};

  // =========================
  // INIT SOCKET LISTENER
  // =========================
  void initSocketListener(String username) {
    if (_initialized) return;
    print('📥 RECEIVE 1');

    _socket.stream.listen((event) {
      print('📥 RECEIVE 2');
      final data = jsonDecode(event);
      print('📥 RECEIVE 3 : $data');

      switch (data["type"]) {
        case "user_status":
          _handleUserStatus(data);
          break;
        case "online_users":
          _handleOnlineUsers(data);
          break;

        case "newMessage":
          _handleIncomingMessage(data, username);
          break;
      }
    });

    _initialized = true;
  }

  // =========================
  // SET INITIAL CHAT LIST
  // (dipanggil setelah fetch dari API)
  // =========================
  void setChatList(List<ChatListModel> list) {
    _chatList = list;
    notifyListeners();
  }

  // =========================
  // HANDLE ONLINE STATUS
  // =========================
  void _handleUserStatus(Map<String, dynamic> data) {
    final username = (data["username"] ?? "").toString().toLowerCase();
    final raw = data["isOnline"];
    final isOnline = raw == true || raw == "true";

    _onlineUsers[username] = isOnline;

    final index = _chatList.indexWhere((e) => e.friend.toLowerCase() == username);

    if (index != -1) {
      final old = _chatList[index];

      _chatList[index] = old.copyWith(isOnline: isOnline);

      notifyListeners();
    }
  }

  // =========================
  // HANDLE NEW MESSAGE
  // =========================
  void _handleIncomingMessage(Map<String, dynamic> data, String username) {
    final sender = (data["sender"] ?? "").toString();
    final receiver = (data["receiver"] ?? "").toString();
    final text = data["text"];
    final createdAt = DateTime.tryParse(data["createdAt"] ?? "");

    final myUsername = username.toLowerCase();

    final friend = sender.toLowerCase() == myUsername ? receiver : sender;

    final index = _chatList.indexWhere((element) => element.friend.toLowerCase() == friend.toLowerCase());

    print("🔥 FRIEND FROM SOCKET: $friend");
    print("🔥 FOUND INDEX: $index");

    if (index != -1) {
      final old = _chatList[index];

      final updated = old.copyWith(
        lastMessage: text,
        lastSender: sender,
        lastMessageTime: createdAt ?? DateTime.now(),
        unreadCount: old.unreadCount + 1,
      );

      _chatList.removeAt(index);
      _chatList.insert(0, updated);

      notifyListeners();
    }
  }

  void _handleOnlineUsers(Map<String, dynamic> data) {
    final List users = data["users"] ?? [];

    // reset dulu map online
    _onlineUsers.clear();

    for (var username in users) {
      _onlineUsers[username.toLowerCase()] = true;
    }

    // update chatList yang sudah ada
    _chatList = _chatList.map((chat) {
      return chat.copyWith(isOnline: _onlineUsers[chat.friend.toLowerCase()] ?? false);
    }).toList();

    notifyListeners();
  }

  Future<void> fetchChatList(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    dynamic res;

    try {
      res = await Network().getApi(Net.gateway, "chatList");
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body["data"] != null) {
        _chatList = (body["data"] as List)
            .map((e) => ChatListModel.fromJson(e))
            .map((chat) => chat.copyWith(isOnline: _onlineUsers[chat.friend.toLowerCase()]))
            .toList();
      } else {
        _chatList = [];
        ApiException("");
      }
    } catch (e) {
      print("chatList error: $e");
      NetMsgDialog.handleError(context, e, res);
    }

    isLoading = false;
    notifyListeners();
  }

  String formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays == 0) {
      return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
    } else if (diff.inDays == 1) {
      return "Yesterday";
    }
    return "${time.day}/${time.month}/${time.year}";
  }

  void logout(BuildContext context) async {
    // 1. Disconnect socket
    SocketService().leaveRoom();

    // 2. Hapus token
    await SecureStorage().deleteToken();
    Network().token = null;

    // 3. Bersihkan provider
    Provider.of<ChatProvider>(context, listen: false).clearRoom();

    // 4. Navigasi ke login
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  Future<void> getListAllUser(BuildContext context) async {
    isLoading = true;
    dynamic res;
    notifyListeners();
    try {
      res = await Network().getApi(Net.gateway, "users");
      var body = AllUserResponse.fromRawJson(res.body);
      if (res.statusCode == 200) {
        users = body.data ?? [];
        isLoading = false;
        notifyListeners();
      } else {
        throw ApiException(body.message);
      }
    } catch (e) {
      NetMsgDialog.handleError(context, e, res);
    }
    isLoading = false;
    notifyListeners();
  }
}
