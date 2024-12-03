import 'package:cloud_firestore/cloud_firestore.dart';
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
        'username': userInfo.username,
        'nickname': userInfo.nickname,
        'profileImgUrl': userInfo.profileImgUrl,
      },
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    final userInfoMap = map['userInfo'] as Map<String, dynamic>;

    return ChatMessage(
      senderId: map['senderId'] as String,
      message: map['message'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      readBy: List<String>.from(map['readBy'] as List),
      userInfo: UserInfo(
        userId: userInfoMap['userId'] as int,
        username: userInfoMap['nickname'] as String,
        nickname: userInfoMap['nickname'] as String,
        profileImgUrl: userInfoMap['profileImgUrl'] as String,
      ),
    );
  }
}
