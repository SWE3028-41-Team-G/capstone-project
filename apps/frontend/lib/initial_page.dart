import 'package:flutter/material.dart';
import 'package:frontend/home.dart';
import 'package:frontend/register.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({
    super.key,
  });

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for Form
  final _emailController = TextEditingController(); //email 유효성 검사

  String _idValue = "";
  String _pwValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                  // SKKU 로고 사진
                  width: 150,
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJxeZwPm3efZhPfYvvalvurcIEA-vQssxoEA&s"),
              SizedBox(
                height: 50,
              ),
              Text(
                // Title
                "SKKU-DM",
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                ),
              ),
              Text(
                // Subtitle
                "Connection with SKKU Double Majors",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                  key: _formKey, // Assign the GlobalKey to Form
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          // 이메일 입력 TextFormField --------------------------------
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "이메일을 입력해 주세요",
                            floatingLabelBehavior: FloatingLabelBehavior
                                .never, //labeltext 올라가는 거 안 보이게 하기
                            contentPadding: EdgeInsets.all(20),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
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
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: TextFormField(
                          // 비밀번호 입력 TextFormField------------------------------
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "비밀번호를 입력해 주세요",
                            floatingLabelBehavior: FloatingLabelBehavior
                                .never, //labeltext 올라가는 거 안 보이게 하기
                            contentPadding: EdgeInsets.all(20),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '비밀번호를 입력해 주세요.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _pwValue = value!;
                          },
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: ElevatedButton(
                          //로그인 버튼 -----------------------------------------
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  const Color.fromARGB(255, 30, 85, 33),
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              // 화면 전환
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Home()));
                            }
                          },
                          child: Text(
                            "로그인",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )),
              TextButton(
                  // 회원가입 버튼 ----------------------------------
                  onPressed: () {
                    // 화면 전환
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.green[600]!, width: 0.5))),
                    child: Text(
                      "아직 회원이 아니신가요?",
                      style: TextStyle(
                        color: Colors.green[600],
                        fontSize: 13,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
