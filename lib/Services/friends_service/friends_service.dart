import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> searchFriend(String phone) async {
    try {
      if (phone.trim().isEmpty) {
        return false;
      }

      final userDoc = await _firestore
          .collection('users')
          .doc(phone.trim())
          .get();

      return userDoc.exists;
    } catch (e) {
      throw Exception("Failed to search user: $e");
    }
  }

  Future<void> sendFriendRequest({
    required String myPhoneNo,
    required String friendPhoneNo,
  }) async {
    try {
      final myPhone = myPhoneNo.trim();
      final friendPhone = friendPhoneNo.trim();

      if (myPhone.isEmpty || friendPhone.isEmpty) {
        throw Exception("Phone number is missing");
      }

      if (myPhone == friendPhone) {
        throw Exception("You cannot send a friend request to yourself");
      }

      // Check if receiver exists
      final receiverDoc = await _firestore
          .collection('users')
          .doc(friendPhone)
          .get();
      if (!receiverDoc.exists) {
        throw Exception("User does not exist");
      }

      // Check if already friends
      final friendshipDoc = await _firestore
          .collection('users')
          .doc(myPhone)
          .collection('friends')
          .doc(friendPhone)
          .get();

      if (friendshipDoc.exists) {
        throw Exception("You are already friends");
      }

      // Check if you already sent them a request
      final sentRequestDoc = await _firestore
          .collection('users')
          .doc(friendPhone)
          .collection('friend_requests')
          .doc(myPhone)
          .get();

      if (sentRequestDoc.exists) {
        throw Exception("Friend request already sent");
      }

      // Check if they already sent YOU a request (prevent overlapping requests)
      final incomingRequestDoc = await _firestore
          .collection('users')
          .doc(myPhone)
          .collection('friend_requests')
          .doc(friendPhone)
          .get();

      if (incomingRequestDoc.exists) {
        throw Exception(
          "This user already sent you a request. Check your pending requests!",
        );
      }

      // Create nested request under the receiver's document
      await _firestore
          .collection('users')
          .doc(friendPhone)
          .collection('friend_requests')
          .doc(myPhone)
          .set({
            'phone': myPhone,
            'status': 'pending',
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception("Failed to send friend request: $e");
    }
  }

  Future<void> acceptFriendRequest({
    required String receiverPhone, // The one who is accepting (Current User)
    required String senderPhone, // The one who sent the request
  }) async {
    try {
      final myPhone = receiverPhone.trim();
      final friendPhone = senderPhone.trim();

      if (myPhone.isEmpty || friendPhone.isEmpty) {
        throw Exception("Phone number is missing");
      }

      final requestRef = _firestore
          .collection('users')
          .doc(myPhone)
          .collection('friend_requests')
          .doc(friendPhone);

      final requestDoc = await requestRef.get();

      if (!requestDoc.exists) {
        throw Exception("Friend request does not exist or was cancelled");
      }

      // Create friendship for both users using nested 'friends' subcollection
      final receiverFriendRef = _firestore
          .collection('users')
          .doc(myPhone)
          .collection('friends')
          .doc(friendPhone);

      final senderFriendRef = _firestore
          .collection('users')
          .doc(friendPhone)
          .collection('friends')
          .doc(myPhone);

      final batch = _firestore.batch();

      // We only store the phone number since it acts as the primary key
      // to fetch the user info later
      batch.set(receiverFriendRef, {
        'phone': friendPhone,
        'createdAt': FieldValue.serverTimestamp(),
      });

      batch.set(senderFriendRef, {
        'phone': myPhone,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Delete request after accepting
      batch.delete(requestRef);

      await batch.commit();
    } catch (e) {
      throw Exception("Failed to accept friend request: $e");
    }
  }

  Future<void> removeOrRejectFriend({
    required String userPhone,
    required String friendPhone,
  }) async {
    try {
      final myPhone = userPhone.trim();
      final targetPhone = friendPhone.trim();

      if (myPhone.isEmpty || targetPhone.isEmpty) {
        throw Exception("Phone number is missing");
      }

      final batch = _firestore.batch();

      // 1. Remove friendship from both users
      final userFriendRef = _firestore
          .collection('users')
          .doc(myPhone)
          .collection('friends')
          .doc(targetPhone);

      final targetUserFriendRef = _firestore
          .collection('users')
          .doc(targetPhone)
          .collection('friends')
          .doc(myPhone);

      // 2. Remove possible incoming request (rejecting)
      final incomingRequestRef = _firestore
          .collection('users')
          .doc(myPhone)
          .collection('friend_requests')
          .doc(targetPhone);

      // 3. Remove possible outgoing request (canceling)
      final outgoingRequestRef = _firestore
          .collection('users')
          .doc(targetPhone)
          .collection('friend_requests')
          .doc(myPhone);

      // Batch delete everything related to the relationship
      batch.delete(userFriendRef);
      batch.delete(targetUserFriendRef);
      batch.delete(incomingRequestRef);
      batch.delete(outgoingRequestRef);

      await batch.commit();
    } catch (e) {
      throw Exception("Failed to remove/reject friend: $e");
    }
  }
}
