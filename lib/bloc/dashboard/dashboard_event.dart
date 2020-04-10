import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {

  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class FetchDashboard extends DashboardEvent {

  const FetchDashboard();

  @override
  String toString() {
    return 'FetchDashboard{}';
  }
}