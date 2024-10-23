import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for Form

  String _idValue = "";
  String _pwValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        elevation: 0.5,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0), // 선의 높이 설정
          child: Container(
            color: Colors.grey[200], // 선의 색상 설정
            height: 1.0, // 선의 두께 설정
          ),
        ),
        leading: Row(
          children: [
            SizedBox(width: 16),
            Text(
              '회원가입',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        leadingWidth: 100,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(CupertinoIcons.xmark, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey, // Assign the GlobalKey to Form
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: TextFormField(
                // 이메일 입력 TextFormField --------------------------------
                decoration: InputDecoration(
                  labelText: "이메일을 입력해 주세요",
                  floatingLabelBehavior:
                      FloatingLabelBehavior.always, //labeltext 위에 고정
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // 입력값이 null 이거나 비었을 때 처리
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력해 주세요.';
                  }

                  // 이메일 형식이 맞는지 확인
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return '이메일 형식으로 입력해 주세요';
                  }

                  // 학교 이메일 형식 확인
                  if (!(value.endsWith('@g.skku.edu') ||
                      value.endsWith('@skku.edu'))) {
                    return '학교 구글 이메일로 로그인해 주세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _idValue = value!;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: TextFormField(
                obscureText: true,
                // 이메일 입력 TextFormField --------------------------------
                decoration: InputDecoration(
                  labelText: "비밀번호를 입력해 주세요",
                  floatingLabelBehavior:
                      FloatingLabelBehavior.always, //labeltext 위에 고정
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // 입력값이 null 이거나 비었을 때 처리
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해 주세요.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _pwValue = value!;
                },
              ),
            ),
            NumberRangeDropdown(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: TextFormField(
                // 이메일 입력 TextFormField --------------------------------
                decoration: InputDecoration(
                  labelText: "원전공을 입력해 주세요",
                  floatingLabelBehavior:
                      FloatingLabelBehavior.always, //labeltext 위에 고정
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // 입력값이 null 이거나 비었을 때 처리
                  if (value == null || value.isEmpty) {
                    return '원전공을 입력해 주세요.';
                  }
                  return null;
                },
                onSaved: (value) {
                  // _pwValue = value!;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: TextFormField(
                // 이메일 입력 TextFormField --------------------------------
                decoration: InputDecoration(
                  labelText: "복수전공을 입력해 주세요",
                  floatingLabelBehavior:
                      FloatingLabelBehavior.always, //labeltext 위에 고정
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // 입력값이 null 이거나 비었을 때 처리
                  if (value == null || value.isEmpty) {
                    return '복수전공을 입력해 주세요.';
                  }
                  return null;
                },
                onSaved: (value) {
                  // _pwValue = value!;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: TextFormField(
                minLines: 5,
                maxLines: 10,
                // 원전공 정보 입력 TextFormField --------------------------------
                decoration: InputDecoration(
                  labelText: "원전공에 관한 정보를 입력해 주세요",
                  floatingLabelBehavior:
                      FloatingLabelBehavior.always, //labeltext 위에 고정
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // 입력값이 null 이거나 비었을 때 처리
                  if (value == null || value.isEmpty) {
                    return '원전공에 관한 정보를 입력해 주세요.';
                  }
                  return null;
                },
                onSaved: (value) {
                  // _pwValue = value!;
                },
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: ElevatedButton(
                //회원가입 버튼 -----------------------------------------
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(255, 30, 85, 33),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                },
                child: Text(
                  "회원가입",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

// 학번 Dropdown 숫자
class NumberRangeDropdown extends StatefulWidget {
  @override
  _NumberRangeDropdownState createState() => _NumberRangeDropdownState();
}

class _NumberRangeDropdownState extends State<NumberRangeDropdown> {
  int? _selectedValue; // 선택된 값 저장

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: '학번을 선택해 주세요',
          border: OutlineInputBorder(),
        ),
        value: _selectedValue, // 현재 선택된 값
        items: List.generate(15, (index) => index + 10) // 10부터 24까지 숫자 생성
            .map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
        onChanged: (int? newValue) {
          setState(() {
            _selectedValue = newValue; // 선택된 값 업데이트
          });
        },
      ),
    );
  }
}
