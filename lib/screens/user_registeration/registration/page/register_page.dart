import 'package:flutter/material.dart';
import 'package:talkter/widgets/bg_design/bg_design.dart';
import 'package:talkter/screens/user_registeration/OTP/page/otp_page.dart';
import 'package:talkter/screens/user_registeration/Phone/page/phone_page.dart';
import 'package:talkter/screens/user_registeration/setup/user_setup.dart';
import 'package:talkter/screens/user_registeration/user_info/user_info.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _pageController = PageController();

  void nextPage() {
    if (!_pageController.hasClients) return;

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void previousPage() {
    if (!_pageController.hasClients) return;

    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BGDesign(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return PhonePage(onNext: nextPage);
                  case 1:
                    return OTP_Page(onNext: nextPage, onBack: previousPage);
                  case 2:
                    return UserInfoPage(onNext: nextPage);
                  case 3:
                    return AccountSetupPage(onBack: previousPage);
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
