// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_path_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UploadPath)
final uploadPathProvider = UploadPathProvider._();

final class UploadPathProvider extends $NotifierProvider<UploadPath, File?> {
  UploadPathProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uploadPathProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadPathHash();

  @$internal
  @override
  UploadPath create() => UploadPath();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(File? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<File?>(value),
    );
  }
}

String _$uploadPathHash() => r'd1172a7e055a52dc32e2b93db6baac52af595871';

abstract class _$UploadPath extends $Notifier<File?> {
  File? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<File?, File?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<File?, File?>,
              File?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
