import 'package:chat_app/network/network.dart';
import 'package:flutter/material.dart';
import 'package:fx_helper/dev_info_wrapper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DevInfoWrapper(
      isDevMode: Network().isDevMode,
      child: Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Column(
          children: [
            Text("Profile"),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("logout"),
            ),
          ],
        ),
      ),
    );
  }
}
