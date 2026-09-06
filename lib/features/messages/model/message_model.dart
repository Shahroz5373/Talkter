import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageStatus { sent, delivered, read }

class MessageModel {
  final String senderId;
  final String receiverId;
  final String cipherText;
  final DateTime timestamp;
  final MessageStatus messageStatus;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.cipherText,
    required this.timestamp,
    required this.messageStatus,
  });

  factory MessageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    if (data == null) throw Exception('Message document is empty');

    return MessageModel(
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      cipherText: data['cipherText'] ?? '',

      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      messageStatus: _parseStatus(data['status']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'cipherText': cipherText,
      'timestamp': FieldValue.serverTimestamp(),
      'status': messageStatus.name,
    };
  }

  static MessageStatus _parseStatus(dynamic status) {
    switch (status) {
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'sent':
      default:
        return MessageStatus.sent;
    }
  }
}
