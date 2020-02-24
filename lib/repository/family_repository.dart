import 'package:dio/dio.dart';
import 'package:gulmate/model/family.dart';
import 'package:gulmate/model/family_type.dart';
import 'package:gulmate/utils/enum_value_to_string.dart';

class FamilyRepository {
  final Dio dio;
  Family _family;

  FamilyRepository(this.dio)
    : assert(dio != null);


  Family get family => _family;

  Future<Family> getMyFamily() async {
    try {
      final response = await dio.get('/api/v1/family/me');
      _family = Family.fromJSON(response.data);
      return _family;

    } catch(e) {
      if(e is DioError) {
        throw Exception("Error: get my family");
      }
      throw Exception("Error: ${e.toString()}");
    }
  }

  Future<Family> createFamily(String familyName, FamilyType familyType) async {
    try {
      final response = await dio.post("/api/v1/family",
          data: {
            'familyName': familyName,
            'familyType': enumValueToString(familyType),
          });
      _family = Family.fromJSON(response.data);
      return _family;
    } catch(e) {
      if(e is DioError) {
        throw Exception("Error: create family api");
      }
      throw Exception("Error: ${e.toString()}");
    }
  }

  Future<Family> joinFamily(String inviteKey) async {
    final response = await dio.post("/api/v1/family/join", data: {
      'inviteKey': inviteKey,
    });
    if(response.statusCode == 200) {
      _family = Family.fromJSON(response.data);
      return _family;
    }
    throw Exception();
  }

}