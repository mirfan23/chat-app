import 'package:chat_app/page/login/login_page.dart';
import 'package:chat_app/page/register/register_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<RegisterProvider>(
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
                    bool isSuccess = await provider.register(context);

                    if (isSuccess) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
                    } else {
                      return;
                    }
                  },
                  child: const Text("Register"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
                  },
                  child: const Text("Ke halaman Login"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
