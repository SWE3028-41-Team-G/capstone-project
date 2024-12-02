import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/api_helper.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/chatting_room.dart';
import 'package:frontend/register/major.dart';
import 'package:frontend/square/recruitment.dart';
import 'package:frontend/square/write_recruit.dart';
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
  // int _selectedIndex = 0; // 0 for DM, 1 for SQUARE
  // // List<dynamic> friends = [];
  // // List<dynamic> squares = [];

  // @override
  // void initState() {
  //   super.initState();
  // }

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
  @override
  Widget build(BuildContext context) {
    var students = [
      {
        'imageUrl':
            'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
        'nickname': '명륜이',
        'primaryMajor': '경제학과',
        'secondMajor': '소프트웨어학과',
        'keyword1': '산책하기',
        'keyword2': '매일 헬스장 가서 운동하기'
      },
      {
        'imageUrl':
            'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
        'nickname': '명륜이',
        'primaryMajor': '경제학과',
        'secondMajor': '소프트웨어학과',
        'keyword1': '산책',
        'keyword2': '운동'
      },
      {
        'imageUrl':
            'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
        'nickname': '외로운 늑대',
        'primaryMajor': '통계학과',
        'secondMajor': '소프트웨어학과',
        'keyword1': '강아지랑 산책',
        'keyword2': '침대에 누워있기'
      },
      {
        'imageUrl':
            'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
        'nickname': '명륜이',
        'primaryMajor': '경제학과',
        'secondMajor': '소프트웨어학과',
        'keyword1': '산책',
        'keyword2': '운동'
      },
      {
        'imageUrl':
            'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
        'nickname': '명륜이',
        'primaryMajor': '경제학과',
        'secondMajor': '소프트웨어학과',
        'keyword1': '산책',
        'keyword2': '운동'
      },
      {
        'imageUrl':
            'https://s3.orbi.kr/data/file/united/ade20dc8d3d033badeddf893b0763f9a.jpeg',
        'nickname': '명륜이',
        'primaryMajor': '경제학과',
        'secondMajor': '소프트웨어학과',
        'keyword1': '산책',
        'keyword2': '운동'
      }
    ];

    return Scaffold(
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
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 5,
              ),
              itemCount: students.length,
              itemBuilder: (context, index) {
                var student = students[index];
                String imageUrl = student['imageUrl']!;
                String nickname = student['nickname'] ?? 'Unknown';
                String primaryMajor = student['primaryMajor']!;
                String secondMajor = student['secondMajor']!;
                String keyword1 = student['keyword1']!;
                String keyword2 = student['keyword2']!;

                index % 2 == 0; // 왼쪽, 1이면 오른쪽

                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => (ChattingRoom(
                                nickname: nickname,
                              )))),
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
                            // height: MediaQuery.of(context).size.width *
                            //     0.5 *
                            //     5 /
                            //     3 *
                            //     0.55,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.all(8),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nickname,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '❶ $primaryMajor',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
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
                                              vertical: 6, horizontal: 12),
                                          // margin: EdgeInsets.symmetric(horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.lightBlue[200],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          child: Text(
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
                                              vertical: 6, horizontal: 12),
                                          // margin: EdgeInsets.symmetric(horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.lightGreen[200],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          child: Text(
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
    _refreshData();
  }

  Future<void> _refreshData() async {
    // 데이터를 새로고침하는 작업
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      isLoading = true; // 새로고침 시 로딩 상태 설정
    });
    await fetchSquareList();
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   fetchSquareList(squareList);
    // });
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: Colors.green[700],
      child: Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator()) // 로딩 중일 때 로딩 스피너 표시
            : Container(
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
                    Expanded(
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
                                      builder: (context) => Recruitment())),
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
