import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talkter/screens/user_registeration/registration/riverpod/user_notifier/user_notifier.dart';
import 'package:talkter/widgets/glassmorphic_cotainer/glassmorphic_container.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<ProfileScreen> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    final userData = ref.read(userProvider);
    return GlassMorphicContainer(
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: Icon(Icons.person, color: Colors.white, size: 50),
                ),
                const SizedBox(height: 5),
                Text(
                  "${userData?.name ?? "User"}",
                  maxLines: 1,
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Contact Information",
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          GlassMorphicContainer(
            child: Row(
              children: [
                Icon(Icons.mail_outlined, color: Colors.white, size: 22),
                const SizedBox(width: 20),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Email\n${userData?.email ?? "user@gmail.com"}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GlassMorphicContainer(
            child: Row(
              children: [
                Icon(Icons.phone_outlined, color: Colors.white, size: 22),
                const SizedBox(width: 20),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Phone\n${userData?.phone ?? "+1234567890"}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Settings",
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          GlassMorphicContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 26,
                ),
                const SizedBox(width: 20),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Notifications",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 20),
                Switch(
                  value: isSwitched,
                  onChanged: (bool newValue) {
                    setState(() {
                      isSwitched = newValue;
                    });
                  },
                  activeThumbColor: Colors.white, // Thumb color when ON
                  activeTrackColor: Colors.greenAccent, // Track color when ON
                  inactiveThumbColor: Colors.redAccent, // Thumb color when OFF
                  inactiveTrackColor: Colors.white.withValues(
                    alpha: 0.7,
                  ), // Track color when OFF
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          TextButton.icon(
            onPressed: () {},
            label: Text(
              "Edit Profile",
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            icon: Icon(Icons.edit_outlined, color: Colors.white, size: 20),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 35),
            ),
          ),
        ],
      ),
    );
  }
}
