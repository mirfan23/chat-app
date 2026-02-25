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
  List messages = [];
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final socket = SocketService().socket;

    socket.off("newMessage");
    socket.off("roomMessages");

    socket.emit("joinRoom", widget.roomId);

    socket.on("roomMessages", (data) {
      setState(() {
        messages = data;
      });
    });

    socket.on("newMessage", (data) {
      setState(() {
        messages.add(data);
      });
    });
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    SocketService().socket.emit("sendMessage", {"roomId": widget.roomId, "sender": widget.username, "text": text});

    messageController.clear();
  }

  @override
  void dispose() {
    SocketService().socket.off("newMessage");
    SocketService().socket.off("roomMessages");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.roomId)),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (_, index) {
                  final msg = messages[index];
                  final isMe = msg["sender"] == widget.username;

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(10),
                      color: isMe ? Colors.green[300] : Colors.grey[300],
                      child: Text(msg["text"]),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(child: TextField(controller: messageController)),
                IconButton(icon: const Icon(Icons.send), onPressed: sendMessage),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
