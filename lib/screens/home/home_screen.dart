import 'package:flutter/material.dart';
import 'package:gulmate/screens/home/shopping/shopping_screen.dart';
import 'package:gulmate/widgets/placeholder_widget.dart';

import 'dashboard/dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _children = <Widget>[
    DashboardScreen(),
    PlaceholderWidget(Colors.amber),
    ShoppingScreen(),
    PlaceholderWidget(Colors.greenAccent),
    PlaceholderWidget(Colors.cyan),
  ];

  int _currentIdx = 0;

  void _onBottomNavigationTap(int idx) {
    print("Navigation Tap index: $idx");
    setState(() {
      _currentIdx = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("홈")),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text("일정")),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket), title: Text("장보기")),
          BottomNavigationBarItem(icon: Icon(Icons.message), title: Text("채팅")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("더보기")),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFFFF6D00),
        unselectedItemColor: Color.fromRGBO(204, 204, 204, 1),
        onTap: _onBottomNavigationTap,
        currentIndex: _currentIdx,
        type: BottomNavigationBarType.fixed,
      ),
      body: _children[_currentIdx],
    );
  }
}
