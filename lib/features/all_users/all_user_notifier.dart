import 'package:chat_app/features/all_users/models/all_user_response.dart';
import 'package:chat_app/core/network/net.dart';
import 'package:chat_app/core/network/network.dart';
import 'package:chat_app/features/all_users/all_user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fx_helper/network/fx_network.dart';

final allUserProvider = StateNotifierProvider<AllUserNotifier, AllUserState>((ref) {
  return AllUserNotifier(ref);
});

class AllUserNotifier extends StateNotifier<AllUserState> {
  final Ref ref;

  AllUserNotifier(this.ref) : super(const AllUserState());

  Future<void> getUsers() async {
    state = state.copyWith(isLoading: true);

    dynamic res;

    try {
      res = await Network().getApi(Net.gateway, "users");

      final body = AllUserResponse.fromRawJson(res.body);

      if (res.statusCode == 200) {
        state = state.copyWith(users: body.data ?? [], isLoading: false);
      } else {
        throw ApiException(body.message);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}
