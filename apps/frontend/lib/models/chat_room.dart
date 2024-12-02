import 'package:frontend/models/chat_message.dart';

class ChatRoom {
  final String roomId;
  final String name;
  ChatMessage? lastMessage;
  int unreadCount;

  ChatRoom({
    required this.roomId,
    required this.name,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      roomId: json['roomId'],
      name: json['name'],
      lastMessage: json['lastMessage'] != null
          ? ChatMessage.fromJson(json['lastMessage'])
          : null,
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}
