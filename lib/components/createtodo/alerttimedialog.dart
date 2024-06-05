import 'package:flutter/material.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/components/years.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

class AlertTimeDialog extends StatefulWidget {
  const AlertTimeDialog({super.key});

  Map<String, List<int>> get lists => {
        'sec': List.generate(5, (index) => (index + 1) * 10),
        'min': List.generate(59, (index) => index + 1),
        'hrs': List.generate(23, (index) => index + 1),
        'days': List.generate(6, (index) => index + 1),
        'wks': List.generate(3, (index) => index + 1),
        'mth': List.generate(12, (index) => index + 1)
      };

  List<String> get durations => ['sec', 'min', 'hrs', 'days', 'wks', 'mth'];

  @override
  State<AlertTimeDialog> createState() => _AlertTimeDialogState();
}

class _AlertTimeDialogState extends State<AlertTimeDialog> {
  String duration = 'sec';
  late int durationLength = widget.lists[duration]![0];
  List<dynamic> dialogOutput = List.generate(3, (index) => null);

  @override
  Widget build(BuildContext context) {
    String formatteduration(int durationLength, String duration) {
      switch (duration) {
        case 'sec':
          return durationLength > 1 ? "seconds" : 'second';
        case 'min':
          return durationLength > 1 ? 'minutes' : 'minute';
        case 'hrs':
          return durationLength > 1 ? 'hours' : 'hour';
        case 'days':
          return durationLength > 1 ? 'days' : 'day';
        case 'wks':
          return durationLength > 1 ? 'weeks' : 'week';
        case 'mth':
          return durationLength > 1 ? 'months' : 'month';
        default:
          return '';
      }
    }

    final height = context.scaleFactor.height;
    final hsf = context.scaleFactor.hsf;
    final wsf = context.scaleFactor.wsf;
    final width = context.scaleFactor.width;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      backgroundColor: const Colour().white,
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8 * context.scaleFactor.hsf)),
      child: Stack(
        children: [
          SizedBox(
              height: isPortrait ? 0.288 * height : 0.288 * width,
              width: isPortrait ? 0.797 * width : 0.797 * height),
          Positioned(
              top: 12 * hsf,
              left: 24 * wsf,
              child: Container(
                height: 92 * hsf,
                width: 67 * wsf,
                decoration: BoxDecoration(
                  color: const Colour().lHint2,
                  borderRadius: BorderRadius.all(Radius.circular(8.0 * hsf)),
                ),
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 30,
                  onSelectedItemChanged: (value) {
                    setState(() {
                      durationLength = widget.lists[duration]![value];
                    });
                  },
                  diameterRatio: 1.0,
                  physics: const FixedExtentScrollPhysics(),
                  useMagnifier: true,
                  magnification: 1.0,
                  overAndUnderCenterOpacity: 0.48,
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: List<Widget>.generate(
                        widget.lists[duration]!.length,
                        (index) => const Scroll()
                            .format2(context, widget.lists[duration]![index])),
                  ),
                ),
              )),
          Positioned(
              top: 12 * hsf,
              left: 107 * wsf,
              child: Container(
                height: 92 * hsf,
                width: 67 * wsf,
                decoration: BoxDecoration(
                  color: const Colour().lHint2,
                  borderRadius: BorderRadius.all(Radius.circular(8.0 * hsf)),
                ),
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 30,
                  onSelectedItemChanged: (value) {
                    setState(() {
                      duration = widget.durations[value];
                      durationLength = widget.lists[duration]![0];
                    });
                  },
                  diameterRatio: 1.0,
                  physics: const FixedExtentScrollPhysics(),
                  useMagnifier: true,
                  magnification: 1.0,
                  overAndUnderCenterOpacity: 0.48,
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: List<Widget>.generate(
                        widget.durations.length,
                        (index) => const Scroll()
                            .format3(context, widget.durations[index])),
                  ),
                ),
              )),
          Positioned(
              top: 50 * hsf,
              left: 188 * wsf,
              child: Text(
                overflow: TextOverflow.ellipsis,
                'before time',
                style: CustomTextStyle(
                  context: context,
                  fontSz: 17,
                  fontWght: Fontweight.w600,
                  colour: FontColour.black,
                  normalSpacing: true,
                ),
              )),
          Positioned(
              top: 124.5 * hsf,
              left: 84.5 * wsf,
              child: Container(
                height: 16 * hsf,
                width: 130 * wsf,
                decoration: BoxDecoration(
                    color: const Colour().lHint2,
                    borderRadius: BorderRadius.circular(8 * hsf)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      overflow: TextOverflow.ellipsis,
                      '$durationLength ${formatteduration(durationLength, duration)} before time',
                      style: CustomTextStyle(
                          context: context,
                          fontSz: 10.5,
                          fontWght: Fontweight.w400,
                          colour: FontColour.black,
                          normalSpacing: true),
                    )
                  ],
                ),
              )),
          Positioned(
            top: 155 * hsf,
            left: 13 * wsf,
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  context.loc.cancel,
                  style: CustomTextStyle(
                    context: context,
                    fontSz: 16,
                    fontWght: Fontweight.w500,
                    colour: FontColour.red,
                    normalSpacing: true,
                  ),
                )),
          ),
          Positioned(
            top: 155 * hsf,
            right: 13 * wsf,
            child: TextButton(
                onPressed: () {
                  setState(() {
                    dialogOutput[0] = durationLength;
                    dialogOutput[1] = period(duration);
                    dialogOutput[2] = durationLength > 1;
                  });
                  Navigator.of(context).pop(dialogOutput);
                },
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  context.loc.create,
                  style: CustomTextStyle(
                    context: context,
                    fontSz: 16,
                    fontWght: Fontweight.w500,
                    colour: FontColour.black,
                    normalSpacing: true,
                  ),
                )),
          )
        ],
      ),
    );
  }
}

int? period(String duration) {
  switch (duration) {
    case 'sec':
      return 0;
    case 'min':
      return 1;
    case 'hrs':
      return 2;
    case 'days':
      return 3;
    case 'wks':
      return 4;
    case 'mth':
      return 5;
    default:
      return null;
  }
}
