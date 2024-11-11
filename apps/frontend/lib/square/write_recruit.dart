import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/register.dart';

class WriteRecruit extends StatefulWidget {
  const WriteRecruit({super.key});

  @override
  State<WriteRecruit> createState() => _WriteRecruitState();
}

class _WriteRecruitState extends State<WriteRecruit> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String? selectedMajor;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
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
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: "모집대상 전공 선택",
                              // labelStyle: TextStyle(color: Colors.grey[500]),
                              border: OutlineInputBorder(),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                            value: selectedMajor,
                            items: [
                              DropdownMenuItem(
                                  value: '경제학과', child: Text('경제학과')),
                              DropdownMenuItem(
                                  value: '소프트웨어학과', child: Text('소프트웨어학과')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedMajor = value; // 선택된 값 업데이트
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return '전공을 선택해 주세요.';
                              }
                              return null;
                            },
                          ),
                        ),
                        Spacer(),
                        NumberRangeDropdown(
                          labelText: '인원 수 선택',
                          width: MediaQuery.of(context).size.width / 2.7,
                          start: 2,
                          end: 10,
                        )
                      ],
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
