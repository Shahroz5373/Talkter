import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talkter/Services/friends_service/friends_service.dart';

part 'friends_stream_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<List<FriendModel>> friendsStream(Ref ref) {
  final myPhoneNo = FirebaseAuth.instance.currentUser?.phoneNumber;

  // If no user is logged in, yield an empty list instead of crashing
  if (myPhoneNo == null || myPhoneNo.isEmpty) {
    return Stream.value([]);
  }

  final firestore = FirebaseFirestore.instance;

  return firestore
      .collection('users')
      .doc(myPhoneNo)
      .collection('friends')
      .snapshots()
      .asyncMap((snapshot) async {
        // Create a list of Futures to fetch all user profiles simultaneously
        final futures = snapshot.docs.map((doc) async {
          final friendDocData = doc.data();
          final friendPhone = friendDocData['phone'] as String?;

          if (friendPhone == null || friendPhone.isEmpty) return null;

          final userDoc = await firestore
              .collection('users')
              .doc(friendPhone)
              .get();

          if (userDoc.exists) {
            return FriendModel.fromFirestore(
              friendDocData: friendDocData,
              userDocData: userDoc.data()!,
            );
          }
          return null;
        });

        // Wait for all profile fetches to complete
        final resolvedFriends = await Future.wait(futures);

        // Remove any nulls (in case a user doc was deleted but friendship remained)
        return resolvedFriends.whereType<FriendModel>().toList();
      });
}
