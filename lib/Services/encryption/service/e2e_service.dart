import 'dart:typed_data';

import 'package:talkter/Services/encryption/e2e/e2e.dart';

class EncryptionService {
  final E2E encryption;

  EncryptionService(this.encryption);

  Map<String, Uint8List> sendMessage({
    required String message,
    required Uint8List receiverPublicKey,
  }) {
    return encryption.encrypt(
      message: message,
      receiverPublicKey: receiverPublicKey,
    );
  }

  String receiveMessage({
    required Uint8List cipher,
    required Uint8List nonce,
    required Uint8List senderPublicKey,
  }) {
    return encryption.decrypt(
      cipher: cipher,
      nonce: nonce,
      senderPublicKey: senderPublicKey,
    );
  }
}
