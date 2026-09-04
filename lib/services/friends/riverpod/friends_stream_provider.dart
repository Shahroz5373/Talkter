import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talkter/services/friends/friends_service_model/friends_service_model.dart';

part 'friends_stream_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<List<FriendModel>> friendsStream(Ref ref) {
  final myPhoneNo = FirebaseAuth.instance.currentUser?.phoneNumber;

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
        final friends = snapshot.docs.map((doc) async {
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

        final friendsData = await Future.wait(friends);

        return friendsData.whereType<FriendModel>().toList();
      });
}
