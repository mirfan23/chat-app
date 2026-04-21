import 'package:chat_app/network/network.dart';
import 'package:chat_app/page/socket_service.dart';
import 'package:chat_app/routes/app_router.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_helper/snackbar_helper.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     await Network().init();
//   } catch (e) {
//     print(e);
//   }
//   // SocketService().connect();
//   runApp(ProviderScope(child: const MyApp()));
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Network().init();

  final container = ProviderContainer();

  // 🔥 connect socket sekali saja
  container.read(socketProvider).connect();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: Network().isDevMode,
      scaffoldMessengerKey: globalSnackbarKey,
      theme: customTheme,
      routerConfig: router,
    );
  }
}
