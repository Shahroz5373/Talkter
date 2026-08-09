import 'package:flutter/material.dart';
import 'package:talkter/Services/auth/auth_service.dart';
import 'package:talkter/designs/bg_design/bg_design.dart';
import 'package:talkter/designs/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:talkter/screens/home/chat/chat_screen.dart';
import 'package:talkter/screens/home/notifications/notifications.dart';
import 'package:talkter/screens/home/profile/user_profile.dart';
import 'package:talkter/screens/home/search/search.dart';
import 'package:talkter/screens/user_registeration/registration/register.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  int currentPageIndex = 0;
  List<Widget> pages = [ChatScreen(), Search(), Notifications(), UserProfile()];
  @override
  Widget build(BuildContext context) {
    // return CustomBottomNavBar();
    return Stack(
      children: [
        const BGDesign(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                onPressed: () async {
                  await _auth.signOut();
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => RegisterPage()),
                    );
                  }
                },
                icon: Icon(Icons.logout_rounded, color: Colors.white, size: 28),
              ),
            ],
          ),
          body: Center(child: pages[currentPageIndex]),
          bottomNavigationBar: CustomBottomNavBar(
            onPageIndexChanged: (index) {
              setState(() => currentPageIndex = index);
            },
          ),
        ),
      ],
    );
  }
}
