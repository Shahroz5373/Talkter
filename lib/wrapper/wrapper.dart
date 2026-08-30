import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:talkter/screens/home/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkter/constants/custom_error_widget.dart';
import 'package:talkter/screens/user_registeration/registration/page/register_page.dart';
import 'package:talkter/widgets/bg_design/bg_design.dart';
import 'package:talkter/widgets/glassmorphic_cotainer/glassmorphic_container.dart';
import 'package:talkter/wrapper/riverpod/stream_riverpod.dart';

class Wrapper extends ConsumerStatefulWidget {
  const Wrapper({super.key});

  @override
  ConsumerState<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<Wrapper> {
  late Future<void> _refreshFuture;

  @override
  void initState() {
    super.initState();

    _refreshFuture = _refreshUser();
  }

  Future<void> _refreshUser() async {
    //await Future.delayed(const Duration(seconds: 15));
    await FirebaseAuth.instance.currentUser?.reload();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _refreshFuture,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          switchInCurve: Curves.easeOutExpo,
          switchOutCurve: Curves.easeInExpo,
          child: _buildStateContent(snapshot),
        );
      },
    );
  }

  Widget _buildStateContent(AsyncSnapshot<void> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return _buildGlassLoading(
        const SpinKitFadingCircle(size: 50, color: Colors.white),
        message: "SYNCING",
      );
    }

    final userStatus = ref.watch(authStatusProvider);

    return userStatus.when(
      data: (status) {
        return switch (status) {
          AppAuthState.authenticated => const HomeScreen(),
          AppAuthState.unauthenticated => RegisterPage(initialPage: 0),
          AppAuthState.requiresProfile => RegisterPage(initialPage: 2),
        };
      },
      error: (error, stackTrace) => _buildGlassError(
        error.toString().trim(),
        key: const ValueKey('error_screen'),
      ),
      loading: () => _buildGlassLoading(
        const SpinKitDoubleBounce(size: 50, color: Colors.blueAccent),
        message: "SECURING CONNECTION",
      ),
    );
  }

  // Beautiful Splash-Style Loading Screen
  Widget _buildGlassLoading(Widget spinner, {required String message}) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const BGDesign(),
          Center(
            child: GlassMorphicContainer(
              // Adjust these parameters to match your specific constructor
              width: 220,
              height: 220,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  spinner,
                  const SizedBox(height: 30),
                  const Text(
                    'TALKTER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Consistent Aesthetic for Error State
  Widget _buildGlassError(String error, {required Key key}) {
    return Scaffold(
      key: key,
      body: Stack(
        children: [
          const BGDesign(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GlassMorphicContainer(
                width: double.infinity,
                height: 200,
                child: Center(child: CustomErrorWidget(error: error)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
