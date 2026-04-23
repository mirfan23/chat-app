import 'package:chat_app/core/network/network.dart';
import 'package:chat_app/features/profile/profile_notifier.dart';
import 'package:chat_app/features/splash/splash_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fx_helper/secure_storage.dart';

final splashNotifier = StateNotifierProvider<SplashNotifier, SplashState>((ref) {
  return SplashNotifier(ref);
});

class SplashNotifier extends StateNotifier<SplashState> {
  final Ref ref;
  SplashNotifier(this.ref) : super(const SplashState());

  Future<void> checkLogin() async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(seconds: 2));

    final token = await SecureStorage().getToken();
    Network().token = token;

    if (token == null || token.isEmpty) {
      state = state.copyWith(isLoading: false, isLoggedIn: false);
      return;
    }

    try {
      await ref.read(profileProvider.notifier).getProfile();

      state = state.copyWith(isLoading: false, isLoggedIn: true);
    } catch (e) {
      if (e.toString().contains('401')) {
        await SecureStorage().deleteToken();

        state = state.copyWith(isLoading: false, isLoggedIn: false);
      } else {
        // network error → tetap login
        state = state.copyWith(isLoading: false, isLoggedIn: true);
      }
    }
  }
}
