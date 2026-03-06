import 'package:chat_app/network/network.dart';
import 'package:chat_app/page/list_user/chat_list_page.dart';
import 'package:chat_app/page/profile/profile_page.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:fx_helper/dev_info_wrapper.dart';

class MainApp extends StatefulWidget {
  final int initialPage;
  const MainApp({super.key, this.initialPage = 0});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int currentPage = 0;
  late PageController pageController;

  @override
  void initState() {
    currentPage = widget.initialPage;
    pageController = PageController(initialPage: currentPage);
    pages[currentPage] = pagesBuilder[currentPage]();
    super.initState();
  }

  void itemSelected(int index) {
    setState(() {
      currentPage = index;
      // if (pages[index] == null) {
      pages[index] = pagesBuilder[index]();
      // }
    });
  }

  final List<BottomNavigationBarItem> bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home, color: darkGreyColor),
      activeIcon: Icon(Icons.home, color: whiteColor),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person, color: darkGreyColor),
      activeIcon: Icon(Icons.person, color: whiteColor),
      label: 'Profile',
    ),
  ];

  final List<Widget Function()> pagesBuilder = [
    () => ChatListPage(),
    // () => AttendancePage(),
    // () => HistoryPage(),
    () => ProfilePage(),
  ];

  List<Widget> pages = List.generate(2, (index) => Container());

  double _getBottombarHeight(BuildContext context) {
    var smallFormFactor = MediaQuery.of(context).size.shortestSide < 550;
    var height = 70.0;
    if (smallFormFactor) {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        return height * 1;
      } else {
        return height * 0.9;
      }
    } else {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        return height * 1.2;
      } else {
        return height * 1.3;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DevInfoWrapper(
      isDevMode: Network().isDevMode,
      child: Scaffold(
        backgroundColor: whiteColor,
        body: pages[currentPage],
        extendBody: true,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomAppBar(
          color: whiteColor,
          padding: EdgeInsets.zero,
          elevation: 0,
          height: _getBottombarHeight(context),
          child: BottomNavigationBar(
            backgroundColor: blackColor,
            items: bottomNavBarItems,
            currentIndex: currentPage,
            onTap: itemSelected,
            elevation: 0,
            selectedLabelStyle: textStyleSmall(context),
            unselectedLabelStyle: textStyleTiny(context),
            selectedItemColor: primaryColor,
            unselectedItemColor: greyColor,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
