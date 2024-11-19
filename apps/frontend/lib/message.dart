import 'package:flutter/material.dart';
import 'package:frontend/chatting_room.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  MessageState createState() => MessageState();
}

class MessageState extends State<Message> {
  // Temporal infos
  List<dynamic> chatrooms = [
    {"title": "김성균", "lastMessage": "감사합니다!", "unreadMessageCounts": 2},
    {"title": "이율전", "lastMessage": "저도 그 수업 듣는데", "unreadMessageCounts": 0},
    {
      "title": "수학과-소프트웨어학과 복전생 모임",
      "lastMessage": "과제 너무 많네요 ㅠㅠ",
      "unreadMessageCounts": 6
    },
    {
      "title": "농구 좋아하는 사람들 모임",
      "lastMessage": "내일 저녁 8시 학교 코트에서 농구하실분?",
      "unreadMessageCounts": 13
    },
  ]; // Temporal

  @override
  void initState() {
    super.initState();
  }

  // API - GET chatroom infos
  // Future<void> _fetchChatrooms() async {
  //   final response = await http.get(
  //     Uri.parse('https://skku-dm.site/'),
  //     headers: {},
  //   );

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       chatrooms = json.decode(response.body)['chatrooms'];
  //     });
  //   } else {
  //     print('Debugging for GET - Filters list');
  //     print(response.statusCode);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Message',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatrooms.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 2))),
                    child: ListTile(
                        title: Text(
                          "${chatrooms[index]["title"]}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          "${chatrooms[index]["lastMessage"]}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          "${chatrooms[index]["unreadMessageCounts"]}",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (ChattingRoom(
                                        nickname:
                                            "${chatrooms[index]["title"]}",
                                      ))));
                        }));
              },
            ),
          ),
        ],
      ),
    );
  }
}
