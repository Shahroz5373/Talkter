import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:talkter/Services/keys/key_generation.dart';

// Provider for Secure Storage
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// Provider for our Key Manager
final keyManagerProvider = Provider<KeyManager>((ref) {
  return KeyManager(ref.read(secureStorageProvider));
});

class KeyManager {
  final FlutterSecureStorage _secureStorage;

  KeyManager(this._secureStorage);

  Future<String> generateAndStoreKeys() async {
    // 1. Generate the key pair
    final keyGen = await KeyGeneration.generate();

    // 2. Extract public and private keys
    final publicKeyBytes = keyGen.keys.publicKey;
    // We use extractBytes() because secretKey is a SecureKey object in sodium
    final privateKeyBytes = keyGen.keys.secretKey.extractBytes();

    // 3. Convert both to Base64 strings for easy storage
    final publicKeyBase64 = base64Encode(publicKeyBytes);
    final privateKeyBase64 = base64Encode(privateKeyBytes);

    // 4. Save the private key to local secure storage
    await _secureStorage.write(key: 'private_key', value: privateKeyBase64);

    // 5. Return the public key so it can be saved to Firestore
    return publicKeyBase64;
  }

  /// Helper to read the private key later when decrypting messages
  Future<String?> getPrivateKey() async {
    return await _secureStorage.read(key: 'private_key');
  }
}
