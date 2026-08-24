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
