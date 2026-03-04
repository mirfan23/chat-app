import 'dart:async';
import 'dart:convert';

import 'package:chat_app/page/chat/chat_provider.dart';
import 'package:chat_app/page/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  final String username;

  const ChatPage({super.key, required this.roomId, required this.username});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController controller = TextEditingController();

  StreamSubscription? subscription;

  String? typingUser;
  Timer? typingTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 🔥 JOIN ROOM (akan auto rejoin kalau reconnect)
      SocketService().joinRoom(widget.roomId);

      subscription = SocketService().stream.listen((data) {
        final decoded = jsonDecode(data);

        if (decoded["type"] == "newMessage" && decoded["roomId"] == widget.roomId) {
          setState(() {
            Provider.of<ChatProvider>(context, listen: false).addMessage(decoded);
          });
        }

        if (decoded["type"] == "typing" && decoded["roomId"] == widget.roomId) {
          setState(() {
            typingUser = decoded["isTyping"] == true ? decoded["sender"] : null;
          });
        }
      });

      Provider.of<ChatProvider>(context, listen: false).getMessages(context, widget.roomId);
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    SocketService().leaveRoom(); // 🔥 penting
    controller.dispose();
    super.dispose();
  }

  void sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    SocketService().send({"type": "sendMessage", "roomId": widget.roomId, "sender": widget.username, "text": text});

    controller.clear();
  }

  void sendTyping(bool isTyping) {
    SocketService().send({"type": "typing", "roomId": widget.roomId, "sender": widget.username, "isTyping": isTyping});
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
              child: Consumer<ChatProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      final msg = provider.messages[index];
                      final isMe = msg["sender"] == widget.username;

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(msg["text"] ?? "", style: TextStyle(color: isMe ? Colors.white : Colors.black)),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            if (typingUser != null && typingUser != widget.username)
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 4),
                child: Text(
                  "$typingUser sedang mengetik...",
                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: (value) {
                      sendTyping(true);

                      typingTimer?.cancel();
                      typingTimer = Timer(const Duration(seconds: 1), () {
                        sendTyping(false);
                      });
                    },
                    decoration: const InputDecoration(hintText: "Type message..."),
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
