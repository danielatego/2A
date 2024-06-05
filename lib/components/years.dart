import 'package:flutter/material.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/views/dateonpress2.dart';

class Scroll {
  const Scroll();

  List<int> get listyears => listYears();
  List<int> listYears() {
    final List<int> years = List.generate(239, (index) => index);
    final int currentYear = DateTime.now().year;
    for (var i = 0; i < 120; i++) {
      years[i] = currentYear + i;
      years[119 + i] = currentYear - 120 + i;
    }
    return years;
  }

  Widget format(BuildContext context, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 0,
      ),
      child: Center(
        child: Material(
          child: InkWell(
            splashColor: const Colour().primary,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DateOnPress2(
                              main: false,
                              date: DateTime.now(),
                              context: context,
                              isWeek: true,
                              year: '$value',
                              week: [
                                DateTime(value, 1, 1),
                                DateTime(value, 12, 31)
                              ])));
            },
            child: Text(
              overflow: TextOverflow.ellipsis,
              value.toString(),
              style: CustomTextStyle(
                context: context,
                fontSz: 11.33,
                fontWght: Fontweight.w600,
                colour: FontColour.black,
                normalSpacing: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget format2(BuildContext context, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 0,
      ),
      child: Center(
        child: Text(
          overflow: TextOverflow.ellipsis,
          value.toString(),
          style: CustomTextStyle(
            context: context,
            fontSz: 17,
            fontWght: Fontweight.w600,
            colour: FontColour.black,
            normalSpacing: true,
          ),
        ),
      ),
    );
  }

  Widget format3(BuildContext context, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 0,
      ),
      child: Center(
        child: Text(
          overflow: TextOverflow.ellipsis,
          value,
          style: CustomTextStyle(
            context: context,
            fontSz: 17,
            fontWght: Fontweight.w600,
            colour: FontColour.black,
            normalSpacing: true,
          ),
        ),
      ),
    );
  }
}
