import 'package:flutter/material.dart';
import 'package:two_a/components/personaltoAccount/materialstate.dart';
import 'package:two_a/components/text_style.dart';

class CustomTextButton extends TextButton {
  final BuildContext context;

  @override
  ButtonStyle? get style => ButtonStyle(
      foregroundColor: ButtonBgColor(context, false),
      textStyle: ButtonTextStyle(
        context: context,
        fontSize: 16.0,
        fontweight: Fontweight.w500,
        fontColour: FontColour.buttonblack,
      ));

  const CustomTextButton({
    super.key,
    required this.context,
    required super.onPressed,
    required super.child,
  });
}
