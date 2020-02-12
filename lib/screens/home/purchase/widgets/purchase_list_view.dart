import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/purchase/purchase.dart';
import 'package:gulmate/model/purchase.dart';
import 'package:gulmate/screens/home/purchase/widgets/purchase_item.dart';

import 'delete_purchase_snack_bar.dart';

class PurchaseListView extends StatelessWidget {
  final List<Purchase> purchaseList;
  final Future<void> Function() onRefresh;

  PurchaseListView(this.purchaseList, {@required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final purchaseItem = purchaseList[index];
          return PurchaseItem(
            purchase: purchaseItem,
            onCheckboxChanged: (value) {
              BlocProvider.of<PurchaseBloc>(context).add(CheckUpdatePurchase(
                  purchaseItem.copyWith(complete: value)));
            },
            onDelete: () {
              BlocProvider.of<PurchaseBloc>(context)
                  .add(DeletePurchase(purchaseItem));
              Scaffold.of(context).showSnackBar(DeletePurchaseSnackBar(
                purchase: purchaseItem,
              ));
            },
          );
        },
        itemCount: purchaseList.length,
      ),
    );
  }
}
