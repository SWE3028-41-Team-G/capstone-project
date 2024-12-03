import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final String name;
  final List<String> participants;
  final DateTime lastMessageTime;
  final String lastMessage;
  final String createdBy;
  final DateTime createdAt;

  ChatRoom({
    required this.id,
    required this.name,
    required this.participants,
    required this.lastMessageTime,
    required this.lastMessage,
    required this.createdBy,
    required this.createdAt,
  });

  factory ChatRoom.fromMap(Map<String, dynamic> map, String id) {
    return ChatRoom(
      id: id,
      name: map['name'] as String,
      participants: List<String>.from(map['participants']),
      lastMessageTime: (map['lastMessageTime'] as Timestamp).toDate(),
      lastMessage: map['lastMessage'] as String,
      createdBy: map['createdBy'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'participants': participants,
      'lastMessageTime': lastMessageTime,
      'lastMessage': lastMessage,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }
}
