import 'package:flutter/material.dart';
import 'package:frontend/dm/chat_room.dart';
import 'package:frontend/models/chat_room.dart';
import 'package:frontend/services/chat_service.dart';
import 'package:frontend/utils/api_helper.dart';
import 'package:provider/provider.dart';

class ChatRoomsScreen extends StatefulWidget {
  @override
  _ChatRoomsScreenState createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {
  late ChatService chatService;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    chatService = ChatService(
      token: authProvider.accessToken?.replaceAll('Bearer ', '') ??
          '', // Bearer 제거
      userId: authProvider.user?.userId ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅'),
      ),
      body: StreamBuilder<List<ChatRoom>>(
        stream: chatService.roomsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final rooms = snapshot.data!;
          if (rooms.isEmpty) {
            return Center(child: Text('참여 중인 채팅방이 없습니다.'));
          }

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return ListTile(
                title: Text(room.name),
                subtitle: Text(
                  room.lastMessage?.message ?? '새로운 대화를 시작해보세요',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: room.unreadCount > 0
                    ? Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          room.unreadCount.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : null,
                onTap: () => _openChatRoom(room.roomId),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _createNewRoom,
      ),
    );
  }

  void _openChatRoom(String roomId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomScreen(
          roomId: roomId,
          chatService: chatService,
        ),
      ),
    );
  }

  void _createNewRoom() async {
    try {
      await chatService.createRoom(
        '새로운 채팅방',
        [/* 참여자 ID 목록 */],
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('채팅방 생성에 실패했습니다.')),
      );
    }
  }

  @override
  void dispose() {
    chatService.dispose();
    super.dispose();
  }
}
