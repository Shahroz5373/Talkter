import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageStatus { sent, delivered, read }

class MessageServiceModel {
  final String senderId;
  final String receiverId;
  final String nonce;
  final String cipherText;
  final DateTime timestamp;
  final MessageStatus messageStatus;

  MessageServiceModel({
    required this.senderId,
    required this.receiverId,
    required this.nonce,
    required this.cipherText,
    required this.timestamp,
    required this.messageStatus,
  });

  factory MessageServiceModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    if (data == null) throw Exception('Message document is empty');

    return MessageServiceModel(
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      nonce: data['nonce'] ?? '',
      cipherText: data['cipherText'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      messageStatus: _parseStatus(data['status']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'nonce': nonce,
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
