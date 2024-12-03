import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/api_helper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Recruitment extends StatefulWidget {
  Map<String, dynamic> squarePost;
  Recruitment({super.key, required this.squarePost});

  @override
  State<Recruitment> createState() => _RecruitmentState();
}

class _RecruitmentState extends State<Recruitment> {
  double _offsetX = 0.0; // 페이지의 밀리는 정도
  final _formKey = GlobalKey<FormState>();
  AuthProvider? authProvider;

  List<Map<String, dynamic>> comments = [];
  List<Map<String, dynamic>> cmtUserData = [];
  var comment = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint("squarePost 정보 확인 중 : ${widget.squarePost}");
    comments = widget.squarePost['posts'][0]['comments'];
    debugPrint("comments 확인 중 : $comments");
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      cmtUserData = (await getUserDataFromComments(comments))!;
      debugPrint("cmtUserData 확인 중 : $cmtUserData");
    } catch (e) {
      debugPrint('_fetchUserData 로드 중 오류 발생: $e');
    }
  }

  String formatDate(String isoString) {
    DateTime parsedDate = DateTime.parse(isoString);
    // 원하는 포맷 생성
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(parsedDate);
    return formattedDate;
  }

  Future<List<Map<String, dynamic>>?> getUserDataFromComments(
      List<Map<String, dynamic>> comments) async {
    try {
      // 중복된 userId를 제거하기 위해 Set을 사용
      Set<int> uniqueUserIds = {};
      for (var comment in comments) {
        debugPrint("var comment in comments에서 comment 확인 중 : $comment");
        debugPrint(
            "var comment in comments에서 userId 확인 중 : ${comment['userId']}");
        uniqueUserIds.add(comment['userId']);
      }

      debugPrint("댓글 아이디 세팅 끝나고 uniqueUserIds 확인 중 : $uniqueUserIds");

      // 중복되지 않은 userId에 대해 사용자 데이터 가져오기
      List<Map<String, dynamic>> userDataList = [];
      for (var userId in uniqueUserIds) {
        debugPrint("두번째 반복문에서 userId 확인 중 : $userId");
        final userData = await getCmtUserById(userId);
        debugPrint("두번째 반복문에서 userData 확인 중 : $userData");
        if (userData != null) {
          userDataList.add(userData);
        }
      }

      if (!uniqueUserIds.contains(widget.squarePost['leader']['id'])) {
        final leaderData =
            await getCmtUserById(widget.squarePost['leader']['id']);
        if (leaderData != null) {
          userDataList.add(leaderData);
        }
      }

      return userDataList;
    } catch (e) {
      debugPrint('getUserDataFromComments 중 오류 발생: $e');
      // rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getCmtUserById(int userId) async {
    try {
      // GET 요청 전송
      final response = await authProvider?.get('users/$userId/profile');
      debugPrint("getCmtUserById에서 userId 확인 중 : $userId");
      debugPrint("댓글 작성자 데이터 GET statusCode: ${response!.statusCode}");
      debugPrint("댓글 작성자 데이터 response.body: ${response.body}");

      if (response?.statusCode == 200 && response.body.isNotEmpty) {
        final cmtData = jsonDecode(response.body);
        String nickname = cmtData['nickname'];
        String imageUrl = cmtData['imageUrl'];

        return {
          'id': userId,
          'nickname': nickname,
          'imageUrl': imageUrl,
        };
      } else if (response.body.isEmpty) {
        String nickname = "익명";
        String imageUrl =
            'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg';
        return {
          'id': userId,
          'nickname': nickname,
          'imageUrl': imageUrl,
        };
        // throw Exception('댓글 작성자 데이터를 가져오지 못했습니다.');
      }
    } catch (e) {
      debugPrint('getCmtUserById 중 오류 발생: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode _focusNode = FocusNode();

    @override
    void dispose() {
      _focusNode.dispose();
      super.dispose();
    }

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _offsetX += details.primaryDelta!;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_offsetX > 100) {
          Navigator.pop(context);
        } else {
          setState(() {
            _offsetX = 0.0;
          });
        }
      },
      child: Transform.translate(
        offset: Offset(_offsetX, 0),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            title: Text("", style: TextStyle(fontSize: 20)),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(2.0),
              child: Container(
                color: Colors.grey[200],
                height: 1.0,
              ),
            ),
          ),
          body: FutureBuilder<List<Map<String, dynamic>>?>(
            future: getUserDataFromComments(comments),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('데이터 로딩 중 오류 발생'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container();
              } else {
                cmtUserData = snapshot.data!;

                // 모집글 작성자 데이터 설정
                Map<String, dynamic> leaderDatas = cmtUserData.firstWhere(
                  (element) =>
                      element['id'] == widget.squarePost['leader']['id'],
                  orElse: () => {
                    'nickname': '익명',
                    'imageUrl':
                        'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
                  },
                );

                String nickname = leaderDatas['nickname'] ?? '익명';
                String imageUrl =
                    leaderDatas['imageUrl'] ?? 'default_image_url';
                String timestamp =
                    formatDate(widget.squarePost['createdAt'] as String);
                String title = widget.squarePost['posts'][0]['title'] as String;
                String content =
                    widget.squarePost['posts'][0]['content'] as String;
                int confirmNumber = widget.squarePost['members'].length as int;
                int recruitNumber = widget.squarePost['max'] as int;

                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        children: [
                          // 모집글 정보 표시 부분
                          SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                  height: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      nickname,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Flexible(
                                      child: AutoSizeText(
                                        timestamp,
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  '($confirmNumber/$recruitNumber)',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: confirmNumber <= recruitNumber / 2
                                        ? Colors.blue
                                        : Colors.red,
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              title,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              content,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),

                          // 댓글 리스트 부분
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> userData =
                                  cmtUserData.firstWhere(
                                (element) =>
                                    element['id'] == comments[index]['userId'],
                                orElse: () => {
                                  'nickname': '익명',
                                  'imageUrl':
                                      'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
                                },
                              );

                              String cmtImage =
                                  userData['imageUrl'] ?? 'default_image_url';
                              String cmtName = userData['nickname'] ?? '익명';
                              String cmtContent = comments[index]['content']!;
                              String cmtTime =
                                  formatDate(comments[index]['createdAt']!);

                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            child: Image.network(
                                              cmtImage,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  AutoSizeText(
                                                    cmtName,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(width: 10),
                                                  AutoSizeText(
                                                    cmtTime,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                            Colors.grey[400]),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: AutoSizeText(
                                                  cmtContent,
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Divider(color: Colors.grey[300]),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // 댓글 입력창
                      margin:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                maxLines: 2,
                                controller: comment,
                                focusNode: _focusNode,
                                decoration: InputDecoration(
                                  hintText: '댓글을 입력하세요...',
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.green[700]!,
                                      width: 2.0,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(10),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      CupertinoIcons.paperplane_fill,
                                      color: Colors.grey[500],
                                    ),
                                    onPressed: () async {
                                      try {
                                        final response =
                                            await authProvider?.post(
                                          'square/${widget.squarePost['posts'][0]['id']}/comments',
                                          {
                                            "userId":
                                                authProvider?.user?.userId,
                                            "content": comment.text
                                          },
                                        );

                                        if (response?.statusCode == 201) {
                                          comment.clear();
                                          final responseData =
                                              jsonDecode(response!.body);
                                          setState(() {
                                            comments.add(responseData);
                                          });
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                                onChanged: (text) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
