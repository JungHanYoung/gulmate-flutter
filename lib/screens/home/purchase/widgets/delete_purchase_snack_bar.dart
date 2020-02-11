import 'package:flutter/material.dart';
import 'package:gulmate/model/purchase.dart';

class DeletePurchaseSnackBar extends SnackBar {

  DeletePurchaseSnackBar({
    Key key,
    @required Purchase purchase,
}) : super(
    key: key,
    content: Text("${purchase.title}가 삭제되었습니다.", maxLines: 1,),
    duration: const Duration(seconds: 2),
  );
}
