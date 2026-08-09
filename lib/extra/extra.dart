// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:talkter/Services/auth/auth_service.dart';
// import 'package:talkter/Services/riverpod/user_notifier.dart';
// import 'package:talkter/designs/bg_design/bg_design.dart';
// import 'package:talkter/designs/glassmorphic_cotainer/glassmorphic_container.dart';
// import 'package:talkter/models/user_info.dart';
// import 'package:talkter/screens/user_registeration/OTP/otp_verify/verify_otp.dart';
// import 'package:talkter/screens/user_registeration/Phone/input/phone_no_input.dart';
// import 'package:talkter/screens/user_registeration/user_data/user_data.dart';

// class Register extends ConsumerStatefulWidget {
//   const Register({super.key});

//   @override
//   ConsumerState<Register> createState() => _RegisterState();
// }

// class _RegisterState extends ConsumerState<Register> {
//   String phone = '';
//   int numLen = 0;
//   bool isPhoneValid = false;
//   bool isloading = false;
//   final AuthService _auth = AuthService();
//   final _nameController = TextEditingController();
//   final _mailController = TextEditingController();
//   final _userInfoFormKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     ref.watch(userProvider);
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           const BGDesign(),
//           Center(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.only(
//                 top: 50,
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Talkter ',
//                     style: GoogleFonts.dancingScript(
//                       textStyle: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 40,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Center(
//                     child: GlassMorphicContainer(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           UserData(
//                             nameController: _nameController,
//                             mailController: _mailController,
//                             formKey: _userInfoFormKey,
//                           ),

//                           RegisterPhone(
//                             onPhoneChanged: (value) =>
//                                 setState(() => phone = value),
//                             onValidationChanged: (value) =>
//                                 setState(() => isPhoneValid = value),
//                           ),
//                           SizedBox(height: 10),

//                           isloading
//                               ? SpinKitThreeBounce(
//                                   color: Colors.white,
//                                   size: 20,
//                                 )
//                               : registerButton(context),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   TextButton registerButton(BuildContext context) {
//     return TextButton.icon(
//       onPressed: () async {
//         if (!_userInfoFormKey.currentState!.validate()) {
//           return;
//         }
//         if (phone.isEmpty || !isPhoneValid) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text("Enter a valid phone number")));
//           return;
//         }
//         setState(() => isloading = true);

//         _auth.registerWithPhone(
//           phoneNum: phone,
//           onCodeSent: (verifyId) {
//             setState(() => isloading = false);

//             ref
//                 .read(userProvider.notifier)
//                 .setUser(
//                   UserInfo(
//                     name: _nameController.text.trim(),
//                     email: _mailController.text.trim(),
//                     phone: phone,
//                   ),
//                 );

//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => VerifyOtp(verificationId: verifyId),
//               ),
//             );
//           },
//         );
//       },
//       icon: Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
//       style: TextButton.styleFrom(
//         backgroundColor: Colors.white.withValues(alpha: 0.4),
//         padding: EdgeInsets.symmetric(vertical: 13, horizontal: 35),
//       ),
//       label: Text(
//         'Continue',
//         style: GoogleFonts.inter(
//           textStyle: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }
