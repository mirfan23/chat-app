import 'package:chat_app/features/chat/widgets/utils.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final Map<String, dynamic> msg;
  final bool isMe;
  final bool grouped;

  const ChatBubble({super.key, required this.msg, required this.isMe, required this.grouped});

  @override
  Widget build(BuildContext context) {
    final time = formatTime(msg["createdAt"]);

    final bubble = Container(
      margin: EdgeInsets.only(top: grouped ? 2 : 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(color: isMe ? Colors.blue : Colors.grey[300], borderRadius: BorderRadius.circular(14)),
      child: Text(msg["text"] ?? "", style: TextStyle(color: isMe ? Colors.white : Colors.black)),
    );

    final info = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isMe)
          Text(msg["isRead"] == true ? "Read" : "Sent", style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: isMe ? [info, SizedBox(width: 10), bubble] : [bubble, SizedBox(width: 10), info],
      ),
    );
  }
}

class DateSeparator extends StatelessWidget {
  final String text;

  const DateSeparator({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
          child: Text(text, style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}

bool isSameSender(Map current, Map? previous) {
  if (previous == null) return false;
  return current["sender"] == previous["sender"];
}
