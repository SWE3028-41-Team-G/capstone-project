import 'dart:async';
import 'package:frontend/models/chat_message.dart';
import 'package:frontend/models/chat_room.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket socket;
  final String token;
  final int userId;

  final Map<String, ChatRoom> rooms = {};
  final Map<String, List<ChatMessage>> messages = {};

  final _roomsController = StreamController<List<ChatRoom>>.broadcast();
  final _messagesController =
      Map<String, StreamController<List<ChatMessage>>>();

  Stream<List<ChatRoom>> get roomsStream => _roomsController.stream;

  ChatService({required this.token, required this.userId}) {
    _initSocket();
  }

  void _initSocket() {
    socket = IO.io(
        'https://skku-dm.site',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({'token': token})
            .disableAutoConnect()
            .build());

    _setupEventListeners();
    socket.connect();
  }

  Stream<List<ChatMessage>> getRoomMessages(String roomId) {
    if (!_messagesController.containsKey(roomId)) {
      _messagesController[roomId] =
          StreamController<List<ChatMessage>>.broadcast();
      messages[roomId] = [];
    }
    return _messagesController[roomId]!.stream;
  }

  void _setupEventListeners() {
    socket.onConnect((_) {
      print('Connected to chat server');
      getRooms();
    });

    socket.onDisconnect((_) {
      print('Disconnected from chat server');
    });

    socket.on('message', (data) {
      final message = ChatMessage.fromJson(data);
      _handleNewMessage(message);
    });

    socket.on('messageRead', (data) {
      final roomId = data['roomId'];
      final readByUserId = data['userId'] as int;
      final timestamp = DateTime.parse(data['timestamp']);
      _handleMessageRead(roomId, readByUserId, timestamp);
    });

    socket.on('roomCreated', (data) {
      final room = ChatRoom.fromJson(data);
      rooms[room.roomId] = room;
      _roomsController.add(rooms.values.toList());
    });
  }

  void _handleNewMessage(ChatMessage message) {
    // 메시지 목록 업데이트
    if (!messages.containsKey(message.roomId)) {
      messages[message.roomId] = [];
    }
    messages[message.roomId]!.add(message);
    _messagesController[message.roomId]?.add(messages[message.roomId]!);

    // 채팅방 정보 업데이트
    if (rooms.containsKey(message.roomId)) {
      rooms[message.roomId]!.lastMessage = message;
      if (message.user.userId != userId) {
        rooms[message.roomId]!.unreadCount++;
      }
      _roomsController.add(rooms.values.toList());
    }
  }

  void _handleMessageRead(String roomId, int readByUserId, DateTime timestamp) {
    if (messages.containsKey(roomId)) {
      for (var message in messages[roomId]!) {
        if (message.timestamp.isBefore(timestamp)) {
          message.isRead = true;
        }
      }
      _messagesController[roomId]?.add(messages[roomId]!);
    }

    if (rooms.containsKey(roomId) && readByUserId == userId) {
      rooms[roomId]!.unreadCount = 0;
      _roomsController.add(rooms.values.toList());
    }
  }

  Future<void> createRoom(String name, List<int> participantIds) {
    final completer = Completer<void>();

    socket.emitWithAck('createRoom', {
      'name': name,
      'participantIds': participantIds,
    }, ack: (data) {
      if (data != null) {
        final room = ChatRoom.fromJson(data);
        rooms[room.roomId] = room;
        _roomsController.add(rooms.values.toList());
        completer.complete();
      } else {
        completer.completeError('방 생성에 실패했습니다.');
      }
    });

    return completer.future;
  }

  void getRooms() {
    socket.emit('getRooms');
  }

  void joinRoom(String roomId) {
    socket.emit('joinRoom', {'roomId': roomId});
  }

  void leaveRoom(String roomId) {
    socket.emit('leaveRoom', {'roomId': roomId});
  }

  void sendMessage(String roomId, String message) {
    socket.emit('message', {
      'roomId': roomId,
      'message': message,
    });
  }

  void markAsRead(String roomId) {
    socket.emit('markAsRead', {'roomId': roomId});
  }

  void dispose() {
    socket.disconnect();
    _roomsController.close();
    for (var controller in _messagesController.values) {
      controller.close();
    }
  }
}
