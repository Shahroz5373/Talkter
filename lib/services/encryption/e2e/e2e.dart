import 'dart:convert';
import 'dart:typed_data';

import 'package:sodium/sodium.dart';

class E2E {
  final Sodium sodium;
  final SecureKey myPrivateKey;

  E2E({required this.sodium, required this.myPrivateKey});

  Map<String, Uint8List> encrypt({
    required String message,
    required Uint8List receiverPublicKey,
  }) {
    final nonce = sodium.randombytes.buf(sodium.crypto.box.nonceBytes);

    final cipher = sodium.crypto.box.easy(
      message: Uint8List.fromList(utf8.encode(message)),
      nonce: nonce,
      publicKey: receiverPublicKey,
      secretKey: myPrivateKey,
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
      secretKey: myPrivateKey,
    );

    return utf8.decode(decrypted);
  }
}
