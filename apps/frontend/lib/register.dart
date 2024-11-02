import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for Form

  final _emailController = TextEditingController();
  String? _selectedDomain;
  String? selectedDoubleMajor;

  void _onVerifyPressed() {
    final email = '${_emailController.text}${_selectedDomain ?? ''}';
    // 여기에 이메일 인증 로직 추가
    print('인증할 이메일: $email');
  }

  //String _idValue = "";
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
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 5),
                child: Text(
                  "학교 구글 이메일 인증을 진행해 주세요",
                ),
              ),
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
              CustomTextFormField(
                labelText: "비밀번호를 입력해 주세요",
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해 주세요.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _pwValue = value!;
                },
              ),
              CustomTextFormField(
                labelText: "비밀번호를 재입력해 주세요",
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 재입력해 주세요.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _pwValue = value!;
                },
              ),
              CustomTextFormField(
                labelText: "원전공을 입력해 주세요",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '원전공을 입력해 주세요.';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  NumberRangeDropdown(),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    // width: MediaQuery.of(context).size.width / 2,
                    // margin: EdgeInsets.symmetric(vertical: 10),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "복수전공 여부",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedDoubleMajor,
                      items: [
                        DropdownMenuItem(value: '해당없음', child: Text('해당없음')),
                        DropdownMenuItem(value: '복수전공생', child: Text('복수전공생')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedDoubleMajor = value; // 선택된 값 업데이트
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
                ],
              ),
              CustomTextFormField(
                labelText: "복수전공을 입력해 주세요",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '복수전공을 입력해 주세요.';
                  }
                  return null;
                },
              ),
              // CustomTextFormField(
              //   labelText: "원전공에 관한 정보를 입력해 주세요",
              //   minLines: 5,
              //   maxLines: 10,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return '원전공에 관한 정보를 입력해 주세요.';
              //     }
              //     return null;
              //   },
              // ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton(
                  //회원가입 버튼 -----------------------------------------
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color.fromARGB(255, 30, 85, 33),
                      padding: EdgeInsets.symmetric(vertical: 13),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                  },
                  child: Text(
                    "다음",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

// 이메일 입력 및 인증
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
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // 아이디 입력 필드
          Expanded(
            flex: 2,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "아이디",
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(),
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
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(),
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

          SizedBox(width: 8),

          // 인증 버튼
          Expanded(
            flex: 1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  backgroundColor: const Color.fromARGB(255, 30, 85, 33),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: onVerifyPressed,
              child: Text(
                '인증',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TextFormField 위젯 커스텀
class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final bool obscureText;
  final int? minLines;
  final int? maxLines;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.validator,
    this.onSaved,
    this.obscureText = false,
    this.minLines,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        obscureText: obscureText,
        minLines: minLines,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.all(17),
          border: OutlineInputBorder(),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
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
      margin: EdgeInsets.symmetric(vertical: 10),
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
