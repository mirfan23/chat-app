import 'package:chat_app/network/network.dart';
import 'package:chat_app/page/list_user/chat_list_page.dart';
import 'package:chat_app/page/login/login_page.dart';
import 'package:chat_app/page/main_app.dart';
import 'package:chat_app/page/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:fx_helper/secure_storage.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    String? token = await SecureStorage().getToken();
    Network().token = token;

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      Provider.of<ProfileProvider>(context, listen: false).getProfile(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainApp()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: FlutterLogo(size: 100)));
  }
}
