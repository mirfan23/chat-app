import 'dart:convert';

import 'package:chat_app/models/chat_list_model.dart';
import 'package:chat_app/network/Net.dart';
import 'package:chat_app/network/network.dart';
import 'package:flutter/material.dart';
import 'package:fx_helper/network/fx_network.dart';
import 'package:fx_helper/widgets/net_msg_dialog.dart';

class ChatListProvider extends ChangeNotifier {
  bool isLoading = false;
  List<dynamic> users = [];
  List<ChatListModel> chats = [];

  Future<void> fetchChatList(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    dynamic res;

    try {
      res = await Network().getApi(Net.gateway, "chatList");
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body["data"] != null) {
        chats = (body["data"] as List).map((e) => ChatListModel.fromJson(e)).toList();
      } else {
        chats = [];
        ApiException("");
      }
    } catch (e) {
      print("chatList error: $e");
      NetMsgDialog.handleError(context, e, res);
    }

    isLoading = false;
    notifyListeners();
  }

  String formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays == 0) {
      return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
    } else if (diff.inDays == 1) {
      return "Yesterday";
    }
    return "${time.day}/${time.month}/${time.year}";
  }
}
