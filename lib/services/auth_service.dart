import 'package:flutter/foundation.dart';
import 'package:gulmate/model/account.dart';
import 'package:gulmate/model/facebook_account.dart';
import 'package:gulmate/model/google_account.dart';

class AuthService with ChangeNotifier {

  Account _currentAccount;


  void setAccount(Account account) {
    if(account is GoogleAccount) {
      print("Google SignIn ...");
    } else if(account is FacebookAccount) {
      print("Facebook SignIn ...");
    }
    _currentAccount = account;
    notifyListeners();
  }

  Account get getAccount => _currentAccount;
}