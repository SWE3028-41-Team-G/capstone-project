import 'package:frontend/models/user_info.dart';

class ChatMessage {
  final String senderId;
  final String message;
  final DateTime timestamp;
  final List<String> readBy;
  final UserInfo userInfo;

  ChatMessage({
    required this.senderId,
    required this.message,
    required this.timestamp,
    required this.readBy,
    required this.userInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp,
      'readBy': readBy,
      'userInfo': {
        'userId': userInfo.userId,
        'nickname': userInfo.nickname,
        'profileImgUrl': userInfo.profileImgUrl,
      },
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderId: map['senderId'],
      message: map['message'],
      timestamp: map['timestamp'].toDate(),
      readBy: List<String>.from(map['readBy'] ?? []),
      userInfo: UserInfo.fromJson(map['userInfo']),
    );
  }
}
