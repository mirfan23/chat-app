// import 'dart:convert';

// import 'package:chat_app/models/chat_list_model.dart';
// import 'package:chat_app/page/socket_service.dart';
// import 'package:flutter/material.dart';

// class ChatListProvider extends ChangeNotifier {
//   bool isLoading = false;

//   bool _initialized = false;
//   final SocketService _socket = SocketService();

//   List<ChatListModel> _chatList = [];
//   List<ChatListModel> get chatList => _chatList;

//   final Map<String, bool> _onlineUsers = {};

//   // =========================
//   // INIT SOCKET LISTENER
//   // =========================
//   void initSocketListener(String userId) {
//     if (_initialized) return;

//     _socket.stream.listen((event) {
//       final data = jsonDecode(event);

//       switch (data["type"]) {
//         case "user_status":
//           _handleUserStatus(data);
//           break;
//         case "online_users":
//           _handleOnlineUsers(data);
//           break;

//         case "newMessage":
//           _handleIncomingMessage(data, userId);
//           break;

//         case "chatList":
//           _handleChatList(data);
//           break;

//         case "messagesRead":
//           _handleMessagesRead(data, userId);
//           break;
//       }
//     });

//     _initialized = true;
//   }

//   // =========================
//   // HANDLE MESSAGES READ
//   // =========================
//   void _handleMessagesRead(Map<String, dynamic> data, String myUsername) {
//     final roomId = data["roomId"];
//     final reader = data["reader"];

//     final index = _chatList.indexWhere((e) => e.roomId == roomId);

//     if (index == -1) return;

//     final old = _chatList[index];

//     // kalau pesan terakhir dikirim oleh kita
//     if (old.lastSender == myUsername) {
//       _chatList[index] = old.copyWith(isRead: true);
//       notifyListeners();
//     }
//   }

//   // =========================
//   // SET INITIAL CHAT LIST
//   // (dipanggil setelah fetch dari API)
//   // =========================
//   void setChatList(List<ChatListModel> list) {
//     _chatList = list;
//     notifyListeners();
//   }

//   // =========================
//   // HANDLE ONLINE STATUS
//   // =========================
//   void _handleUserStatus(Map<String, dynamic> data) {
//     final username = (data["username"] ?? "").toString().toLowerCase();
//     final raw = data["isOnline"];
//     final isOnline = raw == true || raw == "true";

//     _onlineUsers[username] = isOnline;

//     final index = _chatList.indexWhere((e) => e.friend.toLowerCase() == username);

//     if (index != -1) {
//       final old = _chatList[index];

//       _chatList[index] = old.copyWith(isOnline: isOnline);

//       notifyListeners();
//     }
//   }

//   // =========================
//   // HANDLE CHAT LIST
//   // =========================
//   void _handleChatList(Map<String, dynamic> data) {
//     final List list = data["data"] ?? [];

//     print("🔥 CHAT LIST FROM SOCKET: ${list.length}");

//     _chatList = list.map((e) {
//       final chat = ChatListModel.fromJson(e);

//       // simpan ke map
//       _onlineUsers[chat.friend.toLowerCase()] = chat.isOnline;

//       return chat;
//     }).toList();

//     notifyListeners();
//   }

//   // =========================
//   // HANDLE NEW MESSAGE
//   // =========================
//   void _handleIncomingMessage(Map<String, dynamic> data, String username) {
//     final sender = (data["sender"] ?? "").toString();
//     final receiver = (data["receiver"] ?? "").toString();
//     final text = data["text"];
//     final createdAt = DateTime.tryParse(data["createdAt"] ?? "");

//     final myUsername = username.toLowerCase();

//     final friend = sender.toLowerCase() == myUsername ? receiver : sender;

//     final index = _chatList.indexWhere((element) => element.friend.toLowerCase() == friend.toLowerCase());

//     print("🔥 FRIEND FROM SOCKET: $friend");
//     print("🔥 FOUND INDEX: $index");

//     if (index != -1) {
//       final old = _chatList[index];

//       final updated = old.copyWith(
//         lastMessage: text,
//         lastSender: sender,
//         lastMessageTime: createdAt ?? DateTime.now(),
//         unreadCount: old.unreadCount + 1,
//       );

//       _chatList.removeAt(index);
//       _chatList.insert(0, updated);

//       notifyListeners();
//     }
//   }

//   void _handleOnlineUsers(Map<String, dynamic> data) {
//     final List users = data["users"] ?? [];

//     // reset dulu map online
//     _onlineUsers.clear();

