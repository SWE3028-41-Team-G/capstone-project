import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Recruitment extends StatefulWidget {
  const Recruitment({super.key});

  @override
  State<Recruitment> createState() => _RecruitmentState();
}

class _RecruitmentState extends State<Recruitment> {
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
      "nickname": "명륜이",
      "content": "주로 언제 모일 예정이신가요?",
      "timestamp": "11/08 22:15",
    }
  ];

  @override
  Widget build(BuildContext context) {
    String imageUrl = postData[0]['imageUrl'] as String;
    String nickname = postData[0]['nickname'] as String;
    String timestamp = postData[0]['timestamp'] as String;
    String title = postData[0]['title'] as String;
    String content = postData[0]['content'] as String;
    int confirmNumber = postData[0]['confirmNumber'] as int;
    int recruitNumber = postData[0]['recruitNumber'] as int;

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 60,
          // backgroundColor: Colors.grey[100],
          title: Text(
            "소프트웨어학과",
            style: TextStyle(fontSize: 20),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(2.0), // 선의 높이 설정
            child: Container(
              color: Colors.grey[200], // 선의 색상 설정
              height: 1.0, // 선의 두께 설정
            ),
          )),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                // height: MediaQuery.of(context).size.width *
                                //     0.5 *
                                //     5 /
                                //     3 *
                                //     0.55,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
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
                              )
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
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Text(
                        content,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
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
                          icon: Icon(CupertinoIcons.paperplane_fill),
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
                        // 입력된 댓글 처리
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
