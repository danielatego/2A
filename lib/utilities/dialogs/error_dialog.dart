import 'package:flutter/widgets.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: context.loc.generic_error_prompt,
    content: text,
    optionBuilder: () => {
      context.loc.ok: true,
    },
  );
}

Future changeContactCategory(
    BuildContext context, bool hometowork, bool? saycontactexists) {
  return showGenericDialog(
      context: context,
      title: context.loc.updateInfo,
      content: hometowork
          ? saycontactexists ?? false
              ? context.loc.hometowork
              : context.loc.hometowork2
          : saycontactexists ?? false
              ? context.loc.worktohome
              : context.loc.worktohome2,
      optionBuilder: () => {context.loc.ok: true, context.loc.cancel: false});
}

Future deleteContact(BuildContext context, String? deletemessage) {
  return showGenericDialog(
      context: context,
      title: context.loc.delete,
      content: (deletemessage != null) ? deletemessage : context.loc.deleteinfo,
      optionBuilder: () => {context.loc.ok: true, context.loc.cancel: false});
}

Future deleteAccount(BuildContext context, String? deletemessage) {
  return showGenericDialog(
      context: context,
      title: '${context.loc.delete} ${context.loc.account}?',
      content: (deletemessage != null) ? deletemessage : context.loc.deleteinfo,
      optionBuilder: () => {context.loc.ok: true, context.loc.cancel: false});
}

Future infoDialogwithOptions(BuildContext context, String message) {
  return showGenericDialog(
      context: context,
      title: context.loc.info,
      content: message,
      optionBuilder: () => {context.loc.ok: true, context.loc.cancel: false});
}

Future<void> infoDialog(
  BuildContext context,
  String titleText,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: titleText,
    content: text,
    optionBuilder: () => {
      context.loc.ok: true,
    },
  );
}
