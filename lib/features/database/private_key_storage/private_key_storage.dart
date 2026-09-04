import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sodium/sodium.dart';

class PrivateKeyStore {
  static const FlutterSecureStorage _flutterSecureStorage =
      FlutterSecureStorage();

  static const String _privateKey = 'private_key';

  static Future<void> storePrivateKey({required SecureKey privatekey}) async {
    final bytes = privatekey.extractBytes();

    final base64String = base64Encode(bytes);

    await _flutterSecureStorage.write(key: _privateKey, value: base64String);
  }

  static Future<SecureKey?> getPrivateKey({required Sodium sodium}) async {
    final base64String = await _flutterSecureStorage.read(key: _privateKey);
    if (base64String == null) return null;
    final bytes = base64Decode(base64String);
    return sodium.secureCopy(bytes);
  }

  static Future<void> deletePrivateKey() async =>
      await _flutterSecureStorage.delete(key: _privateKey);
}
