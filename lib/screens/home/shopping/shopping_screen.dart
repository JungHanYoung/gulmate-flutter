import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/model/shopping_item.dart';
import 'package:gulmate/utils/format_datetime_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'add_shopping_screen.dart';

class ShoppingScreen extends StatefulWidget {
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  List<ShoppingItem> items;
  int index;
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = [
      ShoppingItem(
          title: "쌀 한 가마니",
          place: "중앙 할인 마트",
          author: "작성자",
          isComplete: false,
          date: DateTime.utc(2019, 11, 19)),
      ShoppingItem(
          title: "치약",
          place: "올리브영",
          author: "작성자",
          isComplete: true,
          date: DateTime.utc(2019, 11, 10)),
      ShoppingItem(
          title: "양파 5개",
          place: "중앙 할인 마트",
          author: "작성자",
          isComplete: false,
          date: DateTime.utc(2019, 11, 19)),
    ];
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
                      style: TextStyle(
                          fontSize: 30, color: DEFAULT_BACKGROUND_COLOR),
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
                        children: items
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
                right: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddShoppingScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: DEFAULT_BACKGROUND_COLOR,
                    ),
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
    @required String title,
    @required String place,
    @required String author,
    @required String date,
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
          height: 76,
        ),
        Slidable(
          actionExtentRatio: 0.15,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
            ),
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            padding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Checkbox(
                  value: item.isComplete,
                  onChanged: (bool value) {},
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
                      "${item.date.month}월 ${item.date.day}일까지",
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
