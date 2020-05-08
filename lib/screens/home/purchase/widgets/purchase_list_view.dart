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

class _PurchaseListViewState extends State<PurchaseListView> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        Completer<void> completer = Completer<void>();
        BlocProvider.of<PurchaseBloc>(context)
            .add(RefreshPurchaseList(completer));
        return completer.future;
      },
      child: ListView(
        children: widget.purchaseList.length == 0
            ? <Widget>[
                Center(
                  child: Text("장보기 데이터가 없습니다."),
                )
              ]
            : widget.purchaseList
                .map((purchase) => PurchaseItem(
                      purchase: purchase,
                      onCheckboxChanged: (value) {
                        BlocProvider.of<PurchaseBloc>(context).add(
                            CheckUpdatePurchase(
                                purchase.copyWith(complete: value)));
                      },
                      onDelete: () {
                        BlocProvider.of<PurchaseBloc>(context)
                            .add(DeletePurchase(purchase));
                        Scaffold.of(context)
                            .showSnackBar(DeletePurchaseSnackBar(
                          purchase: purchase,
                        ));
                      },
                    ))
                .toList(),
      ),
    );
  }
}
