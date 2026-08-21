import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talkter/Services/database/database_service.dart';
import 'package:talkter/Services/keys/key_manage_provider/key_provider.dart';
import 'package:talkter/designs/glassmorphic_cotainer/glassmorphic_container.dart';
import 'package:talkter/designs/snack_bar/snack_bar.dart';
import 'package:talkter/screens/home/home_screen.dart';
import 'package:talkter/screens/user_registeration/registration/riverpod/user_notifier/user_notifier.dart'; // Ensure this path is correct

class SetupAccountPage extends ConsumerStatefulWidget {
  const SetupAccountPage({super.key});

  @override
  ConsumerState<SetupAccountPage> createState() => _SetupAccountPageState();
}

class _SetupAccountPageState extends ConsumerState<SetupAccountPage> {
  final DatabaseService _db = DatabaseService();

  @override
  void initState() {
    super.initState();
    // Start the setup process as soon as the page loads
    _finalizeSetup();
  }

  Future<void> _finalizeSetup() async {
    // Add a small 1.5-second artificial delay so the user actually sees
    // the cool loading animation before it jumps instantly to the home screen
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final user = ref.read(userProvider);

    if (user == null || user.phone.isEmpty) {
      AppSnackBar.failure(
        context,
        title: 'Error',
        Message: 'User data is missing. Please restart the app.',
      );
      return;
    }

    try {
      final public_key = await ref
          .read(keyManagerProvider)
          .generateAndStoreKeys();
      // Save all data to Firestore
      await _db.saveUserData(user: user, public_key: public_key);

      if (!mounted) return;

      // Clear the Riverpod state now that registration is totally complete
      ref.read(userProvider.notifier).clearUser();

      // PushReplacement destroys the RegisterPage (and the PageView)
      // and permanently moves the user to the HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.failure(
        context,
        title: 'Setup Failed',
        Message: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GlassMorphicContainer(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SpinKitWanderingCubes(
                  color: Colors.cyanAccent,
                  size: 50.0,
                ),

                const SizedBox(height: 40),

                Text(
                  'Setting up your space...',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Organizing your profile and getting things ready. This will just take a moment.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
