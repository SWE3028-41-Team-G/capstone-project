import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/bulletin_board/bulletin_board.dart';
import 'package:frontend/utils/api_helper.dart';

class WriteArticle extends StatefulWidget {
  const WriteArticle({super.key});

  @override
  State<WriteArticle> createState() => _WriteArticleState();
}

class _WriteArticleState extends State<WriteArticle> {
  final _formKey = GlobalKey<FormState>();

  AuthProvider? authProvider;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // Temporal infos, soon be linked with API
  List<dynamic> tags = [
    "#수학",
    "#전공진입",
    "#꿀팁",
    "#소프트웨어",
    "#졸업요건",
    "#CL과목",
    "#수업추천",
    "#명강의"
  ];
  List<dynamic> selectedTags = [];

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    var userData = authProvider?.user;
  }

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
              onPressed: () async {
                try {
                  final response = await AuthProvider
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('오류 발생: $e')),
                  );
                }            
              },
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
                      controller: titleController,
                      decoration: InputDecoration(
                          hintText: "제목을 입력해 주세요",
                          hintStyle:
                              TextStyle(fontSize: 20, color: Colors.grey[500]),
                          contentPadding: EdgeInsets.symmetric(vertical: 10)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    MultiSelectChipField(
                      items: tags.map((e) => MultiSelectItem(e, e)).toList(),
                      title: Text('태그'),
                      onTap: (values) {
                        setState(() {
                          selectedTags = values;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        controller: contentController,
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
