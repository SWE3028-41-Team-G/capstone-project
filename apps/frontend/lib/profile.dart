import 'dart:ui';

import 'package:flutter/material.dart';

// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? userProfile; // 사용자 프로필 정보를 저장할 변수

  @override
  void initState() {
    super.initState();
    // fetchUserProfile(); // 사용자 정보를 불러오는 함수 호출
    // fetchUserSchedules(); // 사용자 스케줄 정보를 불러오는 함수 호출
  }

  // // 사용자 정보를 서버에서 불러오는 함수
  // Future<void> fetchUserProfile() async {
  //   var url = 'http://3.38.255.82/profiles/user'; // 서버 주소
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token', // JWT 토큰
  //   };
  //   var body = jsonEncode({});

  //   try {
  //     var response = await http.get(
  //       Uri.parse(url),
  //       headers: headers,
  //     );

  //     if (response.statusCode == 200) {
  //       setState(() {
  //         userProfile = jsonDecode(response.body); // 응답 데이터 저장
  //         print("User Data: $userProfile"); // 콘솔에 사용자 데이터 출력
  //       });
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: "Failed to load user data: ${response.statusCode}",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.BOTTOM,
  //       );
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //       msg: "An error occurred: $e",
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.BOTTOM,
  //     );
  //   }
  // }

  // // 사용자 스케줄 정보를 서버에서 불러오는 함수
  // Future<void> fetchUserSchedules() async {
  //   var url = 'http://3.38.255.82/profiles/schedules'; // 서버 주소
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token', // JWT 토큰
  //   };
  //   var body = jsonEncode({});

  //   try {
  //     var response = await http.post(
  //       Uri.parse(url),
  //       headers: headers,
  //       body: body,
  //     );

  //     if (response.statusCode == 200) {
  //       setState(() {
  //         schedules = List<Map<String, dynamic>>.from(jsonDecode(response.body)['schedules']); // 응답 데이터 저장
  //         print("Schedules Data: $schedules"); // 콘솔에 스케줄 데이터 출력
  //       });
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: "Failed to load schedules: ${response.statusCode}",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.BOTTOM,
  //       );
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //       msg: "An error occurred: $e",
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.BOTTOM,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      body: Column(
        children: [
          // Profile
          Row(
            children: [
              // Title and fix info button
              Row(
                children: [
                  Text(
                    '내 프로필',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('정보 수정',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        )),
                  ),
                ],
              ),
              //
              Row(
                children: [],
              )
            ],
          ),
          // Graduation Requirements

          // Account Infos
          // Settings
        ],
      ),
    );
  }
}
