import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/models/user_info.dart';
import 'package:frontend/utils/jwt_helper.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;

  const ChatScreen({super.key, required this.chatRoomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? _accessToken;
  bool _isLoading = true;
  late Stream<QuerySnapshot> _messagesStream;
  String _chatRoomTitle = 'DM';

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      final token = await _secureStorage.read(key: 'access_token');
      print('Token loaded: ${token != null}');

      if (!mounted) return;

      if (token == null) {
        Navigator.pop(context);
        return;
      }

      final chatRoomDoc =
          await _firestore.collection('chatrooms').doc(widget.chatRoomId).get();

      _messagesStream = _firestore
          .collection('chatrooms')
          .doc(widget.chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();

      print('Chat Room ID: ${widget.chatRoomId}');

      setState(() {
        _accessToken = token;
        _isLoading = false;
        _chatRoomTitle = chatRoomDoc.data()?['name'] ?? 'DM';
      });
    } catch (e) {
      print('Error in _initializeChat: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _accessToken == null) return;

    try {
      final userPayload = JwtHelper.parseJwt(_accessToken!);
      print('Sending message as user: ${userPayload['userId']}');

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

      print('Sending message: ${message.toMap()}');

      await _firestore.runTransaction((transaction) async {
        try {
          final messageRef = _firestore
              .collection('chatrooms')
              .doc(widget.chatRoomId)
              .collection('messages')
              .doc();

          transaction.set(messageRef, message.toMap());

          final chatRoomRef =
              _firestore.collection('chatrooms').doc(widget.chatRoomId);
          transaction.update(chatRoomRef, {
            'lastMessage': message.message,
            'lastMessageTime': message.timestamp,
          });

          print('Message sent successfully');
        } catch (e) {
          print('Transaction error: $e');
          rethrow;
        }
      });

      _messageController.clear();
    } catch (e) {
      print('Error in _sendMessage: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('메시지 전송 중 오류가 발생했습니다.')),
        );
      }
    }
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
        title: Text(_chatRoomTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('메시지가 없습니다.'));
                }

                final messages = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  try {
                    return ChatMessage.fromMap(data);
                  } catch (e) {
                    print('Error parsing message: $e');
                    rethrow;
                  }
                }).toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    try {
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
                        }).then((_) {
                          print('Read status updated successfully');
                        }).catchError((error) {
                          print('Error updating read status: $error');
                        });
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                    backgroundImage: message.userInfo
                                                .profileImgUrl?.isNotEmpty ==
                                            true
                                        ? NetworkImage(
                                            message.userInfo.profileImgUrl!)
                                        : null,
                                    child: message.userInfo.profileImgUrl
                                                ?.isEmpty !=
                                            false
                                        ? Text(message.userInfo.nickname[0])
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  message.userInfo.nickname,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Container(
                              decoration: BoxDecoration(
                                color: isMe ? Colors.blue : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Text(
                                message.message,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            if (isMe) ...[
                              const SizedBox(height: 4),
                              Text(
                                '읽음 ${message.readBy.length}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    } catch (e) {
                      print('Error rendering message at index $index: $e');
                      return const SizedBox.shrink();
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 45.0, horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
