// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/filledbutton.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/components/textbutton.dart';
import 'package:two_a/components/textfield.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/firebase/bloc/auth_bloc.dart';
import 'package:two_a/firebase/bloc/auth_event.dart';
import 'package:two_a/firebase/bloc/auth_state.dart';
import 'package:two_a/main.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _email;
  bool hide = false;

  @override
  void initState() {
    _email = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sf = context.scaleFactor.hsf;
    final mf = context.scaleFactor.hmf;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _email.clear();
            setState(() {
              hide = true;
            });
            await infoDialog(
                context, context.loc.success, context.loc.passwordlinksent);
            setState(() {
              hide = false;
            });
          }
          if (state.exception != null) {
            setState(() {
              hide = true;
            });
            await showErrorDialog(context, context.loc.generic_error_prompt1);
            setState(() {
              hide = false;
            });
          }
        }
      },
      child: Scaffold(
        appBar: CustomAppbar(
          context: context,
          locTitle: hide ? ' ' : context.loc.reset_password,
          tab: false,
          back: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 36 * mf, 0, 0),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'images/logo/logo1.png',
                  height: 64 * sf,
                  width: 64 * sf,
                  fit: BoxFit.cover,
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 16))),
                Text(
                  hide ? ' ' : context.loc.while_we_can,
                  style: CustomTextStyle(
                      context: context,
                      fontSz: 16,
                      fontWght: Fontweight.w200,
                      colour: FontColour.black,
                      normalSpacing: true),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 68.5))),
                SizedBox(
                  width: 0.716 * context.scaleFactor.width,
                  child: Text(
                    hide ? ' ' : context.loc.forgot_message,
                    style: CustomTextStyle(
                        context: context,
                        fontSz: 16,
                        fontWght: Fontweight.w400,
                        colour: FontColour.black,
                        normalSpacing: true),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 36))),
                SizedBox(
                  width: 0.64 * context.scaleFactor.width,
                  child: CustomTextField(
                    context: context,
                    isEmail: true,
                    controllerr: _email,
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 36))),
                CustomFilledButton(
                  context: context,
                  onPressed: () async {
                    if (await hasNetwork()) {
                      context.read<AuthBloc>().add(
                          AuthEventForgotPassword(email: _email.text.trim()));
                    } else {
                      setState(() {
                        hide = true;
                      });
                      await showErrorDialog(
                          context, context.loc.failedrequestinternet);
                      setState(() {
                        hide = false;
                      });
                    }
                  },
                  child: Text(hide ? ' ' : context.loc.resetmypassword),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 134))),
                SizedBox(
                  width: 0.96 * context.scaleFactor.width,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextButton(
                          context: context,
                          onPressed: () async {
                            context.read<AuthBloc>().add(
                                  const AuthEventLogOut(),
                                );
                          },
                          child: Text(hide ? ' ' : context.loc.login_q),
                        ),
                        CustomTextButton(
                          context: context,
                          onPressed: () async {
                            context.read<AuthBloc>().add(
                                  const AuthEventShouldRegister(),
                                );
                          },
                          child: Text(hide ? ' ' : context.loc.sign_upq),
                        )
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
