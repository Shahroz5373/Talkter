// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_local_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userLocalData)
final userLocalDataProvider = UserLocalDataProvider._();

final class UserLocalDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserInfo?>,
          UserInfo?,
          FutureOr<UserInfo?>
        >
    with $FutureModifier<UserInfo?>, $FutureProvider<UserInfo?> {
  UserLocalDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userLocalDataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userLocalDataHash();

  @$internal
  @override
  $FutureProviderElement<UserInfo?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserInfo?> create(Ref ref) {
    return userLocalData(ref);
  }
}

String _$userLocalDataHash() => r'0a3bf7aae78e6947d814082abec87e80c142b3de';
