import 'package:flutter/material.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/createtodo/alerttimedialog.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

class AlertContainer extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController alertTextController;
  final TextEditingController alertFrequencyController;
  final String alertText;
  final String alertFrequency;
  const AlertContainer(
      {super.key,
      required this.controller,
      required this.alertTextController,
      required this.alertFrequency,
      required this.alertText,
      required this.alertFrequencyController});

  @override
  State<AlertContainer> createState() => _AlertContainerState();
}

class _AlertContainerState extends State<AlertContainer> {
  late String? alert;
  late String? repeat;
  late var alertArray = [];

  @override
  void initState() {
    widget.alertTextController.text = widget.alertText;
    widget.alertFrequencyController.text = widget.alertFrequency;
    repeat = widget.alertFrequency;
    alert = widget.alertText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final durations = [
      context.loc.second,
      context.loc.minute,
      context.loc.hour,
      context.loc.day,
      context.loc.week,
      context.loc.month
    ];
    final wsf = context.scaleFactor.wsf;
    final hsf = context.scaleFactor.hsf;
    final width = context.scaleFactor.width;
    final height = context.scaleFactor.height;
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      height: 96 * hsf,
      width: 0.901 * width,
      decoration: BoxDecoration(
        color: const Colour().lHint2,
        borderRadius: BorderRadius.all(Radius.circular(8.0 * hsf)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              height: 48 * hsf,
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 12 * wsf)),
                  Image.asset(
                    'images/alarm/alarm.png',
                    height: 20 * context.scaleFactor.hsf,
                    width: 20.67 * context.scaleFactor.hsf,
                    fit: BoxFit.fill,
                  ),
                  Padding(padding: EdgeInsets.only(left: 0.1 * width)),
                  TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertTimeDialog();
                          },
                        ).then((value) {
                          setState(() {
                            if (value != null) {
                              alertArray = value;
                              alert = alertText(value);
                              widget.alertTextController.text = alert ?? '';
                              if (alertArray.length > 1) {
                                widget.controller.text =
                                    '${alertArray[0]},${durations[alertArray[1]]}';
                              } else {
                                widget.controller.text = '';
                              }
                            } else {
                              alert = context.loc.createalert;
                              widget.controller.text = '';
                            }
                          });
                        });
                      },
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0)),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        alert!,
                        style: CustomTextStyle(
                            context: context,
                            fontSz: 15,
                            fontWght: Fontweight.w400,
                            colour: FontColour.black,
                            normalSpacing: true),
                      ))
                ],
              )),
          Divider(
            indent: 12 * wsf + 20.67 * hsf + 0.1 * width,
            height: 0,
            color: const Colour().black,
            endIndent: 12.4 * wsf,
          ),
          SizedBox(
              height: 48 * hsf,
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 12 * wsf)),
                  Image.asset(
                    'images/repeat/repeat.png',
                    height: 20 * context.scaleFactor.hsf,
                    width: 20.67 * context.scaleFactor.hsf,
                    fit: BoxFit.fill,
                  ),
                  Padding(padding: EdgeInsets.only(left: 0.1 * width)),
                  Row(
                    children: [
                      Text(
                        overflow: TextOverflow.ellipsis,
                        'Alert ',
                        style: CustomTextStyle(
                            context: context,
                            fontSz: 15,
                            fontWght: Fontweight.w400,
                            colour: FontColour.black,
                            normalSpacing: true),
                      ),
                      DropdownButton(
                        style: CustomTextStyle(
                            context: context,
                            fontSz: 15,
                            fontWght: Fontweight.w400,
                            colour: FontColour.black,
                            normalSpacing: true),
                        value: repeat,
                        underline: Container(),
                        dropdownColor: const Colour().white,
                        iconSize: 24,
                        borderRadius: BorderRadius.circular(8 * hsf),
                        menuMaxHeight:
                            isLandScape ? width * 0.223 : height * 0.223,
                        elevation: 0,
                        items: <String>[
                          context.loc.once,
                          context.loc.daily,
                          context.loc.weekly,
                          context.loc.monthly
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            repeat = newValue;
                            widget.alertFrequencyController.text = newValue!;
                          });
                        },
                      )
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}

String alertText(dynamic value) {
  final durations = ['second', 'minute', 'hour', 'day', 'week', 'month'];
  return '${value[0]} ${value[0] > 1 ? '${durations[value[1]]}s' : durations[value[1]]} before time';
}
