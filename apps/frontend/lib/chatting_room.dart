import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/models/user_info.dart';
import 'package:frontend/utils/jwt_helper.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;

  ChatScreen({required this.chatRoomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
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

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _accessToken == null) return;

    final userPayload = JwtHelper.parseJwt(_accessToken!);

    final userInfo = UserInfo(
      userId: userPayload['userId'] as int,
      username: userPayload['username'] as String,
      nickname: userPayload['nickname'] as String,
      profileImgUrl: userPayload['profileImgUrl'] as String,
    );

    final message = ChatMessage(
      senderId: userPayload['userId'].toString(),
      message: _messageController.text.trim(),
      timestamp: DateTime.now(),
      readBy: [userPayload['userId'].toString()],
      userInfo: userInfo,
    );

    await _firestore
        .collection('chatrooms')
        .doc(widget.chatRoomId)
        .collection('messages')
        .add(message.toMap());

    await _firestore.collection('chatrooms').doc(widget.chatRoomId).update({
      'lastMessage': message.message,
      'lastMessageTime': message.timestamp,
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_accessToken == null) {
      return Center(child: CircularProgressIndicator());
    }

    // JWT 토큰에서 현재 사용자 ID 가져오기
    final userPayload = JwtHelper.parseJwt(_accessToken!);
    final currentUserId = userPayload['userId'].toString();

    return Scaffold(
      appBar: AppBar(title: Text('Chat Room')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chatrooms')
                  .doc(widget.chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return ChatMessage.fromMap(data);
                }).toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == currentUserId;

                    if (!message.readBy.contains(currentUserId)) {
                      _firestore
                          .collection('chatrooms')
                          .doc(widget.chatRoomId)
                          .collection('messages')
                          .doc(snapshot.data!.docs[index].id)
                          .update({
                        'readBy': FieldValue.arrayUnion([currentUserId])
                      });
                    }

                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!isMe) ...[
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(
                                      message.userInfo.profileImgUrl),
                                ),
                                SizedBox(width: 8),
                              ],
                              Text(
                                message.userInfo.nickname,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Text(
                              message.message,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          if (isMe) ...[
                            SizedBox(height: 4),
                            Text(
                              '읽음 ${message.readBy.length}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
