import 'package:flutter/material.dart';
import 'package:talkter/widgets/glassmorphic_cotainer/glassmorphic_container.dart';

enum FriendshipStatus { none, pending, friends, self }

class SearchUserTile extends StatelessWidget {
  final String name;
  final String username;
  final String? profilePicUrl;
  final FriendshipStatus status;
  final VoidCallback? onActionButtonPressed;
  final VoidCallback? onTap;

  const SearchUserTile({
    super.key,
    required this.name,
    required this.username,
    this.profilePicUrl,
    this.status = FriendshipStatus.none,
    this.onActionButtonPressed,
    this.onTap,
  });

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
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            splashColor: Colors.cyanAccent.withValues(alpha: 0.1),
            highlightColor: Colors.white.withValues(alpha: 0.05),
            onTap: onTap,
            child: GlassMorphicContainer(
              child: Row(
                children: [
                  // --- AVATAR SECTION ---
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
                          (profilePicUrl != null && profilePicUrl!.isNotEmpty)
                          ? NetworkImage(profilePicUrl!)
                          : null,
                      child: (profilePicUrl == null || profilePicUrl!.isEmpty)
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

                  const SizedBox(width: 14),

                  // --- TEXT INFO SECTION ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
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
                        const SizedBox(height: 4),
                        Text(
                          "@$username",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // --- ACTION BUTTON SECTION ---
                  if (status != FriendshipStatus.self) _buildActionButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Dynamic button builder based on the friendship status
  Widget _buildActionButton() {
    String text;
    IconData icon;
    Color bgColor;
    Color textColor;
    Color? borderColor;

    switch (status) {
      case FriendshipStatus.friends:
        text = "Friends";
        icon = Icons.check_rounded;
        bgColor = Colors.transparent;
        textColor = Colors.cyanAccent;
        borderColor = Colors.cyanAccent.withValues(alpha: 0.5);
        break;
      case FriendshipStatus.pending:
        text = "Pending";
        icon = Icons.access_time_rounded;
        bgColor = Colors.transparent;
        textColor = Colors.white.withValues(alpha: 0.7);
        borderColor = Colors.white.withValues(alpha: 0.3);
        break;
      case FriendshipStatus.none:
      default:
        text = "Add";
        icon = Icons.person_add_alt_1_rounded;
        bgColor = Colors.cyanAccent.withValues(alpha: 0.9);
        textColor = Colors.black;
        borderColor = Colors.cyanAccent;
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onActionButtonPressed,
        borderRadius: BorderRadius.circular(20),
        splashColor: (status == FriendshipStatus.none)
            ? Colors.white.withValues(alpha: 0.3)
            : Colors.cyanAccent.withValues(alpha: 0.2),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: borderColor != null ? Border.all(color: borderColor) : null,
            boxShadow: status == FriendshipStatus.none
                ? [
                    BoxShadow(
                      color: Colors.cyanAccent.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: textColor),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
