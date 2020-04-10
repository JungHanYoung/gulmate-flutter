import 'package:gulmate/model/account.dart';


class Family {
  final int _id;
  String familyName;
  String familyPhotoUrl;
  String inviteKey;
  List<Account> accountList;
  String createdDate;
  String modifiedDate;

  int get id => _id;

  Family(this._id, {
    this.familyName,
    this.familyPhotoUrl,
    this.inviteKey,
    this.accountList,
    this.createdDate,
    this.modifiedDate,
  });

  factory Family.fromJSON(Map<String, dynamic> json) {
    return Family(
      json['id'],
      familyName: json['familyName'],
      familyPhotoUrl: json['familyPhotoUrl'],
      inviteKey: json['inviteKey'],
      accountList: (json['accountList'] as List).map((json) => Account.fromJson(json)).toList(),
      createdDate: json['createdDate'],
      modifiedDate: json['modifiedDate'],
    );
  }

  Family copyWith({
    String familyName,
    String familyPhotoUrl,
    List<Account> accountList
  }) {
    return Family(
      this._id,
      familyName: familyName ?? this.familyName,
      familyPhotoUrl: familyPhotoUrl ?? this.familyPhotoUrl,
      inviteKey: this.inviteKey,
      accountList: accountList ?? this.accountList,
      createdDate: this.createdDate,
      modifiedDate: this.modifiedDate,
    );
  }

  @override
  String toString() {
    return 'Family{familyName: $familyName, accountIds: ${accountList.map((account) => account.id).toList()}';
  }


}