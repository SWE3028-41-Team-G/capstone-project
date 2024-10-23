import 'package:flutter/material.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({
    super.key,
  });

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for Form

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
                            // 적당히 처리해둔 것
                            if (value!.isEmpty) {
                              return '이메일을 입력해 주세요.';
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

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title:
                                        Text("id: $_idValue \npw: $_pwValue"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
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
                  onPressed: () {},
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
