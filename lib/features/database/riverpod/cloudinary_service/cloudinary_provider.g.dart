// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudinary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cloudinaryService)
final cloudinaryServiceProvider = CloudinaryServiceProvider._();

final class CloudinaryServiceProvider
    extends
        $FunctionalProvider<
          CloudinaryService,
          CloudinaryService,
          CloudinaryService
        >
    with $Provider<CloudinaryService> {
  CloudinaryServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cloudinaryServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cloudinaryServiceHash();

  @$internal
  @override
  $ProviderElement<CloudinaryService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CloudinaryService create(Ref ref) {
    return cloudinaryService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CloudinaryService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CloudinaryService>(value),
    );
  }
}

String _$cloudinaryServiceHash() => r'670e67428adbc4508f7154df9f42831aa88776cc';
