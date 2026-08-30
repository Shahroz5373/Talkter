import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talkter/Services/friends_action_service/friends_action_service.dart';
import 'package:talkter/Services/friends_service/friends_service.dart';
import 'package:talkter/widgets/glassmorphic_cotainer/glassmorphic_container.dart';
import 'package:talkter/widgets/snack_bar/snack_bar.dart';

class FriendRequestTile extends StatefulWidget {
  final FriendModel friend; // Replace 'dynamic' with 'FriendModel'

  const FriendRequestTile({super.key, required this.friend});

  @override
  State<FriendRequestTile> createState() => _FriendRequestTileState();
}

class _FriendRequestTileState extends State<FriendRequestTile> {
  final FriendsActionService _actionService = FriendsActionService();
  bool _isLoading = false;

  Future<void> _handleAccept() async {
    final myPhoneNo = FirebaseAuth.instance.currentUser?.phoneNumber;
    if (myPhoneNo == null) return;

    setState(() => _isLoading = true);
    try {
      await _actionService.acceptFriendRequest(
        receiverPhone: myPhoneNo,
        senderPhone: widget.friend.phone,
      );

      if (mounted) {
        AppSnackBar.success(
          context,
          title: 'Accepted',
          Message: 'You are now friends with ${widget.friend.name}',
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.failure(
          context,
          title: 'Error',
          Message: e.toString().replaceAll("Exception: ", ""),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleReject() async {
    final myPhoneNo = FirebaseAuth.instance.currentUser?.phoneNumber;
    if (myPhoneNo == null) return;

    setState(() => _isLoading = true);
    try {
      await _actionService.removeOrRejectFriend(
        userPhone: myPhoneNo,
        friendPhone: widget.friend.phone,
      );
      // No success snackbar needed for rejecting, it just quietly disappears
    } catch (e) {
      if (mounted) {
        AppSnackBar.failure(
          context,
          title: 'Error',
          Message: e.toString().replaceAll("Exception: ", ""),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 16,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.cyanAccent.withValues(alpha: 0.04),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: GlassMorphicContainer(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // --- GLOWING AVATAR ---
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.cyanAccent.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withValues(alpha: 0.15),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    backgroundImage:
                        (widget.friend.profilePicUrl != null &&
                            widget.friend.profilePicUrl!.isNotEmpty)
                        ? NetworkImage(widget.friend.profilePicUrl!)
                        : null,
                    child:
                        (widget.friend.profilePicUrl == null ||
                            widget.friend.profilePicUrl!.isEmpty)
                        ? Text(
                            widget.friend.name.isNotEmpty
                                ? widget.friend.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                ),

                const SizedBox(width: 14),

                // --- NAME & USERNAME ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.friend.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "@${widget.friend.username}",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // --- ACTION BUTTONS (OR LOADER) ---
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.cyanAccent,
                      ),
                    ),
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Reject Button (Subtle Red)
                      GestureDetector(
                        onTap: _handleReject,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.redAccent.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Accept Button (Bold Cyan)
                      GestureDetector(
                        onTap: _handleAccept,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.cyanAccent.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyanAccent.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.black, // High contrast against cyan
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
