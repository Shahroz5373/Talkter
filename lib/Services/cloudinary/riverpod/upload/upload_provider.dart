import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talkter/Services/cloudinary/cloudinary_service.dart';
part 'upload_provider.g.dart';

@riverpod
CloudinaryService cloudinaryService(Ref ref) => CloudinaryService();
