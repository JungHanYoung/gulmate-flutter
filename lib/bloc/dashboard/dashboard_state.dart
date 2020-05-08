import 'package:equatable/equatable.dart';
import 'package:gulmate/model/model.dart';

abstract class DashboardState extends Equatable {

  const DashboardState();

  @override
  List<Object> get props => [];
}


class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<Calendar> recentCalendarList;
  final List<Purchase> todayPurchaseList;
  final int chatLength;

  const DashboardLoaded(this.recentCalendarList, this.todayPurchaseList, this.chatLength);

  @override
  List<Object> get props => [recentCalendarList, todayPurchaseList, chatLength];

  @override
  String toString() {
    return 'DashboardLoaded{recentCalendarList: $recentCalendarList, todayPurchaseList: $todayPurchaseList}';
  }
}

class DashboardError extends DashboardState {
  final String errorMessage;

  const DashboardError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() {
    return 'DashboardError{errorMessage: $errorMessage}';
  }
}