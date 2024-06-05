import 'package:flutter/material.dart';
import 'package:two_a/components/calendar.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/views/personal/create_todo.dart';

// ignore: must_be_immutable
class SwitchBar2Do extends StatefulWidget {
  final DateTime date;
  late int index = 1;

  int get indx => index;
  SwitchBar2Do({required this.date, super.key});

  @override
  State<SwitchBar2Do> createState() => _SwitchBar2Do();
}

class _SwitchBar2Do extends State<SwitchBar2Do> {
  int v = 1;

  @override
  void initState() {
    super.initState();
    widget.index = v;
  }

  @override
  Widget build(BuildContext context) {
    List<String> days = [
      context.loc.monday,
      context.loc.tuesday,
      context.loc.wednesday,
      context.loc.thursday,
      context.loc.friday,
      context.loc.saturday,
      context.loc.sunday,
    ];
    List<String> actions = [
      context.loc.tassign,
      context.loc.tdo,
      context.loc.toaccount
    ];
    String dayInWords = days[widget.date.weekday - 1];
    String dateNumber = (widget.date.day).toString();
    String monthName = Calendar(year: DateTime.now().year, context: context)
        .months[widget.date.month]!
        .monthName;
    String year = widget.date.year.toString();
    return SizedBox(
      height: 40 * context.scaleFactor.hsf,
      width: 348 * context.scaleFactor.wsf,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: (v == 0)
                ? null
                : () {
                    setState(() {
                      if (v >= 1) {
                        v--;
                        widget.index = v;
                      }
                    });
                  },
            icon: Image.asset(
              'images/leftchevron/leftchevron.png',
              height: 10.48 * context.scaleFactor.hsf,
              width: 6 * context.scaleFactor.hsf,
              color: (v == 0) ? const Colour().lHint : const Colour().black,
            ),
            splashRadius: 20 * context.scaleFactor.hsf,
          ),
          Column(
            children: [
              Text(
                overflow: TextOverflow.ellipsis,
                actions[v],
                textAlign: TextAlign.center,
                style: CustomTextStyle(
                    context: context,
                    fontSz: 22,
                    fontWght: Fontweight.w500,
                    colour: FontColour.black,
                    normalSpacing: true),
              ),
              Text(
                overflow: TextOverflow.ellipsis,
                '$dayInWords, $dateNumber, $monthName, $year',
                style: CustomTextStyle(
                    context: context,
                    fontSz: 12,
                    fontWght: Fontweight.w500,
                    colour: FontColour.hintblack,
                    normalSpacing: true),
              )
            ],
          ),
          IconButton(
            alignment: Alignment.center,
            onPressed: (v == 2)
                ? null
                : () {
                    setState(() {
                      if (v < 2) v++;
                      widget.index = v;
                    });
                  },
            icon: Image.asset(
              'images/rightchevron/rightchevron.png',
              height: 10.48 * context.scaleFactor.hsf,
              width: 6 * context.scaleFactor.hsf,
              color: (v == 2) ? const Colour().lHint : const Colour().black,
            ),
            splashRadius: 20 * context.scaleFactor.hsf,
          ),
        ],
      ),
    );
  }
}

class Leftchevron extends StatelessWidget {
  final int v;
  const Leftchevron({super.key, required this.v});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chevron_left_rounded,
      color: (v == 0) ? const Colour().lHint : const Colour().black,
    );
  }
}

class UpgradedSwitchColumn extends StatelessWidget {
  final List<DateTime>? week;
  final String? month;
  final String? year;
  final bool? isWeek;
  final String text1;
  final DateTime date;

  const UpgradedSwitchColumn(
      {super.key,
      required this.text1,
      required this.date,
      this.week,
      this.isWeek,
      this.month,
      this.year});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          overflow: TextOverflow.ellipsis,
          text1,
          textAlign: TextAlign.center,
          style: CustomTextStyle(
              context: context,
              fontSz: 22,
              fontWght: Fontweight.w500,
              colour: FontColour.black,
              normalSpacing: true),
        ),
        Text(
          overflow: TextOverflow.ellipsis,
          year != null
              ? year ?? ''
              : month != null
                  ? month ?? ''
                  : isWeek ?? false
                      ? weekdate(week!)
                      : dateinWords(date, context),
          style: CustomTextStyle(
              context: context,
              fontSz: 12,
              fontWght: Fontweight.w500,
              colour: FontColour.hintblack,
              normalSpacing: true),
        )
      ],
    );
  }
}

class SwitchColumn extends StatelessWidget {
  final List<DateTime>? week;
  final String? month;
  final String? year;
  final bool? isWeek;
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final String text5;

  const SwitchColumn(
      {super.key,
      required this.text1,
      required this.text2,
      required this.text3,
      required this.text4,
      required this.text5,
      this.week,
      this.isWeek,
      this.month,
      this.year});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          overflow: TextOverflow.ellipsis,
          text1,
          textAlign: TextAlign.center,
          style: CustomTextStyle(
              context: context,
              fontSz: 22,
              fontWght: Fontweight.w500,
              colour: FontColour.black,
              normalSpacing: true),
        ),
        Text(
          overflow: TextOverflow.ellipsis,
          year != null
              ? year ?? ''
              : month != null
                  ? month ?? ''
                  : isWeek ?? false
                      ? weekdate(week!)
                      : '$text2, $text3, $text4, $text5',
          style: CustomTextStyle(
              context: context,
              fontSz: 12,
              fontWght: Fontweight.w500,
              colour: FontColour.hintblack,
              normalSpacing: true),
        )
      ],
    );
  }
}

class Rightchevron extends StatelessWidget {
  final int v;
  const Rightchevron({super.key, required this.v});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/rightchevron/rightchevron.png',
      height: 10.48 * context.scaleFactor.hsf,
      width: 6 * context.scaleFactor.hsf,
      color: (v == 2) ? const Colour().lHint : const Colour().black,
    );
  }
}

String weekdate(List<DateTime> week) {
  final beginDay = week[0].day;
  final beginMonth = week[0].month;
  final beginYear = week[0].year;
  final finishDay = week[1].day;
  final finishMonth = week[1].month;
  final finishYear = week[1].year;
  return '$beginDay/$beginMonth/$beginYear - $finishDay/$finishMonth/$finishYear';
}
