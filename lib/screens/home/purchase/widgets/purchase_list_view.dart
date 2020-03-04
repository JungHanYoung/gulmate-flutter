import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/purchase/purchase.dart';
import 'package:gulmate/model/purchase.dart';
import 'package:gulmate/screens/home/purchase/widgets/purchase_item.dart';

import 'delete_purchase_snack_bar.dart';

class PurchaseListView extends StatefulWidget {
  final List<Purchase> purchaseList;

  PurchaseListView(this.purchaseList);

  @override
  _PurchaseListViewState createState() => _PurchaseListViewState();
}
// TODO: ListView Refresh -> 인디케이터 보여진 후 새 목록 refresh, 인디케이터 잔존 에러 해결해야함.
class _PurchaseListViewState extends State<PurchaseListView> {


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        Completer<void> completer = Completer<void>();
        BlocProvider.of<PurchaseBloc>(context).add(RefreshPurchaseList(completer));
        return completer.future;
      },
      child: ListView.builder(
        itemBuilder: (context, index) {
          final purchaseItem = widget.purchaseList[index];
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
        itemCount: widget.purchaseList.length,
      ),
    );
  }
}
