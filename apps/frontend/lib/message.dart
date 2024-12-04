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
  bool _isLoading = true;
  late Stream<QuerySnapshot> _chatRoomsStream;

  @override
  void initState() {
    super.initState();
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    try {
      final token = await _secureStorage.read(key: 'access_token');
      if (!mounted) return;

      if (token == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => InitialPage()),
          (route) => false,
        );
        return;
      }

      final userPayload = JwtHelper.parseJwt(token);
      final currentUserId = userPayload['userId'].toString();

      _chatRoomsStream = _firestore
          .collection('chatrooms')
          .where('participants', arrayContains: currentUserId)
          .orderBy('lastMessageTime', descending: true)  // 임시로 주석 처리
          .snapshots();

      setState(() {
        _accessToken = token;
        _isLoading = false;
      });
    } catch (e) {
      print('Error in _initializeToken: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_accessToken == null) {
      return const Scaffold(body: Center(child: Text('로그인이 필요합니다.')));
    }

    final userPayload = JwtHelper.parseJwt(_accessToken!);
    final currentUserId = userPayload['userId'].toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('DM List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatRoomsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
          }
          if (snapshot.hasData) {
            print('Documents count: ${snapshot.data!.docs.length}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('채팅방이 없습니다. 새로운 채팅방을 만들어보세요!'),
            );
          }

          final chatRooms = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ChatRoom.fromMap(data, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index];
              final imageUrl = userPayload['profileImgUrl'] as String?;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: imageUrl?.isNotEmpty == true
                      ? NetworkImage(imageUrl!)
                      : null,
                  child: imageUrl?.isEmpty != false
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
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      chatRoomId: chatRoom.id,
                    ),
                  ),
                ),
              );
            },
          );
        },
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

              print(userPayload);

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
                    'profileImgUrl': userPayload['profileImgUrl'] ?? '',
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
