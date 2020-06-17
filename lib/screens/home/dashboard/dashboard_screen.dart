import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/authentication/authentication.dart';
import 'package:gulmate/bloc/blocs.dart';
import 'package:gulmate/bloc/family/family_bloc.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/const/resources.dart';
import 'package:gulmate/model/calendar.dart';
import 'package:gulmate/model/model.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final familyState = BlocProvider.of<FamilyBloc>(context).state;
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) =>
          BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) => state is DashboardLoaded
            ? LayoutBuilder(
              builder: (context, constraints) => Stack(
                  children: <Widget>[
                    ListView(
                      padding:
                          EdgeInsets.only(top: constraints.maxWidth / 2 + 40, left: 25, right: 25),
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    (authState
                                            as AuthenticationAuthenticatedWithFamily)
                                        .currentAccount
                                        .name,
                                    style: TextStyle(
                                        fontSize: 30, color: Color(0xFFFF6D00)),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    (familyState as FamilyLoaded)
                                        .family
                                        .familyName,
                                    style: TextStyle(
                                        color: Color.fromRGBO(153, 153, 153, 1),
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 34),
                        state.chatLength > 0 ? _buildSubTitle(context, title: "읽지 않은 대화", moreBtnTitle: "${state.chatLength}개") : SizedBox.shrink(),
                        SizedBox(height: 12,),
                        _buildSubTitle(context,
                            title: "다가오는 일정",
                            moreBtnTitle: "${DateTime.now().month}월"),
                        state.recentCalendarList.length == 0 ? Text("등록된 일정이 없습니다.") : Column(
                          children: state.recentCalendarList
                              .map((calendar) => _buildCalendarItem(
                                  "${calendar.dateTime.day}",
                                  calendar.title,
                                  _formatDateTimeToString(calendar)))
                              .toList(),
                        ),
                        _buildShoppingList(context, state.todayPurchaseList,
                            title: "오늘 장볼 것", onTap: () {
                          BlocProvider.of<AppTabBloc>(context)
                              .add(UpdateTab(AppTab.purchase));
                        }),
                        SizedBox(height: 50),
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Opacity(
                              child: Container(
                                width: constraints.maxWidth,
                                height: constraints.maxWidth / 2,
                                child: (authState as AuthenticationAuthenticatedWithFamily)
    .currentFamily
    .familyPhotoUrl != null ? CachedNetworkImage(
                                  imageUrl: (authState
                                  as AuthenticationAuthenticatedWithFamily)
                                      .currentFamily
                                      .familyPhotoUrl,
                                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                  fit: BoxFit.contain,
                                ) : Image.asset(GulmateResources.PLACEHOLDER_600x400, fit: BoxFit.cover,)
                              ),
                              opacity: 0.8,
                            ),
                            Positioned(
                              bottom: 20,
                              right: 25,
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: RaisedButton(
                                  shape: CircleBorder(),
                                  padding: const EdgeInsets.all(6),
                                  color: PRIMARY_COLOR,
                                  elevation: 0.0,
                                  onPressed: () =>
                                      BlocProvider.of<FamilyBloc>(context)
                                          .add(UploadFamilyPhoto()),
                                  child: Icon(
                                    Icons.edit,
                                    size: 11,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Positioned(
                      top: constraints.maxWidth / 2 - 40,
                      left: 40,
                      child: _buildAvatar(
                          context,
                          (authState as AuthenticationAuthenticatedWithFamily)
                              .currentAccount
                              .photoUrl),
                    ),
                  ],
                ),
            )
            : state is DashboardError
                ? Center(
                    child: Text("${state.errorMessage}"),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
    );
  }

  String _formatDateTimeToString(Calendar calendar) =>
      "${calendar.dateTime.hour >= 12 ? "오후" : "오전"} ${calendar.dateTime.hour < 10 ? "0${calendar.dateTime.hour}" : calendar.dateTime.hour < 12 ? "${calendar.dateTime.hour}" : calendar.dateTime.hour - 12 < 10 ? "0${calendar.dateTime.hour - 12}" : "${calendar.dateTime.hour - 12}"}:${calendar.dateTime.minute < 10 ? "0${calendar.dateTime.minute}":calendar.dateTime.minute}";

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

  Widget _buildAvatar(BuildContext context, String photoUrl) => CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(photoUrl),
      );

//      Stack(children: <Widget>[
//        ,
//        Positioned(
//          bottom: 6,
//          right: 0,
//          child: SizedBox(
//            width: 24,
//            height: 24,
//            child: RaisedButton(
//              shape: CircleBorder(),
//              padding: const EdgeInsets.all(6),
//              color: PRIMARY_COLOR,
//              elevation: 0.0,
//              onPressed: () {
//                Navigator.of(context).push(
//                    MaterialPageRoute(builder: (context) => ProfileScreen()));
//              },
//              child: Icon(
//                Icons.edit,
//                size: 11,
//                color: Colors.white,
//              ),
//            ),
//          ),
//        )
//      ]);

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
      margin: const EdgeInsets.symmetric(vertical: 5),
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

  Widget _buildShoppingList(BuildContext context, List<Purchase> shoppingList,
      {@required String title, Function onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildSubTitle(context, title: title, onTap: onTap),
          shoppingList.length == 0 ? Text("장 보아야 할 것이 없습니다.") : _buildBasicCard(
              child: Column(
                  children: shoppingList
                      .map((item) => _buildShoppingItem(
                          itemName: item.title,
                          authorName:
                              item.complete ? item.checker : item.creator))
                      .toList()))
        ],
      ),
    );
  }

  Widget _buildSubTitle(
    BuildContext context, {
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
              style: TextStyle(
                  color: Color.fromRGBO(153, 153, 153, 1), fontSize: 16),
            ),
            _buildMoreButton(text: moreBtnTitle, onTap: onTap),
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
            Text(
              itemName,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              authorName,
              style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
            ),
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
