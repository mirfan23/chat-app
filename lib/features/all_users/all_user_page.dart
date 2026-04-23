import 'package:chat_app/core/network/network.dart';
import 'package:chat_app/features/all_users/all_user_notifier.dart';
import 'package:chat_app/features/profile/profile_notifier.dart';
import 'package:chat_app/core/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_helper/dev_info_wrapper.dart';
import 'package:fx_helper/image_initials.dart';
import 'package:go_router/go_router.dart';

// class AllUserPage extends StatefulWidget {
//   const AllUserPage({super.key});

//   @override
//   State<AllUserPage> createState() => _AllUserPageState();
// }

// class _AllUserPageState extends State<AllUserPage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<AllUserProvider>(context, listen: false).getListAllUser(context);
//     });
//   }

//   Future<void> refresh() async {
//     Provider.of<AllUserProvider>(context, listen: false).getListAllUser(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DevInfoWrapper(
//       isDevMode: Network().isDevMode,
//       child: RefreshIndicator(
//         onRefresh: refresh,
//         child: Scaffold(
//           appBar: AppBar(title: const Text("New Chat"), automaticallyImplyLeading: false),
//           body: Consumer<AllUserProvider>(
//             builder: (context, provider, _) {
//               print("cok");
//               if (provider.isLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               return ListView.builder(
//                 itemCount: provider.users.length,
//                 itemBuilder: (context, index) {
//                   final user = provider.users[index];
//                   final profileProvider = Provider.of<ProfileProvider>(context);
//                   print("🔥 ALL USER");

//                   return ListTile(
//                     leading: ImageInitials(text: user.username ?? "", style: textStyleExtraHuge(context)),
//                     title: Text(user.username ?? ""),
//                     subtitle: const Text("Start conversation"),
//                     onTap: () {
//                       final myUserId = profileProvider.profile?.id;
//                       final friendId = user.userId;

//                       print("🔥 DEBUG All User Tap");
//                       print("myUserId: $myUserId");
//                       print("friendId: $friendId");
//                       print("myUsername: ${profileProvider.profile?.username}");
//                       print("friendUsername: ${user.username}");

//                       if (myUserId == null || friendId == null) {
//                         print("❌ Cannot create room, one of the IDs is null");
//                         return;
//                       }

//                       final ids = [myUserId, friendId]..sort();
//                       final roomId = "${ids[0]}_${ids[1]}";

//                       print("roomId: $roomId");

//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => ChatPage(
//                             roomId: roomId,
//                             id: profileProvider.profile?.id ?? '',
//                             friend: friendId,
//                             friendName: user.username ?? '',
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

class AllUserPage extends ConsumerStatefulWidget {
  const AllUserPage({super.key});

  @override
  ConsumerState<AllUserPage> createState() => _AllUserPageState();
}

class _AllUserPageState extends ConsumerState<AllUserPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(allUserProvider.notifier).getUsers();
    });
  }

  Future<void> refresh() async {
    await ref.read(allUserProvider.notifier).getUsers();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(allUserProvider);
    final profile = ref.watch(profileProvider).profile;

    return DevInfoWrapper(
      isDevMode: Network().isDevMode,
      child: RefreshIndicator(
        onRefresh: refresh,
        child: Scaffold(
          appBar: AppBar(title: const Text("New Chat"), automaticallyImplyLeading: false),
          body: Builder(
            builder: (_) {
              /// 🔵 LOADING
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              /// 🔵 EMPTY
              if (state.users.isEmpty) {
                return const Center(child: Text("No users"));
              }

              /// 🔵 LIST
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (_, index) {
                  final user = state.users[index];

                  return ListTile(
                    leading: ImageInitials(text: user.username ?? "", style: textStyleExtraHuge(context)),
                    title: Text(user.username ?? ""),
                    subtitle: const Text("Start conversation"),
                    onTap: () {
                      final myUserId = profile?.id;
                      final friendId = user.userId;

                      if (myUserId == null || friendId == null) return;

                      final ids = [myUserId, friendId]..sort();
                      final roomId = "${ids[0]}_${ids[1]}";

                      /// 🔥 GO ROUTER
                      context.pushNamed(
                        'chat',
                        extra: {
                          "roomId": roomId,
                          "id": myUserId,
                          "friend": friendId,
                          "friendName": user.username ?? '',
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
