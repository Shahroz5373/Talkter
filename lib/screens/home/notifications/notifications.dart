import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talkter/services/friends/riverpod/friends_stream_provider.dart';
import 'package:talkter/screens/home/notifications/friend_req_tile/friend_req_tile.dart';

class Notifications extends ConsumerWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsyncValue = ref.watch(friendsStreamProvider);

    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 10, bottom: 20),
            child: Center(
              child: Text(
                'Friend Requests',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          Expanded(
            child: friendsAsyncValue.when(
              data: (allFriends) {
                final pendingRequests = allFriends
                    .where((friend) => friend.status == 'pending')
                    .toList();

                if (pendingRequests.isEmpty) {
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
                              color: Colors.cyanAccent.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            size: 60,
                            color: Colors.cyanAccent.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "No new requests",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "When someone adds you, it will appear here.",
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
                  padding: const EdgeInsets.only(bottom: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: pendingRequests.length,
                  itemBuilder: (context, index) {
                    final friend = pendingRequests[index];
                    return FriendRequestTile(friend: friend);
                  },
                );
              },

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
          ),
        ],
      ),
    );
  }
}
