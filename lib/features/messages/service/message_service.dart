import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talkter/features/messages/model/message_service_model/message_service_model.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage({required MessageServiceModel message}) async {
    final chatDocId = _generateDocId(
      userA: message.senderId,
      userB: message.receiverId,
    );

    final chatDocRef = _firestore.collection('chats').doc(chatDocId);

    final messageDocRef = chatDocRef.collection('messages').doc();

    final batch = _firestore.batch();

    batch.set(chatDocRef, {
      'participants': [message.senderId, message.receiverId],
      'lastActivity': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    batch.set(messageDocRef, message.toFirestore());

    await batch.commit();
  }

  String _generateDocId({required String userA, required String userB}) {
    final firstUser = userA.trim();
    final secondUser = userB.trim();

    if (firstUser.isEmpty || secondUser.isEmpty) {
      throw ArgumentError("Phone numbers can't be empty");
    }

    if (firstUser == secondUser) {
      throw ArgumentError("A user can't create a chat with themselves");
    }

    final participants = [firstUser, secondUser]..sort();

    return '${participants[0]}_${participants[1]}';
  }

  Stream<List<MessageServiceModel>> receieveMessage({
    required String myId,
    required String friendId,
  }) {
    final chatDocId = _generateDocId(userA: myId, userB: friendId);
    return _firestore
        .collection('chats')
        .doc(chatDocId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return MessageServiceModel.fromFirestore(doc);
          }).toList();
        });
  }
}
