import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/purchase/purchase.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/screens/home/purchase/purchase_add_edit_bottom_sheet.dart';
import 'package:gulmate/screens/home/purchase/purchase_add_editing_screen.dart';
import 'package:gulmate/screens/home/purchase/widgets/purchase_item.dart';

import 'widgets/delete_purchase_snack_bar.dart';
import 'widgets/filter_button.dart';

class PurchaseScreen extends StatefulWidget {
  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseBloc, PurchaseState>(builder: (context, state) {
      if (state is PurchaseLoading) {
        return _buildLoadingWidget();
      } else if (state is PurchaseError) {
        return _buildErrorWidget();
      } else {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 94),
                    child: Text(
                      "장보기",
                      style: TextStyle(fontSize: 30, color: PRIMARY_COLOR),
                    ),
                  ),
                  FilterButton(),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        Completer<void> completer = Completer<void>();
                        BlocProvider.of<PurchaseBloc>(context)
                            .add(RefreshPurchaseList(completer));
                        return completer.future;
                      },
                      child: BlocBuilder<FilteredPurchaseBloc,
                          FilteredPurchaseState>(builder: (context, state) {
                        final purchaseList =
                            (state as FilteredPurchaseLoaded).filteredPurchases;
                        return purchaseList.length == 0
                            ? Center(
                                child: Text("장보기 데이터가 없습니다."),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (context, index) {
                                  final purchaseItem = purchaseList[index];
                                  return PurchaseItem(
                                    purchase: purchaseItem,
                                    onCheckboxChanged: (value) {
                                      BlocProvider.of<PurchaseBloc>(context)
                                          .add(CheckUpdatePurchase(purchaseItem
                                              .copyWith(complete: value)));
                                    },
                                    onDelete: () {
                                      BlocProvider.of<PurchaseBloc>(context)
                                          .add(DeletePurchase(purchaseItem));
                                      Scaffold.of(context)
                                          .showSnackBar(DeletePurchaseSnackBar(
                                        purchase: purchaseItem,
                                      ));
                                    },
                                  );
                                },
                                itemCount: purchaseList.length,
                              );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 16,
                right: 16,
                child: InkWell(
                  onTap: () async {
                    final map = await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PurchaseAddEditingScreen(
//                            isEditing: false,
//                            onSave: (title, place, deadline) =>
//                                BlocProvider.of<PurchaseBloc>(context).add(
//                                    AddPurchase(title, place, deadline))))
                    )));
                    if(map != null) {
                      BlocProvider.of<PurchaseBloc>(context).add(AddPurchase(map['title'], map['place'], map['dateTime']));
                    }
//                    Scaffold.of(context).showBottomSheet(
//                        (context) => PurchaseAddEditBottomSheet());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: DEFAULT_BACKGROUND_COLOR,
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(249, 249, 249, 0.5),
                              blurRadius: 10,
                              spreadRadius: 10),
                        ]),
                    width: 60,
                    height: 60,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ))
          ],
        );
      }
    });
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget() => Center(
        child: Text("Error: Fetch Purchase"),
      );
}
