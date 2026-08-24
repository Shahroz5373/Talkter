import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'file_path_provider.g.dart';

@Riverpod(keepAlive: true)
class UploadPath extends _$UploadPath {
  @override
  File? build() {
    return null;
  }

  void steUploadFilePath(File? path) => state = path;
  void clearFilePath() => state = null;
}
