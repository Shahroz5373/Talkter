import 'dart:convert';
import 'dart:typed_data';
import 'package:sodium/sodium_sumo.dart';
import 'package:talkter/features/messages/model/message_service_model/message_service_model.dart';
import 'package:talkter/features/messages/service/message_service.dart';
import 'package:talkter/services/encryption/e2e/e2e.dart';
import 'package:talkter/services/encryption/keys/key_generation.dart';
import 'package:talkter/services/encryption/service/e2e_service.dart';

class MessageControllerModel {
  final dynamic _myId;
  final dynamic _friendId;

  MessageControllerModel({required this._myId, required this._friendId});

  Future<void> sendEncryptedMessage({
    required String message,
    required SecureKey? myPrivateKey,
    required Uint8List? friendPublicKey,
  }) async {
    if (myPrivateKey == null) throw Exception('Your private key is missing');
    if (friendPublicKey == null) throw Exception('Friend public key not found');

    final sodiumData = await KeyGeneration.generate();
    final loadEncryptionService = E2E(
      sodium: sodiumData.sodium,
      myPrivateKey: myPrivateKey,
    );
    final encryptionService = EncryptionService(loadEncryptionService);

    final cipherData = encryptionService.encryptMessage(
      message: message,
      receiverPublicKey: friendPublicKey,
    );
    if (cipherData.isEmpty) throw Exception('No cipher');
    final cipherBytes = cipherData['cipher'];
    final nonceBytes = cipherData['nonce'];

    if (cipherBytes == null || nonceBytes == null) {
      throw Exception('Encryption failed');
    }

    final cipher = base64Encode(cipherBytes);
    final nonce = base64Encode(nonceBytes);
    final messageData = MessageServiceModel(
      senderId: _myId,
      receiverId: _friendId,
      nonce: nonce,
      cipherText: cipher,
      timestamp: DateTime.now(),
      messageStatus: MessageStatus.sent,
    );

    await MessageService().sendMessage(message: messageData);
  }

  Stream<List<Map<String, dynamic>>> getDecryptedMessagesStream({
    required SecureKey? myPrivateKey,
    required Uint8List? friendPublicKey,
  }) async* {
    if (myPrivateKey == null) throw Exception('Your private key is missing');
    if (friendPublicKey == null) throw Exception('Friend public key not found');

    final sodiumData = await KeyGeneration.generate();
    final loadDecryptionService = E2E(
      sodium: sodiumData.sodium,
      myPrivateKey: myPrivateKey,
    );
    final decryptionService = EncryptionService(loadDecryptionService);

    final messagesStream = MessageService().receieveMessage(
      myId: _myId,
      friendId: _friendId,
    );

    await for (final messages in messagesStream) {
      final decryptedMessages = messages.map((msg) {
        final nonce = base64Decode(msg.nonce);
        final cipher = base64Decode(msg.cipherText);

        String plainText;
        try {
          plainText = decryptionService.decryptMessage(
            cipher: cipher,
            nonce: nonce,
            senderPublicKey: friendPublicKey,
          );
        } catch (e) {
          plainText = "Error decrypting message";
        }

        return {'model': msg, 'text': plainText, 'isMe': msg.senderId == _myId};
      }).toList();

      yield decryptedMessages;
    }
  }
}
