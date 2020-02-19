import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/model/family.dart';
import 'package:gulmate/model/family_type.dart';
import 'package:gulmate/repository/repository.dart';
import 'package:gulmate/utils/enum_value_to_string.dart';

class FamilyRepository {
  final Dio dio;
  Family _family;
  UserRepository _userRepository;

  FamilyRepository(this.dio) {
    assert(dio != null);
    _userRepository = GetIt.instance.get<UserRepository>();
  }

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
      final response = await dio.post("/api/v1/family",
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

  Future<Family> joinFamily(String inviteKey) async {
    final String token = _userRepository.token;
    final response = await dio.post("/api/v1/family/join", data: {
      'inviteKey': inviteKey,
    }, options: Options(headers: {
      'Authorization': 'Bearer $token'
    }));
    if(response.statusCode == 200) {
      _family = Family.fromJSON(response.data);
      return _family;
    }
    throw Exception();
  }

}