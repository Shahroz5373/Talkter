import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkter/constants/test.dart';
import 'package:talkter/firebase_options.dart';
//import 'package:talkter/screens/home/home_screen.dart';
//import 'package:talkter/screens/user_registeration/registration/page/register_page.dart';
import 'package:talkter/wrapper/wrapper.dart';

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
      home: Wrapper(),
      //home: ChatTestScreen(),
    );
  }
}
