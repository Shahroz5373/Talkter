import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talkter/widgets/message_tile/message_tile.dart';

class ChatTestScreen extends StatefulWidget {
  const ChatTestScreen({super.key});

  @override
  State<ChatTestScreen> createState() => _ChatTestScreenState();
}

class _ChatTestScreenState extends State<ChatTestScreen> {
  void _handleReply(String messageText) {
    // This is where you will eventually trigger your Riverpod state
    // to show the "Replying to..." box above your text field.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.cyanAccent.withValues(alpha: 0.2),
        content: Text(
          'Replying to: $messageText',
          style: const TextStyle(color: Colors.cyanAccent),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dark background to make the glassmorphism pop
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Chat UI Test',
          style: GoogleFonts.inter(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            // 1. Receiver Message (Left side)
            SwipeToReply(
              onReply: () => _handleReply(
                "Hey bro, how is the new Talkter update coming along?",
              ),
              child: const GlassMessageTile(
                message: "Hey bro, how is the new Talkter update coming along?",
                time: "10:42 AM",
                isSender: false,
              ),
            ),

            const SizedBox(height: 10),

            // 2. Sender Message (Right side)
            SwipeToReply(
              onReply: () => _handleReply(
                "Just added the glassmorphic swipe-to-reply feature. It looks insane!",
              ),
              child: const GlassMessageTile(
                message:
                    "Just added the glassmorphic swipe-to-reply feature. It looks insane!",
                time: "10:44 AM",
                isSender: true,
              ),
            ),

            const SizedBox(height: 10),

            // 3. Short Receiver Message
            SwipeToReply(
              onReply: () => _handleReply("Send a screenshot!"),
              child: const GlassMessageTile(
                message: "Send a screenshot!",
                time: "10:45 AM",
                isSender: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
