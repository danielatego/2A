import 'package:flutter/material.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/extensions/materialstate/state.dart';

class ButtonBgColor implements MaterialStateProperty<Color> {
  final BuildContext context;
  final bool? delete;
  ButtonBgColor(this.context, this.delete);

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.isPressed) {
      return const Colour().primary;
    }
    return delete ?? false ? const Colour().red : const Colour().lBorder;
  }
}

class ButtonTextStyle implements MaterialStateProperty<TextStyle> {
  final BuildContext context;
  final double fontSize;
  final Fontweight fontweight;
  final FontColour fontColour;

  ButtonTextStyle(
      {required this.context,
      required this.fontSize,
      required this.fontweight,
      required this.fontColour});

  @override
  TextStyle resolve(Set<MaterialState> states) => CustomTextStyle(
      context: context,
      fontSz: fontSize,
      fontWght: fontweight,
      colour: fontColour,
      normalSpacing: true);
}

class ButtonShape implements MaterialStateProperty<OutlinedBorder> {
  final BuildContext context;

  ButtonShape(this.context);

  @override
  OutlinedBorder resolve(Set<MaterialState> states) => (RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0 * context.scaleFactor.wsf),
      ));
}

class ButtonSize implements MaterialStateProperty<Size> {
  final BuildContext context;

  ButtonSize(this.context);

  @override
  Size resolve(Set<MaterialState> states) => (Size(
        0.64 * context.scaleFactor.width,
        40.0 * context.scaleFactor.hsf,
      ));
}

class IconButtonSize implements MaterialStateProperty<Size> {
  final BuildContext context;

  IconButtonSize(this.context);

  @override
  Size resolve(Set<MaterialState> states) => (Size(
        20 * context.scaleFactor.hsf,
        20 * context.scaleFactor.hsf,
      ));
}
