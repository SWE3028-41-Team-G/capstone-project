import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/home.dart';
import 'package:frontend/initial_page.dart';
import 'package:frontend/register/register.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/api_helper.dart';
import 'package:image_picker/image_picker.dart';

class RegisterProfile extends StatefulWidget {
  final Map<String, dynamic> registerData;
  final String? pin;
  const RegisterProfile(
      {super.key, required this.registerData, required this.pin});

  @override
  State<RegisterProfile> createState() => _RegisterProfileState();
}

class _RegisterProfileState extends State<RegisterProfile> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for Form
  XFile? _image; //이미지를 담을 변수 선언
  String? _imgUrl;
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  String? _nickname;
  bool _selectedOption = true;
  String? _interest1;
  String? _interest2;
  final List<String?> _interests = [];

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              '프로필 등록',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        leadingWidth: 200,
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
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  _buildProfilePhoto(),
                  SizedBox(
                    height: 30,
                  ),
                  CustomTextFormField(
                    labelText: "닉네임을 설정해 주세요",
                    hintText: "10글자 이내로 작성해 주세요",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '닉네임을 입력해 주세요';
                      }
                      if (value.length > 10) {
                        debugPrint("글자수?? ${value.length}");
                        return '10글자 이내로 작성해 주세요';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _nickname = value;
                      });
                    },
                  ),
                  _openProfile(),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    labelText: "첫번째 관심사를 입력해 주세요",
                    hintText: "10글자 이내로 작성해 주세요",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '관심사를 입력해 주세요';
                      }
                      if (value.length > 10) {
                        debugPrint("글자수?? ${value.length}");
                        return '10글자 이내로 작성해 주세요';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _interest1 = value;
                      });
                    },
                  ),
                  CustomTextFormField(
                    labelText: "두번째 관심사를 입력해 주세요",
                    hintText: "10글자 이내로 작성해 주세요",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '관심사를 입력해 주세요';
                      }
                      if (value.length > 10) {
                        debugPrint("글자수?? ${value.length}");
                        return '10글자 이내로 작성해 주세요';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _interest2 = value;
                      });
                    },
                  ),
                  CustomButton(
                    backgroundColor: Colors.grey[400]!,
                    text: "이전",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // 프로필 등록으로 이동
                        Navigator.pop(
                          context,
                        );
                      }
                    },
                  ),
                  CustomButton(
                    backgroundColor: const Color.fromARGB(255, 30, 85, 33),
                    text: "회원가입 완료",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // 관심사 리스트에 넣기
                        _interests.add(_interest1);
                        _interests.add(_interest2);

                        // 닉네임, 프로필 공개여부, 관심사, PIN번호, intro(무시) registerData에 추가하기
                        widget.registerData['nickname'] = _nickname;
                        widget.registerData['public'] = _selectedOption;
                        widget.registerData['interests'] = _interests;
                        // widget.registerData['pin'] = widget.pin;
                        widget.registerData['intro'] = " ";

                        // 이미지 임시 업로드 POST ----------------------------------------------------
                        if (_image != null) {
                          final Uri imgRequest = ApiHelper.buildRequest(
                              'users/profile/image'); // API endpoint
                          // XFile을 멀티파트 파일로 변환
                          final imgPost =
                              http.MultipartRequest('POST', imgRequest);
                          final file = await http.MultipartFile.fromPath(
                            'image',
                            _image!.path,
                          );
                          imgPost.files.add(file);
                          try {
                            final imgResponse = await imgPost.send();
                            final response =
                                await http.Response.fromStream(imgResponse);

                            if (imgResponse.statusCode == 201) {
                              // 요청 성공
                              final responseData = jsonDecode(response.body);
                              setState(() {
                                _imgUrl = responseData['url']
                                    as String; // URL 값 추출 및 저장
                              });
                              debugPrint("이미지 임시 업로드 성공! ^___^");
                              debugPrint(
                                  "2번째!!! responseBody 디버깅주우우웅 : $_imgUrl"); // 응답 JSON 파싱
                            } else {
                              // 요청 실패
                              debugPrint("요청 실패: ${response.body}");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("서버 오류가 발생했습니다. 다시 시도해주세요.")),
                              );
                            }
                          } catch (e) {
                            // 네트워크 또는 기타 오류 처리
                            debugPrint("오류 발생: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("오류가 발생했습니다. 인터넷 연결을 확인해주세요.")),
                            );
                          }
                        }

                        widget.registerData['profileImageUrl'] = _imgUrl;

                        debugPrint(
                            "최종 registerData 확인중ㅇㅇㅇ : ${widget.registerData}");
                        debugPrint("PIN 번호도 확인 좀 할게여 : ${widget.pin}");

                        // 회원가입 POST -----------------------------------------------------------------------------------
                        final Uri request = ApiHelper.buildRequest(
                            'users/register'); // API endpoint

                        // 파라미터를 쿼리로 추가
                        final reqWithParams = request.replace(queryParameters: {
                          'pin': widget.pin, // widget.pin 값을 쿼리 파라미터로 추가
                        });

                        try {
                          // 회원가입 HTTP POST 요청 보내기
                          final response = await http.post(
                            reqWithParams,
                            headers: {
                              "Content-Type": "application/json",
                            },
                            body:
                                jsonEncode(widget.registerData), // JSON 형식으로 변환
                          );

                          debugPrint("API 요청 URL: $request");
                          debugPrint("응답 상태 코드: ${response.statusCode}");
                          debugPrint("responseBody 디버깅주우우웅 : ${response.body}");

                          if (response.statusCode == 201) {
                            // 요청 성공
                            // 회원가입 status code == 201일 때 이동하기
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const InitialPage()),
                              (Route<dynamic> route) =>
                                  false, // 모든 기존 라우트를 제거하고 새 페이지로 이동
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("회원가입이 완료되었습니다. 로그인을 진행해 주세요")),
                            );
                          }
                        } catch (e) {
                          // 네트워크 또는 기타 오류 처리
                          debugPrint("오류 발생: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("오류가 발생했습니다. 인터넷 연결을 확인해주세요.")),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildProfilePhoto() {
    return GestureDetector(
      onTap: () {
        // 이미지가 있을 때도 클릭 시 이미지를 다시 선택할 수 있게 함
        getImage(ImageSource.gallery);
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: _image == null
              ? Border.all(
                  color: Colors.grey[400]!,
                  width: 2.0,
                )
              : null, // 이미지를 업로드한 경우 테두리 제거
          image: _image != null
              ? DecorationImage(
                  image: FileImage(File(_image!.path)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.photo,
                    color: Colors.grey[400],
                    size: 40,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "프로필 사진 업로드",
                    style: TextStyle(color: Colors.grey[400]),
                  )
                ],
              )
            : null, // 이미지를 업로드한 경우 Icon 숨김
      ),
    );
  }

  Widget _openProfile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 5,
        ),
        Text(
          "프로필 공개 여부를 선택해 주세요",
        ),
        Radio<bool>(
          value: true,
          groupValue: _selectedOption,
          activeColor: const Color.fromARGB(255, 30, 85, 33),
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
          },
        ),
        Text('공개'),
        Radio<bool>(
          value: false,
          groupValue: _selectedOption,
          activeColor: const Color.fromARGB(255, 30, 85, 33),
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
          },
        ),
        Text('비공개'),
      ],
    );
  }
}
