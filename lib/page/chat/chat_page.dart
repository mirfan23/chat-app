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
  final String id;
  final String friend;
  final String friendName;

  const ChatPage({super.key, required this.roomId, required this.id, required this.friend, required this.friendName});

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
    final provider = Provider.of<ChatProvider>(context, listen: false);

    /// 🔥 LISTEN TO SCROLL
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;

      final max = _scrollController.position.maxScrollExtent;
      final current = _scrollController.position.pixels;

      final atBottom = (max - current) < 80;

      if (atBottom && showScrollButton) {
        setState(() => showScrollButton = false);

        provider.setReadMessage(context, widget.roomId);
        provider.markMessagesRead(widget.roomId);
        sendReadMessage();
      }

      if (!atBottom && !showScrollButton) {
        setState(() => showScrollButton = true);
      }
    });

    /// 🔥 INIT SOCKET
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// 🔥 JOIN ROOM (akan auto rejoin kalau reconnect)
      SocketService().joinRoom(widget.roomId);

      /// 🔥 LISTEN TO SOCKET
      subscription = SocketService().stream.listen((data) {
        print("📥 RAW SOCKET: $data");
        final decoded = jsonDecode(data);
        if (decoded["type"] == "typing") {
          print("⌨️ TYPING EVENT: $decoded");
        }

        /// 🔥 NEW MESSAGE
        if (decoded["type"] == "newMessage" && decoded["roomId"] == widget.roomId) {
          final atBottom = isAtBottom();

          setState(() {
            Provider.of<ChatProvider>(context, listen: false).addMessage(decoded);
          });

          if (atBottom) {
            scrollToBottom();
            // 🔥 mark read langsung jika user melihat pesan

            provider.setReadMessage(context, widget.roomId);
            provider.markMessagesRead(widget.roomId);
          } else {
            setState(() => showScrollButton = true);
          }
        }

        /// 🔥 TYPING
        if (decoded["type"] == "typing" && decoded["roomId"] == widget.roomId) {
          if (decoded["sender"] != widget.id) {
            final isTyping = decoded["isTyping"] ?? false;

            setState(() {
              typingUser = isTyping ? decoded["sender"] : null;
            });

            if (isTyping && isAtBottom()) {
              scrollToBottom();
            }
          }
        }

        /// 🔥 MESSAGE READ
        if (decoded["type"] == "messageRead" && decoded["roomId"] == widget.roomId) {
          final reader = decoded["reader"];

          if (reader != widget.id) {
            Provider.of<ChatProvider>(context, listen: false).markMessagesRead(widget.roomId);
          }
        }
      });

      /// 🔥 GET MESSAGES
      provider.getMessages(context, widget.roomId);
      provider.setReadMessage(context, widget.roomId);

      /// 🔥 MARK AS READ
      sendReadMessage();

      /// 🔥 SEND TYPING
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
      "sender": widget.id,
      "receiver": widget.friend,
      "cipherText": encrypted["cipherText"],
      "encryptedKey": encrypted["encryptedKey"],
      "iv": encrypted["iv"],
      "preview": text,
    });

    controller.clear();
  }

  void sendTyping(bool value) {
    final data = {"type": "typing", "roomId": widget.roomId, "sender": widget.id, "isTyping": value};

    print("📤 SEND TYPING: $data");

    SocketService().send(data);
  }

  void sendReadMessage() {
    SocketService().send({"type": "readMessage", "roomId": widget.roomId});
  }

  void scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 80), () {
        if (!_scrollController.hasClients) return;

        final position = _scrollController.position.maxScrollExtent;

        if (animated) {
          _scrollController.animateTo(position, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
        } else {
          _scrollController.jumpTo(position);
        }
      });
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
        appBar: AppBar(title: Text(widget.friendName)),
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
                            final isMe = msg["sender"] == widget.id;

                            print("🔥 ISME  : $isMe");
                            print("🔥 ISME  : sender => ${msg["sender"]}, me => ${widget.id}");
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
                  bottom: 100,
                  right: 20,
                  child: FloatingActionButton(
                    mini: true,
                    shape: const CircleBorder(),
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      scrollToBottom();
                    },
                    child: const Icon(Icons.arrow_downward, color: Colors.white),
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
