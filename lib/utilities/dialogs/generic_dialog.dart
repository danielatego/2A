import 'package:flutter/material.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog(
      barrierLabel: 'barrier',
      barrierColor: const Colour().lbg,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(16 * context.scaleFactor.hsf)),
          content: Text(content),
          actions: options.keys.map((optionTitle) {
            final value = options[optionTitle];
            return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop;
                }
              },
              child: Text(optionTitle),
            );
          }).toList(),
        );
      });
}
