import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/bulletin_board/write_article.dart';
import 'package:frontend/bulletin_board/article.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class BulletinBoard extends StatefulWidget {
  const BulletinBoard({super.key});

  @override
  BulletinBoardState createState() => BulletinBoardState();
}

class BulletinBoardState extends State<BulletinBoard> {
  int _selectedFilterIndex = 0;
  // Temporal infos, soon be linked with API
  List<dynamic> filters = [
    ["#수학", "#전공진입"],
    ["#졸업요건", "#수업추천"],
    ["#꿀팁", "#복수전공", "#수업추천"],
    ["#수학", "#소프트웨어", "#CL과목", "#꿀팁"],
  ];
  List<dynamic> articles = [
    {
      "title": "이번 학기에 반드시 수강신청해야하는 과목",
      "like": 12,
      "comment": 3,
      "content": "이번 학기에 새롭게 부임하신 이율전 교수님이 진행하시는 암호론 되시겠다. 우선 이 교수님...",
      "tags": ["#수학", "#전공진입", "수업추천", "꿀팁"],
    },
    {
      "title": "전공진입 수월하게 하는 꿀팁 공유",
      "like": 6,
      "comment": 1,
      "content":
          "다들 전공진입 어떻게 할 지 슬슬 고민되시죠? 전공진입 어느 학과까지 가능한지 쉽게 알 수 있는 꿀팁 공유해...",
      "tags": ["#수학", "#전공진입"],
    },
    {
      "title": "수강신청 망친 분들 참고하세요",
      "like": 2,
      "comment": 6,
      "content": "참고 하라고 ㅋㅋㅋㅋㅋㅋㅋㅋ",
      "tags": ["#수학", "#전공진입", "#도전학기"],
    },
    {
      "title": "알고개 같이 공부하실 분 구해요~",
      "like": 1,
      "comment": 2,
      "content": "월요일 9시 OOO 교수님 알고개 수업 같이  공부하실 분 구합니다!!!",
      "tags": ["#수학", "#전공진입", "#소프트웨어", "#학점컷"],
    },
  ];

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

  // API - GET search results
  Future<void> _fetchArticles() async {
    final response = await http.get(
      Uri.parse('https://skku-dm.site/board?tag=tag'),
      headers: {},
    );

    if (response.statusCode == 200) {
      setState(() {
        articles = jsonDecode(response.body)['articles'];
      });
    } else {
      print('Debugging for GET - Searched articles list');
      print(response.statusCode);
    }
  }

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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WriteArticle()));
                    },
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
                    children: List.generate(filters.length, (index) {
                      return Row(
                        children: [
                          if (index < filters.length) SizedBox(width: 15),
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
                              children: <Widget>[Text('필터#${index + 1}')],
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
                    children: List.generate(
                        filters[_selectedFilterIndex].length, (index) {
                      return Row(
                        children: [
                          if (index < filters[_selectedFilterIndex].length)
                            SizedBox(width: 15),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(filters[_selectedFilterIndex][index],
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
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Article(title: "${articles[index]["title"]}")));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 2))),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(15, 10, 10, 15),
                                    child: Text(
                                      "${articles[index]["title"]}",
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
                                      Text("${articles[index]["like"]}",
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
                                      Text("${articles[index]["comment"]}",
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
                                "${articles[index]["content"]}",
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
                                children: List.generate(
                                    articles[index]["tags"].length, (idx) {
                                  return Row(
                                    children: [
                                      if (index <
                                          articles[index]["tags"].length)
                                        SizedBox(width: 15),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(articles[index]["tags"][idx],
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
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
