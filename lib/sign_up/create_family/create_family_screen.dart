import 'package:flutter/material.dart';

class CreateFamilyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 85.0,),
              Text("새로운\n 가족 구성을 만들어주세요"),
              SizedBox(height: 50.0,),
              Text("가족명"),
              TextFormField(),
              SizedBox(height: 19.5,),
              Text("가족 구성원 수"),
              DropdownButtonFormField(items: [1,2,3].map((item) => DropdownMenuItem(child: Text(item.toString()),)), onChanged: (val) {print("change $val");}),
              Checkbox(value: false, onChanged: (val) {print("checkbox $val");}),
              Checkbox(value: true, onChanged: (val) {print("checkbox $val");}),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FlatButton(
                onPressed: () {},
                child: Text("다음 단계"),
              textColor: Colors.white,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
