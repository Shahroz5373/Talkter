import 'package:flutter/material.dart';
import 'package:talkter/constants/bg/bg.dart';
import 'package:talkter/constants/glass_container/glassmorphic_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            BGDesign(),
            Center(
              child: GlassMorphicContainer(
                child: Text("""

jhon wick 


""", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
