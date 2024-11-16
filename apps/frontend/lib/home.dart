import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:frontend/bulletin_board/bulletin_board.dart';
import 'package:frontend/message.dart';
import 'package:frontend/square/square.dart';
import 'package:frontend/profile/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0; // initial selected tab index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          BulletinBoard(),
          Square(),
          Message(),
          Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: '게시판',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: '광장',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2_fill),
            label: '메시지',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_crop_square_fill),
            label: '프로필',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[400],
        selectedFontSize: 11,
        unselectedFontSize: 11,
        iconSize: 23,
        // backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
