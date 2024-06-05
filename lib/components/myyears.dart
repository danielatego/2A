import 'package:flutter/material.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

class MyYears extends StatelessWidget {
  final int years;
  const MyYears({super.key, required this.years});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0 * context.scaleFactor.hsf),
      child: Center(
        child: Text(
          overflow: TextOverflow.ellipsis,
          (years + DateTime.now().year - 120).toString(),
          style: CustomTextStyle(
              context: context,
              fontSz: 17.5,
              fontWght: Fontweight.w400,
              colour: FontColour.black,
              normalSpacing: true),
        ),
      ),
    );
  }
}
