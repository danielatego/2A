// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:restart_app/restart_app.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:two_a/database/cloud/firebase_cloud_storage.dart';
import 'package:two_a/database/local/database_tables/online_userTable.dart';
import 'package:two_a/database/local/database_tables/user_table.dart';
import 'package:two_a/firebase/authentication/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/database/local/database_service.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/firebase/authentication/fireauth.dart';
import 'package:two_a/firebase/bloc/auth_bloc.dart';
import 'package:two_a/firebase/bloc/auth_event.dart';
import 'package:two_a/helpers/loading/loading_screen.dart';
import 'package:two_a/main.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';
import 'package:two_a/views/homepage_view.dart';
import 'package:two_a/views/profile/add_new_contact.dart';
import 'package:two_a/views/profile/view_contacts.dart';
import 'package:two_a/views/profile/view_edit_profile.dart';
import 'package:two_a/views/reauthenticate.dart';

class UserProfile extends StatefulWidget {
  final BuildContext contexti;
  final bool? onTutorial;
  final bool? addContactTutorial;

  const UserProfile(
      {super.key,
      required this.contexti,
      this.onTutorial,
      this.addContactTutorial});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();
  final GlobalKey _six = GlobalKey();
  bool hintsEnabled = true;
  late final LocalDatabaseService _databaseService;
  late final FirebaseCloudStorage _cloudService;
  String get userEmail => Service(FireAuth()).currentUser!.email;
  String get userId => Service(FireAuth()).currentUser!.id;
  String? path;
  BuildContext? myContext;
  @override
  void initState() {
    _databaseService = LocalDatabaseService();
    _cloudService = FirebaseCloudStorage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        widget.onTutorial ?? false
            ? widget.addContactTutorial ?? false
                ? ShowCaseWidget.of(myContext!).startShowCase([_one])
                : ShowCaseWidget.of(myContext!).startShowCase([_two])
            : null;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _databaseService;
    super.dispose();
  }

