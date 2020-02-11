import 'package:equatable/equatable.dart';
import 'package:gulmate/model/purchase.dart';

abstract class PurchaseEvent extends Equatable {

  const PurchaseEvent();

  @override
  List<Object> get props => [];

}

class FetchPurchaseList extends PurchaseEvent {}

class RefreshPurchaseList extends PurchaseEvent {}

class AddPurchase extends PurchaseEvent {
  final Purchase purchase;

  const AddPurchase(this.purchase);

  @override
  List<Object> get props => [purchase];

  @override
  String toString() {
    return 'AddPurchase{purchase: $purchase}';
  }

}

class UpdatePurchase extends PurchaseEvent {
  final Purchase purchase;

  const UpdatePurchase(this.purchase);

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'UpdatePurchase{purchase: $purchase}';
  }
}

class DeletePurchase extends PurchaseEvent {
  final Purchase purchase;

  const DeletePurchase(this.purchase);

  @override
  List<Object> get props => [purchase];

  @override
  String toString() {
    return 'DeletePurchase{purchase: $purchase}';
  }
}