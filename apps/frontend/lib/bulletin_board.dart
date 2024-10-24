import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http; // will be used later for API connection

class BulletinBoard extends StatefulWidget {
  const BulletinBoard({super.key});

  @override
  BulletinBoardState createState() => BulletinBoardState();
}

class BulletinBoardState extends State<BulletinBoard> {
  int _selectedIndex = 0;
  // List<dynamic> filters = [];

  @override
  void initState() {
    super.initState();
  }

  // API - GET filters
  // Future<void> _fetchFilters() async {
  //   final response = await http.get(
  //     Uri.parse(''),
  //     headers: {

  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       filters = jsonDecode(response.body)['filters'];
  //     });
  //   }
  //   else {
  //     print('Debugging for GET - Filters list');
  //     print(response.statusCode);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bulletin Board',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
