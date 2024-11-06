import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http; // will be used later for API connection

class BulletinBoard extends StatefulWidget {
  const BulletinBoard({super.key});

  @override
  BulletinBoardState createState() => BulletinBoardState();
}

class BulletinBoardState extends State<BulletinBoard> {
  int _selectedFilterIndex = 0;
  // List<dynamic> filters = [];

  @override
  void initState() {
    super.initState();
  }

  // API - GET filters
  // Future<void> _fetchFilters() async {
  //   final response = await http.get(
  //     Uri.parse(''),
  //     headers: {

  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       filters = jsonDecode(response.body)['filters'];
  //     });
  //   }
  //   else {
  //     print('Debugging for GET - Filters list');
  //     print(response.statusCode);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Bulletin Board',
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
          // write button and filter settings
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.filter_alt),
                    label: Text(
                      '필터 수정',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    )),
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                    label: Text(
                      '새 글 작성',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    )),
              ],
            ),
          ),
          // filter menus
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                // Filter lists
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(4, (index) {
                      String text = ['필터 #1', '필터 #2', '필터 #3', '필터 #4'][index];
                      return Row(
                        children: [
                          if (index < 4) SizedBox(width: 15),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedFilterIndex = index;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedFilterIndex == index
                                  ? Colors.blueAccent
                                  : Colors.grey,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[Text(text)],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                // Tag results
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: List.generate(4, (index) {
                      String text = ['#수학', '#전공진입', '#수업추천', '#꿀팁'][index];
                      return Row(
                        children: [
                          if (index < 4) SizedBox(width: 15),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(text,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.lightBlue))
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          // "Results" Textbox
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.all(10),
            child: Text(
              '검색결과',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          // results
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: List.generate(4, (index) {
                  String title = [
                    "이번 학기에 반드시 수강신청해야하는 과목",
                    "전공진입 수월하게 하는 꿀팁 공유",
                    "수강신청 망친 분들 참고하세요",
                    "알고개 같이 공부하실 분 구해요~"
                  ][index];
                  int like = [12, 6, 2, 1][index];
                  int comment = [3, 1, 6, 2][index];
                  String content = [
                    "이번 학기에 새롭게 부임하신 이율전 교수님이 진행하시는 암호론 되시겠다. 우선 이 교수님...",
                    "다들 전공진입 어떻게 할 지 슬슬 고민되시죠? 전공진입 어느 학과까지 가능한지 쉽게 알 수 있는 꿀팁 공유해...",
                    "참고 하라고 ㅋㅋㅋㅋㅋㅋㅋㅋ",
                    "월요일 9시 수업 같이 듣고 공부하실 분 구합니다!!!",
                  ][index];

                  return Column(
                    children: [
                      if (index < 4) SizedBox(height: 15),
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                child: Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.heart,
                                      color: Colors.pinkAccent,
                                      size: 16,
                                    ),
                                    Text('$like',
                                        style: TextStyle(
                                          color: Colors.pinkAccent,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(width: 3),
                              GestureDetector(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.comment,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                    Text('$comment',
                                        style: TextStyle(
                                          color: Colors.black,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(20, 5, 10, 5),
                            child: Text(
                              content,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              children: List.generate(4, (index) {
                                String text =
                                    ['#수학', '#전공진입', '#수업추천', '#꿀팁'][index];
                                return Row(
                                  children: [
                                    if (index < 4) SizedBox(width: 15),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(text,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.lightBlue))
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
