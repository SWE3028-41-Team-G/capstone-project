import 'package:flutter/material.dart';
import 'package:frontend/home.dart';
import 'package:frontend/register/register.dart';

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
  String? _selectedDomain;

  void _onVerifyPressed() {
    final email = '${_emailController.text}${_selectedDomain ?? ''}';
    // 이메일
    print('인증할 이메일: $email');
  }

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
                  // Form 시작------------------------------------------------------
                  key: _formKey, // Assign the GlobalKey to Form
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        EmailInputRow(
                          emailController: _emailController,
                          selectedDomain: _selectedDomain,
                          onDomainChanged: (newDomain) {
                            setState(() {
                              _selectedDomain = newDomain;
                            });
                          },
                          onVerifyPressed: _onVerifyPressed,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
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
  final TextEditingController emailController;
  final String? selectedDomain;
  final Function(String?) onDomainChanged;
  final VoidCallback onVerifyPressed;

  const EmailInputRow({
    super.key,
    required this.emailController,
    required this.selectedDomain,
    required this.onDomainChanged,
    required this.onVerifyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 아이디 입력 필드
        Expanded(
          flex: 2,
          child: TextFormField(
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
            onSaved: (value) {
              emailController.text = value!;
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
