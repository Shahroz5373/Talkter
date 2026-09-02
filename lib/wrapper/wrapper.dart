import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkter/screens/home/home_screen.dart';
import 'package:talkter/constants/custom_error_widget.dart';
import 'package:talkter/features/auth/screens/registration_page/register_page.dart';
import 'package:talkter/widgets/bg_design/bg_design.dart';
import 'package:talkter/widgets/glassmorphic_cotainer/glassmorphic_container.dart';
import 'package:talkter/wrapper/riverpod/stream_riverpod.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStatus = ref.watch(authStatusProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeOutExpo,
      switchOutCurve: Curves.easeInExpo,
      child: userStatus.when(
        data: (status) {
          return switch (status) {
            AppAuthState.authenticated => const HomeScreen(
              key: ValueKey('home'),
            ),

            AppAuthState.unauthenticated => const RegisterPage(
              key: ValueKey('unauth'),
              initialPage: 0,
            ),

            AppAuthState.requiresProfile => const RegisterPage(
              key: ValueKey('profile'),
              initialPage: 2,
            ),
          };
        },

        loading: () {
          return _buildGlassLoading(
            const SpinKitDoubleBounce(size: 50, color: Colors.blueAccent),
            message: "SECURING CONNECTION",
          );
        },

        error: (error, stackTrace) {
          return _buildGlassError(
            error.toString().trim(),
            key: const ValueKey('error_screen'),
          );
        },
      ),
    );
  }

  static Widget _buildGlassLoading(Widget spinner, {required String message}) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const BGDesign(),

          Center(
            child: GlassMorphicContainer(
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
                    style: const TextStyle(
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

  static Widget _buildGlassError(String error, {required Key key}) {
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
