String formatFromDateTime(DateTime dateTime) =>
    "${dateTime.year}-${dateTime.month / 10 == 0 ? '0${dateTime.month}' : dateTime.month}-${dateTime.day}";

String formatFromDateTimeToDateTime(DateTime dateTime) =>
    "${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour}:${dateTime.minute}";
