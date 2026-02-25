import 'list_user_page.dart';
import 'package:flutter/material.dart';
import 'socket_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();

  void login() {
    final username = usernameController.text.trim();
    if (username.isEmpty) return;

    if (!SocketService().isConnected) {
      print("Socket not connected yet!");
      return;
    }

    SocketService().socket.emit("login", username);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UserListPage(username: username)));
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Login")),
          ],
        ),
      ),
    );
  }
}
