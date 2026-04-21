import 'package:chat_app/network/network.dart';
import 'package:chat_app/page/profile/profile_notifier.dart';
import 'package:chat_app/routes/routes.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:fx_helper/dev_info_wrapper.dart';
import 'package:go_router/go_router.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Future<void> getData() async {
//       await Provider.of<ProfileProvider>(context, listen: false).getProfile(context);
//     }

//     return DevInfoWrapper(
//       isDevMode: Network().isDevMode,
//       child: RefreshIndicator(
//         onRefresh: getData,
//         child: Scaffold(
//           appBar: AppBar(title: const Text("Profile"), automaticallyImplyLeading: false),
//           body: Consumer<ProfileProvider>(
//             builder: (context, provider, _) {
//               return SingleChildScrollView(
//                 physics: AlwaysScrollableScrollPhysics(),
//                 child: Column(
//                   children: [
//                     Text(provider.profile?.username ?? ''),
//                     ElevatedButton(
//                       onPressed: () {
//                         provider.logout(context);
//                         Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
//                       },
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                       child: Text("logout"),
//                     ),
//                     Container(height: getMaxHeight(context)),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import profileProvider

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();

    /// 🔥 load pertama kali
    Future.microtask(() {
      ref.read(profileProvider.notifier).getProfile();
    });
  }

  Future<void> _refresh() async {
    await ref.read(profileProvider.notifier).getProfile();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);

    return DevInfoWrapper(
      isDevMode: Network().isDevMode,
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: Scaffold(
          appBar: AppBar(title: const Text("Profile"), automaticallyImplyLeading: false),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                /// 🔹 LOADING
                if (state.isLoading) const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()),

                /// 🔹 DATA
                Text(state.profile?.username ?? ''),

                /// 🔹 LOGOUT
                ElevatedButton(
                  onPressed: () async {
                    await notifier.logout();

                    /// 🔥 pindah ke login (clear stack)
                    if (context.mounted) {
                      context.go(Routes.login);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Logout", style: TextStyle(color: Colors.white)),
                ),

                Container(height: getMaxHeight(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
