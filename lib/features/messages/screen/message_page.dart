import 'package:flutter/material.dart';
import 'package:talkter/widgets/bg_design/bg_design.dart';

class MessageScreen extends StatefulWidget {
  final String name;
  final String? profilePic;
  const MessageScreen({super.key, required this.name, this.profilePic});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BGDesign(),
        Scaffold(backgroundColor: Colors.transparent),
      ],
    );
  }
}
