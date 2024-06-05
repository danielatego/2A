import 'package:flutter/material.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

class ButtonContainer extends StatelessWidget {
  final String buttonText;
  const ButtonContainer({super.key, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    final width = context.scaleFactor.width;
    final height = context.scaleFactor.height;
    final hsf = context.scaleFactor.hsf;

    return Container(
      alignment: Alignment.center,
      height: 0.21 * height,
      width: 0.859 * width,
      decoration: BoxDecoration(
          color: const Colour().lHint2,
          borderRadius: BorderRadius.circular(8 * hsf)),
      child: Text(
        overflow: TextOverflow.ellipsis,
        buttonText,
        style: CustomTextStyle(
            context: context,
            fontSz: 16,
            fontWght: Fontweight.w600,
            colour: FontColour.black,
            normalSpacing: true),
      ),
    );
  }
}
