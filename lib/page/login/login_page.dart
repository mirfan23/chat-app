import 'package:chat_app/page/login/login_notifier.dart';
import 'package:chat_app/routes/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:fx_helper/widgets/net_msg_dialog.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);

    ref.listen(loginProvider, (previous, next) {
      if (next.error != null) {
        NetMsgDialog.handleError(context, next.error, next.apiError);
      }

      if (next.token != null) {
        context.go(Routes.home);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "password"),
            ),
            const SizedBox(height: 20),
            if (state.isLoading) const CircularProgressIndicator(),
            ElevatedButton(
              onPressed: () async {
                bool isSuccess = await notifier.login(
                  username: usernameController.text,
                  password: passwordController.text,
                );

                if (isSuccess) {
                  context.pushNamed(Routes.home);
                } else {
                  return;
                }
              },
              child: const Text("Login"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                context.push(Routes.register);
              },
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
