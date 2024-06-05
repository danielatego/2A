// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/filledbutton.dart';
import 'package:two_a/components/mediaquery.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/components/textfield.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/firebase/authentication/fireauth.dart';
import 'package:two_a/main.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';

class ReathenticationView extends StatefulWidget {
  final VoidCallback logOut;
  final VoidCallback returnsFalseOnPop;
  final BuildContext profileContext;
  const ReathenticationView(
      {super.key,
      required this.logOut,
      required this.profileContext,
      required this.returnsFalseOnPop});

  @override
  State<ReathenticationView> createState() => _ReathenticationViewState();
}

class _ReathenticationViewState extends State<ReathenticationView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
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
    return Scaffold(
      appBar: CustomAppbar(
        deleteaccount: true,
        context: context,
        locTitle: context.loc.deleteaccount,
        tab: false,
        back: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
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
              Text(context.loc.while_we_could,
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
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, (mf * 90))),
              CustomFilledButton(
                delete: true,
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  if (await hasNetwork()) {
                    try {
                      await FireAuth().reauthenticateWithCredential(
                          email.trim(), password.trim());
                      Navigator.pop(context, true);
                    } catch (e) {
                      await showErrorDialog(
                          context, context.loc.invalidcredentials);
                      widget.logOut();
                      Navigator.pop(context, false);
                      Navigator.pop(widget.profileContext);
                    }
                  } else {
                    Navigator.pop(context, false);
                    await showErrorDialog(
                        context, context.loc.failedrequestinternet);
                  }
                },
                context: context,
                child: Text(context.loc.deleteaccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
