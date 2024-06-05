import 'package:flutter/material.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

class TimeAlldayToggle extends StatefulWidget {
  final TextEditingController controller;
  final bool isallday;
  const TimeAlldayToggle(
      {super.key, required this.controller, required this.isallday});

  @override
  State<TimeAlldayToggle> createState() => _TimeAlldayToggleState();
}

class _TimeAlldayToggleState extends State<TimeAlldayToggle> {
  late bool isAllDay;

  @override
  void initState() {
    isAllDay = widget.isallday;
    widget.controller.text = isAllDay.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hsf = context.scaleFactor.hsf;
    final wsf = context.scaleFactor.wsf;
    return SizedBox(
        height: 26 * hsf,
        width: 102 * wsf,
        child: Row(
          children: [
            Container(
              height: 26 * hsf,
              width: 51 * wsf,
              decoration: BoxDecoration(
                  color:
                      isAllDay ? const Colour().lHint2 : const Colour().primary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8 * hsf),
                      bottomLeft: Radius.circular(8 * hsf))),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isAllDay = false;
                    widget.controller.text = 'false';
                  });
                },
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  context.loc.time,
                  style: CustomTextStyle(
                      context: context,
                      fontSz: 11.9,
                      fontWght: Fontweight.w400,
                      colour:
                          isAllDay ? FontColour.hintblack : FontColour.white,
                      normalSpacing: true),
                ),
              ),
            ),
            Container(
              height: 26 * hsf,
              width: 51 * wsf,
              decoration: BoxDecoration(
                  color:
                      isAllDay ? const Colour().primary : const Colour().lHint2,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8 * hsf),
                      bottomRight: Radius.circular(8 * hsf))),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isAllDay = true;
                    widget.controller.text = 'true';
                  });
                },
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  context.loc.allday,
                  style: CustomTextStyle(
                      context: context,
                      fontSz: 11.9,
                      fontWght: Fontweight.w400,
                      colour:
                          isAllDay ? FontColour.white : FontColour.hintblack,
                      normalSpacing: true),
                ),
              ),
            )
          ],
        ));
  }
}

class TimeToggle extends StatefulWidget {
  late TextEditingController controller;
  final bool isallday;
  TimeToggle({super.key, required this.isallday});

  @override
  State<TimeToggle> createState() => _TimeToggleState();
}

class _TimeToggleState extends State<TimeToggle> {
  late bool isAllDay;

  @override
  void initState() {
    widget.controller = TextEditingController();
    isAllDay = widget.isallday;
    widget.controller.text = isAllDay.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hsf = context.scaleFactor.hsf;
    final wsf = context.scaleFactor.wsf;
    return SizedBox(
        height: 26 * hsf,
        width: 102 * wsf,
        child: Row(
          children: [
            Container(
              height: 26 * hsf,
              width: 51 * wsf,
              decoration: BoxDecoration(
                  color:
                      isAllDay ? const Colour().lHint2 : const Colour().primary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8 * hsf),
                      bottomLeft: Radius.circular(8 * hsf))),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isAllDay = false;
                    widget.controller.text = 'false';
                  });
                },
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  context.loc.time,
                  style: CustomTextStyle(
                      context: context,
                      fontSz: 11.9,
                      fontWght: Fontweight.w400,
                      colour:
                          isAllDay ? FontColour.hintblack : FontColour.white,
                      normalSpacing: true),
                ),
              ),
            ),
            Container(
              height: 26 * hsf,
              width: 51 * wsf,
              decoration: BoxDecoration(
                  color:
                      isAllDay ? const Colour().primary : const Colour().lHint2,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8 * hsf),
                      bottomRight: Radius.circular(8 * hsf))),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isAllDay = true;
                    widget.controller.text = 'true';
                  });
                },
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  context.loc.allday,
                  style: CustomTextStyle(
                      context: context,
                      fontSz: 11.9,
                      fontWght: Fontweight.w400,
                      colour:
                          isAllDay ? FontColour.white : FontColour.hintblack,
                      normalSpacing: true),
                ),
              ),
            )
          ],
        ));
  }
}

class AlldayText extends StatelessWidget {
  final bool isAllDay;
  const AlldayText({super.key, required this.isAllDay});

  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: TextOverflow.ellipsis,
      context.loc.allday,
      style: CustomTextStyle(
          context: context,
          fontSz: 11.9,
          fontWght: Fontweight.w400,
          colour: isAllDay ? FontColour.white : FontColour.hintblack,
          normalSpacing: true),
    );
  }
}

class TimeText extends StatelessWidget {
  final bool isAllDay;
  const TimeText({super.key, required this.isAllDay});

  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: TextOverflow.ellipsis,
      context.loc.time,
      style: CustomTextStyle(
          context: context,
          fontSz: 11.9,
          fontWght: Fontweight.w400,
          colour: isAllDay ? FontColour.hintblack : FontColour.white,
          normalSpacing: true),
    );
  }
}
