import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/purchase/purchase.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/model/purchase.dart';
import 'package:gulmate/screens/home/purchase/purchase_add_edit_screen.dart';
import 'package:gulmate/screens/home/purchase/widgets/purchase_list_view.dart';

import 'widgets/filter_button.dart';

class PurchaseScreen extends StatefulWidget {
  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseBloc, PurchaseState>(
      builder: (context, state) {
        if (state is PurchaseLoading) {
          return _buildLoadingWidget();
        } else if (state is PurchaseError) {
          return _buildErrorWidget();
        } else {
          return BlocProvider<FilteredPurchaseBloc>(
            create: (context) =>
                FilteredPurchaseBloc(BlocProvider.of<PurchaseBloc>(context)),
            child: SafeArea(
                child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, top: 50),
                        child: Text(
                          "장보기",
                          style: TextStyle(fontSize: 30, color: PRIMARY_COLOR),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: FilterButton(),
                      ),
                      Expanded(
                        child: (state is PurchaseLoaded && state.purchaseList.isEmpty)
                            ? Center(
                                child: Text(
                                  "등록된 장보기 데이터가 없습니다.",
                                  style: TextStyle(
                                      color: Color.fromRGBO(153, 153, 153, 1)),
                                ),
                              )
                            : PurchaseListView(
                                (state as PurchaseLoaded).purchaseList,
                                onRefresh: () {
                                BlocProvider.of<PurchaseBloc>(context)
                                    .add(RefreshPurchaseList());
                                return _refreshCompleter.future;
                              }),
                      ),
                    ],
                  ),
                ),
                _buildAddFloatingButton(),
              ],
            )),
          );
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildAddFloatingButton() {
    return Positioned(
        bottom: 16,
        right: 16,
        child: InkWell(
          onTap: () async {
            final addedPurchase = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PurchaseAddEditScreen(
                      prevContext: context,
                      isEditing: false,
                      onSave: (String title, String place, DateTime deadline) {
                        BlocProvider.of<PurchaseBloc>(context)
                            .add(AddPurchase(title, place, deadline));
                      },
                    )));
            if(addedPurchase is Purchase && addedPurchase != null) {
              BlocProvider.of<PurchaseBloc>(context).add(AddPurchase(addedPurchase.title, addedPurchase.place, addedPurchase.deadline));
            }
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
        ));
  }

  Widget _buildErrorWidget() => Center(
        child: Text("Error: Fetch Purchase"),
      );
}
