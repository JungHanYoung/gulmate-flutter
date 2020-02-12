import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gulmate/bloc/purchase/filtered_purchase/filtered_purchase_event.dart';
import 'package:gulmate/bloc/purchase/filtered_purchase/filtered_purchase_state.dart';
import 'package:gulmate/bloc/purchase/purchase.dart';
import 'package:gulmate/model/purchase.dart';
import 'package:gulmate/model/visibility_filter.dart';

class FilteredPurchaseBloc extends Bloc<FilteredPurchaseEvent, FilteredPurchaseState> {
  final PurchaseBloc purchaseBloc;
  StreamSubscription purchaseSubscription;


  FilteredPurchaseBloc(this.purchaseBloc) {
    purchaseSubscription = purchaseBloc.listen((state) {
      if(state is PurchaseLoaded) {
        add(UpdatePurchases(state.purchaseList));
      }
    });
  }

  @override
  // TODO: implement initialState
  FilteredPurchaseState get initialState
    => purchaseBloc.state is PurchaseLoaded
    ?  FilteredPurchaseLoaded((purchaseBloc.state as PurchaseLoaded).purchaseList, VisibilityFilter.all)
    : FilteredPurchaseLoading();

  @override
  Stream<FilteredPurchaseState> mapEventToState(FilteredPurchaseEvent event) async* {
    if(event is UpdateFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if(event is UpdatePurchases) {
      yield* _mapUpdatePurchasesToState(event);

    }
  }

  Stream<FilteredPurchaseState> _mapUpdateFilterToState(UpdateFilter event) async* {
    final visibilityFilter = state is FilteredPurchaseLoaded
        ? event.filter
        : VisibilityFilter.all;
    yield FilteredPurchaseLoaded(
        _mapPurchaseToFilteredPurchase(
            (purchaseBloc.state as PurchaseLoaded).purchaseList,
            visibilityFilter),
        visibilityFilter);
//    if(purchaseBloc.state is PurchaseLoaded) {
//      yield FilteredPurchaseLoaded((purchaseBloc.state as PurchaseLoaded).purchaseList, event.filter);
//    }
  }

  Stream<FilteredPurchaseState> _mapUpdatePurchasesToState(UpdatePurchases event) async* {
    final visibilityFilter = state is FilteredPurchaseLoaded
        ? (state as FilteredPurchaseLoaded).activeFilter
        : VisibilityFilter.all;
    yield FilteredPurchaseLoaded(
        _mapPurchaseToFilteredPurchase(
            (purchaseBloc.state as PurchaseLoaded).purchaseList,
            visibilityFilter),
        visibilityFilter);
  }

  List<Purchase> _mapPurchaseToFilteredPurchase(List<Purchase> purchases, VisibilityFilter filter)
    => purchases.where((purchase)
      => filter == VisibilityFilter.all
          ? true : filter == VisibilityFilter.active
            ? !purchase.complete : purchase.complete).toList();

  @override
  Future<void> close() {
    purchaseSubscription.cancel();
    return super.close();
  }

}