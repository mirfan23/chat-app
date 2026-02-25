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

  @override
  void initState() {
    super.initState();

    SocketService().socket.on("userList", (data) {
      setState(() {
        users = data.where((u) => u != widget.username).toList();
      });
    });
  }

  String getRoomId(String a, String b) {
    final sorted = [a, b]..sort();
    return "${sorted[0]}_${sorted[1]}";
  }

  @override
  void dispose() {
    SocketService().socket.off("userList");
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
