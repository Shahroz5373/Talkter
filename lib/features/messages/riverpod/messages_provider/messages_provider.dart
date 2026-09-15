import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sodium/sodium_sumo.dart';
import 'package:talkter/features/messages/model/message_controller_model/message_controller_model.dart';
import 'package:talkter/features/messages/riverpod/keys_provider/keys_provider.dart';

part 'messages_provider.g.dart';

@Riverpod(keepAlive: true)
class MessagesProvider extends _$MessagesProvider {
  late final MessageController _controller;

  StreamSubscription<List<Map<String, dynamic>>>? _messagesSubscription;

  late final SecureKey _myPrivateKey;
  late final Uint8List _friendPublicKey;

  @override
  FutureOr<List<Map<String, dynamic>>> build({required String friendId}) async {
    final myId = FirebaseAuth.instance.currentUser?.phoneNumber;

    if (myId == null) {
      throw Exception('User not logged in');
    }

    final privateKey = await ref.read(keyProviderProvider.future);

    if (privateKey == null) {
      throw Exception('Your private key is missing');
    }

    _myPrivateKey = privateKey;

    final publicKey = await ref
        .read(keyProviderProvider.notifier)
        .getFriendPublicKey(friendsPhone: friendId);

    if (publicKey == null) {
      throw Exception('Friend public key not found');
    }

    _friendPublicKey = publicKey;

    _controller = MessageController(myId: myId, friendId: friendId);

    final messagesStream = _controller.getDecryptedMessagesStream(
      myPrivateKey: _myPrivateKey,
      friendPublicKey: _friendPublicKey,
    );

    final completer = Completer<List<Map<String, dynamic>>>();

    _messagesSubscription = messagesStream.listen(
      (messages) {
        state = AsyncData(messages);

        if (!completer.isCompleted) {
          completer.complete(messages);
        }
      },
      onError: (error, stackTrace) {
        state = AsyncError(error, stackTrace);

        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      },
    );

    ref.onDispose(() {
      _messagesSubscription?.cancel();
    });

    return completer.future;
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) {
      return;
    }

    try {
      await _controller.sendEncryptedMessage(
        message: text.trim(),
        myPrivateKey: _myPrivateKey,
        friendPublicKey: _friendPublicKey,
      );
    } catch (e) {
      //print('Error sending message: $e');
      rethrow;
    }
  }
}
