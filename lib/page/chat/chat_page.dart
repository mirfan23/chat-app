import 'dart:async';

import 'package:chat_app/page/chat/chat_notifier.dart';
import 'package:chat_app/page/chat/widget/chat_bubble.dart';
import 'package:chat_app/page/chat/widget/typing_indicator.dart';
import 'package:chat_app/page/chat/widget/utils.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ChatPage extends ConsumerStatefulWidget {
//   final String roomId;
//   final String id;
//   final String friend;
//   final String friendName;

//   const ChatPage({super.key, required this.roomId, required this.id, required this.friend, required this.friendName});

//   @override
//   ConsumerState<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends ConsumerState<ChatPage> {
//   final TextEditingController controller = TextEditingController();
//   final ScrollController scrollController = ScrollController();

//   Timer? typingTimer;
//   bool showScrollButton = false;

//   @override
//   void initState() {
//     super.initState();

//     /// 🔥 INIT CHAT
//     Future.microtask(() {
//       final notifier = ref.read(chatProvider.notifier);

//       notifier.init(roomId: widget.roomId, myId: widget.id);

//       notifier.getMessages(widget.roomId);
//       notifier.sendRead();
//     });

//     scrollController.addListener(_handleScroll);
//   }

//   void _handleScroll() {
//     if (!scrollController.hasClients) return;

//     final max = scrollController.position.maxScrollExtent;
//     final current = scrollController.position.pixels;

//     final atBottom = (max - current) < 80;

//     if (atBottom && showScrollButton) {
//       setState(() => showScrollButton = false);

//       ref.read(chatProvider.notifier).sendRead();
//     }

//     if (!atBottom && !showScrollButton) {
//       setState(() => showScrollButton = true);
//     }
//   }

//   void scrollToBottom({bool animated = true}) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!scrollController.hasClients) return;

//       final position = scrollController.position.maxScrollExtent;

//       if (animated) {
//         scrollController.animateTo(position, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
//       } else {
//         scrollController.jumpTo(position);
//       }
//     });
//   }

//   bool isAtBottom() {
//     if (!scrollController.hasClients) return true;

//     final max = scrollController.position.maxScrollExtent;
//     final current = scrollController.position.pixels;

//     return (max - current) < 50;
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     scrollController.dispose();
//     typingTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(chatProvider);
//     final notifier = ref.read(chatProvider.notifier);

//     return Scaffold(
//       backgroundColor: whiteColor,
//       appBar: AppBar(title: Text(widget.friendName)),
//       bottomNavigationBar: Container(),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 /// 🔥 MESSAGE LIST (UI LAMA DIPERTAHANKAN)
//                 Expanded(
//                   child: ListView.builder(
//                     controller: scrollController,
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//                     itemCount: state.messages.length + (state.typingUser != null ? 1 : 0),
//                     itemBuilder: (context, index) {
//                       /// 🔥 TYPING INDICATOR
//                       if (index == state.messages.length) {
//                         return typingBubble();
//                       }

//                       final msg = state.messages[index];
//                       final prev = index > 0 ? state.messages[index - 1] : null;

//                       final isMe = msg["sender"] == widget.id;

//                       final showDate = isNewDate(msg["createdAt"], prev?["createdAt"]);

//                       final grouped = isSameSender(msg, prev);
//                       return Column(
//                         children: [
//                           if (showDate)
//                             Column(
//                               children: [
//                                 const SizedBox(height: 10),
//                                 DateSeparator(text: formatDateSeparator(msg["createdAt"])),
//                                 const SizedBox(height: 10),
//                               ],
//                             ),

//                           ChatBubble(msg: msg, isMe: isMe, grouped: grouped),
//                         ],
//                       );
//                     },
//                   ),
//                 ),

//                 /// 🔥 INPUT (UI LAMA)
//                 AnimatedPadding(
//                   duration: const Duration(milliseconds: 200),
//                   padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: controller,
//                           onChanged: (_) {
//                             notifier.sendTyping(true);

//                             typingTimer?.cancel();
//                             typingTimer = Timer(const Duration(seconds: 1), () => notifier.sendTyping(false));
//                           },
//                           decoration: const InputDecoration(
//                             hintText: "Type message...",
//                             border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Container(
//                         decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(50)),
//                         child: IconButton(
//                           icon: const Icon(Icons.send, color: Colors.white),
//                           onPressed: () {
//                             notifier.sendMessage(text: controller.text, friend: widget.friend);
//                             controller.clear();

