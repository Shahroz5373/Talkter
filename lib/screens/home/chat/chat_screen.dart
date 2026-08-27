import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkter/Services/friends_service/riverpod/friends_stream_provider.dart';
import 'package:talkter/screens/home/chat/user_tile/user_tile.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the real-time stream of friends
    final friendsAsyncValue = ref.watch(friendsStreamProvider);

    return Container(
      // Ensure the background is transparent so the parent Scaffold's background shows through
      color: Colors.transparent,
      child: friendsAsyncValue.when(
        data: (allFriends) {
          // Filter to ONLY show accepted friends on the chat screen
          final acceptedFriends = allFriends
              .where((friend) => friend.status == 'accepted')
              .toList();

          // --- EMPTY STATE ---
          if (acceptedFriends.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.cyanAccent.withValues(alpha: 0.05),
                      border: Border.all(
                        color: Colors.cyanAccent.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 60,
                      color: Colors.cyanAccent.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No chats yet",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Search for friends to start talking securely.",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          // --- FRIENDS LIST ---
          return ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: acceptedFriends.length,
            itemBuilder: (context, index) {
              final friend = acceptedFriends[index];

              return ChatFriendTile(
                name: friend.name,
                profilePicUrl: friend.profilePicUrl,
                // Placeholder values until you implement actual messaging:
                lastMessage: "Tap to start a secure chat!",
                time: "",
                unreadCount: 0,
                isOnline: false,
              );
            },
          );
        },

        // --- LOADING STATE ---
        loading: () => const Center(
          child: SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.cyanAccent,
            ),
          ),
        ),

        // --- ERROR STATE ---
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Something went wrong:\n$error",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.redAccent.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
