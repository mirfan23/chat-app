import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';

// class MainApp extends StatefulWidget {
//   final int initialPage;
//   const MainApp({super.key, this.initialPage = 0});

//   @override
//   State<MainApp> createState() => _MainAppState();
// }

// class _MainAppState extends State<MainApp> {
//   int currentPage = 0;
//   late PageController pageController;

//   @override
//   void initState() {
//     currentPage = widget.initialPage;
//     pageController = PageController(initialPage: currentPage);
//     pages[currentPage] = pagesBuilder[currentPage]();
//     super.initState();
//   }

//   void itemSelected(int index) {
//     setState(() {
//       currentPage = index;
//       // if (pages[index] == null) {
//       pages[index] = pagesBuilder[index]();
//       // }
//     });
//   }

//   final List<BottomNavigationBarItem> bottomNavBarItems = [
//     BottomNavigationBarItem(
//       icon: Icon(Icons.home, color: darkGreyColor),
//       activeIcon: Icon(Icons.home, color: blackColor),
//       label: 'Home',
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(Icons.group, color: darkGreyColor),
//       activeIcon: Icon(Icons.group, color: blackColor),
//       label: 'All User',
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(Icons.person, color: darkGreyColor),
//       activeIcon: Icon(Icons.person, color: blackColor),
//       label: 'Profile',
//     ),
//   ];

//   final List<Widget Function()> pagesBuilder = [() => ChatListPage(), () => AllUserPage(), () => ProfilePage()];

//   List<Widget> pages = List.generate(3, (index) => Container());

//   double _getBottombarHeight(BuildContext context) {
//     var smallFormFactor = MediaQuery.of(context).size.shortestSide < 550;
//     var height = 70.0;
//     if (smallFormFactor) {
//       if (MediaQuery.of(context).orientation == Orientation.portrait) {
//         return height * 1;
//       } else {
//         return height * 0.9;
//       }
//     } else {
//       if (MediaQuery.of(context).orientation == Orientation.portrait) {
//         return height * 1.2;
//       } else {
//         return height * 1.3;
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DevInfoWrapper(
//       isDevMode: Network().isDevMode,
//       child: Scaffold(
//         backgroundColor: whiteColor,
//         body: pages[currentPage],
//         extendBody: true,
//         resizeToAvoidBottomInset: false,
//         bottomNavigationBar: BottomAppBar(
//           color: whiteColor,
//           padding: EdgeInsets.zero,
//           elevation: 0,
//           height: _getBottombarHeight(context),
//           child: BottomNavigationBar(
//             backgroundColor: whiteColor,
//             items: bottomNavBarItems,
//             currentIndex: currentPage,
//             iconSize: 25,
//             onTap: itemSelected,
//             elevation: 0,
//             selectedItemColor: blackColor,
//             unselectedItemColor: darkGreyColor,
//             type: BottomNavigationBarType.shifting,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class MainApp extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainApp({super.key, required this.navigationShell});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  DateTime? lastBackPressed;

  void _handleBack() {
    // 🔥 cek apakah masih bisa pop (misal di chat detail)
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    final now = DateTime.now();

    if (lastBackPressed == null || now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
      lastBackPressed = now;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tekan sekali lagi untuk keluar'), duration: Duration(seconds: 2)));
    } else {
      SystemNavigator.pop();
    }
  }

  double _getBottombarHeight(BuildContext context) {
    var smallFormFactor = MediaQuery.of(context).size.shortestSide < 550;
    var height = 70.0;

    if (smallFormFactor) {
      return MediaQuery.of(context).orientation == Orientation.portrait ? height : height * 0.9;
    } else {
      return MediaQuery.of(context).orientation == Orientation.portrait ? height * 1.2 : height * 1.3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: widget.navigationShell, // 🔥 ini pengganti semua pages lama
        extendBody: true,
        resizeToAvoidBottomInset: false,

        bottomNavigationBar: BottomAppBar(
          color: whiteColor,
          padding: EdgeInsets.zero,
          elevation: 0,
          height: _getBottombarHeight(context),
          child: BottomNavigationBar(
            currentIndex: widget.navigationShell.currentIndex,
            onTap: (index) {
              widget.navigationShell.goBranch(index);
            },
            type: BottomNavigationBarType.shifting,
            elevation: 0,
            selectedItemColor: blackColor,
            unselectedItemColor: darkGreyColor,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: darkGreyColor),
                activeIcon: Icon(Icons.home, color: blackColor),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group, color: darkGreyColor),
                activeIcon: Icon(Icons.group, color: blackColor),
                label: 'All User',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, color: darkGreyColor),
                activeIcon: Icon(Icons.person, color: blackColor),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
