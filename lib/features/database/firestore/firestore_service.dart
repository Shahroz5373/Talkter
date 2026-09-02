import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talkter/features/database/cloudinary/upload_result/upload_result.dart';
import 'package:talkter/features/auth/models/user_info_model/user_info_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData({
    required UserInfo user,
    required String publicKey,
    required CloudinaryUploadResult profilePic,
  }) async {
    try {
      if (user.phone.isEmpty) throw Exception("Phone number is missing");

      await _firestore.collection('users').doc(user.phone).set({
        'name': user.name,
        'username': user.userName,
        'email': user.email,
        'phone': user.phone,
        'public_key': publicKey,
        'profile_pic_url': profilePic.avatar_url,
        'profile_pic_id': profilePic.avatar_public_id,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to save user data: $e");
    }
  }

  // Update existing user data
  Future<void> updateUserData(
    String phone,
    Map<String, dynamic> updateData,
  ) async {
    try {
      await _firestore.collection('users').doc(phone).update(updateData);
    } catch (e) {
      throw Exception("Failed to update user data: $e");
    }
  }
}
