import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gulmate/model/account.dart';
import 'package:gulmate/model/facebook_account.dart';
import 'package:gulmate/model/google_account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  final String apiBaseUrl;
  Account _currentAccount;

  AuthService({
    @required this.apiBaseUrl,
  }) {
    SharedPreferences.getInstance().then((pref) {
      String accessToken = pref.getString("accessToken");
      if (accessToken != null && accessToken.isNotEmpty) {
        print("액세스 토큰 확인: $accessToken");
        print("액세스 토큰으로 사용자 확인중..");
        Dio()
            .get("$apiBaseUrl/me",
                options: Options(headers: {
                  "Authorization": accessToken,
                }))
            .then((result) {
          print("사용자 정보 가져오기 성공: ${result.data}");
          _currentAccount = FacebookAccount(
              name: "정한영",
              email: "8735132@naver.com",
              id: "1",
              photoUrl: "http://localhost:3000");
        });
      } else {
        print("로그인 정보 확인불가");
      }
    });
  }

  void setAccount(Account account) {
    if (account is GoogleAccount) {
      print("Google SignIn ...");
    } else if (account is FacebookAccount) {
      print("Facebook SignIn ...");
    }
    _currentAccount = account;
    notifyListeners();
  }

  Account get getAccount => _currentAccount;
}
