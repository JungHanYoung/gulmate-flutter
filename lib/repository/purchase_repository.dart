import 'package:dio/dio.dart';
import 'package:gulmate/model/purchase.dart';
import 'package:gulmate/repository/family_repository.dart';
import 'package:gulmate/repository/user_repository.dart';

class PurchaseRepository {

  final Dio dio;
  final UserRepository userRepository;
  final FamilyRepository familyRepository;

  PurchaseRepository(
      this.dio,
      this.userRepository,
      this.familyRepository)
    : assert(dio != null),
      assert(userRepository != null),
      assert(familyRepository != null);

  Future<List<Purchase>> getPurchaseList() async {
    final family = familyRepository.family;
    final response = await dio.get("/api/v1/family/${family.id}/purchase",
        options: Options(
          headers: {
            'Authorization': userRepository.token,
          },));
    final rawData = response.data;
    if(response.statusCode == 200 && rawData is List) {
      return rawData.map((json) => Purchase.fromJson(json)).toList();
    }
    throw Exception("Error: Get purchase list");
  }

}