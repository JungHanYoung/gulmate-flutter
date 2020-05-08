import 'package:dio/dio.dart';
import 'package:gulmate/model/family.dart';

class FamilyRepository {
  final Dio dio;
  Family _family;

  FamilyRepository(this.dio)
    : assert(dio != null);


  Family get family => _family;

  Future<Family> getMyFamily() async {
    try {
      final response = await dio.get('/family/me');
      _family = Family.fromJSON(response.data);
      return _family;

    } catch(e) {
      if(e is DioError) {
        throw Exception("Error: get my family");
      }
      throw Exception("Error: ${e.toString()}");
    }
  }

  Future<Family> createFamily(String familyName) async {
    try {
      final response = await dio.post("/family",
          data: {
            'familyName': familyName,
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
    final response = await dio.post("/family/join", data: {
      'inviteKey': inviteKey,
    });
    if(response.statusCode == 200) {
      _family = Family.fromJSON(response.data);
      return _family;
    }
    throw Exception();
  }

  Future<void> withdrawFamily() async {
    final response = await dio.put("/family/withdraw");
    if(response.statusCode == 200) {
      _family = null;
      return;
    }
    throw Exception();
  }

  Future<void> modifyMemberInfo(String nickname) async {
    final response = await dio.put("/family/${_family.id}", data: {
      'nickname': nickname
    });
    if(response.statusCode != 200) {
      throw Exception();
    }
  }

  Future<String> uploadFamilyPhoto(FormData formData) async {
    final response = await dio.post<String>("/family/${_family.id}/upload", data: formData, options: Options(contentType: "multipart/form-data"));
    if(response.statusCode != 200) {
      throw Exception();
    }
    return response.data;
  }

}