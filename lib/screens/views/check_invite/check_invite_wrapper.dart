import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/view/check_invite/check_invite_view.dart';

import 'create_family_view.dart';
import 'join_with_invite_key_view.dart';
import 'select_between_view.dart';
import 'welcome_view.dart';

class CheckInviteWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckInviteViewBloc, CheckInviteViewState>(
        builder: (context, state) => _buildCheckInviteView(state));
  }

  Widget _buildCheckInviteView(CheckInviteViewState state) {
    switch (state) {
      case CheckInviteViewState.selectBetween:
        return SelectBetweenView();
      case CheckInviteViewState.createFamily:
        return CreateFamilyView();
      case CheckInviteViewState.joinWithInviteKey:
        return JoinWithInviteKeyView();
      case CheckInviteViewState.welcome:
        return WelcomeView();
      default:
        return SelectBetweenView();
    }
  }
}
