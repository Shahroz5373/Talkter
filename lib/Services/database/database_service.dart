import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talkter/screens/user_registeration/registration/riverpod/model/user_notifier_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData({
    required UserInfo user,
    required String public_key,
  }) async {
    try {
      if (user.phone.isEmpty) throw Exception("Phone number is missing");

      await _firestore.collection('users').doc(user.phone).set({
        'name': user.name,
        'username': user.userName,
        'email': user.email,
        'phone': user.phone,
        'public_key': public_key,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to save user data: $e");
    }
  }

  // 2. Update existing user data
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