//     for (var username in users) {
//       _onlineUsers[username.toLowerCase()] = true;
//     }

//     // update chatList yang sudah ada
//     _chatList = _chatList.map((chat) {
//       return chat.copyWith(isOnline: _onlineUsers[chat.friend.toLowerCase()] ?? false);
//     }).toList();

//     notifyListeners();
//   }
// }

import 'dart:convert';
import 'package:chat_app/models/chat_list_model.dart';
import 'package:chat_app/page/socket_service.dart';
import 'package:flutter/material.dart';

class ChatListProvider extends ChangeNotifier {
  final SocketService _socket = SocketService();

  bool _initialized = false;

  List<ChatListModel> _chatList = [];
  List<ChatListModel> get chatList => _chatList;

  final Map<String, bool> _onlineUsers = {};

  String _myUsername = "";
  String _myUserId = "";

  // =========================
  // INIT SOCKET
  // =========================
  void initSocketListener(String userId) {
    if (_initialized) return;

    // _myUsername = username.toLowerCase();
    _myUserId = userId;

    _socket.stream.listen((event) {
      final data = jsonDecode(event);

      switch (data["type"]) {
        case "chatList":
          _handleChatList(data);
          break;

        case "newMessage":
          _handleNewMessage(data);
          break;

        case "messagesRead":
          _handleMessagesRead(data);
          break;

        case "user_status":
          _handleUserStatus(data);
          break;

        case "online_users":
          _handleOnlineUsers(data);
          break;
      }
    });

    _initialized = true;
  }

  // =========================
  // CHAT LIST FROM SERVER
  // =========================
  void _handleChatList(Map<String, dynamic> data) {
    final List list = data["data"] ?? [];

    _chatList = list.map((e) {
      final chat = ChatListModel.fromJson(e);

      _onlineUsers[chat.friend.toLowerCase()] = chat.isOnline;

      return chat;
    }).toList();

    notifyListeners();
  }

  // =========================
  // NEW MESSAGE
  // =========================
  void _handleNewMessage(Map<String, dynamic> data) {
    final sender = (data["sender"] ?? "").toString();
    final receiver = (data["receiver"] ?? "").toString();
    final text = data["text"] ?? "";
    final createdAt = DateTime.tryParse(data["createdAt"] ?? "");

    final senderLower = sender.toLowerCase();
    final receiverLower = receiver.toLowerCase();

    final friend = senderLower == _myUsername ? receiverLower : senderLower;

    final index = _chatList.indexWhere((e) => e.friend.toLowerCase() == friend);

    final isFromMe = senderLower == _myUsername;

    if (index != -1) {
      final old = _chatList[index];

      final updated = old.copyWith(
        lastMessage: text,
        lastSender: sender,
        lastMessageTime: createdAt ?? DateTime.now(),
        unreadCount: isFromMe ? old.unreadCount : old.unreadCount + 1,
      );

      _chatList.removeAt(index);
      _chatList.insert(0, updated);
    }

    notifyListeners();
  }

  // =========================
  // MESSAGE READ
  // =========================
  // void _handleMessagesRead(Map<String, dynamic> data) {
  //   final roomId = data["roomId"];

  //   final index = _chatList.indexWhere((element) => element.roomId == roomId);

  //   if (index == -1) return;

  //   final old = _chatList[index];

  //   _chatList[index] = old.copyWith(unreadCount: 0, isRead: true);

  //   notifyListeners();
  // }

  void _handleMessagesRead(Map<String, dynamic> data) {
    final roomId = data["roomId"];
    final reader = data["reader"];

    final index = _chatList.indexWhere((e) => e.roomId == roomId);

    if (index == -1) return;

    final old = _chatList[index];

    // pesan terakhir dari kita
    if (old.lastSender == _myUserId && reader == old.friend) {
      _chatList[index] = old.copyWith(isRead: true);
      notifyListeners();
    }
  }

  // =========================
  // SINGLE USER STATUS
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
  // ONLINE USERS LIST
  // =========================
  void _handleOnlineUsers(Map<String, dynamic> data) {
    final List users = data["users"] ?? [];

    _onlineUsers.clear();

    for (var user in users) {
      _onlineUsers[user.toLowerCase()] = true;
    }

    _chatList = _chatList.map((chat) {
      return chat.copyWith(isOnline: _onlineUsers[chat.friend.toLowerCase()] ?? false);
    }).toList();

    notifyListeners();
  }

  // =========================
  // OPTIONAL REFRESH
  // =========================
  void refreshChatList() {
    _socket.getChatList();
  }
}
