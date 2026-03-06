import 'package:chat_app/models/profile_response.dart';
import 'package:chat_app/network/Net.dart';
import 'package:chat_app/network/network.dart';
import 'package:flutter/material.dart';
import 'package:fx_helper/network/fx_network.dart';
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

      if (res.statusCode == 200) {
        profile = body.data;
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        profile = null;
        throw ApiException(body.message);
      }
    } catch (e) {
      print("profile error: $e");
      NetMsgDialog.handleError(context, e, res);
    }
    isLoading = false;
    notifyListeners();
    return false;
  }
}
