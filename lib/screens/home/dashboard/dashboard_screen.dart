import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/authentication/authentication.dart';
import 'package:gulmate/bloc/family/family_bloc.dart';
import 'package:gulmate/bloc/family/family_state.dart';
import 'package:gulmate/screens/home/profile/profile_screen.dart';


class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final familyState = BlocProvider.of<FamilyBloc>(context).state;

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 46),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        (authState as AuthenticationAuthenticatedWithFamily)
                            .currentAccount.name,
                        style: TextStyle(fontSize: 30, color: Color(0xFFFF6D00)),
                      ),
                    ),
                    Container(
                      child: Text(
                        (familyState as FamilyLoaded)
                            .family.familyName,
                        style: TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
                _buildAvatar(context, (authState as AuthenticationAuthenticatedWithFamily).currentAccount.photoUrl),
              ],
            ),
            SizedBox(height: 34),
            _buildSubTitle(title: "다가오는 일정", moreBtnTitle: "1월"),
//          Padding(
//            padding: const EdgeInsets.only(top: 34),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Text("다가오는 일정",
//                    style: TextStyle(
//                        color: Color.fromRGBO(153, 153, 153, 1), fontSize: 16)),
//                _buildMoreButton(text: "1월", onTap: () {}),
//              ],
//            ),
//          ),
            Column(
              children: <Widget>[
                _buildCalendarItem("10", "가족 외식", "오후 07:00"),
                _buildCalendarItem("16", "서영이 논술 시험", "오전 11:30"),
                _buildCalendarItem("18", "엄마 건강검진", "오전 09:20"),
              ],
            ),
            _buildShoppingList([
              {
                'itemName': '샴푸',
                'authorName': '시영이',
              },
              {
                'itemName': '두부 한 모',
                'authorName': '엄마',
              },
              {
                'itemName': '치약',
                'authorName': '아빠',
              },
              {
                'itemName': '양파 다섯 개',
                'authorName': '엄마',
              },
            ], title: "쇼핑 목록"),
            _buildSubTitle(title: "갤러리", moreBtnTitle: "모두 보기"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics:
//              PageScrollPhysics(),
//                ClampingScrollPhysics(),
              BouncingScrollPhysics(),
              child: Row(
                children: <Widget>[
//                  _buildAlbumCard(
//                      title: "Image 1",
//                      photoUrl: "https://picsum.photos/250"),
//                  _buildAlbumCard(
//                      title: "Image 2",
//                      photoUrl: "https://picsum.photos/250"),
//                  _buildAlbumCard(
//                      title: "Image 3",
//                      photoUrl: "https://picsum.photos/250"),
                ],
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumCard({@required String title, @required String photoUrl}) =>
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: SizedBox(
          width: 220,
          height: 150,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color.fromRGBO(249, 249, 249, 0.5),
                          blurRadius: 10,
                          spreadRadius: 10),
                    ],
                    image: DecorationImage(
                        image: NetworkImage(photoUrl), fit: BoxFit.cover)),
              ),
              Positioned(
                left: 20,
                bottom: 16,
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      );

  Widget _buildAvatar(BuildContext context, String photoUrl) => Stack(children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(photoUrl),
        ),
        Positioned(
          bottom: 6,
          right: 0,
          child: SizedBox(
            width: 24,
            height: 24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: RaisedButton(
                padding: const EdgeInsets.all(6),
                onPressed: () {
                  // TODO: 프로필 수정 스크린 이동 (push)
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: Icon(
                  Icons.edit,
                  size: 11,
                ),
              ),
            ),
          ),
        )
      ]);

  Widget _buildMoreButton({@required String text, @required void onTap()}) =>
      InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Text(
            text,
            style: TextStyle(
                color: Color(0xFFFF6D00),
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
        ),
      );

  Widget _buildCalendarItem(String day, String title, String date) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: <Widget>[
          RichText(
              text: TextSpan(
                  text: day,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFF6D00),
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                TextSpan(
                  text: '일',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                )
              ])),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Text(
            date,
            style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
          )
        ],
      ),
    );
  }

  Widget _buildShoppingList(List<Map<String, String>> shoppingList,
      {@required String title}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: <Widget>[
          _buildSubTitle(title: title),
          _buildBasicCard(
              child: Column(
                  children: shoppingList
                      .map((item) => _buildShoppingItem(
                          itemName: item['itemName'],
                          authorName: item['authorName']))
                      .toList()))
        ],
      ),
    );
  }

  Widget _buildSubTitle({
    @required String title,
    String moreBtnTitle = "더 보기",
    Function onTap,
  }) =>
      Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
            ),
            _buildMoreButton(text: moreBtnTitle, onTap: () {}),
          ],
        ),
      );

  Widget _buildShoppingItem(
          {@required String itemName, @required String authorName}) =>
      Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(itemName),
            Text(authorName),
          ],
        ),
      );

  Container _buildBasicCard(
          {EdgeInsetsGeometry margin = const EdgeInsets.all(0),
          EdgeInsetsGeometry padding =
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          Widget child}) =>
      Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color.fromRGBO(249, 249, 249, 0.5),
                  blurRadius: 10,
                  spreadRadius: 10),
            ]),
        child: child,
      );
}
