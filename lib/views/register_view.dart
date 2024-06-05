// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/filledbutton.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/components/textbutton.dart';
import 'package:two_a/components/textfield.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/firebase/authentication/exceptions.dart';
import 'package:two_a/firebase/bloc/auth_bloc.dart';
import 'package:two_a/firebase/bloc/auth_event.dart';
import 'package:two_a/firebase/bloc/auth_state.dart';
import 'package:two_a/main.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  bool hide = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sf = context.scaleFactor.hsf;
    final mf = context.scaleFactor.hmf;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            setState(() {
              hide = true;
            });
            await showErrorDialog(context, context.loc.weak_password);
            setState(() {
              hide = false;
            });
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            setState(() {
              hide = true;
            });
            await showErrorDialog(context, context.loc.email_already_in_use);
            setState(() {
              hide = false;
            });
          } else if (state.exception is InvalidEmailAuthException) {
            setState(() {
              hide = true;
            });
            await showErrorDialog(context, context.loc.invalid_email);
            setState(() {
              hide = false;
            });
          } else if (state.exception is GenericAuthException) {
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
            locTitle: hide ? "" : context.loc.sign_up,
            tab: false,
            back: false,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 36 * mf, 0, 0),
            child: Center(
              child: Column(children: [
                Image.asset(
                  'images/logo/logo1.png',
                  height: 64 * sf,
                  width: 64 * sf,
                  fit: BoxFit.cover,
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 16))),
                Text(
                  hide ? "" : context.loc.while_we_can,
                  style: CustomTextStyle(
                      context: context,
                      fontSz: 16,
                      fontWght: Fontweight.w200,
                      colour: FontColour.black,
                      normalSpacing: true),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 85))),
                SizedBox(
                  width: 0.64 * context.scaleFactor.width,
                  child: CustomTextField(
                    context: context,
                    isEmail: true,
                    controllerr: _email,
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 24))),
                SizedBox(
                  width: 0.64 * context.scaleFactor.width,
                  child: CustomTextField(
                    context: context,
                    isEmail: false,
                    controllerr: _password,
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 24))),
                SizedBox(
                  width: 0.64 * context.scaleFactor.width,
                  child: CustomTextField(
                    context: context,
                    isEmail: false,
                    controllerr: _confirmPassword,
                    hintText: context.loc.confirm_password,
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 24))),
                CustomFilledButton(
                  context: context,
                  onPressed: () async {
                    if (await hasNetwork()) {
                      final email = _email.text;
                      final password = _password.text;
                      if (_password.text == _confirmPassword.text) {
                        context.read<AuthBloc>().add(
                              AuthEventRegister(email, password),
                            );
                      } else {
                        setState(() {
                          hide = true;
                        });
                        await showErrorDialog(
                            context, context.loc.password_mismatch);
                        setState(() {
                          hide = false;
                        });
                      }
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
                  child: Text(hide ? "" : context.loc.signmeup),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 88))),
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
                          child: Text(hide ? "" : context.loc.login_instead),
                        ),
                        CustomTextButton(
                          context: context,
                          onPressed: () async {
                            context.read<AuthBloc>().add(
                                  const AuthEventForgotPassword(email: null),
                                );
                          },
                          child: Text(hide ? "" : context.loc.forgot_password),
                        )
                      ]),
                ),
              ]),
            ),
          )),
    );
  }
}
