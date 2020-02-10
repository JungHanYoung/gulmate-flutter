import 'package:flutter/material.dart';
import 'package:gulmate/repository/user_repository.dart';
import 'package:gulmate/screens/sign_up/sign_in.dart';
import 'package:introduction_screen/introduction_screen.dart';

const bodyStyle = TextStyle(
  fontSize: 19.0
);

const pageDecoration = const PageDecoration(
  titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
  bodyTextStyle: bodyStyle,
  descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
  pageColor: Colors.white,
  imagePadding: EdgeInsets.zero,
);

var pages = [
  _buildPageViewModel("Fractional shares", "Instead of having to buy an entire share, invest any amount you want."),
  _buildPageViewModel("Learn as you go", "Download the Stockpile app and master the market with our mini-lesson."),
];

PageViewModel _buildPageViewModel(String title, String body) {
  return PageViewModel(
    title: title,
    body: body,
    decoration: pageDecoration,
    footer: SizedBox(width: 20.0, height: 20.0,child: Text("data"),),
  );
}

class IntroductionPage extends StatelessWidget {
  final UserRepository userRepository;

  IntroductionPage({
    @required this.userRepository,
}) : assert(userRepository != null);

  void _onIntroEnd(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Signin(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: pages,
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}

