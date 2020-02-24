import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/model/purchase.dart';
import 'package:gulmate/repository/family_repository.dart';


class PurchaseRepository {
  final Dio dio;
  FamilyRepository familyRepository;

  PurchaseRepository(this.dio) : assert(dio != null) {
    familyRepository = GetIt.instance.get<FamilyRepository>();
  }

  Future<List<Purchase>> getPurchaseList() async {
    final family = familyRepository.family;
    final response = await dio.get("/api/v1/family/${family.id}/purchase");
    final rawData = response.data;
    if (response.statusCode == 200 && rawData is List) {
      return rawData.map((json) => Purchase.fromJson(json)).toList();
    }
    throw Exception("Error: Get purchase list");
  }

  Future<Purchase> createPurchase(
      String title, String place, DateTime deadline) async {
    final familyId = familyRepository.family.id;
    final response = await dio.post("/api/v1/$familyId/purchase",
        data: {
          'title': title,
          'place': place,
          'deadline': deadline != null ? deadline.toIso8601String() : null,
        });
    final saved = response.data;
    if (response.statusCode == 200 && saved != null) {
      return Purchase.fromJson(saved);
    }
    throw Exception("Error: Post purchase");
  }

  Future<void> deletePurchase(Purchase purchase) async {
    final familyId = familyRepository.family.id;
    final purchaseId = purchase.id;
    final response = await dio.delete("/api/v1/$familyId/purchase/$purchaseId");
    if (response.statusCode == 200) {
      return;
    }
    throw Exception("Error: delete purchase");
  }

  Future<int> updatePurchase(Purchase purchase) async {
    final familyId = familyRepository.family.id;
    final purchaseId = purchase.id;
    final response = await dio.put("/api/v1/$familyId/purchase/$purchaseId",
        data: {
          'title': purchase.title,
          'place': purchase.place,
          'complete': purchase.complete,
          'deadline': purchase.deadline != null
              ? purchase.deadline.toIso8601String()
              : null,
        });
    if (response.statusCode == 200 && response.data is int) {
      return response.data;
    }
    throw Exception("Error: occur update purchase");
  }

  Future<Purchase> checkPurchase(Purchase purchase) async {
    final familyId = familyRepository.family.id;
    final purchaseId = purchase.id;
    final response =
        await dio.put("/api/v1/$familyId/purchase/$purchaseId/complete",
            data: {
              'complete': purchase.complete,
            });
    if (response.statusCode == 200 && response.data != null) {
      final json = response.data;
      return purchase.copyWith(
        checker: json['checker'],
        checkedDateTime: json['checkedDateTime'] != null ? DateTime.parse(json['checkedDateTime']) : null,
      );
    }
    throw Exception("Error: occur update purchase");
  }
}
