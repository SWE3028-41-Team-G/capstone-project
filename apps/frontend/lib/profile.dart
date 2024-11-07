import 'package:flutter/material.dart';

// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  Map<String, dynamic>? userProfile = {
    'imageUrl':
        'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
    'nickname': '명륜이',
    'primaryMajor': '경제학과',
    'secondMajor': '소프트웨어학과',
    'keyword1': '산책',
    'keyword2': '헬스'
  }; // 사용자 프로필 정보를 저장할 변수

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
              Container(
                // alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '내 프로필',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 153, 138, 138),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Text('정보 수정',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              )),
                          Icon(Icons.chevron_right)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 1,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: Image.network(
                      userProfile?['imageUrl'],
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${userProfile?['nickname']}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "❶ ${userProfile?['primaryMajor']}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "❷ ${userProfile?['secondMajor']}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue[200],
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              '${userProfile?['keyword1']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow
                                  .ellipsis, // 글자가 넘치면 말줄임표(...)로 표시
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            // margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.lightGreen[200],
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              '${userProfile?['keyword2']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow
                                  .ellipsis, // 글자가 넘치면 말줄임표(...)로 표시
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )),
          // Graduation Requirements
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(color: Colors.grey, width: 2))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    '졸업 요건',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 153, 138, 138),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('원전공',
                            style:
                                TextStyle(color: Colors.black, fontSize: 20)),
                      ),
                      Text('${userProfile?['primaryMajor']}',
                          style: TextStyle(color: Colors.grey, fontSize: 20))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('복수전공',
                            style:
                                TextStyle(color: Colors.black, fontSize: 20)),
                      ),
                      Text('${userProfile?['secondMajor']}',
                          style: TextStyle(color: Colors.grey, fontSize: 20))
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Settings
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    '앱 설정',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 153, 138, 138),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text('다크모드',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text('알림 설정',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text('비밀번호 변경',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
