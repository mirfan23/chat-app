import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/page/list_user/chat_list_provider.dart';
import '../chat/chat_page.dart';

class ChatListPage extends StatefulWidget {
  final String username;

  const ChatListPage({super.key, required this.username});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();

    // Auto fetch saat pertama kali masuk
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  Future<void> getData() async {
    await Provider.of<ChatListProvider>(context, listen: false).fetchChatList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: RefreshIndicator(
        onRefresh: getData,
        child: Consumer<ChatListProvider>(
          builder: (context, provider, _) {
            // 🔵 Loading state
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // 🔵 Empty state
            if (provider.chats.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text("No chats yet", style: TextStyle(fontSize: 16))),
                ],
              );
            }

            // 🔵 Normal state
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.chats.length,
              itemBuilder: (_, index) {
                final chat = provider.chats[index];

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                  title: Text(chat.friend, style: const TextStyle(fontWeight: FontWeight.bold)),

                  subtitle: Row(
                    children: [
                      if (chat.lastSender == widget.username)
                        Icon(
                          chat.isRead ? Icons.done_all : Icons.done,
                          size: 18,
                          color: chat.isRead ? Colors.blue : Colors.grey,
                        ),

                      if (chat.lastSender == widget.username) const SizedBox(width: 4),

                      Expanded(child: Text(chat.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),

                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(provider.formatTime(chat.lastMessageTime), style: const TextStyle(fontSize: 12)),

                      if (chat.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(roomId: chat.roomId, username: widget.username),
                      ),
                    ).then((_) => getData());
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
