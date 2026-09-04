import 'package:flutter/material.dart';
import 'package:talkter/screens/home/chats/chats_screen.dart';
import 'package:talkter/screens/home/notifications/notifications.dart';
import 'package:talkter/screens/home/profile/profile_screen.dart';
import 'package:talkter/screens/home/search/search.dart';
import 'package:talkter/widgets/bg_design/bg_design.dart';
import 'package:talkter/widgets/bottom_nav_bar/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final _pageController = PageController(initialPage: 0);
  List<Widget> screens = [
    ChatsScreen(),
    SearchScreen(),
    Notifications(),
    ProfileScreen(),
  ];

  void onTabChanged(int index) {
    setState(() => currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BGDesign(),
        Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(15),
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => currentIndex = index),
                children: screens,
                // physics: ,
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomBar(
            currentIndex: currentIndex,
            onTap: onTabChanged,
          ),
        ),
      ],
    );
  }
}
