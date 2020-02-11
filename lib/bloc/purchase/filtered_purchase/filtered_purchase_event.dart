import 'package:equatable/equatable.dart';
import 'package:gulmate/model/purchase.dart';
import 'package:gulmate/model/visibility_filter.dart';

abstract class FilteredPurchaseEvent extends Equatable {

  const FilteredPurchaseEvent();

  @override
  List<Object> get props => [];
}

class UpdateFilter extends FilteredPurchaseEvent {
  final VisibilityFilter filter;

  const UpdateFilter(this.filter);

  @override
  List<Object> get props => [filter];

  @override
  String toString() {
    return 'UpdateFilter{filter: $filter}';
  }
}

class UpdatePurchases extends FilteredPurchaseEvent {
  final List<Purchase> purchases;

  const UpdatePurchases(this.purchases);

  @override
  List<Object> get props => [purchases];

  @override
  String toString() {
    return 'UpdatePurchases{purchases: $purchases}';
  }

}