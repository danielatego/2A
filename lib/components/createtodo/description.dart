import 'package:flutter/material.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

class Description extends StatefulWidget {
  final TextEditingController controller;
  final String? text;
  final bool? isDescription;
  final double? height;
  final bool? readOnly;
  const Description(
      {super.key,
      required this.controller,
      required this.text,
      this.height,
      this.isDescription,
      this.readOnly});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  void initState() {
    if (widget.text != null) {
      widget.controller.text = widget.text ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hsf = context.scaleFactor.hsf;
    final width = context.scaleFactor.width;
    final height = context.scaleFactor.height;

    return Container(
      height: widget.height ?? 90 * hsf,
      width: 0.901 * width,
      decoration: BoxDecoration(
        color: const Colour().lHint2,
        borderRadius: BorderRadius.all(Radius.circular(8.0 * hsf)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.0 * hsf, top: 12 * hsf),
            child: Image.asset(
              'images/description/description.png',
              height: 20 * context.scaleFactor.hsf,
              width: 20.67 * context.scaleFactor.hsf,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
              padding:
                  EdgeInsets.only(left: 0.05 * width, top: 0.001 * height)),
          SizedBox(
            width: 0.65 * width,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(0),
              child: TextField(
                onTapOutside: (event) =>
                    {FocusManager.instance.primaryFocus?.unfocus()},
                controller: widget.controller,
                scrollPadding: const EdgeInsets.all(0),
                style: CustomTextStyle(
                    context: context,
                    fontSz: 15.0,
                    fontWght: Fontweight.w400,
                    colour: FontColour.black,
                    normalSpacing: true),
                readOnly: widget.readOnly ?? false,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.isDescription ?? true
                      ? context.loc.description
                      : context.loc.account,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
