import 'package:chat_app/features/profile/models/profile_response.dart';
import 'package:chat_app/core/network/net.dart';
import 'package:chat_app/core/network/network.dart';
import 'package:chat_app/core/services/socket_service.dart';
import 'package:chat_app/features/profile/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fx_helper/network/fx_network.dart';
import 'package:fx_helper/secure_storage.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(ref);
});

class ProfileNotifier extends StateNotifier<ProfileState> {
  final Ref ref;
  ProfileNotifier(this.ref) : super(ProfileState());
  Future<bool> getProfile() async {
    state = state.copyWith(isLoading: true);
    dynamic res;
    try {
      res = await Network().getApi(Net.gateway, 'profile');
      var body = ProfileResponse.fromRawJson(res.body);

      print("⚠️ Profile error 1");
      if (res.statusCode == 200) {
        final profile = body.data;
        state = state.copyWith(isLoading: false, profile: profile);
        return true;
      } else if (res.statusCode == 401) {
        print("⚠️ Profile error 2: ${body.message}");
        await SecureStorage().deleteToken();

        print("⚠️ Profile error 3: ${body.statusCode}");
        return false;
      } else {
        throw ApiException("");
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, apiError: res, error: e);
    }
    state = state.copyWith(isLoading: false);
    return false;
  }

  Future<void> logout() async {
    SocketService(ref).leaveRoom();
    await SecureStorage().deleteToken();
    Network().token = null;

    // clear provider lain
    // ref.read(chatProvider.notifier).clearRoom();

    state = ProfileState(); // reset state
  }
}
