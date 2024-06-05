import 'package:flutter/material.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

enum Fontweight { w100, w200, w300, w400, w500, w600, w700 }

enum FontColour {
  accessiblilityhint,
  black,
  blackhintbtw,
  hintblack,
  buttonblack,
  backgroundColor,
  white,
  red,
  purple,
  green,
  primary
}

class CustomTextStyle extends TextStyle {
  final BuildContext context;
  final double fontSz;
  final Fontweight? fontWght;
  final FontColour? colour;
  final bool? normalSpacing;
  final bool? lineThrough;

  @override
  // TODO: implement decoration
  TextDecoration? get decoration =>
      lineThrough ?? false ? TextDecoration.lineThrough : null;

  @override
  double? get letterSpacing => normalSpacing ?? true ? super.letterSpacing : -2;

  @override
  double? get height => 1.0741;
  @override
  FontWeight get fontWeight => fweight();

  FontWeight fweight() {
    switch (fontWght) {
      case Fontweight.w100:
        return FontWeight.w100;
      case Fontweight.w200:
        return FontWeight.w200;
      case Fontweight.w300:
        return FontWeight.w300;
      case Fontweight.w500:
        return FontWeight.w500;
      case Fontweight.w600:
        return FontWeight.w600;
      case Fontweight.w700:
        return FontWeight.w700;
      default:
        return FontWeight.w400;
    }
  }

  @override
  Color? get color => fontcolour();

  Color fontcolour() {
    switch (colour) {
      case FontColour.purple:
        return const Colour().purple;
      case FontColour.black:
        return const Colour().black;
      case FontColour.buttonblack:
        return const Colour().bhbtw;
      case FontColour.blackhintbtw:
        return const Colour().lBorder;
      case FontColour.hintblack:
        return const Colour().lHint;
      case FontColour.backgroundColor:
        return const Colour().lbg;
      case FontColour.white:
        return const Colour().white;
      case FontColour.red:
        return const Colour().red;
      case FontColour.primary:
        return const Colour().primary;
      case FontColour.green:
        return const Colour().green;
      case FontColour.accessiblilityhint:
        return const Colour().accessiblilityhint;

      default:
        return const Colour().black;
    }
  }

  @override
  double? get fontSize => fontSz * context.scaleFactor.wsf;

  const CustomTextStyle(
      {required this.context,
      required this.fontSz,
      this.fontWght,
      this.colour,
      this.lineThrough,
      this.normalSpacing});

  @override
  String? get fontFamily => 'Roboto';
}
