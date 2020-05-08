import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/model/message.dart';
import 'package:gulmate/repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {


  final Dio dio;
  FamilyRepository _familyRepository;
  int _cmi;

  ChatRepository(this.dio)
  : assert(dio != null) {
    _familyRepository = GetIt.instance.get<FamilyRepository>();
    SharedPreferences.getInstance()
      .then((pref) {
        _cmi = pref.getInt("chatMessageId");
    });
  }

  Future<List<Message>> fetchMessageList() async {
    final familyId = _familyRepository.family.id;
    final response = await dio.get("/$familyId/chat");
    if(response.statusCode == 200 && response.data is List) {
      print(response.data);
      return (response.data as List).map((json) => Message.fromJson(json)).toList();
    }
    throw Exception("Error : Fetch Family Chat Data");
  }

  Future<int> getUnreadChatLength() async {
    final familyId = _familyRepository.family.id;
    Response response;
    if(_cmi != null) {
      response = await dio.get("/$familyId/chat/unread", queryParameters: {
        'chatMessageId': _cmi,
      });
    } else {
      response = await dio.get("/$familyId/chat/unread");
    }
    if(response.statusCode == 200 && response.data is List) {
      return (response.data as List).length;
    }
    throw Exception("Error: Get Unread chat length");
  }

}