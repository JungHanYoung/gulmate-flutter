import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/model/calendar.dart';
import 'package:gulmate/repository/family_repository.dart';

class CalendarRepository {
  final Dio dio;
  FamilyRepository _familyRepository;

  CalendarRepository(this.dio) : assert(dio != null) {
    _familyRepository = GetIt.instance.get<FamilyRepository>();
  }

  Future<List<Calendar>> getCalendarList(int year) async {
    final familyId = _familyRepository.family.id;
    final response = await dio.get("/$familyId/calendar?year=$year");
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((json) => Calendar.fromJson(json))
          .toList();
    }
    throw Exception("Error: get calendar list");
  }

  Future<Calendar> createCalendar(String title, String place, DateTime dateTime,
      List<int> accountIds) async {
    final familyId = _familyRepository.family.id;
    final response = await dio.post("/$familyId/calendar", data: {
      'title': title,
      'place': place,
      'dateTime': dateTime.toIso8601String(),
      'accountIds': accountIds,
    });
    if (response.statusCode == 200 && response.data != null) {
      return Calendar.fromJson(response.data);
    }
    throw Exception("Error create calendar");
  }

  Future<int> deleteCalendar(Calendar calendar) async {
    final familyId = _familyRepository.family.id;
    final calendarId = calendar.id;
    final response = await dio.delete("/$familyId/calendar/$calendarId");
    if (response.statusCode == 200) {
      return calendar.id;
    }
    throw Exception("Error: delete calendar");
  }

  Future<Calendar> updateCalendar(
      Calendar calendar, List<int> accountIds) async {
    final familyId = _familyRepository.family.id;
    final calendarId = calendar.id;
    final response = await dio.put("/$familyId/calendar/$calendarId", data: {
      'title': calendar.title,
      'place': calendar.place,
      'dateTime': calendar.dateTime.toIso8601String(),
      'accountIds': accountIds,
    });
    if (response.statusCode == 200 && response.data is Map) {
      return Calendar.fromJson(response.data);
    }
    throw Exception("Error: update calendar");
  }

  Future<List<Calendar>> getRecentCalendarList({int size}) async {
    final familyId = _familyRepository.family.id;
    final response = await dio
        .get("/$familyId/calendar/recent");
    if(response.statusCode == 200 && response.data is List) {
      return (response.data as List).map((json) => Calendar.fromJson(json)).toList();
    }
    throw Exception("Error: Recent calendar list");
  }
}
