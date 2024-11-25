import 'package:flutter/material.dart';
import 'package:frontend/home.dart';
import 'package:frontend/register/register.dart';
import 'package:frontend/utils/api_helper.dart';
import 'package:provider/provider.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({
    super.key,
  });

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for Form
  String? _selectedDomain;

  var username = TextEditingController(); // id 입력 저장
  var password = TextEditingController(); // pw 입력 저장

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
                  // Form 시작------------------------------------------------------
                  key: _formKey, // Assign the GlobalKey to Form
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        EmailInputRow(
                          textController: username,
                          selectedDomain: _selectedDomain,
                          onDomainChanged: (newDomain) {
                            setState(() {
                              _selectedDomain = newDomain;
                            });
                          },
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            // 비밀번호 입력 TextFormField------------------------------
                            obscureText: true,
                            controller: password,
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
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: ElevatedButton(
                            //로그인 버튼 -----------------------------------------
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                    const Color.fromARGB(255, 30, 85, 33),
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                // 로그인 요청
                                await context.read<AuthProvider>().login(
                                      username.text,
                                      password.text,
                                    );

                                // 로그인 성공 후, 홈 화면으로 이동
                                if (context.read<AuthProvider>().isLoggedIn) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => Home()),
                                  );
                                } else {
                                  // 로그인 실패 시 처리 (예: 오류 메시지)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('로그인 실패')),
                                  );
                                }
                              }
                            },
                            child: Text(
                              "로그인",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
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

// 이메일 입력
class EmailInputRow extends StatelessWidget {
  final TextEditingController textController;
  final String? selectedDomain;
  final Function(String?) onDomainChanged;

  const EmailInputRow({
    super.key,
    required this.textController,
    required this.selectedDomain,
    required this.onDomainChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 아이디 입력 필드
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: textController,
            decoration: InputDecoration(
              labelText: "아이디",
              floatingLabelBehavior:
                  FloatingLabelBehavior.never, //labeltext 올라가는 거 안 보이게 하기
              contentPadding: EdgeInsets.all(20),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '아이디를 입력해 주세요.';
              }
              return null;
            },
          ),
        ),

        SizedBox(width: 8),

        // 도메인 선택 드롭다운
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "도메인 선택",
              floatingLabelBehavior:
                  FloatingLabelBehavior.never, //labeltext 올라가는 거 안 보이게 하기
              contentPadding: EdgeInsets.all(20),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
            value: selectedDomain,
            items: [
              DropdownMenuItem(
                  value: '@g.skku.edu', child: Text('@g.skku.edu')),
              DropdownMenuItem(value: '@skku.edu', child: Text('@skku.edu')),
            ],
            onChanged: onDomainChanged,
            validator: (value) {
              if (value == null) {
                return '도메인을 선택해 주세요.';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
