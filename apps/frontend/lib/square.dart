import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http; // will be used later for API connection

class Square extends StatefulWidget {
  const Square({super.key});

  @override
  SquareState createState() => SquareState();
}

class SquareState extends State<Square> {
  int _selectedIndex = 0; // 0 for DM, 1 for SQUARE
  // List<dynamic> friends = [];
  // List<dynamic> squares = [];

  @override
  void initState() {
    super.initState();
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
      body: Column(
        children: [
          // Menu selection
          Row(
            children: [
              Text(
                'DM',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                'Square',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ],
          ),
          // filters
          // user profiles
        ],
      ),
    );
  }
}
