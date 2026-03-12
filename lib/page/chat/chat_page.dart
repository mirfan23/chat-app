import 'dart:async';
import 'dart:convert';

import 'package:chat_app/page/chat/chat_provider.dart';
import 'package:chat_app/page/chat/widget/chat_bubble.dart';
import 'package:chat_app/page/chat/widget/typing_indicator.dart';
import 'package:chat_app/page/chat/widget/utils.dart';
import 'package:chat_app/page/socket_service.dart';
import 'package:chat_app/security/e2ee_services.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  final String username;
  final String friend;

  const ChatPage({super.key, required this.roomId, required this.username, required this.friend});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  StreamSubscription? subscription;

  String? typingUser;
  Timer? typingTimer;
  bool showScrollButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;

      final max = _scrollController.position.maxScrollExtent;
      final current = _scrollController.position.pixels;

      final atBottom = (max - current) < 80;

      if (atBottom && showScrollButton) {
        setState(() => showScrollButton = false);
      }

      if (!atBottom && !showScrollButton) {
        setState(() => showScrollButton = true);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 🔥 JOIN ROOM (akan auto rejoin kalau reconnect)
      SocketService().joinRoom(widget.roomId);

      subscription = SocketService().stream.listen((data) {
        print("📥 RAW SOCKET: $data");
        final decoded = jsonDecode(data);
        if (decoded["type"] == "typing") {
          print("⌨️ TYPING EVENT: $decoded");
        }

        if (decoded["type"] == "newMessage" && decoded["roomId"] == widget.roomId) {
          final atBottom = isAtBottom();

          setState(() {
            Provider.of<ChatProvider>(context, listen: false).addMessage(decoded);
          });

          if (atBottom) {
            scrollToBottom();
          } else {
            setState(() => showScrollButton = true);
          }
        }

        if (decoded["type"] == "typing" && decoded["roomId"] == widget.roomId) {
          if (decoded["sender"] != widget.username) {
            final isTyping = decoded["isTyping"] ?? false;

            setState(() {
              typingUser = isTyping ? decoded["sender"] : null;
            });

            if (isTyping) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                scrollToBottom();
              });
            }
          }
        }
      });

      Provider.of<ChatProvider>(context, listen: false).getMessages(context, widget.roomId);
      Provider.of<ChatProvider>(context, listen: false).setReadMessage(context, widget.roomId);
      scrollToBottom(animated: false);
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    SocketService().leaveRoom();
    controller.dispose();
    _scrollController.dispose(); // 🔥 jangan lupa dispose
    super.dispose();
  }

  void sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    final encrypted = E2EEService.encryptMessage(text, widget.roomId);

    SocketService().send({
      "type": "sendMessage",
      "roomId": widget.roomId,
      "sender": widget.username,
      "receiver": widget.friend,
      "cipherText": encrypted["cipherText"],
      "encryptedKey": encrypted["encryptedKey"],
      "iv": encrypted["iv"],
      "preview": text,
    });

    controller.clear();
  }

  void sendTyping(bool value) {
    final data = {"type": "typing", "roomId": widget.roomId, "sender": widget.username, "isTyping": value};

    print("📤 SEND TYPING: $data");

    SocketService().send(data);
  }

  void scrollToBottom({bool animated = true}) {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!_scrollController.hasClients) return;

      final position = _scrollController.position.maxScrollExtent;

      if (animated) {
        _scrollController.animateTo(position, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      } else {
        _scrollController.jumpTo(position);
      }
    });
  }

  bool isAtBottom() {
    if (!_scrollController.hasClients) return true;

    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;

    return (max - current) < 50;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: whiteColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text(widget.friend)),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Consumer<ChatProvider>(
                      builder: (context, provider, child) {
                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: provider.messages.length + (typingUser != null ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == provider.messages.length) {
                              return typingBubble();
                            }

                            final msg = provider.messages[index];
                            final prev = index > 0 ? provider.messages[index - 1] : null;
                            final isMe = msg["sender"] == widget.username;
                            final showDate = isNewDate(msg["createdAt"], prev?["createdAt"]);
                            final grouped = isSameSender(msg, prev);

                            return Column(
                              children: [
                                if (showDate)
                                  Column(
                                    children: [
                                      SizedBox(height: 10),
                                      DateSeparator(text: formatDateSeparator(msg["createdAt"])),
                                      SizedBox(height: 10),
                                    ],
                                  ),

                                ChatBubble(msg: msg, isMe: isMe, grouped: grouped),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Consumer<ChatProvider>(
                            builder: (context, provider, _) {
                              return TextField(
                                controller: controller,
                                onChanged: (value) {
                                  if (!provider.isTyping) {
                                    sendTyping(true);
                                    provider.isTyping = true;
                                  }

                                  typingTimer?.cancel();

                                  typingTimer = Timer(const Duration(seconds: 1), () {
                                    sendTyping(false);
                                    provider.isTyping = false;
                                  });
                                },
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                decoration: const InputDecoration(
                                  hintText: "Type message...",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(50)),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: sendMessage,
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Icon(Icons.send, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (showScrollButton)
                Positioned(
                  bottom: 1000,
                  right: 20,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      scrollToBottom();
                    },
                    child: const Icon(Icons.arrow_downward),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget typingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(18)),
        child: const TypingIndicator(),
      ),
    );
  }
}
