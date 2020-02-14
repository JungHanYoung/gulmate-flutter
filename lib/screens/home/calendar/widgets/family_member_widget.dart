import 'package:flutter/material.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/model/account.dart';

class FamilyMemberWidget extends StatelessWidget {
  final Account account;
  final bool checked;
  final bool isMe;
  final VoidCallback onTap;


  FamilyMemberWidget({
    @required this.account,
    this.checked = false,
    this.isMe = false,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      CircleAvatar(
        backgroundImage: NetworkImage(account.photoUrl),
      )
    ];
    if(checked) {
      children.add(Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color.fromRGBO(153, 153, 153, 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check, color: PRIMARY_COLOR,),
      ));
    }

    return Column(
      children: <Widget>[
        InkWell(
          onTap: onTap ?? () {},
          child: Container(
            width: 60,
            height: 60,
            padding: isMe ? EdgeInsets.all(2) : EdgeInsets.all(0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMe ? PRIMARY_COLOR : Colors.transparent,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: children,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(isMe ? "나" : account.name),
      ],
    );
  }
}
