// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// import 'dart:ui';

// import 'package:talkter/Services/riverpod/user_stream/stream_riverpod.dart';
// import 'package:talkter/constants/custom_error_widget.dart';
// import 'package:talkter/screens/home/home_screen.dart';
// import 'package:talkter/screens/user_registeration/registration/register.dart';

// class Wrapper extends ConsumerWidget {
//   const Wrapper({super.key});

//   Future<void> _refreshUser() async {
//     await FirebaseAuth.instance.currentUser?.reload();
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return FutureBuilder(
//       future: _refreshUser(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Loading(
//             child: Center(
//               child: SpinKitFadingCircle(size: 80, color: Colors.white),
//             ),
//           );
//         }
//         final userState = ref.watch(userStateProvider);

//         return userState.when(
//           data: (user) => user == null ? RegisterPage() : HomeScreen(),
//           error: (error, stackTrace) =>
//               CustomErrorWidget(error: error.toString().trim()),
//           loading: () =>
//               Center(child: SpinKitDoubleBounce(size: 60, color: Colors.blue)),
//         );
//       },
//     );
//   }
// }

// class Loading extends StatelessWidget {
//   final Widget child;
//   const Loading({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         /// back image
//         Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF1B3038), Color(0xFF345763), Color(0xFF335969)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         Positioned(
//           top: 120,
//           left: -50,
//           child: Container(
//             height: 200,
//             width: 200,
//             decoration: BoxDecoration(
//               color: Colors.cyan.withValues(alpha: 0.5),
//               shape: BoxShape.circle,
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 70,
//           right: -50,
//           child: Container(
//             height: 200,
//             width: 200,
//             decoration: BoxDecoration(
//               color: Colors.indigoAccent.withValues(alpha: 0.5),
//               shape: BoxShape.circle,
//             ),
//           ),
//         ),

//         /// blur layer
//         BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
//           child: Container(color: Colors.transparent, child: child),
//         ),
//       ],
//     );
//   }
// }
