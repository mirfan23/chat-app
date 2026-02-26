import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'socket_service.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  final String username;

  const ChatPage({super.key, required this.roomId, required this.username});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];

  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();

    // 🔥 JOIN ROOM (cukup sekali)
    SocketService().send({"type": "joinRoom", "roomId": widget.roomId});

    // 🔥 LISTEN MESSAGE
    subscription = SocketService().stream.listen((data) {
      final decoded = jsonDecode(data);

      print("📩 CHAT RECEIVED: $decoded");

      if (decoded["type"] == "newMessage" && decoded["roomId"] == widget.roomId) {
        setState(() {
          messages.add(decoded);
        });
      }
    });
  }

  @override
  void dispose() {
    subscription?.cancel(); // 🔥 WAJIB supaya tidak double
    controller.dispose();
    super.dispose();
  }

  void sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    SocketService().send({"type": "sendMessage", "roomId": widget.roomId, "sender": widget.username, "text": text});

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: Text("Room: ${widget.roomId}")),
        body: Column(
          children: [
            // 🔥 MESSAGE LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];

                  final isMe = msg["sender"] == widget.username;

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(msg["text"] ?? "", style: TextStyle(color: isMe ? Colors.white : Colors.black)),
                    ),
                  );
                },
              ),
            ),

            // 🔥 INPUT
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Type message...",
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: sendMessage),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
