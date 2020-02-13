String formatFromDateTime(DateTime dateTime) =>
    "${dateTime.year}-${dateTime.month / 10 == 0 ? '0${dateTime.month}' : dateTime.month}-${dateTime.day}";

String formatFromDateTimeToDateTime(DateTime dateTime) =>
    "${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour}:${dateTime.minute}";

String formatFromDateTimeToUntilWeek(DateTime dateTime) =>
    "${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일 ${_obtainWeek(dateTime.weekday)}요일";

String formatFromDateTimeToTime(DateTime dateTime) =>
    "${dateTime.hour >= 12 ? "오후" : "오전"} ${dateTime.hour < 10 ? "0${dateTime.hour}" : "${dateTime.hour}"}:${dateTime.minute >= 10 ? "${dateTime.minute}" : "0${dateTime.minute}"}";


String _obtainWeek(int weekday) {
  assert(weekday >= 1 && weekday <= 7);
  switch(weekday) {
    case 1:
      return "월";
    case 2:
      return "화";
    case 3:
      return "수";
    case 4:
      return "목";
    case 5:
      return "금";
    case 6:
      return "토";
    case 7:
      return "일";
  }
}