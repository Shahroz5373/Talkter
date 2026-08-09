import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:talkter/Services/auth/auth_service.dart';
import 'package:talkter/screens/home/home_screen.dart';

class OtpInputField extends StatefulWidget {
  final String verificationId;
  const OtpInputField({super.key, required this.verificationId});

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final AuthService _auth = AuthService();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultTheme = PinTheme(
      width: 55,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
    );

    final focusedTheme = defaultTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.25),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
    );

    final errorTheme = defaultTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.redAccent, width: 1.8),
      ),
    );

    return Form(
      key: formKey,
      child: Column(
        children: [
          Pinput(
            controller: otpController,
            length: 6,
            defaultPinTheme: defaultTheme,
            focusedPinTheme: focusedTheme,
            errorPinTheme: errorTheme,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "OTP cannot be empty";
              }
              if (value.length != 6) {
                return "Enter complete 6-digit OTP";
              }
              return null;
            },
            errorBuilder: (errorText, otp) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorText ?? "",
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          TextButton.icon(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  final user = await _auth.verifyOtp(
                    verificationId: widget.verificationId,
                    smsCode: otpController.text.trim(),
                  );
                  if (user != null && mounted) {
                    Navigator.pushReplacement(
                      context,
                      //we pass to home screen for test that otp is working or not
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              }
            },
            icon: const Icon(Icons.verified, color: Colors.white, size: 20),
            label: Text(
              'Verify OTP',
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.35),
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 35),
            ),
          ),
        ],
      ),
    );
  }
}
