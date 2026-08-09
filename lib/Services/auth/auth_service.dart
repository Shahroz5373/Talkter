import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerWithPhone({
    required String phoneNum,
    required Function(String verificationId) onCodeSent,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNum,

      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },

      verificationFailed: (FirebaseAuthException e) {
        throw e.message ?? "Phone verification failed";
      },

      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },

      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // verify OTP
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
      throw e.message ?? "Invalid OTP!";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // gets user id
  AppUser? _userFromFirebase(User? user) {
    return user == null ? null : AppUser(userId: user.uid);
  }

  // stream (for Riverpod)
  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }
}

class AppUser {
  String userId;

  AppUser({required this.userId});
}
