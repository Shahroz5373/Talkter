import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talkter/features/database/cloudinary/cloudinary_service.dart';
part 'cloudinary_provider.g.dart';

@riverpod
CloudinaryService cloudinaryService(Ref ref) => CloudinaryService();
