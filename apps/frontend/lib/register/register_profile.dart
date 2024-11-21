import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/home.dart';
import 'package:frontend/register/register.dart';
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
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  String _selectedOption = '공개';

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
                  CustomTextFormField(labelText: "닉네임을 설정해 주세요"),
                  _openProfile(),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(labelText: "첫번째 관심사 키워드를 입력해 주세요"),
                  CustomTextFormField(labelText: "두번째 관심사 키워드를 입력해 주세요"),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // 프로필 등록으로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
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
        Radio<String>(
          value: '공개',
          groupValue: _selectedOption,
          activeColor: const Color.fromARGB(255, 30, 85, 33),
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
          },
        ),
        Text('공개'),
        Radio<String>(
          value: '비공개',
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
