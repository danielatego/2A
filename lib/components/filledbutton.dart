import 'package:flutter/material.dart';
import 'package:two_a/components/personaltoAccount/materialstate.dart';
import 'package:two_a/components/text_style.dart';

class CustomFilledButton extends FilledButton {
  final BuildContext context;
  final bool? delete;

  @override
  ButtonStyle? get style => (ButtonStyle(
        alignment: Alignment.center,
        backgroundColor: ButtonBgColor(context, delete),
        textStyle: ButtonTextStyle(
          context: context,
          fontSize: 20,
          fontweight: Fontweight.w500,
          fontColour: FontColour.backgroundColor,
        ),
        shape: ButtonShape(context),
        fixedSize: ButtonSize(context),
      ));

  const CustomFilledButton({
    super.key,
    this.delete,
    required this.context,
    required super.onPressed,
    required super.child,
  });
}
