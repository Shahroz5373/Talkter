import 'package:cloud_firestore/cloud_firestore.dart';

class FriendModel {
  final String phone;
  final String name;
  final String username;
  final String? profilePicUrl;
  final String? publicKey;
  final String status;
  final DateTime? updatedAt;

  FriendModel({
    required this.phone,
    required this.name,
    required this.username,
    this.profilePicUrl,
    this.publicKey,
    required this.status,
    this.updatedAt,
  });

  factory FriendModel.fromFirestore({
    required Map<String, dynamic> friendDocData,
    required Map<String, dynamic> userDocData,
  }) {
    return FriendModel(
      phone: friendDocData['phone'] ?? userDocData['phone'] ?? '',
      name: userDocData['name'] ?? 'Unknown',
      username: userDocData['username'] ?? '',
      profilePicUrl: userDocData['profile_pic_url'],
      publicKey: userDocData['public_key'],
      status: friendDocData['status'] ?? 'none',
      updatedAt: (friendDocData['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
