import 'package:flutter/material.dart';
import 'package:two_a/components/calendar.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/views/dateonpress2.dart';

class Weeks {
  final int month;
  final int year;
  final BuildContext context;

  List<({int count, DateTime weekEnd, DateTime weekStart})> get monthWeekList {
    List<List<({int count, DateTime weekStart, DateTime weekEnd})>> monthWeeks =
        List.generate(
            12,
            (index) => (List.generate(5, (index) {
                  return (
                    count: 0,
                    weekStart: DateTime.now(),
                    weekEnd: DateTime.now(),
                  );
                })));
    var count = 1;
    for (var j = 0; j < 12; j++) {
      var sundays = 0;
      for (var i = 1;
          i <= Calendar(year: year, context: context).months[j + 1]!.monthDays;
          i++) {
        if (DateTime(year, j + 1, i).weekday == DateTime.sunday) {
          if (i + 6 >
              Calendar(year: year, context: context).months[j + 1]!.monthDays) {
            var excessDays = Calendar(year: year, context: context)
                    .months[j + 1]!
                    .monthDays -
                i;
            var weekStartDate = DateTime(year, j + 1, i);
            var weekEndDate = DateTime(year, j + 2, 6 - excessDays, 23, 59);
            monthWeeks[j][sundays] =
                (count: count, weekStart: weekStartDate, weekEnd: weekEndDate);
            count++;
            sundays++;
          } else {
            var weekStartDate = DateTime(year, j + 1, i);
            var weekEndDate = DateTime(year, j + 1, i + 6, 23, 59);
            monthWeeks[j][sundays] =
                (count: count, weekStart: weekStartDate, weekEnd: weekEndDate);
            count++;
            sundays++;
          }
        }
      }
    }
    return monthWeeks[month];
  }

  const Weeks({required this.month, required this.year, required this.context});
}

class WeekConstructor extends StatelessWidget {
  final List<({int count, DateTime weekStart, DateTime weekEnd})> monthWeeks;

  const WeekConstructor({super.key, required this.monthWeeks});

  @override
  Widget build(BuildContext context) {
    int weeksInMonth() {
      int counter = 5;
      for (var i = 0; i < monthWeeks.length; i++) {
        if (monthWeeks[i].count == 0) counter--;
      }
      return counter;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List<Widget>.generate(
          weeksInMonth(),
          (index) => WeekButton(
              count: monthWeeks[index].count,
              weekStart: monthWeeks[index].weekStart,
              weekEnd: monthWeeks[index].weekEnd)),
    );
  }
}

class WeekButton extends StatelessWidget {
  final int count;
  final DateTime weekStart;
  final DateTime weekEnd;

  const WeekButton(
      {super.key,
      required this.count,
      required this.weekStart,
      required this.weekEnd});

  @override
  Widget build(BuildContext context) {
    bool isDayWithin =
        (weekStart.isBefore(DateTime.now()) && weekEnd.isAfter(DateTime.now()));
    return TextButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DateOnPress2(
                      date: weekStart,
                      context: context,
                      main: false,
                      isWeek: true,
                      week: [weekStart, weekEnd],
                    )));
      },
      style: TextButton.styleFrom(
        fixedSize: Size(0.144 * context.scaleFactor.width,
            0.035 * context.scaleFactor.height),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              width: 0.5 * context.scaleFactor.hsf,
              color:
                  isDayWithin ? const Colour().primary : const Colour().black,
            )),
        backgroundColor:
            isDayWithin ? const Colour().primary : const Colour().white,
        foregroundColor:
            isDayWithin ? const Colour().lbg : const Colour().black,
      ),
      child: Text(
        overflow: TextOverflow.ellipsis,
        'W #$count',
        style: CustomTextStyle(
            context: context,
            fontSz: 13.50,
            fontWght: Fontweight.w400,
            normalSpacing: true,
            colour:
                isDayWithin ? FontColour.backgroundColor : FontColour.black),
      ),
    );
  }
}
