import 'dart:typed_data';

import 'package:talkter/services/encryption/e2e/e2e.dart';

class EncryptionService {
  final E2E encryption;

  EncryptionService(this.encryption);

  Map<String, Uint8List> encryptMessage({
    required String message,
    required Uint8List receiverPublicKey,
  }) {
    return encryption.encrypt(
      message: message,
      receiverPublicKey: receiverPublicKey,
    );
  }

  String decryptMessage({
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
