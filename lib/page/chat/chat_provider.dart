import 'dart:convert';

import 'package:chat_app/network/Net.dart';
import 'package:chat_app/network/network.dart';
import 'package:chat_app/security/e2ee_services.dart';
import 'package:flutter/material.dart';
import 'package:fx_helper/network/fx_network.dart';
import 'package:fx_helper/widgets/net_msg_dialog.dart';

class ChatProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isTyping = false;

  List<Map<String, dynamic>> messages = [];

  Future<void> getMessages(BuildContext context, String roomId) async {
    isLoading = true;
    dynamic res;
    notifyListeners();

    try {
      res = await Network().getApi(Net.gateway, 'messages?roomId=$roomId');

      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        messages = List<Map<String, dynamic>>.from(body["data"]);

        for (var msg in messages) {
          try {
            msg["text"] = E2EEService.decryptMessage(msg["cipherText"], msg["iv"], msg["roomId"]);
          } catch (e) {
            msg["text"] = "[decrypt error]";
          }
        }

        notifyListeners();
      } else {
        throw ApiException(body['message']);
      }
    } catch (e) {
      NetMsgDialog.handleError(context, e, res);
    }

    isLoading = false;
    notifyListeners();
  }

  void addMessage(Map<String, dynamic> msg) {
    try {
      msg["text"] = E2EEService.decryptMessage(msg["cipherText"], msg["iv"], msg["roomId"]);
    } catch (e) {
      msg["text"] = "[decrypt error]";
    }

    // ✅ cek apakah message sudah ada
    bool exists = messages.any((m) => m["createdAt"] == msg["createdAt"] && m["sender"] == msg["sender"]);

    if (exists) {
      print("⚠️ Duplicate message ignored");
      return;
    }

    messages.add(msg);
    notifyListeners();
  }

  void clearRoom() {
    messages.clear();
  }

  Future<void> setReadMessage(BuildContext context, String roomId) async {
    dynamic res;
    try {
      res = await Network().getApi(Net.gateway, 'markRead?roomId=$roomId');
      print('mark as read ${res.body}');
    } catch (e) {
      NetMsgDialog.handleError(context, e, res);
    }
  }
}
