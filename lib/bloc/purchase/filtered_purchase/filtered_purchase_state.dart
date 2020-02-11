import 'package:equatable/equatable.dart';
import 'package:gulmate/model/purchase.dart';
import 'package:gulmate/model/visibility_filter.dart';

abstract class FilteredPurchaseState extends Equatable {

  const FilteredPurchaseState();

  @override
  List<Object> get props => [];
}

class FilteredPurchaseLoading extends FilteredPurchaseState {}

class FilteredPurchaseLoaded extends FilteredPurchaseState {
  final List<Purchase> filteredPurchases;
  final VisibilityFilter activeFilter;

  const FilteredPurchaseLoaded(this.filteredPurchases, this.activeFilter);

  @override
  List<Object> get props => [filteredPurchases, activeFilter];

  @override
  String toString() {
    return 'FilteredPurchaseLoaded{filteredPurchases: $filteredPurchases, activeFilter: $activeFilter}';
  }
}