import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gulmate/model/family.dart';
import 'package:gulmate/model/family_type.dart';
import 'package:gulmate/model/shopping_item.dart';
import 'package:gulmate/utils/enum_value_to_string.dart';

class FamilyService with ChangeNotifier {
  final String apiBaseUrl;

  FamilyService({@required this.apiBaseUrl});

  String _token;

  Family _currentFamily;
  bool _isFetching;
  List<ShoppingItem> _shoppingItems = List();

  List<ShoppingItem> get shoppingItems => _shoppingItems;

  Family get getFamily => _currentFamily;

  bool get isFetching => _isFetching;

  void setFamily(Family family) {
    _currentFamily = family;
  }

  void setToken(String token) {
    _token = token;
  }

  Future<void> createFamily(String familyName, FamilyType familyType) async {
    _isFetching = true;
    notifyListeners();

    try {
      var response = await Dio().post("http://localhost:8080/api/v1/family",
          data: {
            'familyName': familyName,
            'familyType': enumValueToString(familyType),
          },
          options: Options(headers: {
            'Authorization': 'Bearer $_token',
          }));

      print(response.data);
      _currentFamily = Family.fromJSON(response.data);

    } catch (e) {
      print(e);
    }
    _isFetching = false;
    notifyListeners();
  }

  Future<void> fetchShoppingItems() async {
    try {
      final response = await Dio().get("http://localhost:8080/api/v1/purchase/${_currentFamily.id}",
      options: Options(
        headers: {
          'Authorization': 'Bearer $_token',
        },
      ));
      print("fetch ShoppingItems: ${response.data}");
      final json = response.data;
      if(json is List) {
        _shoppingItems = json.map((item) => ShoppingItem.fromJson(item)).toList();
        notifyListeners();
      }
//      print(json);
    } catch(e) {
      print(e);
    }
  }

  Future<void> createPurchase(String title, String place,
      bool isCheckedDateTime, DateTime dateTime) async {
    _isFetching = true;
    notifyListeners();
    try {
      if(isCheckedDateTime) {
        final response = await Dio()
            .post("http://localhost:8080/api/v1/purchase/${_currentFamily.id}",
                data: {
                  'title': title,
                  'place': place,
                  'deadline': dateTime.toString(),
                },
                options: Options(
                  headers: {
                    'Authorization': 'Bearer $_token',
                  },
                ));
        if (response.statusCode == 200) {
          final jsonResponse = response.data;
          print(jsonResponse);
        }
      } else {
        final response = await Dio()
            .post("http://localhost:8080/api/v1/purchase/${_currentFamily.id}",
            data: {
              'title': title,
              'place': place,
            },
            options: Options(
              headers: {
                'Authorization': 'Bearer $_token',
              },
            ));
        if (response.statusCode == 200) {
          final jsonResponse = response.data;
          print(jsonResponse);
        }

      }
    } catch (e) {
      print(e);
    }
    _isFetching = false;
    notifyListeners();
  }

  void toggleComplete(ShoppingItem item, bool value) {
    shoppingItems[_shoppingItems.indexOf(item)].isComplete = value;
    notifyListeners();
  }
}
