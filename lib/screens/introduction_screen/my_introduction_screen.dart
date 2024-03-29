import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/intro/intro.dart';
import 'package:gulmate/const/resources.dart';

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
  double _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _pageController = PageController(initialPage: 0)
    ..addListener(() {
      setState(() {
        _currentPage = _pageController.page;
      });
    });

  }

//  bool _onScroll(ScrollNotification notification) {
//    final PageMetrics metrics = notification.metrics;
////    print(metrics.extentAfter);
//    final extentAfter = metrics.extentAfter;
//    final deviceWidth = MediaQuery.of(context).size.width;
////    print(extentAfter < deviceWidth);
//    if(extentAfter < deviceWidth && !_isLastPage) {
//      print("page is last page $_currentPage");
//      setState(() {
//        _isLastPage = true;
//      });
//    } else if(extentAfter >= deviceWidth && _isLastPage) {
//      print("No page is last page $_currentPage");
//      setState(() {
//        _isLastPage = false;
//      });
//    }
//    setState(() {
//      _currentPage = metrics.page;
//    });
//    print(metrics.atEdge);
//    if(metrics.page == pages.length) {
//      setState(() {
//        _currentPage = metrics.page;
//        _isLastPage = true;
//      });
//    } else {
//      setState(() {
//        _currentPage = metrics.page;
//        _isLastPage = false;
//      });
//    }
//    return false;
//  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextButton() {
//    setState(() {
//      _currentPage = _currentPage + 1;
//    });
    _pageController.animateToPage(
        _pageController.page.toInt(),
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceInOut);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: 100),
                  child: Image(image: AssetImage(GulmateResources.GULMATE_LOGO_SYMBOL),),
                ),
                Expanded(
                  child: PageView(
                      controller: _pageController,
                      children: pages.map((p) => Center(
                      child: _buildPage(p["title"], p["description"], deviceSize.height * 4/5 ),
                    ),).toList()
                  ),
                ),

              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: DotsIndicator(
                dotsCount: pages.length,
                position:  _currentPage,
                decorator: DotsDecorator(activeColor: Color(0xFFFF6D00)),
              ),
            ),
          ),
          FlatButton(
            child: _currentPage == pages.length - 1
                ? Text(
              "로그인",
              style: TextStyle(fontSize: 16.0),
            )
                : Text("다음", style: TextStyle(fontSize: 16.0)),
            onPressed: pages.length - 1 == _currentPage.toInt()
                ? () {
              BlocProvider.of<IntroBloc>(context).add(IntroUpdateEvent(IntroState.signIn));
//                            Navigator.pushReplacement(context,
//                                MaterialPageRoute(builder: (context) => Signin()));
            }
                : _onNextButton,
            textColor: Colors.white,
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 20.0),
          )
        ],
      ),
    );
  }

  Widget _buildPage(String title, String description, double topPadding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
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
    );
  }
}
