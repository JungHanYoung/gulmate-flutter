import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gulmate/sign_up/sign_in.dart';

const pages = [
  {
    "title": "귤메이트에 가입하신 것을\n 환영합니다.",
    "description": "함께 귤 까먹으며\n 같이 시간을 보내는 것이\n 진짜 가족 아니겠어요?"
  },
  {
    "title": "가족 메신저라면\n 귤메이트!",
    "description": "귤메이트는\n 1인가구, 2인가구 이상 등\n 모든 가족을 위한\n 강력한 가족 메신저 입니다."
  },
  {
    "title": "귤메이트로 가족끼리\n 일정, 메모, 채팅 등을 한 큐에!",
    "description": "귤메는 이런 거시다~\n 설명하는 화면\n 슬라이드 3가지 정도"
  },
];

class MyIntroductionScreen extends StatefulWidget {
  @override
  _MyIntroductionScreenState createState() => _MyIntroductionScreenState();
}

class _MyIntroductionScreenState extends State<MyIntroductionScreen> {
  PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _currentPage = 0.0;
    _pageController = PageController(initialPage: _currentPage.toInt());
  }

  bool _onScroll(ScrollNotification notification) {
    final PageMetrics metrics = notification.metrics;
    setState(() {
      _currentPage = metrics.page;
    });
    return false;
  }

  void _onNextButton() {
    setState(() {
      _currentPage = _currentPage + 1;
    });
    _pageController.animateToPage(_currentPage.toInt(), duration: const Duration(milliseconds: 300), curve: Curves.bounceInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: PageView(
              controller: _pageController,
              children: pages
                  .map((p) => Center(
                        child: _buildPage(p["title"], p["description"]),
                      ))
                  .toList(),
              scrollDirection: Axis.horizontal,
            ),
          ),
          Positioned(
            bottom: 130.0,
            left: 0,
            right: 0,
            child: Center(
              child: DotsIndicator(
                dotsCount: 3,
                position: _currentPage,
                decorator: DotsDecorator(activeColor: Colors.black),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0,
            right: 0,
            child: FlatButton(
              child: pages.length - 1 == _currentPage.toInt()
                  ? Text(
                      "로그인",
                      style: TextStyle(fontSize: 16.0),
                    )
                  : Text("다음", style: TextStyle(fontSize: 16.0)),
              onPressed: pages.length - 1 == _currentPage.toInt()
                  ? () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Signin()));
                    }
                  : _onNextButton,
              textColor: Colors.white,
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(String title, String description) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 74.0),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 120.0,
            ),
            FlutterLogo(
              size: 180.0,
            ),
            SizedBox(
              height: 60.0,
            ),
            Center(
                child: Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )),
            SizedBox(
              height: 40.0,
            ),
            Center(
                child: Text(
              description,
              style: TextStyle(
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            )),
          ],
        ),
      ),
    );
  }
}