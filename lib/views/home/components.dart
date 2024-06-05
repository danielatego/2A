import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:two_a/components/DateOnPress/todo_list_view.dart';
import 'package:two_a/components/calendar.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

class HomeTitle extends StatelessWidget {
  final DateTime date;
  final String? title;
  final bool? isHome;
  const HomeTitle({super.key, required this.date, this.title, this.isHome});

  @override
  Widget build(BuildContext context) {
    final width = context.scaleFactor.width;
    final height = context.scaleFactor.height;
    final hmf = context.scaleFactor.hmf;
    final hsf = context.scaleFactor.hsf;
    final wsf = context.scaleFactor.wsf;
    return Container(
      width: 0.49 * width,
      height: 0.054 * height,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title ?? context.loc.tdo,
                style: CustomTextStyle(
                    context: context, fontSz: 22, fontWght: Fontweight.w500),
              ),
              Padding(padding: EdgeInsets.only(right: 8 * wsf)),
              Icon(
                isHome ?? true ? Icons.home : Icons.work,
                color: isHome ?? true
                    ? const Colour().primary
                    : const Colour().green,
                size: 26,
              )
            ],
          ),
          Text(
            completeDate(date, context),
            style: CustomTextStyle(
                context: context,
                fontSz: 12,
                colour: FontColour.hintblack,
                fontWght: Fontweight.w500),
          )
        ],
      ),
    );
  }
}

String completeDate(DateTime date, BuildContext context) {
  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  String dayInWords = days[date.weekday - 1];
  String dateNumber = (date.day).toString();
  String monthName =
      Calendar(year: date.year, context: context).months[date.month]!.monthName;
  String year = date.year.toString();
  return '$dayInWords, $dateNumber, $monthName, $year';
}

class TitleAndDuration extends StatelessWidget {
  final int beginTime;
  final int finishTime;
  final String title;

  const TitleAndDuration(
      {super.key,
      required this.beginTime,
      required this.finishTime,
      required this.title});

  @override
  Widget build(BuildContext context) {
    final width = context.scaleFactor.width;
    final height = context.scaleFactor.height;
    final hmf = context.scaleFactor.hmf;
    final hsf = context.scaleFactor.hsf;
    final wsf = context.scaleFactor.wsf;
    return SizedBox(
      height: 0.045 * height,
      width: 0.853 * width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CustomTextStyle(context: context, fontSz: 15),
            overflow: TextOverflow.fade,
            maxLines: 1,
          ),
          Text(
            durationOfTask(beginTime, finishTime),
            style: CustomTextStyle(
                context: context, fontSz: 10, colour: FontColour.hintblack),
          )
        ],
      ),
    );
  }
}
