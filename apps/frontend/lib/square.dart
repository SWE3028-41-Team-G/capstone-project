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
                  color: _currentPage == 0 ? Colors.black : Colors.grey,
                  fontWeight:
                      _currentPage == 0 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              SizedBox(width: 20),
              Text(
                'SQUARE',
                style: TextStyle(
                  fontSize: 25,
                  color: _currentPage == 1 ? Colors.black : Colors.grey,
                  fontWeight:
                      _currentPage == 1 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Expanded(
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            // DM 페이지
            Center(
              child: Text('DM Page', style: TextStyle(fontSize: 24)),
            ),
            // SQUARE 페이지
            Center(
              child: Text('SQUARE Page', style: TextStyle(fontSize: 24)),
            ),
          ],
        ),
      ),
    );
  }
}
