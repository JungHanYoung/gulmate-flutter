import 'package:equatable/equatable.dart';
import 'package:gulmate/model/purchase.dart';

abstract class PurchaseState extends Equatable {

  const PurchaseState();

  @override
  List<Object> get props => [];

}

class PurchaseLoading extends PurchaseState {}

class PurchaseLoaded extends PurchaseState {
  final List<Purchase> purchaseList;

  const PurchaseLoaded(this.purchaseList);

  @override
  List<Object> get props => [purchaseList];

  @override
  String toString() {
    return 'PurchaseLoaded{purchaseList: $purchaseList}';
  }

}

class PurchaseError extends PurchaseState {
  final String errorMessage;

  const PurchaseError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() {
    return 'PurchaseError{errorMessage: $errorMessage}';
  }
}