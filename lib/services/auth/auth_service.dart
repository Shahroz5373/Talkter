import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // register the new user
  Future<void> registerWithPhoneNo({
    required String phoneNo,
    required void Function(String verificationId) onCodeSent,
    required void Function(UserCredential userCredential)
    onVerificationCompleted,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
        verificationCompleted: (PhoneAuthCredential credential) async{
          final userCredential = await _auth.signInWithCredential(credential);
          onVerificationCompleted(userCredential);
        },
        verificationFailed: (FirebaseAuthException e){
          throw e.message ?? "Phone verification Failed.";
        },
        codeSent: (String verificationId , int? resendToken ){
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId){}
    );

  }

  Future<UserCredential> verifyOTP({
    required String verificationId,
    required String smsCode,
  })async{
    try{
      final PhoneAuthCredential credential= PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode
      );
      return await _auth.signInWithCredential(credential);
    }on FirebaseAuthException catch (e){ throw e.message ?? "Invalid OTP!";}
  }

  Future<void> signout()async => await _auth.signOut();

  AppUser? _userfromFireBase(User? user)=>
      user == null? null : AppUser(userId: user.uid);

  Stream<AppUser?> get user => _auth.authStateChanges().map(_userfromFireBase);

}

class AppUser{
  String userId;
  AppUser({required this.userId});
}