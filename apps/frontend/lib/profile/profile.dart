import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frontend/initial_page.dart';
import 'package:frontend/profile/modify_profile.dart';
import 'package:frontend/utils/api_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:fluttertoast/fluttertoast.dart';
// import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final Uri _url1 =
      Uri.parse('https://www.skku.edu/skku/edu/bachelor/ca_de_schedule01.do');
  final Uri _url2 =
      Uri.parse('https://www.skku.edu/skku/about/status/state_02_2012.do');
  final Uri _url3 =
      Uri.parse('https://www.skku.edu/skku/edu/bachelor/curriculum.do');
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    var userData = authProvider.user;
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
                      onTap: () async {
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
                    border: Border.all(
                      color: Colors.grey[400]!, // 테두리 색상
                      width: 0.8,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
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
                            userData!.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              userData!.nickname,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 20,
                              ),
                              maxLines: 1,
                            ),
                            AutoSizeText(
                              "❶ ${userData.majors[0].major.name}",
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 18,
                              ),
                            ),
                            AutoSizeText(
                              userData.real
                                  ? "❷ ${userData.majors[1].major.name}" // real이 true일 경우
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      userData.interests[0],
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
                                      userData.interests[1],
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
                        ),
                      )
                    ],
                  )),
              Divider(),
              // mock apply
              GestureDetector(
                onTap: () {
                  showComingSoonDialog(context);
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[400],
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(
                      //   Icons.format_list_numbered,
                      //   color: Colors.white,
                      // ),
                      // SizedBox(
                      //   width: 5,
                      // ),
                      Text(
                        "복수전공 모의 지원",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
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
                    // 졸업요건 관련 URL 연결하기
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              height: 300,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        if (await canLaunchUrl(_url1)) {
                                          await launchUrl(
                                            _url1,
                                          );
                                        } else {
                                          debugPrint(
                                              "Unable to launch URL!!!!!!!!");
                                        }
                                      },
                                      child: AutoSizeText(
                                        '학사제도 바로가기',
                                        style: GoogleFonts.jua(
                                          fontSize: 22,
                                          color: Colors.blueAccent,
                                          decorationColor: Colors.blueAccent,
                                          decoration: TextDecoration.underline,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (await canLaunchUrl(_url2)) {
                                          await launchUrl(
                                            _url2,
                                          );
                                        } else {
                                          debugPrint(
                                              "Unable to launch URL!!!!!!!!");
                                        }
                                      },
                                      child: AutoSizeText(
                                        '교육과정 바로가기',
                                        style: GoogleFonts.jua(
                                          fontSize: 22,
                                          color: Colors.blueAccent,
                                          decorationColor: Colors.blueAccent,
                                          decoration: TextDecoration.underline,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (await canLaunchUrl(_url3)) {
                                          await launchUrl(
                                            _url3,
                                          );
                                        } else {
                                          debugPrint(
                                              "Unable to launch URL!!!!!!!!");
                                        }
                                      },
                                      child: AutoSizeText(
                                        '학과/교과목 검색 바로가기',
                                        style: GoogleFonts.jua(
                                          fontSize: 22,
                                          color: Colors.blueAccent,
                                          decorationColor: Colors.blueAccent,
                                          decoration: TextDecoration.underline,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text('원전공',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18)),
                                ),
                                Text(' ${userData.majors[0].major.name}',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18))
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text('복수전공',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18)),
                                ),
                                Text(
                                    userData.real
                                        ? userData.majors[1].major
                                            .name // real이 true일 경우
                                        : "해당없음", // real이 false일 경우,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              // Settings
              GestureDetector(
                onTap: () {
                  showComingSoonDialog(context);
                },
                child: Container(
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
              ),
              // 로그아웃 버튼
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
                debugPrint('사용자가 입력한 내용: $userInput');
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

void showComingSoonDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          width: 200,
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              Icon(
                Icons.construction,
                color: Colors.grey[700],
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: AutoSizeText(
                  "아직 준비중인 서비스입니다!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        // actions: [
        //   TextButton(
        //     child: Text(
        //       "확인",
        //       style: TextStyle(color: Colors.green[700]),
        //     ),
        //     onPressed: () {
        //       Navigator.of(context).pop(); // 다이얼로그 닫기
        //     },
        //   ),
        // ],
      );
    },
  );
}
