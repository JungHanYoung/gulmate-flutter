import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/model/message.dart';
import 'package:gulmate/repository/repository.dart';

class ChatRepository {


  final Dio dio;
  FamilyRepository _familyRepository;

  ChatRepository(this.dio)
  : assert(dio != null) {
    _familyRepository = GetIt.instance.get<FamilyRepository>();
  }

  Future<List<Message>> fetchMessageList() async {
    final familyId = _familyRepository.family.id;
    final response = await dio.get("/api/v1/$familyId/chat");
    if(response.statusCode == 200 && response.data is List) {
      print(response.data);
      return (response.data as List).map((json) => Message.fromJson(json)).toList();
    }
    throw Exception("Error : Fetch Family Chat Data");
  }

}