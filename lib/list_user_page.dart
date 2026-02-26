import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'socket_service.dart';
import 'chat_page.dart';

class UserListPage extends StatefulWidget {
  final String username;
  const UserListPage({super.key, required this.username});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List users = [];
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    // 🔥 minta ulang user list
    SocketService().send({"type": "login", "sender": widget.username});

    print("📤 USERLIST PAGE SENT 1: ${{"type": "login", "sender": widget.username}}");

    subscription = SocketService().stream.listen((data) {
      final decoded = jsonDecode(data);

      print("📩 USERLIST PAGE RECEIVED: $decoded");

      if (decoded["type"] == "userList") {
        setState(() {
          users = List<String>.from(decoded["users"]).where((u) => u != widget.username).toList();
        });
      }
    });
  }

  String getRoomId(String a, String b) {
    final sorted = [a, b]..sort();
    return "${sorted[0]}_${sorted[1]}";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Online Users")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (_, index) {
          final friend = users[index];
          return ListTile(
            title: Text(friend),
            onTap: () {
              final roomId = getRoomId(widget.username, friend);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(roomId: roomId, username: widget.username),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
