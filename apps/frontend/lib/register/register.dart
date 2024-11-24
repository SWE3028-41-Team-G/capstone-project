import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/initial_page.dart';
import 'package:frontend/register/register_profile.dart';
import 'package:frontend/register/major.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/api_helper.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for Form

  final _emailController = TextEditingController();
  String? _selectedDomain;
  String? _email;
  String? _pin;
  bool isVerified = false;

  String? _pwValue;
  String? _checkPwValue;

  int? _selectedStudentNumber;
  bool selectedDoubleMajor = false;

  late MajorProvider majorProvider;

  // FocusNode를 클래스 내에서 선언
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // initState에서 listen: false 사용
    majorProvider = Provider.of<MajorProvider>(context, listen: false);
    // FocusNode에 리스너 추가하여 포커스 상태 추적
    _focusNode.addListener(() {
      setState(() {}); // 포커스 상태가 변경되면 UI 업데이트
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // FocusNode 해제
    super.dispose();
  }

  Future<void> _onVerifyPressed() async {
    setState(() {
      _email = '${_emailController.text}${_selectedDomain!}';
      debugPrint('인증할 이메일 확인중!!!: $_email');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("이메일이 확인중")),
      );
    });
    // 이메일 인증 로직 추가
    final Uri request =
        ApiHelper.buildRequest('users/verify-email/request'); // API endpoint
    final emailBody = {"email": _email};
    debugPrint("emailBody 디버깅주우우웅 : $emailBody");

    try {
      // 이메일 인증 요청 HTTP POST 요청 보내기
      final response = await http.post(
        request,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(emailBody), // JSON 형식으로 변환
      );
      debugPrint("API 요청 URL: $request");
      debugPrint("응답 상태 코드: ${response.statusCode}");
      debugPrint("responseBody 디버깅주우우웅 : ${response.body}");
      debugPrint("요청 헤더: ${{"Content-Type": "application/json"}}");
      debugPrint("요청 본문: ${jsonEncode(emailBody)}");

      if (response.statusCode == 201) {
        // 요청 성공
        debugPrint("인증 이메일 전송 성공!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("인증 이메일이 전송되었습니다.")),
        );
      } else {
        // 요청 실패
        debugPrint("인증 이메일 전송 실패: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("인증 이메일 전송에 실패했습니다. 다시 시도해주세요.")),
        );
      }
    } catch (e) {
      // 네트워크 또는 기타 오류 처리
      debugPrint("오류 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("오류가 발생했습니다. 인터넷 연결을 확인해주세요.")),
      );
    }
  }

  Future<void> _onCheckPressed() async {
    debugPrint("PIN번호 확인중: $_pin");

    final Uri request =
        ApiHelper.buildRequest('users/verify-email'); // API endpoint
    final verifyBody = {"email": _email, "pin": _pin};

    try {
      // 이메일 인증 확인 HTTP POST 요청 보내기
      final response = await http.post(
        request,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(verifyBody), // JSON 형식으로 변환
      );

      debugPrint("API 요청 URL: $request");
      debugPrint("응답 상태 코드: ${response.statusCode}");
      debugPrint("responseBody 디버깅주우우웅 : ${response.body}");
      debugPrint("요청 헤더: ${{"Content-Type": "application/json"}}");
      debugPrint("요청 본문: ${jsonEncode(verifyBody)}");

      if (response.statusCode == 201) {
        // 요청 성공
        final responseData = jsonDecode(response.body); // 응답 JSON 파싱
        setState(() {
          isVerified = responseData['verify'] as bool; // verify 값 확인
        });

        debugPrint("2번째!!! responseBody 디버깅주우우웅 : $isVerified");
        if (isVerified) {
          debugPrint("인증 성공! ^___^");
        } else {
          debugPrint("인증 실패: PIN 번호가 유효하지 않습니다.");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("인증번호가 유효하지 않습니다. 다시 시도해주세요.")),
          );
        }
      } else {
        // 요청 실패
        debugPrint("요청 실패: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("서버 오류가 발생했습니다. 다시 시도해주세요.")),
        );
      }
    } catch (e) {
      // 네트워크 또는 기타 오류 처리
      debugPrint("오류 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("오류가 발생했습니다. 인터넷 연결을 확인해주세요.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // provider 이용해서 majorID 관리하기
    final selectedMajors = majorProvider.selectedMajors;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const InitialPage()),
                (Route<dynamic> route) => false, // 모든 기존 라우트를 제거하고 새 페이지로 이동
              );
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
              //PIN 번호 입력
              Visibility(
                visible: _email != null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      child: CustomTextFormField(
                        labelText: "인증번호를 입력해 주세요",
                        // obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _pin = value;
                          });
                        },
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 30, 85, 33),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: _onCheckPressed,
                        child: Text(
                          '확인',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isVerified,
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_outlined,
                      size: 18,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "이메일이 인증되었습니다",
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              CustomTextFormField(
                labelText: "비밀번호를 입력해 주세요",
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  return null;
                },
                onChanged: (value) {
                  _pwValue = value!;
                  debugPrint("비번 확인 중 : $_pwValue");
                },
              ),
              CustomTextFormField(
                labelText: "비밀번호를 재입력해 주세요",
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  if (value != _pwValue) {
                    return '비밀번호가 일치하지 않습니다.';
                  }
                  return null;
                },
                onChanged: (value) {
                  _checkPwValue = value!;
                  debugPrint("재입력 비번 확인 중 : $_checkPwValue");
                },
              ),
              MajorDropdown(
                isStyled: false,
                majorKey: 'primaryMajor',
                labelText: "원전공을 선택해 주세요",
              ),

              Row(
                children: [
                  NumberRangeDropdown(
                    labelText: '입학년도 선택',
                    start: 2010,
                    end: DateTime.now().year.toInt(),
                    width: null,
                    onChanged: (value) {
                      setState(() {
                        _selectedStudentNumber = value;
                        debugPrint("학번 확인중 : $_selectedStudentNumber");
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    // width: MediaQuery.of(context).size.width / 2,
                    // margin: EdgeInsets.symmetric(vertical: 10),
                    child: DropdownButtonFormField<bool?>(
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        labelText: "복수전공 여부",
                        labelStyle: TextStyle(
                          color: _focusNode.hasFocus
                              ? Colors.green[700]
                              : Colors.grey[600],
                        ),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green[700]!, width: 1.5),
                        ),
                      ),
                      value: selectedDoubleMajor,
                      items: [
                        DropdownMenuItem(value: false, child: Text('해당없음')),
                        DropdownMenuItem(value: true, child: Text('복수전공생')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedDoubleMajor = value!; // 선택된 값 업데이트
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return '';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: selectedDoubleMajor == true,
                child: MajorDropdown(
                  isStyled: false,
                  majorKey: 'secondMajor',
                  labelText: "복수전공을 선택해 주세요",
                ),
              ),
              CustomButton(
                backgroundColor: const Color.fromARGB(255, 30, 85, 33),
                text: "다음",
                onPressed: () {
                  if (_formKey.currentState!.validate() && isVerified == true) {
                    _formKey.currentState!.save();

                    final primaryMajor =
                        majorProvider.getSelectedMajor('primaryMajor'); // 원전공
                    final secondMajor =
                        majorProvider.getSelectedMajor('secondMajor'); // 복수전공

                    debugPrint(
                        'selectedMajors 전체 확인!!! : ${majorProvider.selectedMajors}');

                    debugPrint(
                        '선택한 원전공 확인하고 싶음ㅁㅁㅁ: ${primaryMajor!.id} : ${primaryMajor.name}');
                    // debugPrint(
                    //     '선택한 부전공 확인하고 싶음ㅁㅁㅁ: ${secondMajor!.id} : ${secondMajor.name}');

                    final registerData = {
                      "username": _emailController.text,
                      "password": _pwValue,
                      "email": _email,
                      "admitYear": _selectedStudentNumber,
                      "majorId": primaryMajor.id,
                      "real": selectedDoubleMajor,
                      "dualMajorId":
                          selectedDoubleMajor ? secondMajor?.id : null,
                    };
                    debugPrint('$registerData');

                    // 프로필 등록으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterProfile(
                                pin: _pin,
                                registerData: registerData,
                              )),
                    );
                  }
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}

// 이메일 입력 및 인증
class EmailInputRow extends StatefulWidget {
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
  State<EmailInputRow> createState() => _EmailInputRowState();
}

class _EmailInputRowState extends State<EmailInputRow> {
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
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.green[700]!, width: 1.5),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  widget.emailController.text = value;
                });
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
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.green[700]!, width: 1.5),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never),
              value: widget.selectedDomain,
              items: [
                DropdownMenuItem(
                    value: '@g.skku.edu', child: Text('@g.skku.edu')),
                DropdownMenuItem(value: '@skku.edu', child: Text('@skku.edu')),
              ],
              onChanged: widget.onDomainChanged,
              validator: (value) {
                if (value == null) {
                  return '';
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
              onPressed: widget.onVerifyPressed,
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
class CustomTextFormField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final bool obscureText;

  const CustomTextFormField(
      {super.key,
      this.labelText,
      this.hintText,
      this.validator,
      this.onSaved,
      this.obscureText = false,
      this.onChanged});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  // FocusNode를 클래스 내에서 선언
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // FocusNode에 리스너 추가하여 포커스 상태 추적
    _focusNode.addListener(() {
      setState(() {}); // 포커스 상태가 변경되면 UI 업데이트
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // FocusNode 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: _focusNode.hasFocus ? Colors.green[700] : Colors.grey[600],
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.all(17),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green[700]!, width: 1.5),
          ),
        ),
        validator: widget.validator,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
      ),
    );
  }
}

// 학번 Dropdown 숫자
class NumberRangeDropdown extends StatefulWidget {
  final String labelText;
  final int start;
  final int end;
  final double? width;
  final ValueChanged<int?> onChanged;

  const NumberRangeDropdown({
    super.key,
    required this.labelText,
    required this.start,
    required this.end,
    required this.width,
    required this.onChanged,
  });

  @override
  _NumberRangeDropdownState createState() => _NumberRangeDropdownState();
}

class _NumberRangeDropdownState extends State<NumberRangeDropdown> {
  int? _selectedValue;

  @override
  Widget build(BuildContext context) {
    final double effectiveWidth =
        widget.width ?? MediaQuery.of(context).size.width / 2;
    return Container(
      width: effectiveWidth,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green[700]!, width: 1.5),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        value: _selectedValue,
        items: List.generate(
                widget.end - widget.start + 1, (index) => widget.start + index)
            .map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
        onChanged: (int? newValue) {
          setState(() {
            _selectedValue = newValue;
          });
          widget.onChanged(newValue);
        },
        validator: (value) {
          if (value == null) {
            return '';
          }
          return null;
        },
      ),
    );
  }
}

// 버튼 커스텀
class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.backgroundColor,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 13),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
