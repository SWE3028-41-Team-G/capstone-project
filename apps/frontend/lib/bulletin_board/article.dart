import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:frontend/utils/api_helper.dart';
import 'package:frontend/bulletin_board/update_article.dart';

class Article extends StatefulWidget {
  final int id;

  const Article({
    super.key,
    required this.id,
  });
  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  // Temporal data, will be linked with API soon
  var postData = {
    // "createdAt": "11/20 12:30",
  };
  var writerProfile = {};
  List<dynamic> commentUserProfiles = [];

  @override
  void initState() {
    super.initState();
    _fetchpostData();
    _fetchUserProfile();
    _fetchCommentsData();
    debugPrint(commentUserProfiles.toString()); //debug
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

  Future<void> _fetchCommentsData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      postData["Comment"].forEach((comment) async {
        final response =
            await authProvider.get('users/${comment["userId"]}/profile');
        if (response.statusCode == 200) {
          setState(() {
            commentUserProfiles.add(response);
          });
        }
      });
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
    String imageUrl =
        writerProfile['imageUrl'] ?? 'https://cdn.skku-dm.site/default.jpeg';
    String nickname = writerProfile["nickname"] ?? "익명";
    String timestamp = DateFormat('MM/dd hh:mm')
        .format(DateTime.parse(postData['createdAt']))
        .toString();
    String title = postData['title'] as String;
    String content = postData['content'] as String;
    List<dynamic> tags = postData['tags'] as List<dynamic>;
    int likes = postData['likes'] as int;
    List<dynamic> comments = postData["Comment"] as List<dynamic>;

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
                              Text('#${tags[idx]}',
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
                    String cmtImage = commentUserProfiles[index]['imageUrl']!;
                    String cmtName = commentUserProfiles[index]['nickname']!;
                    String cmtContent = comments[index]['content']!;
                    String cmtTime = DateFormat('MM/dd hh:mm')
                        .format(DateTime.parse(comments[index]['createdAt']!))
                        .toString();
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
