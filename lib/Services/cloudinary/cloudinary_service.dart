import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:talkter/Services/cloudinary/upload/cloudinary_upload_result.dart';

class CloudinaryService {
  static const String _cloud_name = "w18fokdf";
  static const String _upload_preset = "talkter";

  late final Cloudinary _cloudinary;

  CloudinaryService() {
    _cloudinary = Cloudinary.unsignedConfig(cloudName: _cloud_name);
  }

  Future<CloudinaryUploadResult> uploadProfileImage({
    required File imageFile,
  }) async {
    final response = await _cloudinary.unsignedUpload(
      file: imageFile.path,
      uploadPreset: _upload_preset,
      resourceType: CloudinaryResourceType.image,
    );
    if (!response.isSuccessful) {
      throw Exception(response.error ?? "Failed");
    }
    final url = response.secureUrl;
    final id = response.publicId;
    if (url == null || id == null) {
      throw Exception(
        'Cloudinary upload succeeded but required data is missing.',
      );
    }

    return CloudinaryUploadResult(avatar_url: url, avatar_public_id: id);
  }
}
