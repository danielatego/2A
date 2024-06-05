import 'package:flutter/material.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/components/years.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';

class DateSetDialog extends StatefulWidget {
  final DateTime date;
  final bool begin;
  final BuildContext context;
  const DateSetDialog(
      {super.key,
      required this.date,
      required this.context,
      required this.begin});

  Map<int, ({String monthName, List<int> monthdays})> get list => {
        1: (
          monthName: context.loc.jan,
          monthdays: List.generate(31, (index) => index + 1)
        ),
        2: (
          monthName: context.loc.feb,
          monthdays:
              List.generate(date.year % 4 == 0 ? 29 : 28, (index) => index + 1)
        ),
        3: (
          monthName: context.loc.mar,
          monthdays: List.generate(31, (index) => index + 1)
        ),
        4: (
          monthName: context.loc.apr,
          monthdays: List.generate(30, (index) => index + 1)
        ),
        5: (
          monthName: context.loc.may1,
          monthdays: List.generate(31, (index) => index + 1)
        ),
        6: (
          monthName: context.loc.jun,
          monthdays: List.generate(30, (index) => index + 1)
        ),
        7: (
          monthName: context.loc.jul,
          monthdays: List.generate(31, (index) => index + 1)
        ),
        8: (
          monthName: context.loc.aug,
          monthdays: List.generate(31, (index) => index + 1)
        ),
        9: (
          monthName: context.loc.sep,
          monthdays: List.generate(30, (index) => index + 1)
        ),
        10: (
          monthName: context.loc.oct,
          monthdays: List.generate(31, (index) => index + 1)
        ),
        11: (
          monthName: context.loc.nov,
          monthdays: List.generate(30, (index) => index + 1)
        ),
        12: (
          monthName: context.loc.dec,
          monthdays: List.generate(31, (index) => index + 1)
        ),
      };

  @override
  State<DateSetDialog> createState() => _DateSetDialogState();
}

class _DateSetDialogState extends State<DateSetDialog> {
  int month = DateTime.now().month;
  int day = DateTime.now().day;
  int hour = 0;
  int minute = 00;
  @override
  Widget build(BuildContext context) {
    final width = context.scaleFactor.width;
    final height = context.scaleFactor.height;
    final hsf = context.scaleFactor.hsf;
    final wsf = context.scaleFactor.wsf;

    return Dialog(
        backgroundColor: const Colour().white,
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16 * context.scaleFactor.hsf)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 0.797 * width,
              height: 0.288 * height,
            ),
            Positioned(
                top: 0.04 * height,
                child: Container(
                  height: 0.153 * height,
                  width: 0.605 * width,
                  decoration: BoxDecoration(
                    color: const Colour().lHint2,
                    borderRadius: BorderRadius.all(Radius.circular(8.0 * hsf)),
                  ),
                )),
            Positioned(
              top: 0.058 * height,
              left: 0.15 * width,
              child: SizedBox(
                height: 0.117 * height,
                width: 24 * wsf,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: widget.begin ? 25 : 25,
                  onSelectedItemChanged: (value) {
                    setState(() {
                      day = value + 1;
                    });
                  },
                  diameterRatio: 1.0,
                  physics: widget.begin
                      ? const NeverScrollableScrollPhysics()
                      : const FixedExtentScrollPhysics(),
                  useMagnifier: true,
                  magnification: 1.0,
                  overAndUnderCenterOpacity: widget.begin ? 0 : 0.48,
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: List<Widget>.generate(
                        widget.list[month]!.monthdays.length,
                        (index) => const Scroll().format2(context,
                            widget.begin ? widget.date.day : index + 1)),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0.058 * height,
              left: 0.246 * width,
              child: SizedBox(
                height: 0.117 * height,
                width: 40 * wsf,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 25,
                  onSelectedItemChanged: (value) {
                    setState(() {
                      month = value + 1;
                    });
                  },
                  diameterRatio: 1.0,
                  physics: widget.begin
                      ? const NeverScrollableScrollPhysics()
                      : const FixedExtentScrollPhysics(),
                  useMagnifier: true,
                  magnification: 1.0,
                  overAndUnderCenterOpacity: widget.begin ? 0 : 0.48,
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: List<Widget>.generate(
                        12,
                        (index) => const Scroll().format3(
                            context,
                            widget.begin
                                ? widget.list[widget.date.month]!.monthName
                                : widget.list[index + 1]!.monthName)),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0.058 * height,
              right: 0.15 * width,
              child: Row(
                children: [
                  SizedBox(
                    height: 0.117 * height,
                    width: 24 * wsf,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 25,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          hour = value;
                        });
                      },
                      diameterRatio: 1.0,
                      physics: const FixedExtentScrollPhysics(),
                      useMagnifier: true,
                      magnification: 1.0,
                      overAndUnderCenterOpacity: 0.48,
                      childDelegate: ListWheelChildLoopingListDelegate(
                        children: List<Widget>.generate(24, (index) {
                          String value;
                          if (index < 10) {
                            value = '0$index';
                          } else {
                            value = '$index';
                          }
                          return const Scroll().format3(context, value);
                        }),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 8 * wsf)),
                  Text(
                    ':',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: const Colour().black),
                  ),
                  Padding(padding: EdgeInsets.only(left: 8 * wsf)),
                  SizedBox(
                    height: 0.117 * height,
                    width: 24 * wsf,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 25,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          minute = value;
                        });
                      },
                      diameterRatio: 1.0,
                      physics: const FixedExtentScrollPhysics(),
                      useMagnifier: true,
                      magnification: 1.0,
                      overAndUnderCenterOpacity: 0.48,
                      childDelegate: ListWheelChildLoopingListDelegate(
                        children: List<Widget>.generate(60, (index) {
                          String value;
                          if (index < 10) {
                            value = '0$index';
                          } else {
                            value = '$index';
                          }
                          return const Scroll().format3(context, value);
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 0.017 * height,
                child: TextButton(
                  style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                  onPressed: () {
                    DateTime date =
                        DateTime(DateTime.now().year, month, day, hour, minute);
                    if (date.isBefore(DateTime.now())) {
                      showErrorDialog(context,
                          'This date or time is invalid.\n It has already passed.');
                    } else {
                      Navigator.of(context).pop(date);
                    }
                  },
                  child: Text(
                    context.loc.set,
                    style: CustomTextStyle(
                        context: context,
                        fontSz: 16,
                        fontWght: Fontweight.w600,
                        colour: FontColour.primary,
                        normalSpacing: true),
                  ),
                ))
          ],
        ));
  }
}
