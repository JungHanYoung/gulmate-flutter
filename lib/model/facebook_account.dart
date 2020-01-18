import 'package:gulmate/model/account.dart';

class FacebookAccount extends Account {

  FacebookAccount({
    String email,
    String id,
    String name,
    String photoUrl,
  }) : super(email: email, id: id, name: name, photoUrl: photoUrl);

  factory FacebookAccount.fromJSON(Map<String, dynamic> json) {
      return FacebookAccount(
        email: json['email'],
        id: json['id'],
        name: json['name'],
        photoUrl: json['picture']['data']['url'],
      );
  }

  @override
  // TODO: implement getProvider
  String get getProvider => "Facebook";
}