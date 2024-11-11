import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChattingRoom extends StatefulWidget {
  final String nickname;

  const ChattingRoom({super.key, required this.nickname});
  @override
  State<ChattingRoom> createState() => _ChattingRoomState();
}

class _ChattingRoomState extends State<ChattingRoom> {
  final _formKey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  final List<Map<String, String>> _messages = [];

  // 현재 시간
  String _getCurrentTimestamp() {
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm');
    return formatter.format(now);
  }

  // 채팅 입력 아이콘 클릭 시
  void _onSendPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _messages.add({
          'timestamp': _getCurrentTimestamp(),
          'content': _textController.text,
        });
        print("This is List: $_messages");
        _textController.clear();
      });

      // 추가된 곳으로 스크롤 위치
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nickname,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            // 채팅 내용 --------------------------------------------------------
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final timestamp = message['timestamp']!;
                  final content = message['content']!;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          timestamp,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width *
                                0.6), // Max width를 70%로 제한
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.lightGreen.shade100,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Text(
                            content,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // 채팅 입력 ---------------------------------------------------------
            Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLines: 2,
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: '내용을 입력하세요...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(10),
                          suffixIcon: IconButton(
                            icon: Icon(
                              CupertinoIcons.paperplane_fill,
                              color: Colors.grey[500],
                            ),
                            onPressed: _onSendPressed,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '댓글을 입력해주세요.';
                          }
                          return null;
                        },
                        onChanged: (text) {
                          // 댓글 입력 처리
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
