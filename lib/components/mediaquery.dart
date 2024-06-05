import 'package:flutter/material.dart';

class MQuery {
  BuildContext context;

  ({double hsf, double hmf, double wsf, double height, double width})
      get scaleFactor {
    return (
      hsf: heightscalefactor(),
      hmf: heigthmarginfactor(),
      wsf: widthScalefactor(),
      height: widthHeight()[1],
      width: widthHeight()[0],
    );
  }

  double heightscalefactor() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return (MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewPadding.top -
              MediaQuery.of(context).viewPadding.bottom) /
          667;
    } else {
      return 1.2;
    }
  }

  double heigthmarginfactor() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom) /
          667;
    } else {
      return 0.75;
    }
  }

  double widthScalefactor() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return (MediaQuery.of(context).size.width) / 375;
    } else {
      return (MediaQuery.of(context).size.height) / 375;
    }
  }

  List<double> widthHeight() {
    final double width = MediaQuery.of(context).size.width -
        MediaQuery.of(context).viewPadding.right -
        MediaQuery.of(context).viewPadding.left;
    final double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewPadding.top -
        MediaQuery.of(context).viewPadding.bottom;
    return [width, height];
  }

  MQuery({required this.context});
}
