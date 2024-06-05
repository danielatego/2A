import 'package:flutter/material.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

class TitleTextField extends StatefulWidget {
  final TextEditingController titleController;
  final String? text;
  const TitleTextField({super.key, required this.titleController, this.text});

  String get titleText => titleController.text;

  @override
  State<TitleTextField> createState() => _TitleTextFieldState();
}

class _TitleTextFieldState extends State<TitleTextField> {
  @override
  void initState() {
    if (widget.text != null) {
      widget.titleController.text = widget.text ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = context.scaleFactor.width;
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SizedBox(
        height: 85,
        width: .904 * width,
        child: TextField(
          onTapOutside: (event) =>
              {FocusManager.instance.primaryFocus?.unfocus()},
          controller: widget.titleController,
          maxLength: 44,
          maxLines: isLandScape ? 1 : 2,
          style: CustomTextStyle(
              context: context,
              fontSz: 27.41,
              fontWght: Fontweight.w400,
              colour: FontColour.buttonblack,
              normalSpacing: false),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: const EdgeInsets.all(0),
            border: InputBorder.none,
            hintText: context.loc.title,
            hintStyle: CustomTextStyle(
                context: context,
                fontSz: 27.41,
                fontWght: Fontweight.w400,
                colour: FontColour.accessiblilityhint,
                normalSpacing: true),
            //border: OutlineInputBorder()
          ),
        ));
  }
}
