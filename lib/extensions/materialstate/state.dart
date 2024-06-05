import 'package:flutter/material.dart';

extension MaterialStateSet on Set<MaterialState> {
  bool get isPressed => contains(MaterialState.pressed);
}
