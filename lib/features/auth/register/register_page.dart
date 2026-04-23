import 'package:chat_app/features/auth/register/register_notifier.dart';
import 'package:chat_app/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: notifier.usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: notifier.passwordController,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),

            /// 🔹 BUTTON REGISTER
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      final isSuccess = await notifier.register(context);

                      if (isSuccess) {
                        context.go(Routes.login); // ✅ go_router
                      }
                    },
              child: state.isLoading ? const CircularProgressIndicator() : const Text("Register"),
            ),

            /// 🔹 KE LOGIN
            ElevatedButton(
              onPressed: () {
                context.go(Routes.login);
              },
              child: const Text("Ke halaman Login"),
            ),
          ],
        ),
      ),
    );
  }
}
