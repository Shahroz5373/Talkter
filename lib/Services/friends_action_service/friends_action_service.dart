import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsActionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      if (!receiverDoc.exists) throw Exception("User does not exist");

      // Check current relationship status
      final myFriendDoc = await _firestore
          .collection('users')
          .doc(myPhone)
          .collection('friends')
          .doc(friendPhone)
          .get();

      if (myFriendDoc.exists) {
        final status = myFriendDoc.data()?['status'];
        if (status == 'accepted') throw Exception("You are already friends");
        if (status == 'requested') {
          throw Exception("Friend request already sent");
        }
        if (status == 'pending') {
          throw Exception(
            "This user already sent you a request. Check your pending requests!",
          );
        }
      }

      //Batch write for two-way sync
      final batch = _firestore.batch();

      final myRef = _firestore
          .collection('users')
          .doc(myPhone)
          .collection('friends')
          .doc(friendPhone);
      final friendRef = _firestore
          .collection('users')
          .doc(friendPhone)
          .collection('friends')
          .doc(myPhone);

      // What I see in my list
      batch.set(myRef, {
        'phone': friendPhone,
        'status': 'requested',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // What they see in their list
      batch.set(friendRef, {
        'phone': myPhone,
        'status': 'pending',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
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

      final myRef = _firestore
          .collection('users')
          .doc(myPhone)
          .collection('friends')
          .doc(friendPhone);
      final friendRef = _firestore
          .collection('users')
          .doc(friendPhone)
          .collection('friends')
          .doc(myPhone);

      // Verify the request is actually pending before accepting
      final requestDoc = await myRef.get();
      if (!requestDoc.exists || requestDoc.data()?['status'] != 'pending') {
        throw Exception("Friend request does not exist or was cancelled");
      }

      // Batch update both documents to 'accepted'
      final batch = _firestore.batch();

      batch.update(myRef, {
        'status': 'accepted',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      batch.update(friendRef, {
        'status': 'accepted',
        'updatedAt': FieldValue.serverTimestamp(),
      });

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

      // This elegantly handles un-friending, rejecting a request, AND canceling a sent request
      final myRef = _firestore
          .collection('users')
          .doc(myPhone)
          .collection('friends')
          .doc(targetPhone);
      final friendRef = _firestore
          .collection('users')
          .doc(targetPhone)
          .collection('friends')
          .doc(myPhone);

      batch.delete(myRef);
      batch.delete(friendRef);

      await batch.commit();
    } catch (e) {
      throw Exception("Failed to remove/reject friend: $e");
    }
  }
}
