import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/model/shopping_item.dart';
import 'package:gulmate/services/family_service.dart';
import 'package:gulmate/widgets/gul_check_box.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'add_shopping_screen.dart';


class ShoppingScreen extends StatefulWidget {
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}


class _ShoppingScreenState extends State<ShoppingScreen> {
  int index;
  RefreshController _refreshController = RefreshController();
  FamilyService _familyService;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final familyService = Provider.of<FamilyService>(context);

    if(this._familyService != familyService) {
      this._familyService = familyService;
      Future.microtask(() => familyService.fetchShoppingItems());
    }
  }


  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
//    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
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
                      style:
                      TextStyle(fontSize: 30, color: DEFAULT_BACKGROUND_COLOR),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 24.0),
                          child: InkWell(
                            child: Text("전체", style: TextStyle(fontSize: 16)),
                            onTap: () {},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 24.0),
                          child: Text(
                            "구매 예정",
                            style: TextStyle(
                                color: Color.fromRGBO(204, 204, 204, 1),
                                fontSize: 16.0),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: Text(
                              "구매 완료",
                              style: TextStyle(
                                  color: Color.fromRGBO(204, 204, 204, 1),
                                  fontSize: 16.0),
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: false,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: ListView(
                        children: _familyService.shoppingItems
                            .map(
                              (item) => _buildShoppingTile(
                              item: item,
                              onChanged: (checked) {
                                setState(() {
                                  item.isComplete = !item.isComplete;
                                });
                              },
                              deviceSize: size),
                        )
                            .toList(),
                      ),
                      controller: _refreshController,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 16,
                right: 16,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddShoppingScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
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
                )),
          ],
        ));
  }

  Widget _buildShoppingTile({
    void Function(bool) onChanged,
    ShoppingItem item,
    Size deviceSize,
  }) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(249, 249, 249, 0.5),
                    blurRadius: 10,
                    spreadRadius: 10)
              ]),
          width: deviceSize.width - 50,
          height: 73,
        ),
        Slidable(
          actionExtentRatio: 0.15,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
            ),
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            padding: const EdgeInsets.only(
                top: 14.0, bottom: 14.0, right: 18.0, left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: GulCheckbox(
                    value: item.isComplete,
                    onChanged: (bool value) {
                      Provider.of<FamilyService>(context, listen: false).toggleComplete(item, value);
                    },
                    checkColor: DEFAULT_BACKGROUND_COLOR,
                    activeColor: Colors.white,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title,
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.place,
                            size: 15,
                            color: DEFAULT_BACKGROUND_COLOR,
                          ),
                          Text(
                            item.place,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      item.author,
                      style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1),
                      ),
                    ),
                    Text(
                      "${item.deadline?.month}월 ${item.deadline?.day}일까지",
                      style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actionPane: SlidableBehindActionPane(),
          secondaryActions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
                child: IconSlideAction(
                  color: Colors.red,
                  icon: Icons.delete_outline,
                  onTap: () => {},
                ),
              ),
            )
          ],
        )
      ],
    );
  }
//      item != null
//          ? ListTile(
//              leading: Checkbox(
//                value: item.isComplete,
//                onChanged: onChanged,
//              ),
//              title: Text(item.title),
//              subtitle: Text(item.place),
//              trailing: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.end,
//                children: <Widget>[
//                  Text(item.author),
//                  Text(
//                    formatFromDateTime(item.date),
//                    style: TextStyle(color: Color.fromRGBO(204, 204, 204, 1)),
//                  ),
//                ],
//              ),
//            )
//          : ListTile(
//              leading: Checkbox(value: false, onChanged: onChanged),
//              title: Text(title),
//              subtitle: Text(place),
//              trailing: Column(
//                crossAxisAlignment: CrossAxisAlignment.end,
//                children: <Widget>[
//                  Text(author),
//                  Text(
//                    date,
//                    style: TextStyle(color: Color.fromRGBO(204, 204, 204, 1)),
//                  ),
//                ],
//              ),
//            );
}
