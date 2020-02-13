import 'package:enum_to_string/enum_to_string.dart';
import 'package:gulmate/model/account.dart';

import 'family_type.dart';

class Family {
  final int _id;
  String familyName;
  FamilyType familyType;
  String inviteKey;
  List<Account> accountList;
  String createdDate;
  String modifiedDate;

  int get id => _id;

  Family(this._id, {
    this.familyName,
    this.familyType,
    this.inviteKey,
    this.accountList,
    this.createdDate,
    this.modifiedDate,
  });

  factory Family.fromJSON(Map<String, dynamic> json) {
    return Family(
      json['id'],
      familyName: json['familyName'],
      familyType: EnumToString.fromString(FamilyType.values, json['familyType']),
      inviteKey: json['inviteKey'],
      accountList: (json['accountList'] as List).map((json) => Account.fromJson(json)).toList(),
      createdDate: json['createdDate'],
      modifiedDate: json['modifiedDate'],
    );
  }

  @override
  String toString() {
    return 'Family{familyName: $familyName, familyType: $familyType, accountIds: ${accountList.map((account) => account.id).toList()}';
  }


}