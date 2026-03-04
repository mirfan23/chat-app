import 'package:chat_app/network/network.dart';
import 'package:chat_app/page/chat/chat_provider.dart';
import 'package:chat_app/page/list_user/chat_list_provider.dart';
import 'package:chat_app/page/login/login_provider.dart';
import 'package:chat_app/page/register/register_provider.dart';
import 'package:chat_app/page/socket_service.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'page/login/login_page.dart';
import 'package:fx_helper/snackbar_helper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SocketService().connect(); // WAJIB DI SINI
  try {
    await Network().init();
  } catch (e) {
    print(e);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ChatListProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: Network().isDevMode,
        scaffoldMessengerKey: globalSnackbarKey,
        home: const LoginPage(),
        theme: customTheme,
      ),
    );
  }
}
