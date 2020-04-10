import 'package:dio/dio.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gulmate/model/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {

  String _token;
  final Dio dio;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: const <String>["email"]);
  final FacebookLogin _facebookSignIn = FacebookLogin();

  UserRepository(this.dio)
      : assert(dio != null) {
    dio.interceptors.add(InterceptorsWrapper(
      onError: (error) async {
        final statusCode = error.response.statusCode;
        if(statusCode == 403) {

        }
      }
    ));
  }

  String get token => _token;


  Future<String> getToken() {
    return SharedPreferences.getInstance()
        .then((pref) {
          try {
            String token =pref.getString('token');
            _token = token;
            return token;
          } catch(_) {
            return null;
          }
    });
  }

  Future<Account> verifyToken() async {
    if(_token != null) {
      var response = await dio.get("/me", options: Options(
          headers: {
            "Authorization": "Bearer $_token",
          }
      ));
      if(response.statusCode != 200) {
        throw Exception("Invalid Token");
      }
      return Account.fromJson(response.data);
    }
    throw Exception("No token exists");
  }

  Future<void> persistToken(String token) {

    return SharedPreferences.getInstance()
        .then((pref) {
          return Future.delayed(Duration(milliseconds: 1500))
          .then((_) {
            _token = token;
            pref.setString('token', token);
          });
        });
  }

  Future<void> deleteToken() {
    return SharedPreferences.getInstance()
        .then((pref) {
          return Future.delayed(Duration(milliseconds: 1500))
            .then((_) {
              _token = null;
              pref.remove('token');
          });
    });
  }

  Future<String> onGoogleSignIn() async {
    GoogleSignInAccount account = await _googleSignIn.signIn();
    var googleSignInAuthentication = await account.authentication;
    var response = await dio.post<String>("/authenticate", data: {
      "accessToken": googleSignInAuthentication.accessToken,
      "provider": "GOOGLE",
    });
    if(response.statusCode != 200) {
      throw Exception('Google Sign In Error');
    }
    _token = response.data;
    SharedPreferences.getInstance().then((pref) {
      pref.setString("token", _token);
    });
    return response.data;
  }

  Future<String> onFacebookSignIn() async {
    final FacebookLoginResult result = await _facebookSignIn.logIn(["email"]);

    switch(result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        print("Facebook Access Token : " + token);
        var response = await dio.post<String>("/authenticate", data: {
          "accessToken": token,
          "provider": "FACEBOOK",
        });
        if(response.statusCode != 200) {
          throw Exception('Error: verify facebook access token on Server');
        }
        _token = response.data;
        SharedPreferences.getInstance().then((pref) {
          pref.setString("token", _token);
        });
        return _token;
        break;
      case FacebookLoginStatus.cancelledByUser:
        throw Exception("canceled facebook login");
      case FacebookLoginStatus.error:
        throw Exception("Server Error");
      default:
        throw Exception("Error");
    }
  }
}