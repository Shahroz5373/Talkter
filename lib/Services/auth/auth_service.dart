import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerWithPhone({
    required String phoneNum,
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException error) onVerificationFailed,
  }) async {
    debugPrint('📱 Sending phone to Firebase: $phoneNum');

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNum,

      verificationCompleted: (PhoneAuthCredential credential) async {
        debugPrint('Verification completed automatically');

        try {
          await _auth.signInWithCredential(credential);
        } on FirebaseAuthException catch (e) {
          onVerificationFailed(e);
        }
      },

      verificationFailed: (FirebaseAuthException e) {
        debugPrint('Firebase verification failed');
        debugPrint('Code: ${e.code}');
        debugPrint('Message: ${e.message}');

        onVerificationFailed(e);
      },

      codeSent: (String verificationId, int? resendToken) {
        debugPrint('OTP SENT');
        debugPrint('Verification ID: $verificationId');

        onCodeSent(verificationId);
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint(' Auto retrieval timeout');
      },
    );
  }

  Future<AppUser?> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential result = await _auth.signInWithCredential(credential);

      return _userFromFirebase(result.user);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  AppUser? _userFromFirebase(User? user) {
    return user == null ? null : AppUser(userId: user.uid);
  }

  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }
}

class AppUser {
  String userId;

  AppUser({required this.userId});
}
