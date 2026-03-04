import 'package:chat_app/page/list_user/chat_list_provider.dart';
import 'package:chat_app/page/login/login_provider.dart';
import 'package:chat_app/page/register/register_page.dart';
import 'package:provider/provider.dart';

import '../list_user/chat_list_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<LoginProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                TextField(
                  controller: provider.usernameController,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
                TextField(
                  controller: provider.passwordController,
                  decoration: const InputDecoration(labelText: "password"),
                ),
                const SizedBox(height: 20),
                // ElevatedButton(onPressed: login, child: const Text("Login")),
                ElevatedButton(
                  onPressed: () async {
                    bool isSuccess = await provider.login(context);

                    if (isSuccess) {
                      Provider.of<ChatListProvider>(context, listen: false).fetchChatList(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => ChatListPage(username: provider.usernameController.text)),
                      );
                    } else {
                      return;
                    }
                  },
                  child: const Text("Login"),
                ),
                const SizedBox(height: 20),
                // ElevatedButton(onPressed: login, child: const Text("Login")),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RegisterPage()));
                  },
                  child: const Text("Register"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
