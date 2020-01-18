import 'package:google_sign_in/google_sign_in.dart';
import 'package:gulmate/model/account.dart';

class GoogleAccount extends Account {

  GoogleAccount({
    String photoUrl,
    String name,
    String email,
    String id,
  }) : super(id: id, email: email, name: name);

  factory GoogleAccount.fromGoogleSignInAccount(GoogleSignInAccount account)
    => GoogleAccount(
      name: account.displayName,
      photoUrl: account.photoUrl,
      email: account.email,
      id: account.id,
    );

  @override
  // TODO: implement getProvider
  String get getProvider => "Google";
}