import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gulmate/model/account.dart';


class AuthService with ChangeNotifier {
  final String apiBaseUrl;
  Account _currentAccount;
  String _currentToken;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: const <String>["email"]);
  FacebookLogin _facebookSignIn = FacebookLogin();

  bool _isSigning;

  get isSigning => _isSigning;
  get currentToken => _currentToken;

  AuthService({
    @required this.apiBaseUrl,
  });

  Future<dynamic> fetchMyAccount() async {
    if(_currentToken != null) {
      print("current token : $_currentToken");
      try {
        var response = await Dio().get("http://localhost:8080/api/v1/me", options: Options(
          headers: {
            "Authorization": "Bearer $_currentToken",
          }
        ));
        _currentAccount = Account.fromJson(response.data);
        return response.data;
      } catch(e) {
        print(e);
      }
    }
    return null;
  }

  Future<void> handleGoogleSignIn() async {
    _isSigning = true;
    notifyListeners();
    GoogleSignInAccount account = await _googleSignIn.signIn();
    var googleSignInAuthentication = await account.authentication;
    print(googleSignInAuthentication.accessToken);
    var response = await Dio().post<String>("http://localhost:8080/api/v1/authenticate", data: {
      "accessToken": googleSignInAuthentication.accessToken,
      "provider": "GOOGLE",
    });
    _isSigning = false;
    print("handlerGoogleSignIn : ${response.data}");
    _currentToken = response.data;
    notifyListeners();
  }

  Future<void> handleFacebookLogin() async {
    _isSigning = true;
    notifyListeners();
    final FacebookLoginResult result = await _facebookSignIn.logIn(["email"]);

    switch(result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        print("Facebook Access Token : " + token);
        var response = await Dio().post<String>("http://localhost:8080/api/v1/authenticate", data: {
          "accessToken": token,
          "provider": "FACEBOOK",
        });
        _currentToken = response.data;
//        final graphResponse = await Dio().get('https://graph.facebook.com/v5.0/${result.accessToken.userId}?access_token=$token&fields=email,name,picture');

//        final json = jsonDecode(graphResponse.data);
//        _currentAccount = FacebookAccount.fromJSON(json);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("페이스북 로그인 취소");
        throw Exception("canceled facebook login");
      case FacebookLoginStatus.error:
        print("에러 발생 ${result.errorMessage}");
//        await showDialog(context: context, builder: (context) => AlertDialog(title: Text("Facebook Login Error"), content: Text("${result.errorMessage}"),));
        throw Exception("Server Error");
      default:
        break;
    }


    _isSigning = false;
    notifyListeners();

  }

  Account get account => _currentAccount;
}
