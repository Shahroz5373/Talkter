import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:talkter/designs/bg_design/bg_design.dart';
import 'package:talkter/firebase_options.dart';
//import 'package:talkter/screens/user_registeration/registration/page/register_page.dart';
import 'package:talkter/screens/user_registeration/user_info/user_info.dart';
// import 'package:talkter/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.transparent,
      debugShowCheckedModeBanner: false,
      //home: HomeScreen(),
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [BGDesign(), UserInfoPage()]),
      ),
    );
  }
}
