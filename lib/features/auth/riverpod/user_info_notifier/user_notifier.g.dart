// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserNotifier)
final userProvider = UserNotifierProvider._();

final class UserNotifierProvider
    extends $NotifierProvider<UserNotifier, UserInfo?> {
  UserNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userNotifierHash();

  @$internal
  @override
  UserNotifier create() => UserNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserInfo? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserInfo?>(value),
    );
  }
}

String _$userNotifierHash() => r'ede6b7493a66911f7f5514234a1a21cc21692b2a';

abstract class _$UserNotifier extends $Notifier<UserInfo?> {
  UserInfo? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<UserInfo?, UserInfo?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserInfo?, UserInfo?>,
              UserInfo?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
