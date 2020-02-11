import 'package:equatable/equatable.dart';
import 'package:gulmate/model/purchase.dart';

abstract class PurchaseState extends Equatable {

  const PurchaseState();

  @override
  List<Object> get props => [];

}

class PurchaseLoading extends PurchaseState {}

class PurchaseRefreshing extends PurchaseState {}

class PurchaseLoaded extends PurchaseState {
  final List<Purchase> purchaseList;

  const PurchaseLoaded(this.purchaseList);

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'PurchaseLoaded{purchaseList: $purchaseList}';
  }

}

class PurchaseError extends PurchaseState {}