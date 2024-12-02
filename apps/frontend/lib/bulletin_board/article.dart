import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend/utils/api_helper.dart';
import 'package:frontend/bulletin_board/update_article.dart';

class Article extends StatefulWidget {
  final int id;
  // final String title;
  // final String content;
  // final int userId;
  //final String writerName;
  //final String imageUrl;
  // final int likes;
  // final List<String> tags;
  // final List<String> Comments;
  // final String createdAt;
  // final String updatedAt;

  const Article({
    super.key,
    required this.id,
    // required this.title,
    // required this.content,
    // required this.userId,
    // required this.likes,
    // required this.tags,
    // required this.Comments,
    // required this.createdAt,
    // required this.updatedAt,
  });
  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  // Temporal data, will be linked with API soon
  var postData = {
    'id': 1,
    "title": "이번 학기에 반드시 수강신청해야하는 과목",
    "content":
        "이번 학기에 새롭게 부임하신 이율전 교수님이 진행하시는 암호론 되시겠다. 우선 이 교수님은 별명이 학점천사이실 정도로 학점을 거의 채워서 주시는 걸로 유명하다. 게다가 강의력도 좋으셔서 집중만 하면 내용 이해하는 것도 쉽고 유익하다. 가끔씩 빠뜨린 부분이 있어도 강의저장 올려주시는거 다시 보면서 복습하기까지 가능! 유일한 단점이 수업이 하도 좋다보니 다들 공부도 열심히 하는건지 성적이 다들 높다는 건데..앞서 말했듯이 학점 진짜 꽉꽉 채워담아 주시니까 걱정 ㄴㄴ 지금 당장 책가방에 담기 ㄱㄱ",
    'userId': 1,
    "likes": 12,
    "tags": ["#수학", "#전공진입", "수업추천", "꿀팁"],
    "createdAt": "11/20 12:30",
    "updatedAt": "11/20 12:30",
    "Comments": [
      {
        'imageUrl':
            'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
        "nickname": "율전이",
        "content": "수업 추천 감사요!",
        "timestamp": "11/20 13:30",
      },
      {
        'imageUrl':
            'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
        "nickname": "복전이",
        "content": "와 나도 들어봐야지~",
        "timestamp": "11/20 17:50",
      },
      {
        'imageUrl':
            'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
        "nickname": "수학이",
        "content": "이 수업 ㄹㅇ 강추임 저번학기에 들은 수업 중 가장 유익했었음",
        "timestamp": "11/21 00:30",
      },
    ],
  };

  var writerProfile = {};

  @override
  void initState() {
    super.initState();
    _fetchpostData();
    _fetchUserProfile();
  }

  Future<void> _fetchpostData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response = await authProvider.get('board/${widget.id}');
      if (response.statusCode == 200) {
        setState(() {
          postData = jsonDecode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('글 정보 가져오기 실패')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }

  Future<void> _fetchUserProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response =
          await authProvider.get('users/${postData['userId']}/profile');
      if (response.statusCode == 200) {
        setState(() {
          writerProfile = jsonDecode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('작성자 정보 검색 실패')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    var userData = authProvider.user;

    // 모집글
    String imageUrl = writerProfile['imageUrl'] ??
        'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg';
    String nickname = writerProfile["nickname"] ?? "익명";
    String timestamp = postData['timestamp'] as String;
    String title = postData['title'] as String;
    String content = postData['content'] as String;
    List<String> tags = postData['tags'] as List<String>;
    int likes = postData['likes'] as int;
    List<Map<String, String>> comments =
        postData["Comments"] as List<Map<String, String>>;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text(
          "게시글",
          style: TextStyle(fontSize: 20),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Container(
            color: Colors.grey[200],
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        height: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nickname,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Flexible(
                            child: Text(timestamp),
                          ),
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          debugPrint(
                              "글 수정 - 유저아이디: ${userData?.userId}, 작성자 아이디: ${postData["userId"]}");
                          if (postData["userId"] != userData!.userId) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('글 작성자만 수정이 가능합니다.')),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateArticle(
                                        id: widget.id,
                                        initTitle: postData['title'].toString(),
                                        initContent:
                                            postData['content'].toString(),
                                      )),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Text('글 수정',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                )),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Text(
                    content,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: List.generate(tags.length, (idx) {
                      return Row(
                        children: [
                          if (idx < tags.length) SizedBox(width: 15),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(tags[idx],
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.lightBlue))
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.heart,
                            color: Colors.pinkAccent,
                            size: 16,
                          ),
                          Text("$likes",
                              style: TextStyle(
                                color: Colors.pinkAccent,
                              )),
                        ],
                      ),
                    )
                  ],
                ),
                Divider(),
                SizedBox(height: 10),
                ListView.builder(
                  // 댓글 ------------------------------------------------------
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    String cmtImage = comments[index]['imageUrl']!;
                    String cmtName = comments[index]['nickname']!;
                    String cmtContent = comments[index]['content']!;
                    String cmtTime = comments[index]['createdAt']!;
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  // child: Image.network(
                                  //   // cmtImage,
                                  //   // fit: BoxFit.cover,
                                  // ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          cmtName,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          cmtTime,
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[400]),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(
                                        cmtContent,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            // 댓글 입력창 -----------------------------------------------------
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines: 2,
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: '댓글을 입력하세요...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                        suffixIcon: IconButton(
                          icon: Icon(
                            CupertinoIcons.paperplane_fill,
                            color: Colors.grey[500],
                          ),
                          onPressed: () async {
                            try {
                              Map<String, dynamic> body = {
                                'userId': userData!.userId,
                                'content': commentController.text,
                              };

                              final response = await authProvider.post(
                                  'board/${widget.id}/comment', body);
                              if (response.statusCode == 201) {
                                debugPrint("게시판 댓글 작성 성공!!!!!");
                                _fetchpostData();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('게시판 글 검색 실패')),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('오류 발생: $e')),
                              );
                            }
                          },
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
    );
  }
}
