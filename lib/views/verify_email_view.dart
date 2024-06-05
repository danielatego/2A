import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/filledbutton.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/components/textbutton.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/firebase/bloc/auth_bloc.dart';
import 'package:two_a/firebase/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    final sf = context.scaleFactor.hsf;
    final mf = context.scaleFactor.hmf;
    return Scaffold(
      appBar: CustomAppbar(
        context: context,
        locTitle: context.loc.verify_email,
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
                context.loc.while_we_can,
                style: CustomTextStyle(
                    context: context,
                    fontSz: 16,
                    fontWght: Fontweight.w200,
                    colour: FontColour.black,
                    normalSpacing: true),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 36))),
              SizedBox(
                width: 0.716 * context.scaleFactor.width,
                child: Text(
                  context.loc.verify_message,
                  style: CustomTextStyle(
                      context: context,
                      fontSz: 16,
                      fontWght: Fontweight.w400,
                      colour: FontColour.black,
                      normalSpacing: true),
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 72))),
              CustomFilledButton(
                context: context,
                onPressed: () {
                  context
                      .read<AuthBloc>()
                      .add(const AuthEventSendEmailVerification());
                },
                child: Text(context.loc.resend_link),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 116))),
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
                        child: Text(
                          context.loc.login_q,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      CustomTextButton(
                        context: context,
                        onPressed: () async {
                          context
                              .read<AuthBloc>()
                              .add(const AuthEventShouldRegister());
                        },
                        child: Text(
                          context.loc.sign_upq,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
