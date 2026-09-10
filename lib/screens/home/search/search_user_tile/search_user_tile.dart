import 'package:flutter/material.dart';
import 'package:talkter/widgets/glassmorphic_cotainer/glassmorphic_container.dart';

enum FriendshipStatus { none, pending, friends, self }

class SearchUserTile extends StatelessWidget {
  final String name;
  final String username;
  final String phoneNumber;
  final String? profilePicUrl;
  final FriendshipStatus status;
  final VoidCallback? onActionButtonPressed;
  final VoidCallback? onTap;

  const SearchUserTile({
    super.key,
    required this.name,
    required this.username,
    required this.phoneNumber,
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
                      radius:
                          28, // Slightly larger to balance the 3 lines of text
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
                                fontSize: 22,
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
                        const SizedBox(height: 3),
                        Text(
                          "@$username",
                          style: TextStyle(
                            color: Colors.cyanAccent.withValues(
                              alpha: 0.8,
                            ), // Highlighted username
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        // --- PHONE NUMBER SECTION ---
                        Row(
                          children: [
                            Icon(
                              Icons.phone_android_rounded,
                              size: 12,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                phoneNumber,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

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
    Color? bgColor;
    Color textColor;
    Color borderColor;
    Gradient? buttonGradient;
    List<BoxShadow>? buttonShadow;

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
        textColor = Colors.black;
        borderColor = Colors.transparent; // No border for the add button

        // Use a sleek gradient instead of a solid color to make it unique
        buttonGradient = const LinearGradient(
          colors: [Colors.cyanAccent, Colors.cyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

        // Tighter, cleaner shadow to avoid the "bleeding" effect
        buttonShadow = [
          BoxShadow(
            color: Colors.cyanAccent.withValues(
              alpha: 0.25,
            ), // Much lower alpha
            blurRadius: 4, // Tighter blur
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ];
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
            gradient: buttonGradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: buttonShadow,
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
