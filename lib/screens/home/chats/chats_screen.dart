import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:talkter/features/messages/screen/message_page.dart';
import 'package:talkter/services/friends/riverpod/friends_stream_provider.dart';
import 'package:talkter/screens/home/chats/user_tile/user_tile.dart';

class ChatsScreen extends ConsumerWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsyncValue = ref.watch(friendsStreamProvider);

    return Container(
      color: Colors.transparent,
      child: friendsAsyncValue.when(
        data: (allFriends) {
          final acceptedFriends = allFriends
              .where((friend) => friend.status == 'accepted')
              .toList();

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

          return ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: acceptedFriends.length,

            itemBuilder: (context, index) {
              final friend = acceptedFriends[index];

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessageScreen(
                        friendId: friend.phone,
                        friendName: friend.name,
                        profilePic: friend.profilePicUrl,
                      ),
                    ),
                  );
                },
                child: ChatFriendTile(
                  name: friend.name,
                  profilePicUrl: friend.profilePicUrl,
                  lastMessage: "Tap to start a secure chat!",
                  time: "",
                  unreadCount: 0,
                  isOnline: false,
                ),
              );
            },
          );
        },

        loading: () => const Center(
          child: SizedBox(
            height: 40,
            width: 40,
            child: SpinKitCircle(color: Colors.cyanAccent, size: 20),
          ),
        ),

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
