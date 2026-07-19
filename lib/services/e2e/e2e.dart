import 'dart:typed_data';
import 'package:sodium/sodium.dart';

class KeyGeneration {
  static final KeyGeneration _instance = KeyGeneration._internal();

  late final Sodium _sodium;
  late final KeyPair _keypair;

  bool _initialized = false;

  KeyGeneration._internal();

  static Future<KeyGeneration> generate() async {
    if (!_instance._initialized) {
      await _instance._initSodium();
      _instance._initialized = true;
    }
    return _instance;
  }

  Future<void> _initSodium() async {
    _sodium = await SodiumInit.init();
    _keypair = _sodium.crypto.box.keyPair();
  }

  // Uint8List get publicKey => _keypair.publicKey;
  // SecureKey get privateKey => _keypair.secretKey;
  Sodium get sodium => _sodium;
  KeyPair get keys => _keypair;
}

class E2E {
  final Sodium sodium;
  final KeyPair myKeyPair;
  final Uint8List
  otherPublicKey; // receiver (for encrypt) or sender (for decrypt)

  E2E({
    required this.sodium,
    required this.myKeyPair,
    required this.otherPublicKey,
  });

  //encryptt msg
  Map<String, Uint8List> encrypt(String message) {
    final nonce = sodium.randombytes.buf(sodium.crypto.box.nonceBytes);

    final encrypted = sodium.crypto.box.easy(
      message: Uint8List.fromList(message.codeUnits),
      nonce: nonce,
      publicKey: otherPublicKey,
      secretKey: myKeyPair.secretKey,
    );

    return {"cipher": encrypted, "nonce": nonce};
  }

  // decrypt msg
  String decrypt({required Uint8List cipher, required Uint8List nonce}) {
    final decrypted = sodium.crypto.box.openEasy(
      cipherText: cipher,
      nonce: nonce,
      publicKey: otherPublicKey,
      secretKey: myKeyPair.secretKey,
    );

    return String.fromCharCodes(decrypted);
  }
}

class EncryptionService {
  final E2E e2e;

  EncryptionService(this.e2e);

  Map<String, Uint8List> sendMessage(String msg) {
    return e2e.encrypt(msg);
  }

  String receiveMessage(Uint8List cipher, Uint8List nonce) {
    return e2e.decrypt(cipher: cipher, nonce: nonce);
  }
}