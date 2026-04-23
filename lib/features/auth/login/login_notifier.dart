import 'dart:convert';
import 'package:chat_app/core/network/net.dart';
import 'package:chat_app/core/network/network.dart';
import 'package:chat_app/features/auth/login/login_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fx_helper/network/fx_network.dart';
import 'package:fx_helper/secure_storage.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier();
});

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(const LoginState());

  Future<bool> login({required String username, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    dynamic res;
    try {
      final postData = {"username": username, "password": password};
      res = await Network().postApi(Net.gateway, 'login', postData);
      final body = json.decode(res.body);

      if (res.statusCode == 200) {
        final token = body['data']['token'];

        await SecureStorage().setToken(token);
        Network().token = token;

        state = state.copyWith(isLoading: false, token: token, message: body['message']);

        return true;
      } else {
        throw ApiException(body['message']);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, apiError: res, error: e);
      return false;
    }
  }

  void reset() {
    state = const LoginState();
  }
}
