import 'package:equatable/equatable.dart';
import 'package:gulmate/bloc/tab/app_tab_state.dart';

abstract class AppTabEvent extends Equatable {
  const AppTabEvent();
}

class UpdateTab extends AppTabEvent {
  final AppTab tab;

  const UpdateTab(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() {
    return 'UpdateTab{tab: $tab}';
  }

}