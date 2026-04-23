import 'dart:convert';
import 'package:chat_app/core/network/net.dart';
import 'package:chat_app/core/network/network.dart';
import 'package:chat_app/features/auth/register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fx_helper/network/fx_network.dart';
import 'package:fx_helper/widgets/net_msg_dialog.dart';

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier();
});

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier() : super(RegisterState());

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<bool> register(BuildContext context) async {
    state = state.copyWith(isLoading: true);

    dynamic res;

    try {
      Map<String, String> postData = {"username": usernameController.text, "password": passwordController.text};

      res = await Network().postApi(Net.gateway, 'register', postData);
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        throw ApiException(body['message']);
      }
    } catch (e) {
      NetMsgDialog.handleError(context, e, res);
    }

    state = state.copyWith(isLoading: false);
    return false;
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
