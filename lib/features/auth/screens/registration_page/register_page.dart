import 'package:flutter/material.dart';
import 'package:talkter/widgets/bg_design/bg_design.dart';
import 'package:talkter/features/auth/screens/OTP/page/otp_page.dart';
import 'package:talkter/features/auth/screens/Phone/page/phone_page.dart';
import 'package:talkter/features/auth/screens/account_setup/account_setup.dart';
import 'package:talkter/features/auth/screens/user_info/user_info.dart';

class RegisterPage extends StatefulWidget {
  final int initialPage;
  const RegisterPage({super.key, this.initialPage = 0});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
  }

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
