import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/blocs.dart';
import '../repository/repository.dart';

class AuthWrapper extends StatefulWidget {
  final Widget child;

  AuthWrapper({
    @required this.child
  }) : assert(child != null);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {

  @override
  void initState() {
    super.initState();
    GetIt.instance.get<UserRepository>().getToken();
  }

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
        create: (context) => IntroBloc(
          BlocProvider.of<AuthenticationBloc>(context)
        ),
      )
    ], child: widget.child,);
  }
}