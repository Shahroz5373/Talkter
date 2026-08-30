import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talkter/Services/cloudinary/riverpod/file_path/file_path_provider.dart';
import 'package:talkter/Services/cloudinary/riverpod/upload/upload_provider.dart';
import 'package:talkter/Services/database/database_service.dart';
import 'package:talkter/Services/encryption/keys/key_generation.dart';
import 'package:talkter/Services/encryption/private_key_storage/private_key_storage.dart';
import 'package:talkter/Services/localStorage/local_storage.dart';
import 'package:talkter/widgets/glassmorphic_cotainer/glassmorphic_container.dart';
import 'package:talkter/widgets/snack_bar/snack_bar.dart';
import 'package:talkter/screens/home/home_screen.dart';
import 'package:talkter/screens/user_registeration/registration/riverpod/user_notifier/user_notifier.dart';

class AccountSetupPage extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  const AccountSetupPage({super.key, required this.onBack});

  @override
  ConsumerState<AccountSetupPage> createState() => _SetupAccountPageState();
}

class _SetupAccountPageState extends ConsumerState<AccountSetupPage> {
  @override
  void initState() {
    super.initState();
    _finalizeSetup();
  }

  Future<void> _finalizeSetup() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final user = ref.read(userProvider);
    final profilePic = ref.read(uploadPathProvider);
    //print(profilePic);
    if (user == null || user.phone.isEmpty) {
      AppSnackBar.failure(
        context,
        title: 'Error',
        Message: 'User data is missing. Please restart the app.',
      );
      widget.onBack();
      return;
    }

    if (profilePic == null) {
      AppSnackBar.failure(
        context,
        title: 'Error',
        Message: 'Profile picture is missing.',
      );
      widget.onBack();
      return;
    }

    try {
      final cloudinary = ref.read(cloudinaryServiceProvider);

      final keys = KeyGeneration.generate();
      final uploadRes = cloudinary.uploadProfileImage(imageFile: profilePic);

      final keysPair = await keys;
      final cloudinaryResult = await uploadRes;

      if (!mounted) return;

      final privateKey = keysPair.keys.secretKey;
      await PrivateKeyStore.storePrivateKey(privatekey: privateKey);

      final publicKeyBytes = keysPair.keys.publicKey;
      final publicKey = base64Encode(publicKeyBytes);

      await DatabaseService().saveUserData(
        user: user,
        publicKey: publicKey,
        profilePic: cloudinaryResult,
      );
      await UserLocalStorage().saveUser(
        user: user,
        avatarUrl: cloudinaryResult.avatar_url,
      );

      if (!mounted) return;

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
      widget.onBack();
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
