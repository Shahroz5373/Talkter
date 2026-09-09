import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:talkter/features/messages/riverpod/messages_provider/messages_provider.dart';
import 'package:talkter/widgets/bg_design/bg_design.dart';

class MessageScreen extends ConsumerStatefulWidget {
  final String friendId; // ADDED: We need this for the provider!
  final String friendName;
  final String? profilePic;

  const MessageScreen({
    super.key,
    required this.friendId,
    required this.friendName,
    this.profilePic,
  });

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

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
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    int hour = time.hour > 12
        ? time.hour - 12
        : (time.hour == 0 ? 12 : time.hour);
    String minute = time.minute.toString().padLeft(2, '0');
    String amPm = time.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $amPm";
  }

  @override
  Widget build(BuildContext context) {
    // 1. Watch your provider using the friendId
    final messagesAsyncValue = ref.watch(
      messagesProviderProvider(friendId: widget.friendId),
    );

    return Stack(
      children: [
        const BGDesign(),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: _buildGlassAppBar(),
          body: Column(
            children: [
              Expanded(
                // 2. Handle the Riverpod AsyncValue states
                child: messagesAsyncValue.when(
                  data: (messages) {
                    if (messages.isEmpty) {
                      return Center(
                        child: Text(
                          "Say hi to ${widget.friendName}!",
                          style: const TextStyle(color: Colors.white54),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 100, bottom: 20),
                      itemCount: messages.length,
                      // If your stream returns newest messages last, you might want to reverse this
                      itemBuilder: (context, index) {
                        final msgData = messages[index];
                        return _buildMessageBubble(msgData);
                      },
                    );
                  },
                  loading: () => const Center(
                    child: SpinKitCircle(color: Colors.cyanAccent, size: 40),
                  ),
                  error: (error, stack) => Center(
                    child: Text(
                      'Error loading messages: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
              _buildFloatingInput(),
            ],
          ),
        ),
      ],
    );
  }

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
          child: Icon(Icons.lock_outline, color: Colors.white38, size: 18),
        ),
      ],
    );
  }

  // 3. Map the real data to the UI bubble
  Widget _buildMessageBubble(Map<String, dynamic> msgData) {
    final text = msgData['text'] as String;
    final isMe = msgData['isMe'] as bool;
    final model = msgData['model']; // Your MessageServiceModel

    // Fallback time if model structure differs slightly
    final timeString = model != null && model.timestamp != null
        ? _formatTime(model.timestamp)
        : "";

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? Colors.cyan.withOpacity(0.15)
              : Colors.white.withOpacity(0.08),
          border: isMe
              ? Border.all(color: Colors.cyan.withOpacity(0.4), width: 1)
              : Border.all(color: Colors.white12, width: 1),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe
                ? const Radius.circular(20)
                : const Radius.circular(0),
            bottomRight: isMe
                ? const Radius.circular(0)
                : const Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeString,
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                ),
                if (isMe) ...[
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
                          ? () async {
                              // 4. Trigger the sendMessage function!
                              final text = _messageController.text;
                              _messageController.clear();

                              try {
                                await ref
                                    .read(
                                      messagesProviderProvider(
                                        friendId: widget.friendId,
                                      ).notifier,
                                    )
                                    .sendMessage(text);

                                // Optional: Auto-scroll to bottom after sending
                                if (_scrollController.hasClients) {
                                  _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                }
                              } catch (e) {
                                // Handle error silently or show a snackbar
                                debugPrint("Failed to send: $e");
                              }
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
