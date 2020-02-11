import 'package:dio/dio.dart';
import 'package:gulmate/model/family.dart';
import 'package:gulmate/model/family_type.dart';
import 'package:gulmate/utils/enum_value_to_string.dart';

class FamilyRepository {
  final Dio dio;
  Family _family;

  FamilyRepository(this.dio);

  Family get family => _family;

  Future<Family> getMyFamily(String token) async {
    try {
      final response = await dio.get('/api/v1/family/me', options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ));
      _family = Family.fromJSON(response.data);
      return _family;

    } catch(e) {
      if(e is DioError) {
        throw Exception("Error: get my family");
      }
      throw Exception("Error: ${e.toString()}");
    }
  }

  Future<Family> createFamily(String familyName, FamilyType familyType, String token) async {
    try {
      final response = await Dio().post("http://localhost:8080/api/v1/family",
          data: {
            'familyName': familyName,
            'familyType': enumValueToString(familyType),
          },
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      _family = Family.fromJSON(response.data);
      return _family;
    } catch(e) {
      if(e is DioError) {
        throw Exception("Error: create family api");
      }
      throw Exception("Error: ${e.toString()}");
    }
  }

}