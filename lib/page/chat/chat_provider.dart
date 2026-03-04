import 'dart:convert';

import 'package:chat_app/network/Net.dart';
import 'package:chat_app/network/network.dart';
import 'package:flutter/material.dart';
import 'package:fx_helper/network/fx_network.dart';
import 'package:fx_helper/widgets/net_msg_dialog.dart';

class ChatProvider extends ChangeNotifier {
  bool isLoading = false;
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
        isLoading = false;
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
    messages.add(msg);
    notifyListeners();
  }

  void clearRoom() {
    messages.clear();
  }
}
