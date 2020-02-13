import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/model/calendar.dart';
import 'package:gulmate/repository/family_repository.dart';
import 'package:gulmate/repository/user_repository.dart';

class CalendarRepository {
  final Dio dio;
  UserRepository _userRepository;
  FamilyRepository _familyRepository;

  CalendarRepository(this.dio)
    : assert(dio != null) {
    _userRepository = GetIt.instance.get<UserRepository>();
    _familyRepository = GetIt.instance.get<FamilyRepository>();
  }

  Future<List<Calendar>> getCalendarList(int year, int month) async {
    final familyId = _familyRepository.family.id;
    final response = await dio.get("/api/v1/$familyId/calendar?year=$year&month=$month", options: Options(
      headers: {
        'Authorization': 'Bearer ${_userRepository.token}'
      }
    ));
    if(response.statusCode == 200 && response.data is List) {
      return (response.data as List).map((json) => Calendar.fromJson(json)).toList();
    }
    throw Exception("Error: get calendar list");
  }

  Future<Calendar> createCalendar(String title, String place, DateTime dateTime, List<int> accountIds) async {
    final familyId = _familyRepository.family.id;
    final response = await dio.post("/api/v1/$familyId/calendar", data: {
      'title': title,
      'place': place,
      'dateTime': dateTime.toIso8601String(),
      'accountIds': accountIds,
    }, options: Options(
      headers: {
        'Authorization': 'Bearer ${_userRepository.token}',
      }
    ));
    if(response.statusCode == 200 && response.data != null) {
      return Calendar.fromJson(response.data);
    }
    throw Exception("Error create calendar");
  }

}