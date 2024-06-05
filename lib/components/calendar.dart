import 'package:flutter/widgets.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

class Calendar {
  final int year;
  final BuildContext context;

  bool leapYear(int year) {
    return (year % 4 == 0);
  }

  Map<int, ({int monthDays, String monthName, String weekday})> get months => {
        1: (
          monthDays: 31,
          monthName: context.loc.january,
          weekday: context.loc.monday
        ),
        2: (
          monthDays: leapYear(year) ? 29 : 28,
          monthName: context.loc.february,
          weekday: context.loc.tuesday
        ),
        3: (
          monthDays: 31,
          monthName: context.loc.march,
          weekday: context.loc.wednesday
        ),
        4: (
          monthDays: 30,
          monthName: context.loc.april,
          weekday: context.loc.thursday
        ),
        5: (
          monthDays: 31,
          monthName: context.loc.may,
          weekday: context.loc.friday
        ),
        6: (
          monthDays: 30,
          monthName: context.loc.june,
          weekday: context.loc.saturday
        ),
        7: (
          monthDays: 31,
          monthName: context.loc.july,
          weekday: context.loc.sunday
        ),
        8: (monthDays: 31, monthName: context.loc.august, weekday: ''),
        9: (monthDays: 30, monthName: context.loc.september, weekday: ''),
        10: (monthDays: 31, monthName: context.loc.october, weekday: ''),
        11: (monthDays: 30, monthName: context.loc.november, weekday: ''),
        12: (monthDays: 31, monthName: context.loc.december, weekday: ''),
      };

  (List<List> grid, Map months) monthCalendar(yEar, moNth) {
    int row = 6;
    int col = 7;
    List<String> days = [
      context.loc.sun,
      context.loc.mon,
      context.loc.tue,
      context.loc.wed,
      context.loc.thu,
      context.loc.fri,
      context.loc.sat
    ];
    var twoDList = List<List>.generate(
        row, (i) => List<dynamic>.generate(col, (index) => '', growable: false),
        growable: false);

    for (var i = 0; i <= 6; i++) {
      twoDList[0][i] = days[i];
    }

    DateTime date = DateTime(yEar, moNth);
    int daysInMonth = months[date.month]!.monthDays;
    DateTime month = DateTime(date.year, date.month, 1);
    var monthFirstDay = month.weekday;
    int count = 1;

    for (var i = monthFirstDay == 7 ? 0 : monthFirstDay; i <= 6; i++) {
      twoDList[1][i] = count;
      count++;
    }

    for (var i = 2; i < 6; i++) {
      for (var j = 0; j < 7; j++) {
        if (count <= daysInMonth) {
          twoDList[i][j] = count;
        }
        count++;
      }
    }
    for (var i = 0; i < 7; i++) {
      if (count <= daysInMonth) {
        twoDList[1][i] = count;
      }
      count++;
    }

    return (twoDList, months);
  }

  Calendar({required this.year, required this.context});
}
