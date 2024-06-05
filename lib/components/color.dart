import 'package:flutter/material.dart';

class Colour {
  final Color accessiblilityhint = const Color(0xff707070);
  final Color appBg = const Color(0XFF034565);
  final Color black = const Color(0XFF000000);
  final Color lBorder = const Color(0XFF838383);
  final Color lBorder2 = const Color(0XFF0570C6);
  final Color lHint = const Color(0XFF808080);
  final Color bhbtw = const Color(0xFF4C4C4C);
  final Color lbg = const Color(0XFFF5F5F5);
  final Color primary = const Color(0XFF0BAADA);
  final Color white = const Color(0XFFFFFFFF);
  final Color red = const Color(0xFFFF2D2D);
  final Color lHint2 = const Color(0xFFD9D9D9);
  final Color green = const Color(0xFF4DDA0B);
  final Color purple = const Color(0xFF9747FF);
  final Color amber = const Color(0xFFFFC107);

  const Colour();

  ({
    Color accessiblilityhint,
    Color appBg,
    Color lbg,
    Color black,
    Color lBorder,
    Color lBorder2,
    Color bhbtw,
    Color lHint,
    Color primary,
    Color white,
    Color lHint2,
    Color red,
    Color green,
    Color purple,
    Color amber,
  }) get color {
    final Color accessiblilityhint = this.accessiblilityhint;
    final Color appBg = this.appBg;
    final Color black = this.black;
    final Color lBorder = this.lBorder;
    final Color lBorder2 = this.lBorder2;
    final Color bhbtw = this.bhbtw;
    final Color lHint = this.black;
    final Color lbg = this.lbg;
    final Color primary = this.primary;
    final Color white = this.white;
    final Color lHint2 = this.lHint2;
    final Color red = this.red;
    final Color green = this.green;
    final Color purple = this.purple;
    final Color amber = this.amber;
    return (
      accessiblilityhint: accessiblilityhint,
      appBg: appBg,
      black: black,
      lBorder: lBorder,
      lBorder2: lBorder2,
      bhbtw: bhbtw,
      lHint: lHint,
      lbg: lbg,
      primary: primary,
      white: white,
      lHint2: lHint2,
      red: red,
      green: green,
      purple: purple,
      amber: amber,
    );
  }
}
