import 'package:chat_app/features/all_users/all_user_page.dart';
import 'package:chat_app/features/chat/chat_page.dart';
import 'package:chat_app/features/chat_list/chat_list_page.dart';
import 'package:chat_app/features/auth/login/login_page.dart';
import 'package:chat_app/main_app.dart';
import 'package:chat_app/features/profile/profile_page.dart';
import 'package:chat_app/features/auth/register/register_page.dart';
import 'package:chat_app/features/splash/splash_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      /// 🔹 SPLASH / AUTH (di luar shell)
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),

      /// 🔹 MAIN APP (SHELL)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainApp(navigationShell: navigationShell);
        },
        branches: [
          /// 🟢 HOME (CHAT LIST + DETAIL)
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', builder: (_, _) => const ChatListPage())],
          ),

          /// 🟢 USERS
          StatefulShellBranch(
            routes: [GoRoute(path: '/users', builder: (_, _) => const AllUserPage())],
          ),

          /// 🟢 PROFILE
          StatefulShellBranch(
            routes: [GoRoute(path: '/profile', builder: (_, _) => const ProfilePage())],
          ),
        ],
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          return ChatPage(
            roomId: extra['roomId'],
            id: extra['id'],
            friend: extra['friend'],
            friendName: extra['friendName'],
          );
        },
      ),
    ],
  );
});
