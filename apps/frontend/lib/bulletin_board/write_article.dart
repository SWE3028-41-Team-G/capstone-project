import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/bulletin_board/bulletin_board.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class WriteArticle extends StatefulWidget {
  const WriteArticle({super.key});

  @override
  State<WriteArticle> createState() => _WriteArticleState();
}

class _WriteArticleState extends State<WriteArticle> {
  final _formKey = GlobalKey<FormState>();
  List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text(
          '새 글 작성',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(top: 10, right: 10),
            child: ElevatedButton(
              // 완료 버튼 -----------------------------------------------
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: const Color.fromARGB(255, 30, 85, 33),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40))),
              onPressed: () {},
              child: Text(
                '완료',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "제목을 입력해 주세요",
                          hintStyle:
                              TextStyle(fontSize: 20, color: Colors.grey[500]),
                          contentPadding: EdgeInsets.symmetric(vertical: 10)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: MultiSelectChipField(
                        items: [
                          MultiSelectItem('#꿀팁', 'tag1'),
                          MultiSelectItem('#수업추천', 'tag2'),
                          MultiSelectItem('#졸업요건', 'tag3'),
                          MultiSelectItem('#전공진입', 'tag4'),
                          MultiSelectItem('#새내기', 'tag5'),
                        ],
                        title: Text('태그'),
                        onTap: (values) {
                          selectedTags = values;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        minLines: 20,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            hintText: "내용을 입력해 주세요",
                            hintStyle: TextStyle(
                                fontSize: 18, color: Colors.grey[500]))),
                  ],
                ),
              ))),
    );
  }
}
