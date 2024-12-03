import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/chatting_room.dart';
import 'package:frontend/initial_page.dart';
import 'package:frontend/models/chat_room.dart';
import 'package:frontend/utils/jwt_helper.dart';
import 'package:intl/intl.dart';

class ChatRoomsScreen extends StatefulWidget {
  @override
  State<ChatRoomsScreen> createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _loadAccessToken();
  }

  Future<void> _loadAccessToken() async {
    final token = await _secureStorage.read(key: 'access_token');
    setState(() {
      _accessToken = token;
    });
  }

  void _handleLogout(BuildContext context) async {
    await _secureStorage.delete(key: 'access_token');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => InitialPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_accessToken == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final userPayload = JwtHelper.parseJwt(_accessToken!);
    final currentUserId = userPayload['userId'].toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('채팅방 목록'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chatrooms')
            .where('participants', arrayContains: currentUserId)
            .orderBy('lastMessageTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final chatRooms = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ChatRoom.fromMap(data, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(userPayload['imageUrl'] ?? ''),
                  child: (userPayload['imageUrl'] ?? '').isEmpty
                      ? Text(chatRoom.name[0])
                      : null,
                ),
                title: Text(chatRoom.name),
                subtitle: Text(chatRoom.lastMessage),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('MM/dd HH:mm')
                          .format(chatRoom.lastMessageTime),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatRoomId: chatRoom.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showCreateChatRoomDialog(context),
      ),
    );
  }

  void _showCreateChatRoomDialog(BuildContext context) {
    final nameController = TextEditingController();
    final userPayload = JwtHelper.parseJwt(_accessToken!);
    final currentUserId = userPayload['userId'].toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('새 채팅방 만들기'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: '채팅방 이름을 입력하세요',
          ),
        ),
        actions: [
          TextButton(
            child: Text('취소'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('만들기'),
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;

              final chatRoomRef = await _firestore.collection('chatrooms').add({
                'name': nameController.text.trim(),
                'participants': [currentUserId],
                'lastMessageTime': DateTime.now(),
                'lastMessage': '채팅방이 생성되었습니다.',
                'createdBy': currentUserId,
                'createdAt': DateTime.now(),
                'participantDetails': [
                  {
                    'userId': currentUserId,
                    'nickname': userPayload['nickname'],
                    'imageUrl': userPayload['imageUrl'] ?? '',
                  }
                ],
              });

              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    chatRoomId: chatRoomRef.id,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