//                             scrollToBottom();
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             /// 🔥 SCROLL BUTTON (TETAP)
//             if (showScrollButton)
//               Positioned(
//                 bottom: 100,
//                 right: 20,
//                 child: FloatingActionButton(
//                   mini: true,
//                   backgroundColor: Colors.blue,
//                   onPressed: scrollToBottom,
//                   child: const Icon(Icons.arrow_downward, color: Colors.white),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget typingBubble() {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Container(
//         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
//         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(18)),
//         child: const TypingIndicator(),
//       ),
//     );
//   }
// }

class ChatPage extends ConsumerStatefulWidget {
  final String roomId;
  final String id;
  final String friend;
  final String friendName;

  const ChatPage({super.key, required this.roomId, required this.id, required this.friend, required this.friendName});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> with WidgetsBindingObserver {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  Timer? typingTimer;
  bool showScrollButton = false;

  bool _isUserAtBottom = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    Future.microtask(() {
      final notifier = ref.read(chatProvider.notifier);

      notifier.init(roomId: widget.roomId, myId: widget.id);

      notifier.getMessages(widget.roomId);
      notifier.sendRead();
    });

    scrollController.addListener(_onScroll);
  }

  @override
  void didChangeMetrics() {
    final view = View.of(context);
    final keyboardVisible = view.viewInsets.bottom > 0;

    if (keyboardVisible && _isUserAtBottom) {
      Future.delayed(const Duration(milliseconds: 120), () {
        _scrollToBottom(animated: true);
      });
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final max = scrollController.position.maxScrollExtent;
    final current = scrollController.position.pixels;

    final atBottom = (max - current) < 100;

    _isUserAtBottom = atBottom;

    if (atBottom && showScrollButton) {
      setState(() => showScrollButton = false);
      ref.read(chatProvider.notifier).sendRead();
    }

    if (!atBottom && !showScrollButton) {
      setState(() => showScrollButton = true);
    }
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      final pos = scrollController.position.maxScrollExtent;

      if (animated) {
        scrollController.animateTo(pos, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      } else {
        scrollController.jumpTo(pos);
      }
    });
  }

  void _handleNewMessageAutoScroll() {
    if (_isUserAtBottom) {
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    scrollController.dispose();
    typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final state = ref.watch(chatProvider);
    final notifier = ref.read(chatProvider.notifier);

    ref.listen(chatProvider, (prev, next) {
      if (prev?.messages.length != next.messages.length) {
        _handleNewMessageAutoScroll();
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: whiteColor,

      /// ❗ IMPORTANT: jangan pakai bottomNavigationBar kosong
      /// ini sering bikin layout weird di shell route
      appBar: AppBar(title: Text(widget.friendName)),

      body: SafeArea(
        child: Column(
          children: [
            /// =========================
            /// MESSAGE LIST
            /// =========================
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(vertical: 10),
                // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: state.messages.length + (state.typingUser != null ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.messages.length) {
                    return _typingBubble();
                  }

                  final msg = state.messages[index];
                  final prev = index > 0 ? state.messages[index - 1] : null;

                  final isMe = msg["sender"] == widget.id;

                  final showDate = isNewDate(msg["createdAt"], prev?["createdAt"]);

                  final grouped = isSameSender(msg, prev);

                  return Column(
                    children: [
                      if (showDate) ...[
                        const SizedBox(height: 10),
                        DateSeparator(text: formatDateSeparator(msg["createdAt"])),
                        const SizedBox(height: 10),
                      ],
                      ChatBubble(msg: msg, isMe: isMe, grouped: grouped),
                    ],
                  );
                },
              ),
            ),

            /// =========================
            /// INPUT (KEYBOARD SAFE + PINNED)
            /// =========================
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(left: 12, right: 12, bottom: 10, top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        onTap: () => _scrollToBottom(),
                        onChanged: (_) {
                          notifier.sendTyping(true);

                          typingTimer?.cancel();
                          typingTimer = Timer(const Duration(seconds: 1), () => notifier.sendTyping(false));
                        },
                        decoration: const InputDecoration(
                          hintText: "Type message...",
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    /// SEND BUTTON
                    Container(
                      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(50)),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          final text = controller.text.trim();
                          if (text.isEmpty) return;

                          notifier.sendMessage(text: text, friend: widget.friend);

                          controller.clear();

                          _scrollToBottom();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /// =========================
      /// SCROLL BUTTON
      /// =========================
      // floatingActionButton: showScrollButton
      //     ? FloatingActionButton(
      //         mini: true,
      //         backgroundColor: Colors.blue,
      //         onPressed: _scrollToBottom,
      //         child: const Icon(Icons.arrow_downward, color: Colors.white),
      //       )
      //     : null,
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Widget _typingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(18)),
        child: const TypingIndicator(),
      ),
    );
  }
}
