import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/chatting_room.dart';
import 'package:frontend/initial_page.dart';
import 'package:frontend/models/chat_room.dart';
import 'package:frontend/utils/api_helper.dart';
import 'package:frontend/register/major.dart';
import 'package:frontend/square/recruitment.dart';
import 'package:frontend/square/write_recruit.dart';
import 'package:frontend/utils/jwt_helper.dart';
import 'package:provider/provider.dart';

// import 'package:http/http.dart' as http; // will be used later for API connection

class Square extends StatefulWidget {
  final int initialPage; // 초기 페이지를 지정할 수 있는 파라미터

  // 생성자에서 initialPage를 받도록 수정
  const Square({super.key, this.initialPage = 0}); // 기본값은 0 (DMPage)

  @override
  SquareState createState() => SquareState();
}

class SquareState extends State<Square> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // 외부에서 전달받은 initialPage로 PageController의 초기 페이지를 설정
    _pageController = PageController(initialPage: widget.initialPage);
    _currentPage = widget.initialPage;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        // backgroundColor: Colors.white, // AppBar 배경색 설정
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 50.0), // 위쪽 여백 조정
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                'DM',
                style: TextStyle(
                  fontSize: 25,
                  color: _currentPage == 0 ? Colors.black : Colors.grey[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 20),
              Text(
                'SQUARE',
                style: TextStyle(
                  fontSize: 25,
                  color: _currentPage == 1 ? Colors.black : Colors.grey[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                DMPage(),
                SquarePage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// DM 페이지
class DMPage extends StatefulWidget {
  const DMPage({super.key});

  @override
  State<DMPage> createState() => _DMPageState();
}

class _DMPageState extends State<DMPage> {
  AuthProvider? authProvider;
  MajorProvider? majorProvider;
  List<UserReturnType> dmList = [];
  bool isLoading = true; // 로딩 상태를 나타내는 변수
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    majorProvider = Provider.of<MajorProvider>(context, listen: false);
    _refreshData();
    _initializeToken();
  }

  Future<void> fetchDMList() async {
    // DM 리스트를 받아오기
    try {
      var response;
      // GET 요청 전송
      debugPrint(
          "DM 불러오기 원전공 확인 중 : ${majorProvider?.selectedMajors['dm_primaryMajor']} ");
      debugPrint(
          "DM 불러오기 복수전공 확인 중 : ${majorProvider?.selectedMajors['dm_doubleMajor']} ");
      if (majorProvider?.selectedMajors['dm_primaryMajor'] == null &&
          majorProvider?.selectedMajors['dm_doubleMajor'] == null) {
        response = await authProvider?.get('users/majors/profiles');
        debugPrint("DM 데이터 GET statusCode: ${response?.statusCode}");
        debugPrint("DM 데이터 response.body: ${response?.body}");
      } else if (majorProvider?.selectedMajors['dm_primaryMajor'] != null &&
          majorProvider?.selectedMajors['dm_doubleMajor'] == null) {
        setState(() {
          dmList = [];
          isLoading = true;
        });
        response = await authProvider?.get(
            'users/majors/profiles?majorId=${majorProvider?.selectedMajors['dm_primaryMajor'].id}');
        debugPrint(
            "response로 보내는 majorId 확인 중 : ${majorProvider?.selectedMajors['dm_primaryMajor'].id}");
        debugPrint("DM 데이터 GET statusCode: ${response?.statusCode}");
        debugPrint("DM 데이터 response.body: ${response?.body}");
      } else if (majorProvider?.selectedMajors['dm_primaryMajor'] == null &&
          majorProvider?.selectedMajors['dm_doubleMajor'] != null) {
        setState(() {
          dmList = [];
          isLoading = true;
        });
        response = await authProvider?.get(
            'users/majors/profiles?dualMajorId=${majorProvider?.selectedMajors['dm_doubleMajor'].id}');
        debugPrint(
            "response로 보내는 복수전공 majorId 확인 중 : ${majorProvider?.selectedMajors['dm_doubleMajor'].id}");
        debugPrint("DM 데이터 GET statusCode: ${response?.statusCode}");
        debugPrint("DM 데이터 response.body: ${response?.body}");
      } else if (majorProvider?.selectedMajors['dm_primaryMajor'] != null &&
          majorProvider?.selectedMajors['dm_doubleMajor'] != null) {
        setState(() {
          dmList = [];
          isLoading = true;
        });
        response = await authProvider?.get(
            'users/majors/profiles?majorId=${majorProvider?.selectedMajors['dm_primaryMajor'].id}&dualMajorId=${majorProvider?.selectedMajors['dm_doubleMajor'].id}');
        debugPrint(
            "response로 보내는 원전공 majorId 확인 중 : ${majorProvider?.selectedMajors['dm_primaryMajor'].id}");
        debugPrint(
            "response로 보내는 복수전공 majorId 확인 중 : ${majorProvider?.selectedMajors['dm_doubleMajor'].id}");
        debugPrint("DM 데이터 GET statusCode: ${response?.statusCode}");
        debugPrint("DM 데이터 response.body: ${response?.body}");
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response!.body);
        // dmList 에 data 넣기
        dmList = (data as List)
            .map((item) => UserReturnType.fromJson(item))
            .toList();

        setState(() {
          isLoading = false;
        });

        debugPrint("DM 리스트 저장 완료: $dmList");
      } else {
        setState(() {
          isLoading = false; // 오류 발생 시에도 로딩 상태를 해제
        });
        // throw Exception('DM 리스트 데이터를 가져오지 못했습니다.');
      }
    } catch (e) {
      debugPrint('DM 리스트 데이터 가져오는 중 오류 발생: $e');
      // rethrow;
    }
  }

  Future<void> _refreshData() async {
    // 데이터를 새로고침하는 작업
    await Future.delayed(Duration());
    setState(() {
      isLoading = true; // 새로고침 시 로딩 상태 설정
      majorProvider?.removeSelectedMajor('dm_primaryMajor');
      majorProvider?.removeSelectedMajor('dm_doubleMajor');
    });
    await fetchDMList();
  }

   Future<void> _initializeToken() async {
    try {
      final token = await _secureStorage.read(key: 'access_token');
      if (!mounted) return;

      if (token == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => InitialPage()),
          (route) => false,
        );
        return;
      }

      setState(() {
        _accessToken = token;
      });
    } catch (e) {
      print('Error in _initializeToken: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<UserReturnType> filteredList = dmList
        .where((student) => student.userId != authProvider?.user?.userId)
        .toList();

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: Colors.green[700],
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: MajorDropdown(
                      isStyled: true,
                      majorKey: 'dm_primaryMajor',
                      labelText: "원전공",
                      onChanged: () {
                        fetchDMList();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: MajorDropdown(
                      isStyled: true,
                      majorKey: 'dm_doubleMajor',
                      labelText: "복수전공",
                      onChanged: () {
                        fetchDMList();
                      },
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.green[700],
                  )) // 로딩 중일 때 로딩 스피너 표시
                : Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 5,
                      ),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        var student = filteredList[index];
                        int userId =
                            student.userId; // 해당 프로필 유저 아이디 ------------------
                        String imageUrl = student.imageUrl;
                        String nickname = student.nickname;
                        String primaryMajor = student.majors
                            .firstWhere((major) => major.origin)
                            .major
                            .name;
                        String secondMajor = student.real
                            ? student.majors
                                .firstWhere((major) => !major.origin)
                                .major
                                .name
                            : "해당없음";
                        String keyword1 = student.interests[0];
                        String keyword2 = student.interests[1];

                        index % 2 == 0; // 왼쪽, 1이면 오른쪽

                        final userPayload = JwtHelper.parseJwt(_accessToken!);
                        final currentUserId = userPayload['userId'].toString();



                        return GestureDetector(
                          onTap: () async {
                            final chatRoomRef =
                                await _firestore.collection('chatrooms').add({
                              'name': "[DM] " +
                                  userPayload['nickname'] +
                                  ", " +
                                  nickname,
                              'participants': [currentUserId, userId.toString()],
                              'lastMessageTime': DateTime.now(),
                              'lastMessage': '채팅방이 생성되었습니다.',
                              'createdBy': currentUserId,
                              'createdAt': DateTime.now(),
                              'participantDetails': [
                                {
                                  'userId': currentUserId,
                                  'nickname': userPayload['nickname'],
                                  'profileImgUrl':
                                      userPayload['profileImgUrl'] ?? '',
                                },
                                {
                                  'userId': userId.toString(),
                                  'nickname': nickname,
                                  'profileImgUrl': imageUrl,
                                }
                              ],
                            });

                            if (!mounted) return;

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                        chatRoomId: chatRoomRef.id)));
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
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
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.width *
                                        0.5 *
                                        5 /
                                        3 *
                                        0.55,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 6),
                                    padding: const EdgeInsets.all(8),
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          nickname,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        AutoSizeText(
                                          '❶ $primaryMajor',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        AutoSizeText(
                                          '❷ $secondMajor',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 12),
                                                  // margin: EdgeInsets.symmetric(horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.lightBlue[200],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(8),
                                                    ),
                                                  ),
                                                  child: AutoSizeText(
                                                    keyword1,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                    overflow: TextOverflow
                                                        .ellipsis, // 글자가 넘치면 말줄임표(...)로 표시
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 12),
                                                  // margin: EdgeInsets.symmetric(horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.lightGreen[200],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(8),
                                                    ),
                                                  ),
                                                  child: AutoSizeText(
                                                    keyword2,
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
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// SQUARE 페이지
class SquarePage extends StatefulWidget {
  const SquarePage({super.key});

  @override
  State<SquarePage> createState() => _SquarePageState();
}

class _SquarePageState extends State<SquarePage> {
  AuthProvider? authProvider;
  MajorProvider? majorProvider;
  List<dynamic> squareList = [];
  bool isLoading = true; // 로딩 상태를 나타내는 변수

  Future<void> fetchSquareList() async {
    // 스퀘어 리스트를 받아오기
    try {
      // GET 요청 전송
      final response = await authProvider?.get('square');
      debugPrint("스퀘어 데이터 GET statusCode: ${response?.statusCode}");
      debugPrint("스퀘어 데이터 response.body: ${response?.body}");

      if (response?.statusCode == 200) {
        final data = jsonDecode(response!.body);
        // squareList 에 data 넣기
        squareList = data
            .map((item) => {
                  'id': item['id'],
                  'name': item['name'],
                  'leader': {
                    'id': item['leader']['id'],
                    'username': item['leader']['username'],
                    'nickname': item['leader']['nickname'],
                  },
                  'max': item['max'],
                  'members': (item['UserSquare'] as List)
                      .map((userSquare) => {
                            'userId': userSquare['userId'],
                            'user': {
                              'id': userSquare['user']['id'],
                              'username': userSquare['user']['username'],
                              'nickname': userSquare['user']['nickname'],
                            }
                          })
                      .toList(),
                  'posts': (item['SquarePosts'] as List)
                      .map((post) => {
                            'id': post['id'],
                            'title': post['title'],
                            'content': post['content'],
                            'createdAt': post['createdAt'],
                            'updatedAt': post['updatedAt'],
                            'comments': (post['SquarePostComment'] as List)
                                .map((comment) => {
                                      'id': comment['id'],
                                      'createdAt': comment['createdAt'],
                                      'updatedAt': comment['updatedAt'],
                                      'userId': comment['userId'],
                                      'content': comment['content'],
                                      'squarePostId': comment['squarePostId'],
                                    })
                                .toList(),
                          })
                      .toList(),
                  'createdAt': item['createdAt'],
                  'updatedAt': item['updatedAt'],
                })
            .toList();
        setState(() {
          isLoading = false; // 데이터 로딩 완료 시 상태 변경
        });

        debugPrint("스퀘어 리스트 저장 완료: $squareList");
      } else {
        setState(() {
          isLoading = false; // 오류 발생 시에도 로딩 상태를 해제
        });
        throw Exception('스퀘어 전체 리스트 데이터를 가져오지 못했습니다.');
      }
    } catch (e) {
      debugPrint('스퀘어 전체 리스트 데이터 가져오는 중 오류 발생: $e');
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    majorProvider = Provider.of<MajorProvider>(context, listen: false);
    _refreshData();
  }

  Future<void> _refreshData() async {
    // 데이터를 새로고침하는 작업
    await Future.delayed(Duration());
    setState(() {
      isLoading = true; // 새로고침 시 로딩 상태 설정
      majorProvider?.removeSelectedMajor('square_Major');
    });
    await fetchSquareList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: Colors.green[700],
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 17),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: MajorDropdown(
                        isStyled: true,
                        majorKey: 'square_Major',
                        labelText: "모집대상 전공",
                        // 모집대상 전공별 SQUARE 검색하기 -------------------------------
                        onChanged: () async {
                          try {
                            // GET 요청 전송
                            setState(() {
                              isLoading = true;
                            });
                            debugPrint(
                                "스퀘어 검색 주소 확인 : square?majorId=${majorProvider?.selectedMajors['square_Major'].id}");
                            final response = await authProvider?.get(
                                'square?majorId=${majorProvider?.selectedMajors['square_Major'].id}');
                            debugPrint(
                                "모집대상 전공 스퀘어 검색 GET statusCode: ${response?.statusCode}");
                            debugPrint(
                                "모집대상 전공 스퀘어 검색 response.body: ${response?.body}");

                            if (response?.statusCode == 200) {
                              final responseData = jsonDecode(response!.body);
                              // squareList 에 data 넣기
                              squareList = responseData
                                  .map((item) => {
                                        'id': item['id'],
                                        'name': item['name'],
                                        'leader': {
                                          'id': item['leader']['id'],
                                          'username': item['leader']
                                              ['username'],
                                          'nickname': item['leader']
                                              ['nickname'],
                                        },
                                        'max': item['max'],
                                        'members': (item['UserSquare'] as List)
                                            .map((userSquare) => {
                                                  'userId':
                                                      userSquare['userId'],
                                                  'user': {
                                                    'id': userSquare['user']
                                                        ['id'],
                                                    'username':
                                                        userSquare['user']
                                                            ['username'],
                                                    'nickname':
                                                        userSquare['user']
                                                            ['nickname'],
                                                  }
                                                })
                                            .toList(),
                                        'posts': (item['SquarePosts'] as List)
                                            .map((post) => {
                                                  'id': post['id'],
                                                  'title': post['title'],
                                                  'content': post['content'],
                                                  'createdAt':
                                                      post['createdAt'],
                                                  'updatedAt':
                                                      post['updatedAt'],
                                                  'comments':
                                                      (post['SquarePostComment']
                                                              as List)
                                                          .map((comment) => {
                                                                'id': comment[
                                                                    'id'],
                                                                'createdAt':
                                                                    comment[
                                                                        'createdAt'],
                                                                'updatedAt':
                                                                    comment[
                                                                        'updatedAt'],
                                                                'userId': comment[
                                                                    'userId'],
                                                                'content': comment[
                                                                    'content'],
                                                                'squarePostId':
                                                                    comment[
                                                                        'squarePostId'],
                                                              })
                                                          .toList(),
                                                })
                                            .toList(),
                                        'createdAt': item['createdAt'],
                                        'updatedAt': item['updatedAt'],
                                      })
                                  .toList();
                              setState(() {
                                isLoading = false; // 데이터 로딩 완료 시 상태 변경
                              });

                              debugPrint(
                                  "모집대상 전공 스퀘어 검색 리스트 저장 완료: $squareList");
                            } else {
                              setState(() {
                                isLoading = false; // 오류 발생 시에도 로딩 상태를 해제
                              });
                              throw Exception(
                                  '모집대상 전공 스퀘어 검색 리스트 데이터를 가져오지 못했습니다.');
                            }
                          } catch (e) {
                            debugPrint('모집대상 전공 스퀘어 검색 데이터 가져오는 중 오류 발생: $e');
                            rethrow;
                          }
                        },
                      ),
                    ),
                    Spacer(),
                    Flexible(
                      flex: 2,
                      child: ElevatedButton(
                        // 모집글 작성 버튼 -----------------------------------------------
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            backgroundColor: Colors.grey[400],
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WriteRecruit()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Flexible(
                              child: AutoSizeText(
                                '모집글 작성',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: Colors.green[700],
                    )) // 로딩 중일 때 로딩 스피너 표시
                  : Expanded(
                      // 모집글 목록들 ----------------------------------------------------------
                      child: ListView.builder(
                          itemCount: squareList.length,
                          itemBuilder: (context, index) {
                            int reversedIndex = squareList.length - 1 - index;
                            String title =
                                squareList[reversedIndex]['posts'][0]['title'];
                            String content = squareList[reversedIndex]['posts']
                                [0]['content'];
                            int confirmNumber =
                                squareList[reversedIndex]['members'].length;
                            int recruitNumber =
                                squareList[reversedIndex]['max'];

                            return GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Recruitment(
                                          squarePost:
                                              squareList[reversedIndex]))),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 12),
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 8,
                                          child: Text(
                                            title,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          '($confirmNumber/$recruitNumber)',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: confirmNumber <=
                                                    recruitNumber / 2
                                                ? Colors.blue
                                                : Colors.red,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      content,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
