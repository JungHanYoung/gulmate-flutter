import 'package:gulmate/model/account.dart';

class Calendar {
  int id;
  String title;
  String place;
  DateTime dateTime;
  List<Account> accountList;

  Calendar({this.id, this.title, this.place, this.dateTime, this.accountList});

  factory Calendar.fromJson(Map<String, dynamic> json) {
    return Calendar(
      id: json['id'],
      title: json['title'],
      place: json['place'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Calendar copyWith({
    String title,
    String place,
    DateTime dateTime,
    List<Account> accountList,
  }) {
    return Calendar(
      id: this.id,
      title: title ?? this.title,
      place: place ?? this.place,
      dateTime: dateTime ?? this.dateTime,
      accountList: accountList ?? this.accountList,
    );
  }

  @override
  String toString() {
    return 'Calendar{title: $title, place: $place, dateTime: $dateTime}';
  }


}
