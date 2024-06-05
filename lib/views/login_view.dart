// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/filledbutton.dart';
import 'package:two_a/components/mediaquery.dart';
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

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool hide = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MQuery(context: context);
    final sf = media.heightscalefactor();
    final mf = media.heigthmarginfactor();
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is WrongDetailsAuthException) {
            setState(() {
              hide = true;
            });
            await showErrorDialog(
                context, context.loc.login_error_cannot_find_user);
            setState(() {
              hide = false;
            });
          } else if (state.exception is InvalidEmailAuthException) {
            setState(() {
              hide = true;
            });
            await showErrorDialog(
              context,
              context.loc.login_error_wrong_credentials,
            );
            setState(() {
              hide = false;
            });
          } else if (state.exception is AccountDisabledAuthException) {
            setState(() {
              hide = true;
            });
            await showErrorDialog(context, context.loc.account_disable);
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
          locTitle: hide ? ' ' : context.loc.login,
          tab: false,
          back: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, (36 * mf), 0, 0),
            child: Column(
              children: [
                Image.asset(
                  'images/logo/logo1.png',
                  height: 64 * sf,
                  width: 64 * sf,
                  fit: BoxFit.cover,
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 16))),
                Text(hide ? "" : context.loc.while_we_can,
                    style: CustomTextStyle(
                        context: context,
                        fontSz: 16,
                        fontWght: Fontweight.w200,
                        colour: FontColour.black,
                        normalSpacing: true)),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 120))),
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
                CustomFilledButton(
                  onPressed: () async {
                    if (await hasNetwork()) {
                      final email = _email.text;
                      final password = _password.text;
                      context.read<AuthBloc>().add(
                            AuthEventLogin(email.trim(), password.trim()),
                          );
                    } else {
                      setState(() {
                        hide = true;
                      });
                      await showErrorDialog(
                          context, context.loc.failedrequestinternet);
                    }
                    setState(() {
                      hide = false;
                    });
                  },
                  context: context,
                  child: Text(hide ? "" : context.loc.letmein),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 120))),
                Center(
                  child: SizedBox(
                    width: 0.96 * context.scaleFactor.width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 0.44 * context.scaleFactor.width,
                            child: CustomTextButton(
                              context: context,
                              onPressed: () async {
                                context.read<AuthBloc>().add(
                                      const AuthEventShouldRegister(),
                                    );
                              },
                              child: Text(
                                hide ? "" : context.loc.sign_up_instead,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 0.44 * context.scaleFactor.width,
                            child: CustomTextButton(
                              context: context,
                              onPressed: () async {
                                context.read<AuthBloc>().add(
                                      const AuthEventForgotPassword(
                                          email: null),
                                    );
                              },
                              child: Text(
                                hide ? "" : context.loc.forgot_password,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
