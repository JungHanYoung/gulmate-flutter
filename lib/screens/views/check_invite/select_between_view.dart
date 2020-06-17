import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/authentication/authentication.dart';
import 'package:gulmate/bloc/family/family.dart';
import 'package:gulmate/bloc/view/check_invite/check_invite_view.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/const/resources.dart';

class SelectBetweenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<FamilyBloc, FamilyState>(
      builder: (context, familyState) {
        if (familyState is FamilyLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text("귤메이트 정보를 불러오는 중")
                ],
              ),
            ),
          );
        } else {
          final currentName = (BlocProvider.of<AuthenticationBloc>(context)
              .state as AuthenticationAuthenticatedWithoutFamily)
              .currentAccount
              .name;
          return Scaffold(
            backgroundColor: DEFAULT_BACKGROUND_COLOR,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: size.height * 0.15,
                  ),
                  Center(
                      child: Image(
                          image: AssetImage(
                              GulmateResources.GULMATE_LOGO_SYMBOL))),
                  SizedBox(
                    height: 30.0,
                  ),
                  Center(
                      child: Image(
                          image: AssetImage(
                              GulmateResources.GULMATE_LOGO_TYPEFACE_WHITE))),
                  SizedBox(height: 20.0),
                  Center(
                      child: Text(
                        "$currentName님 반갑습니다.\n혹시 초대를 받으셨나요?",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(
                    height: size.height * 0.15,
                  ),
                  RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 17.0),
                    child: Text(
                      "네, 초대 받았습니다.",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    textColor: Color(0xFFFF6D00),
                    onPressed: () {
                      BlocProvider.of<CheckInviteViewBloc>(context).add(UpdateCheckInviteView(CheckInviteViewState.joinWithInviteKey));
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    padding: const EdgeInsets.symmetric(vertical: 17.0),
                    child: Text(
                      "아니오, 처음입니다.",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    color: Colors.white,
                    textColor: Color(0xFFFFA200),
                    onPressed: () {
                      BlocProvider.of<CheckInviteViewBloc>(context).add(UpdateCheckInviteView(CheckInviteViewState.createFamily));
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
