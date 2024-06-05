import 'package:flutter/material.dart';
import 'package:two_a/components/calendar.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/views/dateonpress2.dart';

class Gridview extends StatelessWidget {
  final BuildContext context;
  final int yEar;
  final int moNth;
  const Gridview(
      {super.key,
      required this.yEar,
      required this.moNth,
      required this.context});

  (List, int, int) get monthdata {
    final v =
        Calendar(year: yEar, context: context).monthCalendar(yEar, moNth).$1;
    int k = 0;
    final listedMonthData = List<dynamic>.generate(42, (index) => null);
    for (var i = 0; i < 6; i++) {
      for (var j = 0; j < 7; j++) {
        listedMonthData[k] = v[i][j];
        k++;
      }
    }
    return (listedMonthData, yEar, moNth);
  }

  List<Widget> get dateRows {
    var v = List<Widget>.generate(7, (index) => Container());
    for (var i = 0; i < 6; i++) {
      v[i] = Row(
        children: List<Widget>.generate(
            7,
            (index) => DateDay(
                  day: monthdata.$1[index + 7 * i],
                  month: monthdata.$3,
                  year: monthdata.$2,
                  context: context,
                )),
      );
    }
    return v;
  }

//DateDay(day: monthdata.$1[index + (7 * i)]);
  @override
  Widget build(BuildContext context) {
    return Column(children: dateRows);
  }
}

class DateDay extends StatelessWidget {
  final BuildContext context;
  final dynamic day;
  final dynamic month;
  final dynamic year;
  const DateDay(
      {super.key,
      required this.day,
      required this.month,
      required this.year,
      required this.context});

  bool get isThisMonth =>
      (month == DateTime.now().month && year == DateTime.now().year);

  @override
  Widget build(BuildContext context) {
    return (day is int)
        ? Container(
            margin: EdgeInsets.all(0.012 * context.scaleFactor.width),
            decoration: BoxDecoration(
                color: (isThisMonth && day == DateTime.now().day)
                    ? const Colour().primary
                    : const Colour().lbg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: (isThisMonth && day == DateTime.now().day)
                      ? const Colour().primary
                      : const Colour().lBorder,
                  width: .6,
                  style: BorderStyle.solid,
                  strokeAlign: BorderSide.strokeAlignInside,
                )),
            alignment: Alignment.center,
            width: 0.1 * context.scaleFactor.width,
            height: 0.1 * context.scaleFactor.width,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (contex) => DateOnPress2(
                        date: DateTime(year, month, day),
                        context: context,
                        main: false,
                      ),
                    ));
              },
              child: Text(
                day.toString(),
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyle(
                    context: context,
                    fontSz: 15.0,
                    normalSpacing: true,
                    fontWght: Fontweight.w400,
                    colour: (isThisMonth && day == DateTime.now().day)
                        ? FontColour.backgroundColor
                        : FontColour.black),
              ),
            ))
        : Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(0.012 * context.scaleFactor.width),
            width: 0.1 * context.scaleFactor.width,
            height: 0.1 * context.scaleFactor.width,
            child: Text(
              overflow: TextOverflow.ellipsis,
              day.toString(),
              style: CustomTextStyle(
                  context: context,
                  fontSz: 13.0,
                  fontWght: Fontweight.w400,
                  colour: FontColour.black,
                  normalSpacing: true),
            ),
          );
  }
}
