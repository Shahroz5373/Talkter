// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keys_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(KeyProvider)
final keyProviderProvider = KeyProviderProvider._();

final class KeyProviderProvider
    extends $AsyncNotifierProvider<KeyProvider, SecureKey?> {
  KeyProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keyProviderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keyProviderHash();

  @$internal
  @override
  KeyProvider create() => KeyProvider();
}

String _$keyProviderHash() => r'e542780c21706d745c0af6bee98100bcc211e3e0';

abstract class _$KeyProvider extends $AsyncNotifier<SecureKey?> {
  FutureOr<SecureKey?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SecureKey?>, SecureKey?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SecureKey?>, SecureKey?>,
              AsyncValue<SecureKey?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
