import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talkter/Services/auth/auth_service.dart';
import 'package:talkter/screens/user_registeration/Phone/page/riverpod/phone_id_provider.dart';
import 'package:talkter/screens/user_registeration/registration/riverpod/user_notifier/user_notifier.dart';
import 'package:talkter/designs/glassmorphic_cotainer/glassmorphic_container.dart';
import 'package:talkter/designs/snack_bar/snack_bar.dart';
import 'package:talkter/screens/user_registeration/Phone/input/phone_no_input.dart';

class PhonePage extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const PhonePage({super.key, required this.onNext});

  @override
  ConsumerState<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends ConsumerState<PhonePage> {
  String phoneNumber = '';
  bool isPhoneValid = false;
  bool isloading = false;
  final AuthService _auth = AuthService();

  void onPhoneChanged(String phone) {
    setState(() => phoneNumber = phone);
  }

  void onPhoneValidationChanged(bool value) {
    setState(() => isPhoneValid = value);
  }

  void handleContinue() async {
    if (phoneNumber.isEmpty || !isPhoneValid) {
      AppSnackBar.warning(
        context,
        title: 'Warning',
        Message: 'Please enter a valid phone number',
      );
      return;
    }

    setState(() => isloading = true);

    _auth.registerWithPhone(
      phoneNum: phoneNumber,
      onCodeSent: (verifyID) {
        if (!mounted) return;
        setState(() => isloading = false);

        // Update Riverpod state
        ref.read(userProvider.notifier).setPhone(phoneNo: phoneNumber);

        ref.read(verificationIdProvider.notifier).state = verifyID;

        // Move to OTP Page
        widget.onNext();
      },
      onVerificationFailed: (FirebaseAuthException e) {
        if (!mounted) return;
        setState(() => isloading = false);

        AppSnackBar.failure(
          context,
          title: 'Error',
          Message: e.message ?? 'Verification failed',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(userProvider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GlassMorphicContainer(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 30, 22, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Talkter',
                    style: GoogleFonts.dancingScript(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Text(
                  'Let’s get you started',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your phone number to create your account.',
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Phone number',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                RegisterPhone(
                  onPhoneChanged: onPhoneChanged,
                  onValidationChanged: onPhoneValidationChanged,
                ),

                const SizedBox(height: 25),

                Center(
                  child: isloading
                      ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                      : TextButton.icon(
                          onPressed: handleContinue,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.4,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 13,
                              horizontal: 35,
                            ),
                          ),
                          label: Text(
                            'Continue',
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                ),

                const SizedBox(height: 18),
                Center(
                  child: Text(
                    'We’ll send you a verification code.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
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
