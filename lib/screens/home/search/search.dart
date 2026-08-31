import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talkter/Services/friends_action_service/friends_action_service.dart';
import 'package:talkter/screens/home/search/search_user_tile/search_user_tile.dart';
import 'package:talkter/widgets/snack_bar/snack_bar.dart';
import 'package:talkter/screens/user_registeration/Phone/input/phone_no_input.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FriendsActionService _friendsService = FriendsActionService();

  // State variables for the phone input component
  String _searchInputPhone = '';
  bool _isSearchPhoneValid = false;

  bool _isLoading = false;
  Map<String, dynamic>? _searchedUserData;
  String _searchedPhone = '';
  FriendshipStatus _currentStatus = FriendshipStatus.none;

  Future<void> _performSearch() async {
    final String myPhoneNo =
        FirebaseAuth.instance.currentUser?.phoneNumber ?? '';

    if (myPhoneNo.isEmpty) {
      AppSnackBar.failure(
        context,
        title: 'Auth Error',
        Message: 'Could not get your phone number. Try logging in again.',
      );
      return;
    }

    if (_searchInputPhone.isEmpty || !_isSearchPhoneValid) {
      AppSnackBar.warning(
        context,
        title: 'Invalid Number',
        Message: 'Please enter a valid phone number with country code.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _searchedUserData = null;
    });

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_searchInputPhone)
          .get();

      if (userDoc.exists) {
        FriendshipStatus status = FriendshipStatus.none;

        if (_searchInputPhone == myPhoneNo) {
          status = FriendshipStatus.self;
        } else {
          // 4. Optimized single-read check for friendship status
          final friendDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(myPhoneNo)
              .collection('friends')
              .doc(_searchInputPhone)
              .get();

          if (friendDoc.exists) {
            final docStatus = friendDoc.data()?['status'];
            if (docStatus == 'accepted') {
              status = FriendshipStatus.friends;
            } else if (docStatus == 'requested' || docStatus == 'pending') {
              status = FriendshipStatus.pending;
            }
          }
        }

        setState(() {
          _searchedUserData = userDoc.data();
          _searchedPhone = _searchInputPhone;
          _currentStatus = status;
        });
      } else {
        AppSnackBar.failure(
          context,
          title: 'Not Found',
          Message: 'No user is registered with this phone number.',
        );
      }
    } catch (e) {
      AppSnackBar.failure(
        context,
        title: 'Error',
        Message: 'Something went wrong: $e',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Sends a friend request and updates UI
  Future<void> _sendRequest() async {
    final String myPhoneNo =
        FirebaseAuth.instance.currentUser?.phoneNumber ?? '';

    if (myPhoneNo.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _friendsService.sendFriendRequest(
        myPhoneNo: myPhoneNo,
        friendPhoneNo: _searchedPhone,
      );

      setState(() {
        _currentStatus = FriendshipStatus.pending;
      });

      AppSnackBar.success(
        context,
        title: 'Request Sent',
        Message: 'Friend request sent to $_searchedPhone.',
      );
    } catch (e) {
      AppSnackBar.failure(
        context,
        title: 'Failed',
        Message: e.toString().replaceAll("Exception: ", ""),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // --- CUSTOM HEADER ---
          Text(
            'Add Friends',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          // --- REUSABLE PHONE INPUT + SEARCH BUTTON ---
          RegisterPhone(
            onPhoneChanged: (phone) {
              setState(() {
                _searchInputPhone = phone;
              });
            },
            onValidationChanged: (isValid) {
              setState(() {
                _isSearchPhoneValid = isValid;
              });
            },
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: _isLoading ? null : _performSearch,
            child: Container(
              // 1. Added padding so the button has a nice clickable area
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.cyanAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.cyanAccent.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 70, // 2. Expanded width so the 3 dots have room
                      child: SpinKitThreeBounce(
                        color: Colors.cyanAccent,
                        size:
                            20, // 3. Scaled down the dots to fit inside the button
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.search,
                          color: Colors.cyanAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Search',
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: Colors.cyanAccent.withValues(alpha: 0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 30),

          if (_searchedUserData != null)
            SearchUserTile(
              name: _searchedUserData!['name'] ?? 'Unknown',
              username: _searchedUserData!['username'] ?? 'unknown',
              phoneNumber: _searchedPhone,
              profilePicUrl: _searchedUserData!['profile_pic_url'] ?? '',
              status: _currentStatus,
              onActionButtonPressed: () {
                if (_currentStatus == FriendshipStatus.none) {
                  _sendRequest();
                }
              },
            ),

          // Illustration or instruction text when empty
          if (_searchedUserData == null && !_isLoading)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_search_rounded,
                      size: 80,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Search for a friend via their phone number.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
