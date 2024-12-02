import 'package:flutter/material.dart';
import 'package:frontend/dm/chat_bubble.dart';
import 'package:frontend/models/chat_message.dart';
import 'package:frontend/services/chat_service.dart';

class ChatRoomScreen extends StatefulWidget {
  final String roomId;
  final ChatService chatService;

  ChatRoomScreen({
    required this.roomId,
    required this.chatService,
  });

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.chatService.markAsRead(widget.roomId);
    widget.chatService.joinRoom(widget.roomId);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    widget.chatService.sendMessage(
      widget.roomId,
      _messageController.text,
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅방'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: widget.chatService.getRoomMessages(widget.roomId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(8),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ChatBubble(
                      message: message,
                      isMe: message.user.userId == widget.chatService.userId,
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: '메시지를 입력하세요...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.chatService.leaveRoom(widget.roomId);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
