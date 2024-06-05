import 'package:flutter/material.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

enum Controllr { email, password }

class CustomTextField extends TextField {
  final TextEditingController controllerr;
  final BuildContext context;
  final bool isEmail;
  final String? hintText;

  @override
  TapRegionCallback? get onTapOutside => (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      };

  @override
  TextEditingController? get controller => controllerr;
  @override
  bool get obscureText => isEmail ? false : true;
  @override
  bool get enableSuggestions => false;
  @override
  TextInputType get keyboardType =>
      (isEmail ? TextInputType.emailAddress : TextInputType.visiblePassword);

  @override
  TextStyle? get style => CustomTextStyle(
      context: context,
      fontSz: 16,
      fontWght: Fontweight.w400,
      colour: FontColour.black,
      normalSpacing: true);
  @override
  int? get maxLines => 1;

  @override
  InputDecoration? get decoration => (InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 12.0 * context.scaleFactor.hsf,
          horizontal: 10.0 * context.scaleFactor.wsf,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(8.0 * context.scaleFactor.hsf)),
          borderSide:
              BorderSide(width: 1, color: const Colour().accessiblilityhint),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(8.0 * context.scaleFactor.hsf)),
          borderSide: BorderSide(width: 1, color: const Colour().lBorder2),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: const Colour().accessiblilityhint),
          borderRadius: BorderRadius.all(
            Radius.circular(
              8.0 * context.scaleFactor.hsf,
            ),
          ),
        ),
        hintText: isEmail
            ? context.loc.email_text_field_placeholder
            : hintText ?? context.loc.password_text_field_placeholder,
        hintStyle: CustomTextStyle(
            context: context,
            fontSz: 16,
            fontWght: Fontweight.w400,
            colour: FontColour.accessiblilityhint,
            normalSpacing: true),
      ));

  const CustomTextField(
      {super.key,
      required this.context,
      required this.isEmail,
      required this.controllerr,
      this.hintText});
}
