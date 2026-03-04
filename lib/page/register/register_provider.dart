import 'dart:convert';

import 'package:chat_app/network/Net.dart';
import 'package:chat_app/network/network.dart';
import 'package:flutter/material.dart';
import 'package:fx_helper/network/fx_network.dart';
import 'package:fx_helper/widgets/net_msg_dialog.dart';
import 'package:fx_helper/secure_storage.dart';

class RegisterProvider extends ChangeNotifier {
  bool isLoading = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<bool> register(BuildContext context) async {
    isLoading = true;
    dynamic res;
    notifyListeners();
    try {
      Map<String, String> postData = {"username": usernameController.text, "password": passwordController.text};
      res = await Network().postApi(Net.gateway, 'register', postData);
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        final token = body['token'];
        await SecureStorage().setToken(token);
        Network().token = token;
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw ApiException(body['message']);
      }
    } catch (e) {
      NetMsgDialog.handleError(context, e, res);
    }
    isLoading = false;
    notifyListeners();
    return false;
  }
}
