import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/authentication/authentication.dart';
import 'package:gulmate/bloc/family/family_bloc.dart';
import 'package:gulmate/bloc/family/family_state.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/const/resources.dart';
import 'package:gulmate/screens/sign_up/create_family/create_family_screen.dart';
import 'package:gulmate/screens/sign_up/join_family/join_family_screen.dart';

class CheckInvitedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final AuthService authService = Provider.of<AuthService>(context);

    final size = MediaQuery.of(context).size;

    return BlocBuilder<FamilyBloc, FamilyState>(
      builder: (context, familyState) {
        if (familyState is FamilyLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
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
                    height: size.height * 0.1,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FlatButton(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 17.0),
                      child: Text(
                        "네, 초대 받았습니다.",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      textColor: Color(0xFFFF6D00),
                      onPressed: () {
                        print("초대쪽으로");
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => JoinFamilyScreen(),
                        ));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FlatButton(
                      padding: const EdgeInsets.symmetric(vertical: 17.0),
                      child: Text(
                        "아니오, 처음입니다.",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.white,
                      textColor: Color(0xFFFFA200),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CreateFamilyScreen()));
                      },
                    ),
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
