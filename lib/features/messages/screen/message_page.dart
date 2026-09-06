import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:talkter/widgets/bg_design/bg_design.dart';

// Dummy message model for UI testing
class _Message {
  final String text;
  final bool isMe;
  final String time;
  _Message(this.text, this.isMe, this.time);
}

class MessageScreen extends StatefulWidget {
  final String friendName;
  final String? profilePic;

  const MessageScreen({super.key, required this.friendName, this.profilePic});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;

  // Dummy chat history
  final List<_Message> _messages = [
    _Message("Hey! Is the new encryption working?", false, "10:00 AM"),
    _Message("Yes! Everything is fully E2E encrypted now.", true, "10:02 AM"),
    _Message("Awesome. The new UI looks super clean too.", false, "10:05 AM"),
    _Message(
      "Thanks brother! Just finishing up the chat bubbles.",
      true,
      "10:06 AM",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        _isTyping = _messageController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BGDesign(),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar:
              true, // Lets messages scroll under the frosted glass
          appBar: _buildGlassAppBar(),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 100, bottom: 20),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return _buildMessageBubble(msg);
                  },
                ),
              ),
              _buildFloatingInput(),
            ],
          ),
        ),
      ],
    );
  }

  // 1. Frosted Glass App Bar
  PreferredSizeWidget _buildGlassAppBar() {
    return AppBar(
      backgroundColor: Colors.black.withOpacity(0.3),
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            backgroundImage: widget.profilePic != null
                ? NetworkImage(widget.profilePic!)
                : null,
            child: widget.profilePic == null
                ? const Icon(Icons.person, color: Colors.white70)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.friendName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.cyanAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent,
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Online",
                      style: TextStyle(color: Colors.cyanAccent, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(
            Icons.lock_outline,
            color: Colors.white38,
            size: 18,
          ), // E2E Indicator
        ),
      ],
    );
  }

  // 2. Message Bubbles
  Widget _buildMessageBubble(_Message msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: msg.isMe
              ? Colors.cyan.withOpacity(0.15)
              : Colors.white.withOpacity(0.08),
          border: msg.isMe
              ? Border.all(color: Colors.cyan.withOpacity(0.4), width: 1)
              : Border.all(color: Colors.white12, width: 1),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: msg.isMe
                ? const Radius.circular(20)
                : Radius.circular(0),
            bottomRight: msg.isMe
                ? Radius.circular(0)
                : const Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: msg.isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.time,
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                ),
                if (msg.isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.done_all,
                    color: Colors.cyanAccent,
                    size: 14,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 3. Floating Input Pill
  Widget _buildFloatingInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: _isTyping
                        ? [
                            const BoxShadow(
                              color: Colors.cyan,
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                  child: CircleAvatar(
                    backgroundColor: _isTyping ? Colors.cyan : Colors.white10,
                    child: IconButton(
                      icon: Icon(
                        Icons.send_rounded,
                        color: _isTyping ? Colors.black : Colors.white38,
                        size: 20,
                      ),
                      onPressed: _isTyping
                          ? () {
                              // Handle send logic here
                              _messageController.clear();
                            }
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
