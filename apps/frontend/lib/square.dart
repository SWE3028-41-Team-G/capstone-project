import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http; // will be used later for API connection

class Square extends StatefulWidget {
  const Square({super.key});

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
  final PageController _pageController = PageController();
  int _currentPage = 0; // 현재 페이지 인덱스

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  // API - GET friends
  // Future<void> _fetchFriends() async {
  //   final response = await http.get(
  //     Uri.parse(''),
  //     headers: {

  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       filters = jsonDecode(response.body)['friends'];
  //     });
  //   }
  //   else {
  //     print('Debugging for GET - Friends list');
  //     print(response.statusCode);
  //   }
  // }

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
    const students = [
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
                MajorDropdown(
                  hintText: '원전공', items: ['경제학과', '소프트웨어학과'], // 필요한 전공 목록을 추가
                ),
                SizedBox(
                  width: 15,
                ),
                MajorDropdown(
                  hintText: '복수전공', items: ['경제학과', '소프트웨어학과'], // 필요한 전공 목록을 추가
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
                String nickname = student['nickname']!;
                String primaryMajor = student['primaryMajor']!;
                String secondMajor = student['secondMajor']!;
                String keyword1 = student['keyword1']!;
                String keyword2 = student['keyword2']!;

                index % 2 == 0; // 왼쪽, 1이면 오른쪽

                return Container(
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
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

// 전공 드롭다운
class MajorDropdown extends StatefulWidget {
  final String hintText;
  final List<String> items; // 드롭다운 목록을 받아오는 리스트

  const MajorDropdown({required this.hintText, required this.items, super.key});

  @override
  _MajorDropdownState createState() => _MajorDropdownState();
}

class _MajorDropdownState extends State<MajorDropdown> {
  String? selectedMajor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: DropdownButton<String>(
        value: selectedMajor,
        hint: Text(
          widget.hintText,
          style: TextStyle(color: Colors.grey[500]),
        ), // 전달받은 힌트 텍스트를 표시
        onChanged: (String? newValue) {
          setState(() {
            selectedMajor = newValue;
          });
        },
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        underline: Container(), // 밑줄 제거
      ),
    );
  }
}
