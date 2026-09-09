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

  // Saved keys so we can reuse them when sending messages.
  late final SecureKey _myPrivateKey;
  late final Uint8List _friendPublicKey;

  @override
  FutureOr<List<Map<String, dynamic>>> build({required String friendId}) async {
    final myId = FirebaseAuth.instance.currentUser?.uid;

    if (myId == null) {
      throw Exception('User not logged in');
    }

    // Get my private key.
    final privateKey = await ref.read(keyProviderProvider.future);

    if (privateKey == null) {
      throw Exception('Your private key is missing');
    }

    _myPrivateKey = privateKey;

    // Get friend's public key.
    final publicKey = await ref
        .read(keyProviderProvider.notifier)
        .getFriendPublicKey(friendsPhone: friendId);

    if (publicKey == null) {
      throw Exception('Friend public key not found');
    }

    _friendPublicKey = publicKey;

    // Create controller for this conversation.
    _controller = MessageController(myId: myId, friendId: friendId);

    // Start receiving/decrypting messages.
    final messagesStream = _controller.getDecryptedMessagesStream(
      myPrivateKey: _myPrivateKey,
      friendPublicKey: _friendPublicKey,
    );

    final completer = Completer<List<Map<String, dynamic>>>();

    _messagesSubscription = messagesStream.listen(
      (messages) {
        state = AsyncData(messages);

        // Complete build() with the first message list.
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

    // Cancel the stream when provider is disposed.
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
      print('Error sending message: $e');
      rethrow;
    }
  }
}
