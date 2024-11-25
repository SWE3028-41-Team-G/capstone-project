import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/initial_page.dart';
import 'package:frontend/profile/modify_profile.dart';
import 'package:frontend/utils/api_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// import 'package:fluttertoast/fluttertoast.dart';
// import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  late userReturnType? _userData; // 데이터 저장용 변수
  bool _isLoading = true; // 로딩 상태 변수

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
    _fetchProfileData();
  }

  // 프로필 데이터를 가져오는 함수
  Future<void> _fetchProfileData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final response = await authProvider.get('users/current/profile');

    debugPrint("fetchProfile 중 statusCode 확인 중 : ${response.statusCode}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        _userData = userReturnType.fromJson(jsonData);
        debugPrint("fetchProfile 중 userData 확인 중 : $_userData");
        _isLoading = false; // 데이터 로딩 완료
      });
    } else {
      setState(() {
        _isLoading = false; // 에러 발생 시에도 로딩 종료
      });
      // 에러 처리
      throw Exception('Failed to load profile data');
    }
  }

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
        automaticallyImplyLeading: false,
        shape: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              // Profile
              Container(
                // alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '내 프로필',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // 프로필 수정으로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ModifyProfile()),
                        );
                      },
                      child: Row(
                        children: [
                          Text('정보 수정',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              )),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 15),
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
                      Container(
                        width: 150,
                        height: 150,
                        padding: EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          child: Image.network(
                            _userData?.imageUrl ??
                                'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_userData?.nickname}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "❶ ${_userData?.majors[0].major.name}",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            _userData!.real
                                ? "❷ ${_userData!.majors[1].major.name}" // real이 true일 경우
                                : "❷ 해당없음", // real이 false일 경우
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
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
                                    '${_userData?.interests[0]}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // 글자가 넘치면 말줄임표(...)로 표시
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
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
                                    '${_userData?.interests[1]}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // 글자가 넘치면 말줄임표(...)로 표시
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              Divider(),
              // mock apply
              GestureDetector(
                onTap: () {
                  debugPrint("모의지원에서 테스트 중 : ${_userData!.nickname}");
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[800],
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
                  child: Text(
                    "모의 지원",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              Divider(),
              // Graduation Requirements
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            '졸업 요건',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                              onTap: () {
                                _showInputDialog(context);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.orangeAccent[700],
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "오류신고",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.orangeAccent[700]),
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('원전공',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18)),
                          ),
                          Text('${userProfile?['primaryMajor']}',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('복수전공',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18)),
                          ),
                          Text('${userProfile?['secondMajor']}',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              // Settings
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        '앱 설정',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text('다크모드',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          )),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text('알림 설정',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          )),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text('비밀번호 변경',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          )),
                    ),
                  ],
                ),
              ),
              // 탈퇴하기 버튼
              GestureDetector(
                onTap: () async {
                  // 로그아웃 처리
                  await context.read<AuthProvider>().logout();
                  // 로그아웃 후 로그인 화면으로 이동
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => InitialPage()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.redAccent[200],
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    "로그아웃",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 오류신고 Dialog 띄우는 함수
  void _showInputDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '오류신고',
            style: TextStyle(fontSize: 18),
          ),
          content: TextField(
            controller: controller,
            minLines: 5,
            maxLines: null,
            decoration: InputDecoration(
                hintText: "내용을 입력해 주세요",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                ),
                hintStyle: TextStyle(color: Colors.grey[400])),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text(
                '취소',
                style: TextStyle(color: Colors.green[700]),
              ),
            ),
            TextButton(
              onPressed: () {
                String userInput = controller.text;
                print('사용자가 입력한 내용: $userInput');
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text(
                '확인',
                style: TextStyle(color: Colors.green[700]),
              ),
            ),
          ],
        );
      },
    );
  }
}

// User정보
class UserMajor {
  final bool origin; // 원전공 여부
  final MajorDetails major; // 전공 정보

  UserMajor({required this.origin, required this.major});

  factory UserMajor.fromJson(Map<String, dynamic> json) {
    return UserMajor(
      origin: json['origin'],
      major: MajorDetails.fromJson(json['Major']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'origin': origin,
      'Major': major.toJson(),
    };
  }
}

class MajorDetails {
  final int id; // 전공 ID
  final String name; // 전공 이름

  MajorDetails({required this.id, required this.name});

  factory MajorDetails.fromJson(Map<String, dynamic> json) {
    return MajorDetails(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class userReturnType {
  final List<UserMajor> majors; // 전공 목록
  final int userId; // 사용자 ID
  final String imageUrl; // 프로필 이미지 주소
  final String intro; // 한줄소개 (Deprecated)
  final List<String> interests; // 관심사 목록
  final bool public; // 프로필 공개 여부
  final String username; // 아이디
  final String nickname; // 별명
  final int admitYear; // 입학년도(yyyy)
  final bool real; // 실제 복수전공 여부

  userReturnType({
    required this.majors,
    required this.userId,
    required this.imageUrl,
    required this.intro,
    required this.interests,
    required this.public,
    required this.username,
    required this.nickname,
    required this.admitYear,
    required this.real,
  });

  factory userReturnType.fromJson(Map<String, dynamic> json) {
    var majorsList = (json['majors'] as List)
        .map((major) => UserMajor.fromJson(major))
        .toList();

    return userReturnType(
      majors: majorsList,
      userId: json['userId'],
      imageUrl: json['imageUrl'],
      intro: json['intro'],
      interests: List<String>.from(json['interests']),
      public: json['public'],
      username: json['username'],
      nickname: json['nickname'],
      admitYear: json['admitYear'],
      real: json['real'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'majors': majors.map((major) => major.toJson()).toList(),
      'userId': userId,
      'imageUrl': imageUrl,
      'intro': intro,
      'interests': interests,
      'public': public,
      'username': username,
      'nickname': nickname,
      'admitYear': admitYear,
      'real': real,
    };
  }
}
