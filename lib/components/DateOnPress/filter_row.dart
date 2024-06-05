import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

class FilterRow extends StatelessWidget {
  final bool active;
  final String text;
  final int count;
  const FilterRow(
      {super.key,
      required this.text,
      required this.active,
      required this.count});

  @override
  Widget build(BuildContext context) {
    final wsf = context.scaleFactor.wsf;
    final hsf = context.scaleFactor.hsf;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 50 * hsf),
          child: Text(
            text,
            softWrap: true,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: CustomTextStyle(
                context: context,
                fontSz: 13,
                fontWght: Fontweight.w500,
                colour: active ? FontColour.black : FontColour.hintblack,
                normalSpacing: true),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5 * wsf),
        ),
        Container(
          height: 16 * hsf,
          width: 20 * hsf,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: active ? const Colour().black : const Colour().lHint,
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            overflow: TextOverflow.ellipsis,
            count.toString(),
            style: CustomTextStyle(
                context: context,
                fontSz: 10,
                fontWght: Fontweight.w500,
                colour: FontColour.white,
                normalSpacing: true),
          ),
        )
      ],
    );
  }
}

class FilterRowPrimary extends StatelessWidget {
  final bool active;
  final double boxwidth;
  final String text;
  final bool? isHome;
  final int count;
  const FilterRowPrimary(
      {super.key,
      required this.boxwidth,
      required this.text,
      required this.active,
      required this.count,
      this.isHome});

  @override
  Widget build(BuildContext context) {
    final wsf = context.scaleFactor.wsf;
    final hsf = context.scaleFactor.hsf;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.center,
          height: 48 * hsf,
          width: boxwidth,
          child: Text(
            text,
            softWrap: true,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyle(
                context: context,
                fontSz: 12,
                fontWght: Fontweight.w500,
                colour: active
                    ? isHome ?? true
                        ? FontColour.primary
                        : FontColour.green
                    : FontColour.hintblack,
                normalSpacing: true),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 4 * wsf),
        ),
        Container(
          padding: const EdgeInsets.all(0),
          height: 14 * hsf,
          width: 18 * hsf,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: active
                  ? isHome ?? true
                      ? const Colour().primary
                      : const Colour().green
                  : const Colour().lHint,
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            overflow: TextOverflow.ellipsis,
            count == 0 ? '' : count.toString(),
            style: CustomTextStyle(
                context: context,
                fontSz: 10,
                fontWght: Fontweight.w500,
                colour: FontColour.white,
                normalSpacing: true),
          ),
        )
      ],
    );
  }
}
