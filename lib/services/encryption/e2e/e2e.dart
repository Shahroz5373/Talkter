import 'dart:convert';
import 'dart:typed_data';

import 'package:sodium/sodium.dart';

class E2E {
  final Sodium sodium;
  final KeyPair myKeyPair;

  E2E({required this.sodium, required this.myKeyPair});

  Map<String, Uint8List> encrypt({
    required String message,
    required Uint8List receiverPublicKey,
  }) {
    final nonce = sodium.randombytes.buf(sodium.crypto.box.nonceBytes);

    final cipher = sodium.crypto.box.easy(
      message: Uint8List.fromList(utf8.encode(message)),
      nonce: nonce,
      publicKey: receiverPublicKey,
      secretKey: myKeyPair.secretKey,
    );

    return {'cipher': cipher, 'nonce': nonce};
  }

  String decrypt({
    required Uint8List cipher,
    required Uint8List nonce,
    required Uint8List senderPublicKey,
  }) {
    final decrypted = sodium.crypto.box.openEasy(
      cipherText: cipher,
      nonce: nonce,
      publicKey: senderPublicKey,
      secretKey: myKeyPair.secretKey,
    );

    return utf8.decode(decrypted);
  }
}
