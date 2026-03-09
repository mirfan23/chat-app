import 'package:chat_app/models/profile_response.dart';
import 'package:chat_app/network/Net.dart';
import 'package:chat_app/network/network.dart';
import 'package:chat_app/page/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fx_helper/network/fx_network.dart';
import 'package:fx_helper/secure_storage.dart';
import 'package:fx_helper/widgets/net_msg_dialog.dart';

class ProfileProvider extends ChangeNotifier {
  bool isLoading = false;
  ProfileModel? profile;

  Future<bool> getProfile(BuildContext context) async {
    isLoading = true;
    dynamic res;
    notifyListeners();
    try {
      res = await Network().getApi(Net.gateway, 'profile');
      var body = ProfileResponse.fromRawJson(res.body);

      print("⚠️ Profile error 1");
      if (res.statusCode == 200) {
        profile = body.data;
        isLoading = false;
        notifyListeners();
        return true;
      } else if (res.statusCode == 401) {
        print("⚠️ Profile error 2: ${body.message}");
        await SecureStorage().deleteToken();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
        print("⚠️ Profile error 3: ${body.statusCode}");
        return false;
      } else {
        profile = null;
        throw ApiException(body.message);
      }
    } catch (e) {
      print("profile error 4: $e");
      NetMsgDialog.handleError(context, e, res);
    }
    isLoading = false;
    notifyListeners();
    return false;
  }
}
