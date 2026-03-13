import 'package:chat_app/models/all_user_response.dart';
import 'package:chat_app/network/Net.dart';
import 'package:chat_app/network/network.dart';
import 'package:flutter/material.dart';
import 'package:fx_helper/network/fx_network.dart';
import 'package:fx_helper/widgets/net_msg_dialog.dart';

class AllUserProvider extends ChangeNotifier {
  bool isLoading = false;
  List<AllUserModel> users = [];

  Future<void> getListAllUser(BuildContext context) async {
    isLoading = true;
    dynamic res;
    notifyListeners();
    try {
      res = await Network().getApi(Net.gateway, "users");
      var body = AllUserResponse.fromRawJson(res.body);
      if (res.statusCode == 200) {
        users = body.data ?? [];
        isLoading = false;
        notifyListeners();
      } else {
        throw ApiException(body.message);
      }
    } catch (e) {
      NetMsgDialog.handleError(context, e, res);
    }
    isLoading = false;
    notifyListeners();
  }
}
