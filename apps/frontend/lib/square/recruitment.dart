import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/square/square.dart';

class Recruitment extends StatefulWidget {
  const Recruitment({super.key});

  @override
  State<Recruitment> createState() => _RecruitmentState();
}

class _RecruitmentState extends State<Recruitment> {
  double _offsetX = 0.0; // 페이지의 밀리는 정도
  final _formKey = GlobalKey<FormState>();

  var postData = [
    {
      'imageUrl':
          'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
      "nickname": "명륜이",
      "timestamp": "11/08 22:15",
      "title": "운영체제 같이 공부하실 솦트 복전생 찾고 있어여",
      "content":
          "이번에 엄영익 교수님 운영체제 듣을 예정인데(만약 수강신청 성공한다면...) 혹시 같이 으샤으샤 공부하실 복전생있나요?? 저도 잘하는 건 아니라 같이 힘내서 xv6 뿌실 전우 구해요!!",
      "confirmNumber": 2,
      "recruitNumber": 4,
    }
  ];

  List<Map<String, dynamic>> comments = [
    {
      'imageUrl':
          'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
      "nickname": "율전이",
      "content": "주로 언제 모일 예정이신가요?",
      "timestamp": "11/09 16:30",
    },
    {
      'imageUrl':
          'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
      "nickname": "율전이",
      "content": "주로 언제 모일 예정이신가요?",
      "timestamp": "11/09 16:30",
    },
    {
      'imageUrl':
          'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
      "nickname": "율전이",
      "content": "주로 언제 모일 예정이신가요?",
      "timestamp": "11/09 16:30",
    },
    {
      'imageUrl':
          'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
      "nickname": "율전이",
      "content": "주로 언제 모일 예정이신가요?",
      "timestamp": "11/09 16:30",
    },
    {
      'imageUrl':
          'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
      "nickname": "율전이",
      "content": "주로 언제 모일 예정이신가요?",
      "timestamp": "11/09 16:30",
    },
    {
      'imageUrl':
          'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
      "nickname": "율전이",
      "content": "주로 언제 모일 예정이신가요?",
      "timestamp": "11/09 16:30",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 모집글
    String imageUrl = postData[0]['imageUrl'] as String;
    String nickname = postData[0]['nickname'] as String;
    String timestamp = postData[0]['timestamp'] as String;
    String title = postData[0]['title'] as String;
    String content = postData[0]['content'] as String;
    int confirmNumber = postData[0]['confirmNumber'] as int;
    int recruitNumber = postData[0]['recruitNumber'] as int;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          // 터치에 의한 X축 방향으로 이동하는 정도를 _offsetX에 반영
          _offsetX += details.primaryDelta!;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_offsetX > 100) {
          // 페이지가 일정 이상 밀리면 이전 페이지로 이동
          Navigator.pop(
              context); // 수정하기 ----------------------------------------------------
        } else {
          // 밀리지 않으면 원위치로 되돌린다
          setState(() {
            _offsetX = 0.0;
          });
        }
      },
      child: Transform.translate(
        offset: Offset(_offsetX, 0), // 밀리는 방향
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            title: Text(
              "소프트웨어학과",
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
                                child: Text(
                                  timestamp,
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
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
        ),
      ),
    );
  }
}
