import 'package:frontend/models/user_info.dart';

class ChatMessage {
  final String messageId;
  final String roomId;
  final String message;
  final UserInfo user;
  final DateTime timestamp;
  bool isRead;

  ChatMessage({
    required this.messageId,
    required this.roomId,
    required this.message,
    required this.user,
    required this.timestamp,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageId: json['messageId'],
      roomId: json['roomId'],
      message: json['message'],
      user: UserInfo.fromJson(json['user']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
