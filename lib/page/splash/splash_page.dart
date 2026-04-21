import 'package:chat_app/page/splash/splash_notiifer.dart';
import 'package:chat_app/routes/routes.dart';
import 'package:chat_app/state/splash/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();

    // delay supaya context sudah ready
    Future.microtask(() {
      ref.read(splashNotifier.notifier).checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(splashNotifier);

    // 🔥 listen untuk navigation
    ref.listen<SplashState>(splashNotifier, (previous, next) {
      if (!next.isLoading) {
        if (next.isLoggedIn) {
          context.go(Routes.home); // ✅ ke home
        } else {
          context.go(Routes.login); // ❌ ke login
        }
      }
    });

    return Scaffold(
      body: Center(child: state.isLoading ? const CircularProgressIndicator() : const FlutterLogo(size: 100)),
    );
  }
}
