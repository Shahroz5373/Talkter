import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talkter/Services/friends_service/friends_service.dart';
import 'package:talkter/screens/home/search/search_user_tile/search_user_tile.dart';
import 'package:talkter/widgets/snack_bar/snack_bar.dart';

class SearchScreen extends StatefulWidget {
  final String currentUserPhone;

  const SearchScreen({super.key, required this.currentUserPhone});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _countryCodeController = TextEditingController(
    text: "92",
  );
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FriendsService _friendsService = FriendsService();

  bool _isLoading = false;
  Map<String, dynamic>? _searchedUserData;
  FriendshipStatus _friendshipStatus = FriendshipStatus.none;

  @override
  void dispose() {
    _countryCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _formatPhoneNumber(String countryCode, String phone) {
    String cleanCountry = countryCode.replaceAll(RegExp(r'[^0-9]'), '');
    String cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    return '+$cleanCountry$cleanPhone';
  }

  Future<void> _performSearch() async {
    FocusScope.of(context).unfocus();

    if (_countryCodeController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      AppSnackBar.warning(
        context,
        title: "Missing Info",
        Message: "Please enter both country code and phone number.",
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _searchedUserData = null;
    });

    try {
      final formattedPhone = _formatPhoneNumber(
        _countryCodeController.text,
        _phoneController.text,
      );

      final userDoc = await _firestore
          .collection('users')
          .doc(formattedPhone)
          .get();

      if (!userDoc.exists) {
        setState(() => _isLoading = false);
        if (mounted) {
          AppSnackBar.failure(
            context,
            title: "Not Found",
            Message: "No user found with the number $formattedPhone.",
          );
        }
        return;
      }

      FriendshipStatus status = FriendshipStatus.none;

      if (formattedPhone == widget.currentUserPhone) {
        status = FriendshipStatus.self;
      } else {
        final friendDoc = await _firestore
            .collection('users')
            .doc(widget.currentUserPhone)
            .collection('friends')
            .doc(formattedPhone)
            .get();

        if (friendDoc.exists) {
          status = FriendshipStatus.friends;
        } else {
          final pendingDoc = await _firestore
              .collection('users')
              .doc(formattedPhone)
              .collection('friend_requests')
              .doc(widget.currentUserPhone)
              .get();

          if (pendingDoc.exists) {
            status = FriendshipStatus.pending;
          }
        }
      }

      setState(() {
        _searchedUserData = userDoc.data();
        _friendshipStatus = status;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        AppSnackBar.failure(
          context,
          title: "Error",
          Message: "An error occurred while searching. Please try again.",
        );
      }
    }
  }

  Future<void> _handleFriendAction() async {
    if (_searchedUserData == null) return;

    final targetPhone = _searchedUserData!['phone'];

    try {
      if (_friendshipStatus == FriendshipStatus.none) {
        await _friendsService.sendFriendRequest(
          myPhoneNo: widget.currentUserPhone,
          friendPhoneNo: targetPhone,
        );

        setState(() => _friendshipStatus = FriendshipStatus.pending);

        if (mounted) {
          AppSnackBar.success(
            context,
            title: "Request Sent",
            Message: "Friend request sent to ${_searchedUserData!['name']}!",
          );
        }
      } else if (_friendshipStatus == FriendshipStatus.pending) {
        await _friendsService.removeOrRejectFriend(
          userPhone: widget.currentUserPhone,
          friendPhone: targetPhone,
        );

        setState(() => _friendshipStatus = FriendshipStatus.none);

        if (mounted) {
          AppSnackBar.warning(
            context,
            title: "Request Cancelled",
            Message: "You cancelled the friend request.",
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.failure(
          context,
          title: "Action Failed",
          Message: e.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Find Friends",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Search by phone number to connect.",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.cyanAccent.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "+",
                        style: TextStyle(
                          color: Colors.cyanAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 45,
                        child: TextField(
                          controller: _countryCodeController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.cyanAccent.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone Number",
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      onSubmitted: (_) => _performSearch(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _performSearch,
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.cyanAccent, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withValues(alpha: 0.2),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              color: Colors.cyanAccent,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Icon(
                            Icons.search_rounded,
                            color: Colors.cyanAccent,
                            size: 26,
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Expanded(child: _buildResultsArea()),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsArea() {
    if (_isLoading) {
      return const Center(child: SizedBox.shrink());
    }

    if (_searchedUserData == null) {
      return Center(
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
              "Search for someone to chat with",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14, bottom: 10),
          child: Text(
            "Result",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SearchUserTile(
          name: _searchedUserData!['name'] ?? 'Unknown User',
          username: _searchedUserData!['username'] ?? 'no_username',
          profilePicUrl: _searchedUserData!['profile_pic_url'],
          status: _friendshipStatus,
          onActionButtonPressed: _handleFriendAction,
        ),
      ],
    );
  }
}
