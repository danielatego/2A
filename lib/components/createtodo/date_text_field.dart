import 'package:flutter/material.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';

class DateTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool isAllDay;
  final bool begin;
  final DateTime date;
  final String? text;

  DateTime get time {
    return DateTime(
        date.year,
        date.month,
        date.day,
        (int.parse(controller.text[0] + controller.text[1])),
        (int.parse(controller.text[3] + controller.text[4])));
  }

  const DateTextField({
    super.key,
    required this.controller,
    required this.date,
    this.text,
    required this.isAllDay,
    required this.begin,
  });

  @override
  State<DateTextField> createState() => _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  @override
  void initState() {
    if (widget.text != null) {
      widget.controller.text = widget.text ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = context.scaleFactor.width;
    final hsf = context.scaleFactor.hsf;

    return SizedBox(
        height: 48 * hsf,
        width: 0.767 * width,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            width: 0.24 * width,
            child: Text(
                overflow: TextOverflow.ellipsis,
                widget.begin ? context.loc.begin : context.loc.finish,
                style: CustomTextStyle(
                  context: context,
                  fontSz: 17,
                  fontWght: Fontweight.w700,
                  colour:
                      widget.isAllDay ? FontColour.hintblack : FontColour.black,
                  normalSpacing: true,
                )),
          ),
          Container(
            alignment: Alignment.center,
            //color: const Colour().amber,
            height: 48 * hsf,
            width: 48 * hsf,
            child: TextField(
              onTapOutside: (event) =>
                  {FocusManager.instance.primaryFocus?.unfocus()},
              enabled: !widget.isAllDay,
              keyboardType: TextInputType.datetime,
              maxLength: 5,
              controller: widget.controller,
              onChanged: (input) {
                if (input.length == 1) {
                  if (int.parse(input) > 2) {
                    widget.controller.value = const TextEditingValue(
                      text: '0',
                      selection: TextSelection.collapsed(offset: 1),
                    );
                  }
                }
                if (input.contains(':') &&
                    input.length >= 3 &&
                    input[2] != ':') {
                  widget.controller.value = const TextEditingValue(
                    text: '',
                    selection: TextSelection.collapsed(offset: 0),
                  );
                }
                if (input.length >= 3 && !input.contains(':')) {
                  widget.controller.value = const TextEditingValue(
                    text: '',
                    selection: TextSelection.collapsed(offset: 0),
                  );
                }
                if (input.length < 3 && input.contains(':')) {
                  widget.controller.value = const TextEditingValue(
                    text: '',
                    selection: TextSelection.collapsed(offset: 0),
                  );
                } else if (input.length == 2) {
                  if (int.parse(input[0]) == 2) {
                    if (int.parse(input) > 23) {
                      widget.controller.value = const TextEditingValue(
                        text: '23',
                        selection: TextSelection.collapsed(offset: 2),
                      );
                    }
                  }
                } else if (input.length == 3 && !input.contains(":")) {
                  String hour = input[0] + input[1];
                  widget.controller.value = TextEditingValue(
                    text: '$hour:',
                    selection: const TextSelection.collapsed(offset: 3),
                  );
                } else if (input.length == 4) {
                  if (int.parse(input[3]) > 5) {
                    String hourPlusColon = '${input[0]}${input[1]}${input[2]}5';
                    widget.controller.value = TextEditingValue(
                      text: hourPlusColon,
                      selection: const TextSelection.collapsed(offset: 4),
                    );
                  }
                }
              },
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 9.5 * hsf),
                border: InputBorder.none,
                hintText: widget.begin ? ' 00:00' : ' 24:00',
                hintStyle: CustomTextStyle(
                    context: context,
                    fontSz: 15,
                    fontWght: Fontweight.w400,
                    colour: FontColour.accessiblilityhint,
                    normalSpacing: true),
              ),
              onSubmitted: (String text) async {
                if (text.length < 5 && text.isNotEmpty ||
                    text[3] == ':' ||
                    int.parse(text[0] + text[1]) > 23 ||
                    int.parse(text[3] + text[4]) > 59) {
                  await showErrorDialog(context, context.loc.incorrectdate);
                  widget.controller.value = const TextEditingValue(
                    text: '',
                    selection: TextSelection.collapsed(offset: 0),
                  );
                }
              },
            ),
          )
        ]));
  }
}
