import 'package:equatable/equatable.dart';
import 'package:gulmate/bloc/view/check_invite/check_invite_view_bloc.dart';

abstract class CheckInviteViewEvent extends Equatable {

  const CheckInviteViewEvent();

  @override
  List<Object> get props => [];

}

class UpdateCheckInviteView extends CheckInviteViewEvent {
  final CheckInviteViewState state;

  const UpdateCheckInviteView(this.state);

  @override
  List<Object> get props => [state];
}