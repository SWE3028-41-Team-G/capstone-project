import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

import 'package:frontend/bulletin_board/write_article.dart';
import 'package:frontend/bulletin_board/article.dart';
import 'package:frontend/utils/api_helper.dart';

class BulletinBoard extends StatefulWidget {
  const BulletinBoard({super.key});

  @override
  BulletinBoardState createState() => BulletinBoardState();
}

class BulletinBoardState extends State<BulletinBoard> {
  // Temporal infos, soon be linked with API
  List<dynamic> tags = [
    "수학",
    "전공진입",
    "꿀팁",
    "소프트웨어",
    "졸업요건",
    "CL과목",
    "수업추천",
    "명강의",
    "복수전공",
  ];
  List<dynamic> selectedTags = [];
  List<dynamic> articles = [];

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response = await authProvider.get('board');
      if (response.statusCode == 200) {
        setState(() {
          articles = jsonDecode(response.body);
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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    var userData = authProvider.user;

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
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WriteArticle()));
                },
                icon: Icon(Icons.edit),
                label: Text(
                  '새 글 작성',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                )),
          ),
          // tag selection & search menu
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: MultiSelectChipField(
              items: tags.map((e) => MultiSelectItem(e, "#$e")).toList(),
              title: Text('태그'),
              onTap: (values) {
                setState(() {
                  selectedTags = values;
                });
              },
            ),
          ),
          // "Results" Textbox
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  '검색결과',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      try {
                        late dynamic response;
                        if (selectedTags.isEmpty) {
                          response = await authProvider.get('board');
                        } else {
                          response = await authProvider
                              .get('board?tags=${selectedTags.join('&tags=')}');
                        }
                        if (response.statusCode == 200) {
                          debugPrint("게시판 글 검색 성공!!!!!");
                          setState(() {
                            articles = jsonDecode(response.body);
                          });
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
                    icon: Icon(Icons.refresh_outlined))
              ],
            ),
          ),
          // results
          Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    debugPrint(articles[index]["id"]
                        .runtimeType
                        .toString()); //debugging
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Article(id: articles[index]["id"])));
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
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.heart,
                                      color: Colors.pinkAccent,
                                      size: 16,
                                    ),
                                    Text("${articles[index]["likes"]}",
                                        style: TextStyle(
                                          color: Colors.pinkAccent,
                                        )),
                                  ],
                                ),
                                SizedBox(width: 3),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.comment,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                    Text(
                                        "${articles[index]["Comment"].length ?? 0}",
                                        style: TextStyle(
                                          color: Colors.black,
                                        )),
                                  ],
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
                                    articles[index]["tags"].length ?? 0, (idx) {
                                  return Row(
                                    children: [
                                      if (index <
                                          (articles[index]["tags"].length ?? 0))
                                        SizedBox(width: 15),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                              '#${articles[index]["tags"][idx]}',
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
