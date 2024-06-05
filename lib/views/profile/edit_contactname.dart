// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/cloudOnlineprofile/contact.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/database/cloud/cloud_user.dart';
import 'package:two_a/database/local/database_tables/online_userTable.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/helpers/loading/loading_screen.dart';
import 'package:two_a/main.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';
import 'package:two_a/views/profile/user_profile.dart';

class EditContactToSave extends StatefulWidget {
  final CloudUser? userToAdd;
  final bool? onTutorial;
  final String? name;
  final String? contactFile;
  final OnlineUser? usertoUpdate;
  final bool addtoHome;
  final bool? update;
  const EditContactToSave(
      {super.key,
      required this.userToAdd,
      required this.addtoHome,
      this.update,
      this.usertoUpdate,
      this.name,
      this.contactFile,
      this.onTutorial});

  @override
  State<EditContactToSave> createState() => _EditContactToSaveState();
}

class _EditContactToSaveState extends State<EditContactToSave> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();
  final TextEditingController contactName = TextEditingController();
  late FocusNode myfocusNode;
  late Contact _contact;
  BuildContext? myContext;

  @override
  void initState() {
    contactName.text = widget.name ??
        nameGeneratedFromEmail(widget.userToAdd?.accountEmail ??
            widget.usertoUpdate!.accountEmail);
    _contact = Contact();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        ShowCaseWidget.of(myContext!).startShowCase([_one]);
      });
    });
    super.initState();
    myfocusNode = FocusNode();
  }

  @override
  void dispose() {
    contactName.dispose();
    _contact;
    myfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String path = widget.contactFile ?? '';
    final hsf = context.scaleFactor.hsf;
    final wsf = context.scaleFactor.wsf;
    final width = context.scaleFactor.width;
    final height = context.scaleFactor.height;
    final hmf = context.scaleFactor.hmf;
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBa = CustomAppbar(
      back: true,
      tab: false,
      context: context,
      locTitle: null,
      appBarRequired: true,
    );
    return ShowCaseWidget(
      disableBarrierInteraction: true,
      enableShowcase: widget.onTutorial ?? false,
      builder: Builder(builder: (context) {
        myContext = context;
        return Scaffold(
          appBar: appBa,
          body: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                    top: isLandScape ? 6 * hsf : 6 * hsf,
                    //left: 0.085 * width - MediaQuery.of(context).viewPadding.left,
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      width: 150 * hsf,
                      height: 150 * hsf,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(width: 0.6, color: const Colour().lHint),
                      ),
                      child: widget.usertoUpdate == null
                          ? widget.userToAdd?.profilePicture?.isEmpty ?? true
                              ? Icon(
                                  Icons.person_rounded,
                                  size: 132 * hsf,
                                )
                              : Image.network(
                                  widget.userToAdd!.profilePicture!,
                                  fit: BoxFit.fill,
                                )
                          : widget.contactFile == null
                              ? Icon(
                                  Icons.person_rounded,
                                  size: 132 * hsf,
                                )
                              : Image.file(
                                  File(path),
                                  height: 150 * hsf,
                                  width: 150 * hsf,
                                  fit: BoxFit.fill,
                                ),
                      // Image.network(
                      //     widget.usertoUpdate!.profilePicture!,
                      //     fit: BoxFit.fill,
                      //   )
                    )),
                Positioned(
                  top: isLandScape ? 177 * hsf : 177 * hsf,
                  left: 0.109 * width + MediaQuery.of(context).viewPadding.left,
                  child: Container(
                      height: 46 * hsf,
                      width: 0.781 * width,
                      //color: const Colour().bhbtw,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.account_circle,
                                size: 24 * hsf,
                                color: const Colour().black,
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(right: 0.064 * width)),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.loc.editContactName,
                                    style: CustomTextStyle(
                                        context: context,
                                        fontSz: 15,
                                        fontWght: Fontweight.w400,
                                        colour: FontColour.hintblack,
                                        normalSpacing: true),
                                  ),
                                  Showcase(
                                    key: _one,
                                    description:
                                        'The text you type here will be the contact name\nExcuse my vanity💁🏾 and brilliance🤓\nLemme come up with something else\nTap to see👀 and continue',
                                    onTargetClick: () {
                                      setState(() {
                                        contactName.text = '2A_was_here';
                                      });
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_two]);
                                    },
                                    onToolTipClick: () {
                                      setState(() {
                                        contactName.text = '2A_was_here';
                                      });
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_two]);
                                    },
                                    disposeOnTap: false,
                                    child: SizedBox(
                                        width: 147 * hsf,
                                        child: TextField(
                                          focusNode: myfocusNode,
                                          style: CustomTextStyle(
                                              context: context,
                                              fontSz: 16,
                                              fontWght: Fontweight.w500,
                                              colour: FontColour.black,
                                              normalSpacing: true),
                                          controller: contactName,
                                          decoration: (InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 4 * hsf),
                                          )),
                                          onTapOutside: (event) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                        )),
                                  )
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                myfocusNode.requestFocus();
                              },
                              icon: const Icon(
                                Icons.edit,
                              ))
                        ],
                      )),
                ),
                Positioned(
                  top: isLandScape ? 258 * hsf : 258 * hsf,
                  left: 0.109 * width + MediaQuery.of(context).viewPadding.left,
                  child: Container(
                      height: 40 * hsf,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Icon(
                            Icons.markunread_outlined,
                            size: 24 * hsf,
                            color: const Colour().black,
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 0.064 * width)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.loc.contactEmail,
                                style: CustomTextStyle(
                                    context: context,
                                    fontSz: 15,
                                    fontWght: Fontweight.w400,
                                    colour: FontColour.hintblack,
                                    normalSpacing: true),
                              ),
                              Text(
                                widget.userToAdd?.accountEmail ??
                                    widget.usertoUpdate!.accountEmail,
                                style: CustomTextStyle(
                                    context: context,
                                    fontSz: 16,
                                    fontWght: Fontweight.w500,
                                    colour: FontColour.black,
                                    normalSpacing: true),
                              )
                            ],
                          )
                        ],
                      )),
                ),
                Positioned(
                    top: isLandScape ? 552 * hsf : 552 * hsf,
                    child: widget.addtoHome
                        ? Showcase(
                            key: _two,
                            description:
                                'and just like that 🎉💃🏽CONGRATULATIONS🕺🏽🎉 on adding your first home contact\nKhaby lame reaction 🤷🏿',
                            onTargetClick: () async {
                              if (await hasNetwork()) {
                                LoadingScreen().show(
                                    context: context,
                                    text: context.loc.pleasewaitamoment);
                                final exists =
                                    await _contact.existsInWorkContacts(
                                        widget.userToAdd?.cloudUserId ??
                                            widget.usertoUpdate!.onlineUserId);
                                exists ? LoadingScreen().hide() : null;
                                if (exists) {
                                  //LoadingScreen().hide;
                                  await changeContactCategory(
                                          context, true, true)
                                      .then((value) async {
                                    if (value) {
                                      LoadingScreen().show(
                                          context: context,
                                          text: context.loc.pleasewaitamoment);
                                      await _contact.deleteWorkContact(
                                          userId:
                                              widget.userToAdd?.cloudUserId ??
                                                  widget.usertoUpdate!
                                                      .onlineUserId);
                                      await _contact.addHomeContact(
                                        userId: widget.userToAdd?.cloudUserId ??
                                            widget.usertoUpdate!.onlineUserId,
                                        userEmail: widget
                                                .userToAdd?.accountEmail ??
                                            widget.usertoUpdate!.accountEmail,
                                        name: contactName.text.isEmpty
                                            ? nameGeneratedFromEmail(widget
                                                    .userToAdd?.accountEmail ??
                                                widget
                                                    .usertoUpdate!.onlineUserId)
                                            : contactName.text,
                                      );
                                    }
                                  });
                                } else {
                                  await _contact.addHomeContact(
                                    userId: widget.userToAdd?.cloudUserId ??
                                        widget.usertoUpdate!.onlineUserId,
                                    userEmail: widget.userToAdd?.accountEmail ??
                                        widget.usertoUpdate!.accountEmail,
                                    name: contactName.text.isEmpty
                                        ? nameGeneratedFromEmail(widget
                                                .userToAdd?.accountEmail ??
                                            widget.usertoUpdate!.accountEmail)
                                        : contactName.text,
                                  );
                                }
                                LoadingScreen().hide();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              } else {
                                await showErrorDialog(
                                    context, context.loc.failedrequestinternet);
                              }
                            },
                            onToolTipClick: () async {
                              if (await hasNetwork()) {
                                LoadingScreen().show(
                                    context: context,
                                    text: context.loc.pleasewaitamoment);
                                final exists =
                                    await _contact.existsInWorkContacts(
                                        widget.userToAdd?.cloudUserId ??
                                            widget.usertoUpdate!.onlineUserId);
                                exists ? LoadingScreen().hide() : null;
                                if (exists) {
                                  await changeContactCategory(
                                          context, true, true)
                                      .then((value) async {
                                    if (value) {
                                      LoadingScreen().show(
                                          context: context,
                                          text: context.loc.pleasewaitamoment);
                                      await _contact.deleteWorkContact(
                                          userId:
                                              widget.userToAdd?.cloudUserId ??
                                                  widget.usertoUpdate!
                                                      .onlineUserId);
                                      await _contact.addHomeContact(
                                        userId: widget.userToAdd?.cloudUserId ??
                                            widget.usertoUpdate!.onlineUserId,
                                        userEmail: widget
                                                .userToAdd?.accountEmail ??
                                            widget.usertoUpdate!.accountEmail,
                                        name: contactName.text.isEmpty
                                            ? nameGeneratedFromEmail(widget
                                                    .userToAdd?.accountEmail ??
                                                widget
                                                    .usertoUpdate!.onlineUserId)
                                            : contactName.text,
                                      );
                                    }
                                  });
                                } else {
                                  await _contact.addHomeContact(
                                    userId: widget.userToAdd?.cloudUserId ??
                                        widget.usertoUpdate!.onlineUserId,
                                    userEmail: widget.userToAdd?.accountEmail ??
                                        widget.usertoUpdate!.accountEmail,
                                    name: contactName.text.isEmpty
                                        ? nameGeneratedFromEmail(widget
                                                .userToAdd?.accountEmail ??
                                            widget.usertoUpdate!.accountEmail)
                                        : contactName.text,
                                  );
                                }
                                LoadingScreen().hide();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              } else {
                                await showErrorDialog(
                                    context, context.loc.failedrequestinternet);
                              }
                            },
                            targetBorderRadius: BorderRadius.circular(16 * hsf),
                            disposeOnTap: true,
                            child: Container(
                              height: 32 * hsf,
                              width: 0.781 * width,
                              decoration: BoxDecoration(
                                color: const Colour().green,
                                borderRadius: BorderRadius.circular(16 * hsf),
                              ),
                              child: TextButton.icon(
                                onPressed: widget.update ?? false
                                    ? () async {
                                        if (await hasNetwork()) {
                                          await _contact.updateContact(
                                              userId: widget
                                                      .userToAdd?.cloudUserId ??
                                                  widget.usertoUpdate!
                                                      .onlineUserId,
                                              name: contactName.text.isEmpty
                                                  ? nameGeneratedFromEmail(
                                                      widget.userToAdd
                                                              ?.accountEmail ??
                                                          widget.usertoUpdate!
                                                              .accountEmail)
                                                  : contactName.text,
                                              isHomeContact: widget.addtoHome);
                                          Navigator.pop(context);
                                        } else {
                                          await showErrorDialog(
                                              context,
                                              context
                                                  .loc.failedrequestinternet);
                                        }
                                      }
                                    : () async {
                                        if (await hasNetwork()) {
                                          LoadingScreen().show(
                                              context: context,
                                              text: context
                                                  .loc.pleasewaitamoment);
                                          final exists = await _contact
                                              .existsInWorkContacts(widget
                                                      .userToAdd?.cloudUserId ??
                                                  widget.usertoUpdate!
                                                      .onlineUserId);
                                          exists
                                              ? LoadingScreen().hide()
                                              : null;
                                          if (exists) {
                                            //LoadingScreen().hide;
                                            await changeContactCategory(
                                                    context, true, true)
                                                .then((value) async {
                                              if (value) {
                                                LoadingScreen().show(
                                                    context: context,
                                                    text: context
                                                        .loc.pleasewaitamoment);
                                                await _contact
                                                    .deleteWorkContact(
                                                        userId: widget.userToAdd
                                                                ?.cloudUserId ??
                                                            widget.usertoUpdate!
                                                                .onlineUserId);
                                                await _contact.addHomeContact(
                                                  userId: widget.userToAdd
                                                          ?.cloudUserId ??
                                                      widget.usertoUpdate!
                                                          .onlineUserId,
                                                  userEmail: widget.userToAdd
                                                          ?.accountEmail ??
                                                      widget.usertoUpdate!
                                                          .accountEmail,
                                                  name: contactName.text.isEmpty
                                                      ? nameGeneratedFromEmail(
                                                          widget.userToAdd
                                                                  ?.accountEmail ??
                                                              widget
                                                                  .usertoUpdate!
                                                                  .onlineUserId)
                                                      : contactName.text,
                                                );
                                              }
                                            });
                                          } else {
                                            await _contact.addHomeContact(
                                              userId: widget
                                                      .userToAdd?.cloudUserId ??
                                                  widget.usertoUpdate!
                                                      .onlineUserId,
                                              userEmail: widget.userToAdd
                                                      ?.accountEmail ??
                                                  widget.usertoUpdate!
                                                      .accountEmail,
                                              name: contactName.text.isEmpty
                                                  ? nameGeneratedFromEmail(
                                                      widget.userToAdd
                                                              ?.accountEmail ??
                                                          widget.usertoUpdate!
                                                              .accountEmail)
                                                  : contactName.text,
                                            );
                                          }
                                          LoadingScreen().hide();
                                          Navigator.pop(context);
                                        } else {
                                          await showErrorDialog(
                                              context,
                                              context
                                                  .loc.failedrequestinternet);
                                        }
                                      },
                                icon: Icon(
                                  Icons.save_outlined,
                                  color: const Colour().white,
                                ),
                                label: Text(
                                  widget.update ?? false
                                      ? context.loc.update
                                      : context.loc.save,
                                  style: TextStyle(color: const Colour().white),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 32 * hsf,
                            width: 0.781 * width,
                            decoration: BoxDecoration(
                              color: const Colour().primary,
                              borderRadius: BorderRadius.circular(16 * hsf),
                            ),
                            child: TextButton.icon(
                              onPressed: widget.update ?? false
                                  ? () async {
                                      if (await hasNetwork()) {
                                        await _contact.updateContact(
                                            userId:
                                                widget.userToAdd?.cloudUserId ??
                                                    widget.usertoUpdate!
                                                        .onlineUserId,
                                            name: contactName.text.isEmpty
                                                ? nameGeneratedFromEmail(widget
                                                        .userToAdd
                                                        ?.accountEmail ??
                                                    widget.usertoUpdate!
                                                        .accountEmail)
                                                : contactName.text,
                                            isHomeContact: widget.addtoHome);

                                        Navigator.pop(context);
                                      } else {
                                        await showErrorDialog(context,
                                            context.loc.failedrequestinternet);
                                      }
                                    }
                                  : () async {
                                      if (await hasNetwork()) {
                                        LoadingScreen().show(
                                            context: context,
                                            text:
                                                context.loc.pleasewaitamoment);
                                        final exists =
                                            await _contact.existsInHomeContacts(
                                                widget.userToAdd?.cloudUserId ??
                                                    widget.usertoUpdate!
                                                        .onlineUserId);
                                        exists ? LoadingScreen().hide() : null;
                                        if (exists) {
                                          await changeContactCategory(
                                                  context, true, true)
                                              .then((value) async {
                                            if (value) {
                                              LoadingScreen().show(
                                                  context: context,
                                                  text: context
                                                      .loc.pleasewaitamoment);
                                              await _contact.deleteHomeContact(
                                                  userId: widget.userToAdd
                                                          ?.cloudUserId ??
                                                      widget.usertoUpdate!
                                                          .onlineUserId);
                                              await _contact.addWorkContact(
                                                userId: widget.userToAdd
                                                        ?.cloudUserId ??
                                                    widget.usertoUpdate!
                                                        .onlineUserId,
                                                userEmail: widget.userToAdd
                                                        ?.accountEmail ??
                                                    widget.usertoUpdate!
                                                        .onlineUserId,
                                                name: contactName.text.isEmpty
                                                    ? nameGeneratedFromEmail(
                                                        widget.userToAdd
                                                                ?.accountEmail ??
                                                            widget.usertoUpdate!
                                                                .onlineUserId)
                                                    : contactName.text,
                                              );
                                            }
                                          });
                                        } else {
                                          await _contact.addWorkContact(
                                            userId:
                                                widget.userToAdd?.cloudUserId ??
                                                    widget.usertoUpdate!
                                                        .onlineUserId,
                                            userEmail: widget
                                                    .userToAdd?.accountEmail ??
                                                widget
                                                    .usertoUpdate!.accountEmail,
                                            name: contactName.text.isEmpty
                                                ? nameGeneratedFromEmail(widget
                                                        .userToAdd
                                                        ?.accountEmail ??
                                                    widget.usertoUpdate!
                                                        .onlineUserId)
                                                : contactName.text,
                                          );
                                        }
                                        LoadingScreen().hide();
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                      } else {
                                        await showErrorDialog(context,
                                            context.loc.failedrequestinternet);
                                      }
                                    },
                              icon: Icon(
                                Icons.save_outlined,
                                color: const Colour().white,
                              ),
                              label: Text(
                                widget.update ?? false
                                    ? context.loc.update
                                    : context.loc.save,
                                style: TextStyle(color: const Colour().white),
                              ),
                            ),
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
          ),
        );
      }),
    );
  }
}
