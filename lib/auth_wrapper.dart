import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/blocs.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;

  AuthWrapper({
    @required this.child
  }) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<AuthenticationBloc>(
          create: (context) =>
              AuthenticationBloc()),
      BlocProvider<AppTabBloc>(
        create: (context) => AppTabBloc(),
      ),
      BlocProvider<CheckInviteViewBloc>(
        create: (context) => CheckInviteViewBloc(),
      ),
      BlocProvider<FamilyBloc>(
        create: (context) => FamilyBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          checkInviteViewBloc: BlocProvider.of<CheckInviteViewBloc>(context),
        ),
      ),
      BlocProvider<IntroBloc>(
        create: (context) => IntroBloc(),
      )
    ], child: child,);
  }

}