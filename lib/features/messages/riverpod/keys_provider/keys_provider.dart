import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sodium/sodium.dart';
import 'package:talkter/features/database/private_key_storage/private_key_storage.dart';
import 'package:talkter/services/encryption/keys/key_generation.dart';

part 'keys_provider.g.dart';

@Riverpod(keepAlive: true)
class KeyProvider extends _$KeyProvider {
  @override
  Future<SecureKey?> build() async => _loadMyPrivateKey();

  Future<SecureKey?> _loadMyPrivateKey() async {
    final genSodium = await KeyGeneration.generate();

    final privateKey = await PrivateKeyStore.getPrivateKey(
      sodium: genSodium.sodium,
    );

    return privateKey;
  }

  Future<String?> getFriendPublicKey({required String friendsPhone}) async {
    friendsPhone = friendsPhone.trim();

    if (friendsPhone.isEmpty) {
      throw Exception('No phone number provided');
    }

    final firestore = FirebaseFirestore.instance;

    final friendData = await firestore
        .collection('users')
        .doc(friendsPhone)
        .get();

    if (!friendData.exists) {
      return null;
    }

    final data = friendData.data();

    return data?['public_key'] as String?;
  }
}
