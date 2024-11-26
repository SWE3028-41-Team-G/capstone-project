import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Article extends StatefulWidget {
  final String title;

  const Article({super.key, required this.title});
  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  final _formKey = GlobalKey<FormState>();

  // Temporal data, will be linked with API soon
  var postData = {
    'imageUrl':
        'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
    "nickname": "명륜이",
    "timestamp": "11/20 12:30",
    "title": "이번 학기에 반드시 수강신청해야하는 과목",
    "like": 12,
    "comment": 3,
    "content":
        "이번 학기에 새롭게 부임하신 이율전 교수님이 진행하시는 암호론 되시겠다. 우선 이 교수님은 별명이 학점천사이실 정도로 학점을 거의 채워서 주시는 걸로 유명하다. 게다가 강의력도 좋으셔서 집중만 하면 내용 이해하는 것도 쉽고 유익하다. 가끔씩 빠뜨린 부분이 있어도 강의저장 올려주시는거 다시 보면서 복습하기까지 가능! 유일한 단점이 수업이 하도 좋다보니 다들 공부도 열심히 하는건지 성적이 다들 높다는 건데..앞서 말했듯이 학점 진짜 꽉꽉 채워담아 주시니까 걱정 ㄴㄴ 지금 당장 책가방에 담기 ㄱㄱ",
    "tags": ["#수학", "#전공진입", "수업추천", "꿀팁"],
  };

  List<dynamic> comments = [
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
  ];

  @override
  Widget build(BuildContext context) {
    // 모집글
    String imageUrl = postData['imageUrl'] as String;
    String nickname = postData['nickname'] as String;
    String timestamp = postData['timestamp'] as String;
    // String title = postData['title'] as String;
    String content = postData['content'] as String;

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nickname,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            timestamp,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(
                    widget.title,
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
                SizedBox(height: 10),
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
                    String cmtTime = comments[index]['timestamp']!;
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
                                  child: Image.network(
                                    cmtImage,
                                    fit: BoxFit.cover,
                                  ),
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
                      decoration: InputDecoration(
                        hintText: '댓글을 입력하세요...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                        suffixIcon: IconButton(
                          icon: Icon(
                            CupertinoIcons.paperplane_fill,
                            color: Colors.grey[500],
                          ),
                          onPressed: () {},
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