import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talkter/designs/glassmorphic_cotainer/glassmorphic_container.dart';
import 'package:talkter/screens/user_registeration/Phone/input/phone_no_input.dart';

class PhonePage extends StatefulWidget {
  final VoidCallback onNext;

  const PhonePage({super.key, required this.onNext});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  String phoneNumber = '';
  bool isPhoneValid = false;

  void onPhoneChanged(String phone) {
    setState(() {
      phoneNumber = phone;
    });
  }

  void onPhoneValidationChanged(bool value) {
    setState(() {
      isPhoneValid = value;
    });
  }

  void continuePressed() {
    if (!isPhoneValid || phoneNumber.isEmpty) {
      return;
    }

    debugPrint('Phone: $phoneNumber');

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
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
                    'talkter',
                    style: GoogleFonts.poppins(
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
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Enter your phone number to create your account.',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  'Phone number',
                  style: GoogleFonts.poppins(
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

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isPhoneValid ? continuePressed : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      disabledBackgroundColor: Colors.white12,
                      foregroundColor: Colors.black,
                      disabledForegroundColor: Colors.white30,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
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
