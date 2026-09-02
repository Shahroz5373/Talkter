// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_stream_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(friendsStream)
final friendsStreamProvider = FriendsStreamProvider._();

final class FriendsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FriendModel>>,
          List<FriendModel>,
          Stream<List<FriendModel>>
        >
    with
        $FutureModifier<List<FriendModel>>,
        $StreamProvider<List<FriendModel>> {
  FriendsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendsStreamProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<FriendModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<FriendModel>> create(Ref ref) {
    return friendsStream(ref);
  }
}

String _$friendsStreamHash() => r'd41c4cd0b7ba031570715ea94d24d6816d934dc6';
