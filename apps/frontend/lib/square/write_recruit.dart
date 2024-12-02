import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/home.dart';
import 'package:frontend/register/major.dart';
import 'package:frontend/register/register.dart';
import 'package:frontend/utils/api_helper.dart';
import 'package:provider/provider.dart';

class WriteRecruit extends StatefulWidget {
  const WriteRecruit({super.key});

  @override
  State<WriteRecruit> createState() => _WriteRecruitState();
}

class _WriteRecruitState extends State<WriteRecruit> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  AuthProvider? authProvider;
  late MajorProvider majorProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    majorProvider = Provider.of<MajorProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _focusNode.dispose(); // FocusNode 해제
    super.dispose();
  }

  var title = TextEditingController();
  var content = TextEditingController();

  int? _selectedStudentNumber;

  Map<String, dynamic> recruitPostData = {};

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        majorProvider.removeSelectedMajor('writeRecruitMajor');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          title: Text(
            '모집글 작성',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
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
                  if (_formKey.currentState!.validate()) {
                    recruitPostData['name'] = title
                        .text; // SQUARE 그룹 자체 이름 나중에 시간 있으면 수정하기 =======================
                    recruitPostData['leaderId'] = authProvider!.user?.userId;
                    recruitPostData['majorId'] =
                        majorProvider.selectedMajors['writeRecruitMajor'].id;
                    recruitPostData['max'] = _selectedStudentNumber;
                    recruitPostData['postTitle'] = title.text;
                    recruitPostData['postContent'] = content.text;

                    debugPrint("recruitPostData 확인 중 : $recruitPostData");

                    try {
                      // POST 요청 보내기
                      final response =
                          await authProvider?.post('square', recruitPostData);

                      debugPrint(
                          "모집글 작성 response.statusCode 확인 중 : ${response?.statusCode}");
                      debugPrint(
                          "모집글 작성 response.body 확인 중 : ${response?.body}");

                      // 응답 상태에 따라 처리
                      if (response?.statusCode == 201) {
                        // 성공적으로 처리됨
                        debugPrint("SQURE 모집글 작성 성공!!!!!");
                        final responseData = jsonDecode(response!.body);
                        final squareId = responseData['id'];
                        debugPrint("squareId 확인 중 : $squareId");
                        debugPrint(
                            "userId 확인 중 : ${authProvider?.user?.userId}");

                        final regSquareResponse = await authProvider?.post(
                            'square/$squareId/join',
                            {"userId": authProvider?.user?.userId});
                        debugPrint(
                            "주소 확인 중 : ${regSquareResponse?.toString()}");

                        debugPrint(
                            "스퀘어 작성자 가입 response.statusCode 확인 중 : ${regSquareResponse?.statusCode}");
                        debugPrint(
                            "스퀘어 작성자 가입 작성 response.body 확인 중 : ${regSquareResponse?.body}");

                        majorProvider.removeSelectedMajor('writeRecruitMajor');
                        // SQUARE로 이동
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home(
                                    initialIndex: 1,
                                    squareIndex: 1,
                                  )),
                          (Route<dynamic> route) => false,
                        );
                        // Navigator.pop(context);
                      } else {
                        // 실패
                        debugPrint("SQURE 모집글 작성 실패!!!!!");
                        debugPrint(
                            "Received status code: ${response?.statusCode}");
                      }
                    } catch (e) {
                      // 오류 처리
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('오류 발생: $e')),
                      );
                    }
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
                        controller: title,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                            hintText: "제목을 입력해 주세요",
                            hintStyle: TextStyle(
                                fontSize: 20, color: Colors.grey[500]),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: _focusNode.hasFocus
                                    ? Colors.green[800]!
                                    : Colors.grey[600]!,
                                width: 2,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '제목을 입력해 주세요';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: MajorDropdown(
                              isStyled: false,
                              majorKey:
                                  'writeRecruitMajor', // 뒤로가기 했을때 삭제하기 추가해야됨!!!! ================================
                              labelText: "모집대상 전공 선택",
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: NumberRangeDropdown(
                              labelText: '인원 수 선택',
                              width: MediaQuery.of(context).size.width / 2.7,
                              start: 2,
                              end: 10,
                              onChanged: (value) {
                                setState(() {
                                  _selectedStudentNumber = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          minLines: 20,
                          maxLines: null,
                          controller: content,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '내용을 입력해 주세요';
                            }
                            return null;
                          },
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
      ),
    );
  }
}
