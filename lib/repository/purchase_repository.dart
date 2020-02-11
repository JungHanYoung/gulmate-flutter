import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/model/purchase.dart';
import 'package:gulmate/repository/family_repository.dart';
import 'package:gulmate/repository/user_repository.dart';

class PurchaseRepository {
  final Dio dio;
  UserRepository userRepository;
  FamilyRepository familyRepository;

  PurchaseRepository(this.dio) : assert(dio != null) {
    userRepository = GetIt.instance.get<UserRepository>();
    familyRepository = GetIt.instance.get<FamilyRepository>();
  }

  Future<List<Purchase>> getPurchaseList() async {
    final family = familyRepository.family;
    final response = await dio.get("/api/v1/family/${family.id}/purchase",
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userRepository.token}',
          },
        ));
    final rawData = response.data;
    final content = rawData['content'];
    final pageInfo = rawData['pageable'];
//    print("content: " + content);
//    print("pageInfo: " + pageInfo);
    if (response.statusCode == 200 && content is List) {
      print('pageSize: ${pageInfo['pageSize']}');
      return content.map((json) => Purchase.fromJson(json)).toList();
    }
    throw Exception("Error: Get purchase list");
  }

  Future<Purchase> createPurchase(
      String title, String place, DateTime deadline) async {
    final familyId = familyRepository.family.id;
    final response = await dio.post("/api/v1/$familyId/purchase", data: {
      'title': title,
      'place': place,
      'deadline': deadline.toIso8601String(),
    }, options: Options(
      headers: {
        'Authorization': 'Bearer ${userRepository.token}',
      },
    ));
    final saved = response.data;
    if(response.statusCode == 200 && saved != null) {
      return Purchase.fromJson(saved);
    }
    throw Exception("Error: Post purchase");
  }
}
