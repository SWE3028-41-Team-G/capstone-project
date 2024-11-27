import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/home.dart';
import 'package:frontend/register/major.dart';
import 'package:frontend/register/register.dart';
import 'package:frontend/utils/api_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ModifyProfile extends StatefulWidget {
  const ModifyProfile({super.key});

  @override
  State<ModifyProfile> createState() => _ModifyProfileState();
}

class _ModifyProfileState extends State<ModifyProfile> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for Form

  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  // FocusNode를 클래스 내에서 선언
  final FocusNode _focusNode = FocusNode();

  AuthProvider? authProvider;
  MajorProvider? majorProvider;
  Major? doubleMajor;
  bool? selectedReal;
  bool? selectedPublic;

  var nickname = TextEditingController();
  var keyword1 = TextEditingController();
  var keyword2 = TextEditingController();
  List<String> interests = [];

  Map<String, dynamic> modifyProfile = {};

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    majorProvider = Provider.of<MajorProvider>(context, listen: false);
    var userData = authProvider?.user;
    doubleMajor = Major(
        id: userData!.majors[1].major.id, name: userData.majors[1].major.name);
    selectedReal = userData.real;
    selectedPublic = userData.public;
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
    var userData = authProvider?.user!;
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
              majorProvider?.removeSelectedMajor('modifySecondMajor');
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
                    hintText: userData?.nickname,
                    textEditingController: nickname,
                  ),
                  _openProfile(),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<bool>(
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
                    value: selectedReal,
                    items: [
                      DropdownMenuItem(value: false, child: Text('해당없음')),
                      DropdownMenuItem(value: true, child: Text('복수전공생')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedReal = value!;
                      });
                    },
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Visibility(
                    visible: selectedReal == true,
                    child: MajorDropdown(
                      isStyled: false,
                      value: userData!.real ? doubleMajor : null,
                      majorKey:
                          'modifySecondMajor', // 수정필요 ------------------------------------
                      labelText: "복수전공을 선택해 주세요",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    labelText: "첫번째 관심사 키워드를 입력해 주세요",
                    hintText: userData.interests[0],
                    textEditingController: keyword1,
                    validator: (value) {
                      if (value != null && value.length > 10) {
                        debugPrint("글자수?? ${value.length}");
                        return '10글자 이내로 작성해 주세요';
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    labelText: "두번째 관심사 키워드를 입력해 주세요",
                    hintText: userData.interests[1],
                    textEditingController: keyword2,
                    validator: (value) {
                      if (value != null && value.length > 10) {
                        debugPrint("글자수?? ${value.length}");
                        return '10글자 이내로 작성해 주세요';
                      }
                      return null;
                    },
                  ),
                  CustomButton(
                    backgroundColor: const Color.fromARGB(255, 30, 85, 33),
                    text: "프로필수정 완료",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        if (nickname.text.isNotEmpty) {
                          modifyProfile['nickname'] = nickname.text;
                        }
                        if (keyword1.text.isNotEmpty && keyword2.text.isEmpty) {
                          interests.add(keyword1.text);
                          interests.add(userData!.interests[1]);
                          modifyProfile['interests'] = interests;
                        }
                        if (keyword2.text.isNotEmpty && keyword1.text.isEmpty) {
                          interests.add(userData!.interests[0]);
                          interests.add(keyword2.text);
                          modifyProfile['interests'] = interests;
                        }
                        if (keyword1.text.isNotEmpty &&
                            keyword1.text.isNotEmpty) {
                          interests.add(keyword1.text);
                          interests.add(keyword2.text);
                          modifyProfile['interests'] = interests;
                        }
                        if (selectedPublic != userData!.public) {
                          modifyProfile['public'] = selectedPublic;
                        }
                        if (majorProvider!
                                .getSelectedMajor('modifySecondMajor') !=
                            null) {
                          debugPrint(
                              "??? : ${majorProvider!.getSelectedMajor('modifySecondMajor')!.id}");
                          modifyProfile['dualMajorId'] = majorProvider!
                              .getSelectedMajor('modifySecondMajor')!
                              .id;
                        }
                        if (selectedReal != userData.real) {
                          modifyProfile['real'] = selectedReal;
                          if (selectedReal == true) {
                            if (majorProvider != null) {
                              debugPrint(
                                  "복전 id 확인 중 : ${majorProvider!.getSelectedMajor('modifySecondMajor')!.id}");
                              modifyProfile['dualMajorId'] = majorProvider!
                                  .getSelectedMajor('modifySecondMajor')!
                                  .id;
                            } else {
                              debugPrint(
                                  "majorProvider가 null이랍니다------------------------------------------------");
                            }
                          }
                        }

                        debugPrint("modifyProfile 확인 중 : $modifyProfile");

                        if (modifyProfile.isEmpty) {
                          // 프로필로 이동
                          Navigator.pop(context);
                        } else {
                          try {
                            // PUT 요청 보내기
                            final response = await authProvider?.put(
                                'users/profile', modifyProfile);

                            // 응답 상태에 따라 처리
                            if (response?.statusCode == 200) {
                              // 성공적으로 처리됨
                              debugPrint("프로필 수정 성공!!!!!");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('프로필 수정 요청 성공')),
                              );
                              majorProvider
                                  ?.removeSelectedMajor('modifySecondMajor');
                              // 프로필로 이동
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home(
                                          initialIndex: 3,
                                        )),
                                (Route<dynamic> route) => false,
                              );
                            } else {
                              // 실패
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('프로필 수정 요청 실패')),
                              );
                            }
                          } catch (e) {
                            // 오류 처리
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('오류 발생: $e')),
                            );
                          }
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
        Flexible(
          child: AutoSizeText(
            "프로필 공개 여부를 선택해 주세요",
            maxLines: 1,
          ),
        ),
        Radio<bool>(
          value: true,
          groupValue: selectedPublic,
          activeColor: const Color.fromARGB(255, 30, 85, 33),
          onChanged: (value) {
            setState(() {
              selectedPublic = value!;
            });
          },
        ),
        Text('공개'),
        Radio<bool>(
          value: false,
          groupValue: selectedPublic,
          activeColor: const Color.fromARGB(255, 30, 85, 33),
          onChanged: (value) {
            setState(() {
              selectedPublic = value!;
            });
          },
        ),
        Text('비공개'),
      ],
    );
  }
}
