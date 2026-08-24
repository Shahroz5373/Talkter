import 'package:flutter/material.dart';
import 'package:talkter/widgets/glassmorphic_cotainer/glassmorphic_container.dart';

class ChatFriendTile extends StatelessWidget {
  final String name;
  final String? profilePicUrl;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final bool isMessageRead;
  final bool isSentByMe;

  const ChatFriendTile({
    super.key,
    required this.name,
    this.profilePicUrl,
    this.lastMessage = "Hey there! I am using Talkter.",
    this.time = "10:45 AM",
    this.unreadCount = 0,
    this.isOnline = false,
    this.isMessageRead = false,
    this.isSentByMe = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = unreadCount > 0;

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
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            splashColor: Colors.cyanAccent.withValues(alpha: 0.1),
            highlightColor: Colors.white.withValues(alpha: 0.05),

            child: GlassMorphicContainer(
              child: Row(
                children: [
                  Stack(
                    children: [
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
                              (profilePicUrl != null &&
                                  profilePicUrl!.isNotEmpty)
                              ? NetworkImage(profilePicUrl!)
                              : null,
                          child:
                              (profilePicUrl == null || profilePicUrl!.isEmpty)
                              ? Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                                  style: const TextStyle(
                                    color: Colors.cyanAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                      ),

                      if (isOnline)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00FFC2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.8),
                                width: 2.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF00FFC2,
                                  ).withValues(alpha: 0.6),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              time,
                              style: TextStyle(
                                color: hasUnread
                                    ? Colors.cyanAccent
                                    : Colors.white.withValues(alpha: 0.45),
                                fontSize: 12,
                                fontWeight: hasUnread
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 5),

                        Row(
                          children: [
                            if (isSentByMe) ...[
                              Icon(
                                Icons.done_all_rounded,
                                size: 16,
                                color: isMessageRead
                                    ? Colors.cyanAccent
                                    : Colors.white.withValues(alpha: 0.4),
                              ),
                              const SizedBox(width: 4),
                            ],

                            Expanded(
                              child: Text(
                                lastMessage,
                                style: TextStyle(
                                  color: hasUnread
                                      ? Colors.white.withValues(alpha: 0.95)
                                      : Colors.white.withValues(alpha: 0.5),
                                  fontSize: 13.5,
                                  fontWeight: hasUnread
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            if (hasUnread)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                margin: const EdgeInsets.only(left: 6),
                                decoration: BoxDecoration(
                                  color: Colors.cyanAccent.withValues(
                                    alpha: 0.9,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.cyanAccent.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  unreadCount > 99 ? "99+" : "$unreadCount",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
