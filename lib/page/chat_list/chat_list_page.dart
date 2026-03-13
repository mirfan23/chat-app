import 'dart:async';
import 'package:chat_app/page/profile/profile_provider.dart';
import 'package:chat_app/page/socket_service.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/util/formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/page/chat_list/chat_list_provider.dart';
import '../chat/chat_page.dart';
import 'package:fx_helper/image_initials.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = context.read<ChatListProvider>();
      final profileProvider = context.read<ProfileProvider>();

      final username = profileProvider.profile?.username ?? '';

      chatProvider.initSocketListener(username);

      SocketService().getChatList();
    });
  }

  Future<void> getData() async {
    context.read<ChatListProvider>().refreshChatList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var profielProvider = context.watch<ProfileProvider>();
    // var username = profielProvider.profile?.username ?? '';
    var id = profielProvider.profile?.id ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text("Chats"), automaticallyImplyLeading: false),
      body: RefreshIndicator(
        onRefresh: getData,
        child: Consumer<ChatListProvider>(
          builder: (context, provider, _) {
            // 🔵 Loading state
            // if (provider.isLoading) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            // 🔵 Empty state
            if (provider.chatList.isEmpty) {
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
              itemCount: provider.chatList.length,
              itemBuilder: (_, index) {
                final chat = provider.chatList[index];
                return ListTile(
                  leading: Stack(
                    children: [
                      ImageInitials(text: chat.friendName, style: textStyleHuge(context)),

                      // ONLINE DOT
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: chat.isOnline ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.friendName,
                          style: TextStyle(fontWeight: chat.unreadCount > 0 ? FontWeight.bold : FontWeight.w500),
                        ),
                      ),

                      if (chat.isOnline)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text("online", style: TextStyle(fontSize: 10, color: Colors.green)),
                        ),
                    ],
                  ),

                  subtitle: Row(
                    children: [
                      if (chat.lastSender == id)
                        Icon(
                          chat.isRead ? Icons.done_all : Icons.done,
                          size: 18,
                          color: chat.isRead ? Colors.blue : Colors.grey,
                        ),

                      if (chat.lastSender == id) const SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                            color: chat.unreadCount > 0 ? Colors.black : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(Formatter().formatTime(chat.lastMessageTime), style: const TextStyle(fontSize: 12)),

                      if (chat.unreadCount > 0)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),

                  onTap: () {
                    print("🔥 DEBUG Chat List Tap : $id");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ChatPage(roomId: chat.roomId, id: id, friend: chat.friend, friendName: chat.friendName),
                      ),
                    ).then((_) => SocketService().getChatList());
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