  @override
  Widget build(BuildContext context1) {
    final hsf = context.scaleFactor.hsf;
    final wsf = context.scaleFactor.wsf;
    final width = context.scaleFactor.width;
    final height = context.scaleFactor.height;
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBa = CustomAppbar(
      back: true,
      tab: false,
      context: context,
      locTitle: null,
      appBarRequired: true,
    );
    return FutureBuilder(
        future: Future.wait([
          _databaseService.getOnlineUser(id: userId),
          pathtoProfilePicture(userId),
          _databaseService.getUser(email: userEmail, id: userId)
        ]),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Scaffold(
                body: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      top: 0.38 * height,
                      child: Column(
                        children: [
                          Text(context.loc.pleasewaitamoment),
                          Padding(padding: EdgeInsets.only(bottom: 8 * hsf)),
                          const CircularProgressIndicator(),
                        ],
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: height - appBa.preferredSize.height,
                        width: width,
                        //color: const Colour().red,
                      ),
                    )
                  ],
                ),
              );
            case ConnectionState.done:
              OnlineUser onlineUser = snapshot.data![0] as OnlineUser;
              path = snapshot.data![1] as String;
              DatabaseUser databaseUser = snapshot.data![2] as DatabaseUser;
              try {
                File(path!).lengthSync();
              } on FileSystemException catch (e) {
                if (e.message == 'Cannot retrieve length of file') {
                  path = null;
                }
              }

              return ShowCaseWidget(
                disableBarrierInteraction: true,
                enableShowcase: widget.onTutorial ?? false,
                builder: Builder(
                  builder: (context) {
                    myContext = context;
                    return Scaffold(
                        appBar: appBa,
                        body: SingleChildScrollView(
                          child: Stack(
                            children: [
                              Positioned(
                                  top: isLandScape ? 6 * hsf : 6 * hsf,
                                  left: 0.085 * width +
                                      MediaQuery.of(context).viewPadding.left,
                                  child: SizedBox(
                                    height: 48 * hsf,
                                    child: Row(
                                      children: [
                                        Container(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          width: 48 * hsf,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 0.6,
                                                color: const Colour().black),
                                          ),
                                          child: path == null
                                              ? Icon(
                                                  Icons.person_rounded,
                                                  size: 40 * hsf,
                                                )
                                              : Image.file(
                                                  File(path!),
                                                  height: 150 * hsf,
                                                  width: 150 * hsf,
                                                  fit: BoxFit.fill,
                                                ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 0.064 * width)),
                                        Text(
                                          nameGeneratedFromEmail(
                                              onlineUser.accountEmail),
                                          style: CustomTextStyle(
                                              context: context,
                                              fontSz: 17,
                                              fontWght: Fontweight.w600,
                                              colour: FontColour.black,
                                              normalSpacing: true),
                                        ),
                                      ],
                                    ),
                                  )),
                              Positioned(
                                  top: isLandScape ? 86 * hsf : 86 * hsf,
                                  left: 0.117 * width +
                                      MediaQuery.of(context).viewPadding.left,
                                  child: Container(
                                    height: 24 * hsf,
                                    alignment: Alignment.center,
                                    child: TextButton.icon(
                                        style: TextButton.styleFrom(
                                            padding: const EdgeInsets.all(0)),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                  builder: (context) =>
                                                      ViewEditProfile(
                                                        onlineUser: onlineUser,
                                                        path: path,
                                                      )));
                                        },
                                        icon: Icon(
                                          Icons.account_circle,
                                          size: 24 * hsf,
                                          color: const Colour().black,
                                        ),
                                        label: Padding(
                                          padding:
                                              EdgeInsets.only(left: 16.0 * wsf),
                                          child: Text(context.loc.profile,
                                              style: CustomTextStyle(
                                                  context: context,
                                                  fontSz: 15,
                                                  fontWght: Fontweight.w400,
                                                  colour: FontColour.black,
                                                  normalSpacing: true)),
                                        )),
                                  )),
                              Positioned(
                                  top: isLandScape ? 134 * hsf : 134 * hsf,
                                  left: 0.117 * width +
                                      MediaQuery.of(context).viewPadding.left,
                                  child: Container(
                                    height: 24 * hsf,
                                    alignment: Alignment.center,
                                    child: TextButton.icon(
                                        style: TextButton.styleFrom(
                                            padding: const EdgeInsets.all(0)),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                  builder: (context) =>
                                                      const ViewContacts()));
                                        },
                                        icon: Icon(
                                          Icons.contact_page_rounded,
                                          size: 24 * hsf,
                                          color: const Colour().black,
                                        ),
                                        label: Padding(
                                          padding:
                                              EdgeInsets.only(left: 16.0 * wsf),
                                          child: Text(context.loc.contacts,
                                              style: CustomTextStyle(
                                                  context: context,
                                                  fontSz: 15,
                                                  fontWght: Fontweight.w400,
                                                  colour: FontColour.black,
                                                  normalSpacing: true)),
                                        )),
                                  )),
                              Positioned(
                                  top: isLandScape ? 182 * hsf : 182 * hsf,
                                  left: 0.117 * width +
                                      MediaQuery.of(context).viewPadding.left,
                                  child: Showcase(
                                    key: _one,
                                    description:
                                        'Tap here to add a 2A user to your contacts',
                                    disableBarrierInteraction: true,
                                    onTargetClick: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                              builder: (context) =>
                                                  AddNewContact(
                                                    onlineUser: onlineUser,
                                                    onTutorial: true,
                                                  )));
                                    },
                                    onToolTipClick: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                              builder: (context) =>
                                                  AddNewContact(
                                                    onlineUser: onlineUser,
                                                    onTutorial: true,
                                                  )));
                                    },
                                    disposeOnTap: true,
                                    child: Container(
                                      height: 24 * hsf,
                                      alignment: Alignment.center,
                                      child: TextButton.icon(
                                          style: TextButton.styleFrom(
                                              padding: const EdgeInsets.all(0)),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute<void>(
                                                    builder: (context) =>
                                                        AddNewContact(
                                                            onlineUser:
                                                                onlineUser)));
                                          },
                                          icon: Icon(
                                            Icons.person_add,
                                            size: 24 * hsf,
                                            color: const Colour().black,
                                          ),
                                          label: Padding(
                                            padding: EdgeInsets.only(
                                                left: 16.0 * wsf),
                                            child: Text(
                                                context.loc.addnewcontact,
                                                style: CustomTextStyle(
                                                    context: context,
                                                    fontSz: 15,
                                                    fontWght: Fontweight.w400,
                                                    colour: FontColour.black,
                                                    normalSpacing: true)),
                                          )),
                                    ),
                                  )),
                              Positioned(
                                  top: isLandScape ? 278 * hsf : 278 * hsf,
                                  left: 0.117 * width +
                                      MediaQuery.of(context).viewPadding.left,
                                  child: Container(
                                    height: 24 * hsf,
                                    alignment: Alignment.center,
                                    child: TextButton.icon(
                                        style: TextButton.styleFrom(
                                            padding: const EdgeInsets.all(0)),
                                        onPressed: () {
                                          widget.contexti.read<AuthBloc>().add(
                                                const AuthEventLogOut(),
                                              );
                                          Navigator.of(context).pop();
                                          //Navigator.of(context).pop();
                                        },
                                        icon: Icon(
                                          Icons.logout,
                                          size: 24 * hsf,
                                          color: const Colour().black,
                                        ),
                                        label: Padding(
                                          padding:
                                              EdgeInsets.only(left: 16.0 * wsf),
                                          child: Text(context.loc.logout,
                                              style: CustomTextStyle(
                                                  context: context,
                                                  fontSz: 15,
                                                  fontWght: Fontweight.w400,
                                                  colour: FontColour.black,
                                                  normalSpacing: true)),
                                        )),
                                  )),
                              Positioned(
                                  top: isLandScape ? 230 * hsf : 230 * hsf,
                                  left: 0.117 * width +
                                      MediaQuery.of(context).viewPadding.left,
                                  child: Showcase(
                                    key: _two,
                                    description:
                                        'Learn about the calendar 🗓️.',
                                    disposeOnTap: true,
                                    onTargetClick: () {
                                      //Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                              builder: (context) => LandingPage(
                                                    user: databaseUser,
                                                    onTutorial: true,
                                                  )));
                                    },
                                    onToolTipClick: () {
                                      //Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                              builder: (context) => LandingPage(
                                                    user: databaseUser,
                                                    onTutorial: true,
                                                  )));
                                    },
                                    child: Container(
                                      height: 24 * hsf,
                                      alignment: Alignment.center,
                                      child: TextButton.icon(
                                          style: TextButton.styleFrom(
                                              padding: const EdgeInsets.all(0)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute<void>(
                                                    builder: (context) =>
                                                        LandingPage(
                                                          user: databaseUser,
                                                        )));
                                          },
                                          icon: Icon(
                                            Icons.calendar_month_rounded,
                                            size: 24 * hsf,
                                            color: const Colour().black,
                                          ),
                                          label: Padding(
                                            padding: EdgeInsets.only(
                                                left: 16.0 * wsf),
                                            child: Text(context.loc.calendar,
                                                style: CustomTextStyle(
                                                    context: context,
                                                    fontSz: 15,
                                                    fontWght: Fontweight.w400,
                                                    colour: FontColour.black,
                                                    normalSpacing: true)),
                                          )),
                                    ),
                                  )),
                              Positioned(
                                  top: isLandScape ? 326 * hsf : 326 * hsf,
                                  left: 0.117 * width +
                                      MediaQuery.of(context).viewPadding.left,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 24 * hsf,
                                        alignment: Alignment.center,
                                        child: TextButton.icon(
                                            style: TextButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(0)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                      builder: (context) =>
                                                          ViewEditProfile(
                                                            onlineUser:
                                                                onlineUser,
                                                            path: path,
                                                          )));
                                            },
                                            icon: Icon(
                                              Icons.info,
                                              size: 24 * hsf,
                                              color: const Colour().black,
                                            ),
                                            label: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16.0 * wsf),
                                              child: Text(context.loc.hints,
                                                  style: CustomTextStyle(
                                                      context: context,
                                                      fontSz: 15,
                                                      fontWght: Fontweight.w400,
                                                      colour: FontColour.black,
                                                      normalSpacing: true)),
                                            )),
                                      ),
                                      Padding(
                                          padding:
                                              EdgeInsets.only(left: 16 * hsf)),
                                      Row(
                                        children: [
                                          Material(
                                            child: InkWell(
                                              onTap: databaseUser.hintsEnabled
                                                  ? null
                                                  : () async {
                                                      final result =
                                                          await infoDialogwithOptions(
                                                              context,
                                                              context.loc
                                                                  .effectchanges);
                                                      if (result == true) {
                                                        await _databaseService
                                                            .updateUser(
                                                                databaseUser:
                                                                    databaseUser,
                                                                hintsEnabled:
                                                                    true);
                                                        Restart.restartApp();
                                                      } else {
                                                        return;
                                                      }
                                                    },
                                              child: Container(
                                                height: 24 * hsf,
                                                width: 40 * wsf,
                                                decoration: BoxDecoration(
                                                    color: databaseUser
                                                            .hintsEnabled
                                                        ? const Colour().purple
                                                        : const Colour().lHint2,
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            topLeft: Radius
                                                                .circular(
                                                                    16 * hsf),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    16 * hsf))),
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: const Colour().white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Material(
                                            child: InkWell(
                                              onTap: databaseUser.hintsEnabled
                                                  ? () async {
                                                      final result =
                                                          await infoDialogwithOptions(
                                                              context,
                                                              context.loc
                                                                  .effectchanges);
                                                      if (result == true) {
                                                        await _databaseService
                                                            .updateUser(
                                                                databaseUser:
                                                                    databaseUser,
                                                                hintsEnabled:
                                                                    false);
                                                        Restart.restartApp();
                                                      } else {
                                                        return;
                                                      }
                                                    }
                                                  : null,
                                              child: Container(
                                                height: 24 * hsf,
                                                width: 40 * wsf,
                                                decoration: BoxDecoration(
                                                    color: databaseUser
                                                            .hintsEnabled
                                                        ? const Colour().lHint2
                                                        : const Colour().purple,
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            topRight: Radius
                                                                .circular(
                                                                    16 * hsf),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    16 * hsf))),
                                                child: Icon(
                                                  Icons.cancel,
                                                  color: const Colour().white,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                              Positioned(
                                  top: isLandScape ? 374 * hsf : 374 * hsf,
                                  left: 0.117 * width +
                                      MediaQuery.of(context).viewPadding.left,
                                  child: Container(
                                    height: 24 * hsf,
                                    alignment: Alignment.center,
                                    child: TextButton.icon(
                                        style: TextButton.styleFrom(
                                            padding: const EdgeInsets.all(0)),
                                        onPressed: () async {
                                          bool proceed = await deleteAccount(
                                              context, context.loc.eraseall);
                                          if (proceed) {
                                            if (await hasNetwork()) {
                                              final result =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReathenticationView(
                                                    logOut: () {
                                                      widget.contexti
                                                          .read<AuthBloc>()
                                                          .add(
                                                            const AuthEventLogOut(),
                                                          );
                                                    },
                                                    profileContext: context1,
                                                    returnsFalseOnPop: () {
                                                      Navigator.pop(
                                                          context, false);
                                                    },
                                                  ),
                                                ),
                                              );
                                              if (result == true) {
                                                LoadingScreen().show(
                                                    context: context,
                                                    text: context
                                                        .loc.pleasewaitamoment);

                                                //profile picture deletion
                                                try {
                                                  final storageRef =
                                                      FirebaseStorage.instance
                                                          .ref();
                                                  final onlineprofpic =
                                                      storageRef.child(
                                                          "images/profilepictures/$userId.jpg");
                                                  await onlineprofpic
                                                      .getMetadata();
                                                  await onlineprofpic.delete();
                                                  File(await pathtoProfilePicture(
                                                          userId))
                                                      .delete();
                                                } catch (e) {
                                                  //throw CouldNotDeleteCloudLocalProfilePicException();
                                                  null;
                                                }
                                                if (await _cloudService
                                                    .cloudUserExists(
                                                        cloudUserId: userId)) {
                                                  final user =
                                                      await _cloudService
                                                          .getcloudUser(
                                                              cloudUserId:
                                                                  userId);
                                                  await _cloudService
                                                      .deleteCloudUser(
                                                          cloudUserid:
                                                              user!.documentId);
                                                }
                                                //delete online user and database user
                                                await _databaseService
                                                    .deleteUser(
                                                        email: userEmail);
                                                await _databaseService
                                                    .deleteOnlineUser(
                                                        email: userEmail);
                                                await FireAuth().delete(() {
                                                  widget.contexti
                                                      .read<AuthBloc>()
                                                      .add(
                                                        const AuthEventLogOut(),
                                                      );
                                                });
                                                Navigator.pop(context1);
                                                LoadingScreen().hide();
                                              }
                                            } else {
                                              await showErrorDialog(
                                                  context,
                                                  context.loc
                                                      .accountdelfailedinternet);
                                            }
                                          }
                                        },
                                        icon: Icon(
                                          Icons.delete_forever_outlined,
                                          size: 24 * hsf,
                                          color: const Colour().red,
                                        ),
                                        label: Padding(
                                          padding:
                                              EdgeInsets.only(left: 16.0 * wsf),
                                          child: Text(
                                              context.loc.deletemyaccount,
                                              style: CustomTextStyle(
                                                  context: context,
                                                  fontSz: 15,
                                                  fontWght: Fontweight.w400,
                                                  colour: FontColour.red,
                                                  normalSpacing: true)),
                                        )),
                                  )),
                              Center(
                                child: SizedBox(
                                  height: !isLandScape
                                      ? height - appBa.preferredSize.height
                                      : width - appBa.preferredSize.height,
                                ),
                              ),
                            ],
                          ),
                        ));
                  },
                ),
              );
            default:
              return Container();
          }
        });
  }
}

String nameGeneratedFromEmail(String email) {
  int index = email.indexOf(RegExp(r'@'));
  var name = email.substring(0, index);
  bool startsWithLetter =
      name.startsWith(RegExp(r'[A-Z][a-z]', caseSensitive: false));
  return startsWithLetter ? name[0].toUpperCase() + name.substring(1) : name;
}
