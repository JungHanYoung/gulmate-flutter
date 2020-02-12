import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/model/purchase.dart';


class PurchaseItem extends StatelessWidget {
  final Purchase purchase;
  final Function(bool) onCheckboxChanged;
  final Function onDelete;

  static const _completeColor = const Color.fromRGBO(153, 153, 153, 1);
  static const _incompleteColor = const Color.fromRGBO(34, 34, 34, 1);

  PurchaseItem({
    @required this.purchase,
    this.onCheckboxChanged,
    this.onDelete,
  }) : assert(purchase != null);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
          width: size.width - 50,
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
                  child: Checkbox(
                    value: purchase.complete,
                    onChanged: onCheckboxChanged,
                    checkColor: PRIMARY_COLOR,
                    activeColor: Colors.white,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        purchase.title,
                        style: TextStyle(fontSize: 16, color: purchase.complete ? _completeColor : _incompleteColor),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.place,
                            size: 15,
                            color: purchase.complete ? _completeColor : DEFAULT_BACKGROUND_COLOR,
                          ),
                          Text(
                            purchase.place,
                            style: TextStyle(fontSize: 14, color: purchase.complete ? _completeColor : _incompleteColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      purchase.complete ? purchase.checker : purchase.creator,
                      style: TextStyle(
                        color: purchase.complete ? PRIMARY_COLOR : Color.fromRGBO(153, 153, 153, 1),
                      ),
                    ),
                    Text(
                      purchase.complete
                          ? "${purchase.checkedDateTime?.month}월 ${purchase.checkedDateTime?.day}일"
                        : purchase.deadline != null ? "${purchase.deadline?.month}월 ${purchase.deadline?.day}일까지" : "",
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
                  onTap: onDelete,
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
