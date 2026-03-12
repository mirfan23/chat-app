import 'package:chat_app/network/network.dart';
import 'package:chat_app/page/login/login_page.dart';
import 'package:chat_app/page/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:fx_helper/dev_info_wrapper.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DevInfoWrapper(
      isDevMode: Network().isDevMode,
      child: Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Consumer<ProfileProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                Text(provider.profile?.username ?? ''),
                ElevatedButton(
                  onPressed: () {
                    provider.logout(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("logout"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
