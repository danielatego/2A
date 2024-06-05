// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/cloudOnlineprofile/contact.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/database/local/database_service.dart';
import 'package:two_a/database/local/database_tables/online_userTable.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/firebase/authentication/fireauth.dart';
import 'package:two_a/firebase/authentication/service.dart';
import 'package:two_a/helpers/loading/loading_screen.dart';
import 'package:two_a/main.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';
import 'package:two_a/views/homepage_view.dart';
import 'package:two_a/views/personal/Assign/assign.dart';
import 'package:two_a/views/profile/add_new_contact.dart';
import 'package:two_a/views/profile/edit_contactname.dart';

class ViewContacts extends StatefulWidget {
  const ViewContacts({super.key});

  @override
  State<ViewContacts> createState() => _ViewContactsState();
}

class _ViewContactsState extends State<ViewContacts> {
  late LocalDatabaseService _localdatabase;
  late Contact _contact;
  final String userId = Service(FireAuth()).currentUser!.id;
  final String userEmail = Service(FireAuth()).currentUser!.email;
  late Future _path, _onlineUser, futureList;
  bool isHomeContact = true;
  List futures = List.generate(4, (index) => null);
  bool show = true;
  late List<bool> shows;
  String? path;
  String? newPath;

  @override
  void initState() {
    _contact = Contact();
    _localdatabase = LocalDatabaseService();
    futureList = flist(userId, _contact, _localdatabase);
    shows = List.generate(_contact.contactListLength(), (index) => false);
    super.initState();
  }

  @override
  void dispose() async {
    // await _contact.closeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hsf = context.scaleFactor.hsf;
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
    return Scaffold(
        appBar: appBa,
        body: GestureDetector(
          onTap: () {
            setState(() {
              for (var i = 0; i < shows.length; i++) {
                shows[i] = false;
              }
            });
          },
          child: FutureBuilder(
              future: futureList,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned(
                          top: 0.38 * height,
                          child: Column(
                            children: [
                              Text(context.loc.pleasewaitamoment),
                              Padding(
                                  padding: EdgeInsets.only(bottom: 8 * hsf)),
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
                    );

                  case ConnectionState.done:
                    LoadingScreen().hide();
                    path = snapshot.data[0] as String;
                    shows = snapshot.data[1];
                    OnlineUser currentUser = snapshot.data[2];
                    newPath = path != null
                        ? path!.substring(0, path!.lastIndexOf('/') + 1)
                        : '';
                    try {
                      File(path!).lengthSync();
                    } on FileSystemException catch (e) {
                      if (e.message == 'Cannot retrieve length of file') {
                        path = null;
                      }
                    }
                    return SingleChildScrollView(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                              top: isLandScape ? 6 * hsf : 6 * hsf,
                              left: 0.085 * width +
                                  MediaQuery.of(context).viewPadding.left,
                              child: SizedBox(
                                height: 64 * hsf,
                                child: Row(
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      width: 64 * hsf,
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
                                      overflow: TextOverflow.ellipsis,
                                      isHomeContact
                                          ? context.loc.homecontact
                                          : context.loc.workcontact,
                                      style: CustomTextStyle(
                                          context: context,
                                          fontSz: 20,
                                          fontWght: Fontweight.w500,
                                          colour: FontColour.black,
                                          normalSpacing: true),
                                    )
                                  ],
                                ),
                              )),
                          Positioned(
                              top: 0.156 * height,
                              child: SingleChildScrollView(
                                  child:
                                      StreamBuilder<
                                              List<
                                                  ({
                                                    String email,
                                                    String id,
                                                    String name,
                                                    String ppicAvailable
                                                  })>>(
                                          stream: _contact
                                              .contactListStream(isHomeContact),
                                          builder: (context, snapshot) {
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.active:
                                              case ConnectionState.waiting:
                                                if (snapshot.hasData) {
                                                  final streamcontacts =
                                                      snapshot.data;
                                                  return SingleChildScrollView(
                                                    child: Column(
                                                      children: List<
                                                              Widget>.generate(
                                                          streamcontacts
                                                                  ?.length ??
                                                              0, (index) {
                                                        return Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom:
                                                                      13 * hsf),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          height: 0.06 * height,
                                                          width: 0.789 * width,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(8 *
                                                                          hsf)),
                                                          child: Material(
                                                            color: shows[index]
                                                                ? const Colour()
                                                                    .lHint2
                                                                : const Colour()
                                                                    .lbg,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12 *
                                                                            hsf),
                                                            clipBehavior:
                                                                Clip.hardEdge,
                                                            child: InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  shows[index] =
                                                                      true;
                                                                });
                                                              },
                                                              onLongPress: () {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute<
                                                                            void>(
                                                                        builder: (context) => AssignWork(
                                                                            isHome:
                                                                                isHomeContact,
                                                                            contactEmail: streamcontacts[index]
                                                                                .email,
                                                                            contactId: streamcontacts[index]
                                                                                .id,
                                                                            ppicPath: streamcontacts[index].ppicAvailable == 'true'
                                                                                ? File('$newPath${streamcontacts[index].id}.jpg')
                                                                                : null,
                                                                            name: streamcontacts[index].name,
                                                                            date: DateTime.now())));
                                                              },
                                                              child: Stack(
                                                                children: [
                                                                  Positioned(
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(left: 4 * hsf),
                                                                          clipBehavior:
                                                                              Clip.antiAliasWithSaveLayer,
                                                                          width:
                                                                              0.048 * height,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            border:
                                                                                Border.all(width: 0.6, color: const Colour().black),
                                                                          ),
                                                                          child: streamcontacts![index].ppicAvailable == 'false'
                                                                              ? Icon(
                                                                                  Icons.person_rounded,
                                                                                  size: 0.036 * height,
                                                                                )
                                                                              : Image.file(
                                                                                  File('$newPath${streamcontacts[index].id}.jpg'),
                                                                                  height: 0.048 * height,
                                                                                  width: 0.048 * height,
                                                                                  fit: BoxFit.fill,
                                                                                ),
                                                                        ),
                                                                        Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: 8 * hsf)),
                                                                        Text(
                                                                          streamcontacts[index]
                                                                              .name,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.fade,
                                                                          style: CustomTextStyle(
                                                                              context: context,
                                                                              fontSz: 15,
                                                                              fontWght: Fontweight.w400),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    right: 0,
                                                                    child: AnimatedOpacity(
                                                                        opacity: shows[index] ? 1.0 : 00,
                                                                        duration: const Duration(milliseconds: 800),
                                                                        child: Container(
                                                                          height:
                                                                              0.06 * height,
                                                                          width:
                                                                              0.427 * width,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(8 * hsf),
                                                                              color: const Colour().lHint2),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Container(
                                                                                height: 0.048 * height,
                                                                                width: 0.048 * height,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8 * hsf)),
                                                                                child: Material(
                                                                                  clipBehavior: Clip.hardEdge,
                                                                                  borderRadius: BorderRadius.circular(8 * hsf),
                                                                                  child: InkWell(
                                                                                    onTap: shows[index]
                                                                                        ? () async {
                                                                                            if (await hasNetwork()) {
                                                                                              OnlineUser user = OnlineUser(onlineUserId: streamcontacts[index].id, accountEmail: streamcontacts[index].email, documentId: '', workContacts: '', homeContacts: '', profilePicture: '');
                                                                                              Navigator.pop(context);
                                                                                              Navigator.push(
                                                                                                  context,
                                                                                                  MaterialPageRoute<void>(
                                                                                                      builder: (context) => EditContactToSave(
                                                                                                            usertoUpdate: user,
                                                                                                            addtoHome: isHomeContact,
                                                                                                            userToAdd: null,
                                                                                                            name: streamcontacts[index].name,
                                                                                                            update: true,
                                                                                                            contactFile: streamcontacts[index].ppicAvailable == 'true' ? '$newPath${streamcontacts[index].id}.jpg' : null,
                                                                                                          )));
                                                                                            } else {
                                                                                              await showErrorDialog(context, context.loc.failedrequestinternet);
                                                                                            }
                                                                                          }
                                                                                        : null,
                                                                                    child: Icon(
                                                                                      Icons.edit,
                                                                                      color: const Colour().green,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 0.048 * height,
                                                                                width: 0.048 * height,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8 * hsf)),
                                                                                child: Material(
                                                                                  clipBehavior: Clip.hardEdge,
                                                                                  borderRadius: BorderRadius.circular(8 * hsf),
                                                                                  child: InkWell(
                                                                                    onTap: shows[index]
                                                                                        ? () async {
                                                                                            if (await hasNetwork()) {
                                                                                              setState(() {
                                                                                                shows[index] = false;
                                                                                              });
                                                                                              deleteContact(context, null).then((value) async {
                                                                                                if (value) {
                                                                                                  if (isHomeContact) {
                                                                                                    await _contact.deleteHomeContact(userId: streamcontacts[index].id);
                                                                                                  } else {
                                                                                                    await _contact.deleteWorkContact(userId: streamcontacts[index].id);
                                                                                                  }
                                                                                                }
                                                                                                return;
                                                                                              });
                                                                                            } else {
                                                                                              await showErrorDialog(context, context.loc.failedrequestinternet);
                                                                                            }
                                                                                          }
                                                                                        : null,
                                                                                    child: Icon(
                                                                                      Icons.delete,
                                                                                      color: const Colour().red,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 0.048 * height,
                                                                                width: 0.048 * height,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8 * hsf)),
                                                                                child: Material(
                                                                                  //clipBehavior: Clip.hardEdge,
                                                                                  borderRadius: BorderRadius.circular(8 * hsf),
                                                                                  child: InkWell(
                                                                                    onTap: shows[index]
                                                                                        ? () async {
                                                                                            if (await hasNetwork()) {
                                                                                              setState(() {
                                                                                                shows[index] = false;
                                                                                              });
                                                                                              changeContactCategory(context, isHomeContact, false).then((value) async {
                                                                                                if (value) {
                                                                                                  if (isHomeContact) {
                                                                                                    LoadingScreen().show(context: context, text: context.loc.pleasewaitamoment);
                                                                                                    await _contact.exchangehometowork(userId: streamcontacts[index].id, userEmail: streamcontacts[index].email, name: streamcontacts[index].name, isppicAvailable: streamcontacts[index].ppicAvailable);
                                                                                                    LoadingScreen().hide();
                                                                                                  } else {
                                                                                                    LoadingScreen().show(context: context, text: context.loc.pleasewaitamoment);
                                                                                                    await _contact.exchangeworktohome(userId: streamcontacts[index].id, userEmail: streamcontacts[index].email, name: streamcontacts[index].name, isppicAvailable: streamcontacts[index].ppicAvailable);
                                                                                                    LoadingScreen().hide();
                                                                                                  }
                                                                                                }
                                                                                              });
                                                                                            } else {
                                                                                              await showErrorDialog(context, context.loc.failedrequestinternet);
                                                                                            }
                                                                                          }
                                                                                        : null,
                                                                                    child: Icon(
                                                                                      Icons.switch_account,
                                                                                      color: const Colour().purple,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 0.048 * height,
                                                                                width: 0.048 * height,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8 * hsf)),
                                                                                child: Material(
                                                                                  clipBehavior: Clip.hardEdge,
                                                                                  borderRadius: BorderRadius.circular(8 * hsf),
                                                                                  child: InkWell(
                                                                                    onTap: shows[index]
                                                                                        ? () async {
                                                                                            if (await hasNetwork()) {
                                                                                              Navigator.pop(context);
                                                                                              Navigator.push(context, MaterialPageRoute<void>(builder: (context) => AssignWork(isHome: isHomeContact, contactEmail: streamcontacts[index].email, contactId: streamcontacts[index].id, ppicPath: streamcontacts[index].ppicAvailable == 'true' ? File('$newPath${streamcontacts[index].id}.jpg') : null, name: streamcontacts[index].name, date: DateTime.now())));
                                                                                            } else {
                                                                                              await showErrorDialog(context, context.loc.failedrequestinternet);
                                                                                            }
                                                                                          }
                                                                                        : null,
                                                                                    child: Center(
                                                                                        child: Text(
                                                                                      '2A',
                                                                                      style: CustomTextStyle(context: context, fontSz: 15, fontWght: Fontweight.w600, colour: FontColour.primary),
                                                                                    )),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  ),
                                                                  Center(
                                                                    child:
                                                                        SizedBox(
                                                                      height: 0.06 *
                                                                          height,
                                                                      width: 0.789 *
                                                                          width,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  );
                                                }
                                                return Container();

                                              default:
                                                return Container();
                                            }
                                          }))),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              child: ClipPath(
                                clipper: leftcurvedButton(),
                                child: Material(
                                  color: isHomeContact
                                      ? const Colour().primary
                                      : const Colour().lHint2,
                                  clipBehavior: Clip.hardEdge,
                                  child: InkWell(
                                    splashColor: const Colour().primary,
                                    onTap: () {
                                      setState(() {
                                        for (var i = 0; i < shows.length; i++) {
                                          shows[i] = false;
                                        }
                                        isHomeContact = true;
                                      });
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 0.147 * width),
                                      alignment: Alignment.centerLeft,
                                      height: 0.084 * height,
                                      width: 0.5 * width,
                                      child: Icon(
                                        Icons.home,
                                        color: const Colour().white,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Positioned(
                              bottom: 0,
                              left: 0.5 * width,
                              child: Transform.flip(
                                flipX: true,
                                child: ClipPath(
                                  clipper: leftcurvedButton(),
                                  child: Material(
                                    color: isHomeContact
                                        ? const Colour().lHint2
                                        : const Colour().green,
                                    clipBehavior: Clip.hardEdge,
                                    child: InkWell(
                                      splashColor: const Colour().green,
                                      onTap: () {
                                        setState(() {
                                          for (var i = 0;
                                              i < shows.length;
                                              i++) {
                                            shows[i] = false;
                                          }
                                          isHomeContact = false;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 0.147 * width),
                                        alignment: Alignment.centerLeft,
                                        height: 0.084 * height,
                                        width: 0.5 * width,
                                        child: Icon(
                                          Icons.work,
                                          color: const Colour().white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Positioned(
                              bottom: 0.006 * height,
                              child: Material(
                                color: isHomeContact
                                    ? const Colour().green
                                    : const Colour().primary,
                                borderRadius: BorderRadius.circular(48 * hsf),
                                clipBehavior: Clip.hardEdge,
                                child: InkWell(
                                  splashColor: const Colour().white,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                            builder: (context) => AddNewContact(
                                                onlineUser: currentUser)));
                                  },
                                  child: Container(
                                    height: 48 * hsf,
                                    width: 48 * hsf,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: const Colour().white,
                                    ),
                                  ),
                                ),
                              )),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: !isLandScape
                                  ? height - appBa.preferredSize.height
                                  : width - appBa.preferredSize.height,
                            ),
                          ),
                        ],
                      ),
                    );
                  default:
                    return Container();
                }
              }),
        ));
  }
}

class leftcurvedButton extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.473, 0);
    path.cubicTo(size.width * 0.83, 0, 0.765 * size.width, size.height,
        size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

Future<List> flist(
    final userId, Contact contact, LocalDatabaseService localdatabase) async {
  final String userEmail = Service(FireAuth()).currentUser!.email;
  final patho = await pathtoProfilePicture(userId);
  final OnlineUser user = await contact.currentUser;
  contact.resetContactList();
  await contact.cacheContacts();
  final list = List.generate(contact.contactListLength(), (index) => false);
  return [patho, list, user];
}

List<Widget> contactlists(
    BuildContext context,
    List<({String email, String id, String name, String ppicAvailable})>?
        contacts,
    String? path,
    bool isHomeContact,
    Contact contact) {
  bool showw = true;
  final width = context.scaleFactor.width;
  final height = context.scaleFactor.height;
  final hsf = context.scaleFactor.hsf;
  final wsf = context.scaleFactor.wsf;
  final newPath =
      path != null ? path.substring(0, path.lastIndexOf('/') + 1) : '';
  if (contacts == null || contacts.isEmpty) {
    return [Container()];
  } else {
    return List<Widget>.generate(contacts.length, (index) {
      return StateBasedContacts(
        index: index,
        contacts: contacts,
        path: path,
        isHomeContact: isHomeContact,
        contact: contact,
      );
    });
  }
}

Widget contactOnLongPress(BuildContext context, String userId, String userEmail,
    String name, String isppicAvailable, bool isHomeContact, Contact contact) {
  final width = context.scaleFactor.width;
  final height = context.scaleFactor.height;
  final hsf = context.scaleFactor.hsf;
  final wsf = context.scaleFactor.wsf;
  return Container(
    height: 0.06 * height,
    width: 0.427 * width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8 * hsf),
        color: const Colour().lHint2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 0.048 * height,
          width: 0.048 * height,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(8 * hsf)),
          child: Material(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(8 * hsf),
            child: InkWell(
              onTap: () async {
                final w = await changeContactCategory(context, true, false);
              },
              child: Icon(
                Icons.edit,
                color: const Colour().green,
              ),
            ),
          ),
        ),
        Container(
          height: 0.048 * height,
          width: 0.048 * height,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(8 * hsf)),
          child: Material(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(8 * hsf),
            child: InkWell(
              onTap: () async {
                deleteContact(context, null).then((value) async {
                  if (value) {
                    if (isHomeContact) {
                      await contact.deleteHomeContact(userId: userId);
                    } else {
                      await contact.deleteWorkContact(userId: userId);
                    }
                  }
                  return;
                });
              },
              child: Icon(
                Icons.delete,
                color: const Colour().red,
              ),
            ),
          ),
        ),
        Container(
          height: 0.048 * height,
          width: 0.048 * height,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(8 * hsf)),
          child: Material(
            //clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(8 * hsf),
            child: InkWell(
              onTap: () async {
                bool proceed = false;
                changeContactCategory(context, true, false).then((value) async {
                  proceed = value;
                  if (value) {
                    if (isHomeContact) {
                      LoadingScreen().show(
                          context: context,
                          text: context.loc.pleasewaitamoment);
                      await contact.exchangehometowork(
                          userId: userId,
                          userEmail: userEmail,
                          name: name,
                          isppicAvailable: isppicAvailable);
                      LoadingScreen().hide();
                    } else {
                      LoadingScreen().show(
                          context: context,
                          text: context.loc.pleasewaitamoment);
                      await contact.exchangeworktohome(
                          userId: userId,
                          userEmail: userEmail,
                          name: name,
                          isppicAvailable: isppicAvailable);
                      LoadingScreen().hide();
                    }
                  }
                });
              },
              child: Icon(
                Icons.switch_account,
                color: const Colour().purple,
              ),
            ),
          ),
        ),
        Container(
          height: 0.048 * height,
          width: 0.048 * height,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(8 * hsf)),
          child: Material(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(8 * hsf),
            child: InkWell(
              child: Center(
                  child: Text(
                '2A',
                style: CustomTextStyle(
                    context: context,
                    fontSz: 15,
                    fontWght: Fontweight.w600,
                    colour: FontColour.primary),
              )),
            ),
          ),
        )
      ],
    ),
  );
}

class StateBasedContacts extends StatefulWidget {
  final List<({String email, String id, String name, String ppicAvailable})>?
      contacts;
  final String? path;
  final int index;
  final bool isHomeContact;
  final Contact contact;
  const StateBasedContacts(
      {super.key,
      required this.contacts,
      required this.path,
      required this.index,
      required this.isHomeContact,
      required this.contact});

  @override
  State<StateBasedContacts> createState() => _StateBasedContactsState();
}

class _StateBasedContactsState extends State<StateBasedContacts> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    final width = context.scaleFactor.width;
    final height = context.scaleFactor.height;
    final hsf = context.scaleFactor.hsf;
    final wsf = context.scaleFactor.wsf;
    final newPath = widget.path != null
        ? widget.path!.substring(0, widget.path!.lastIndexOf('/') + 1)
        : '';
    return Container(
      margin: EdgeInsets.only(bottom: 13 * hsf),
      alignment: Alignment.centerLeft,
      height: 0.06 * height,
      width: 0.789 * width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8 * hsf)),
      child: Material(
        color: show ? const Colour().lHint2 : const Colour().lbg,
        borderRadius: BorderRadius.circular(12 * hsf),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            setState(() {
              show = false;
            });
          },
          onLongPress: () {
            setState(() {
              show = true;
            });
          },
          child: Stack(
            children: [
              Positioned(
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 4 * hsf),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      width: 0.048 * height,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(width: 0.6, color: const Colour().black),
                      ),
                      child: widget.contacts![widget.index].ppicAvailable ==
                              'false'
                          ? Icon(
                              Icons.person_rounded,
                              size: 0.036 * height,
                            )
                          : Image.file(
                              File(
                                  '$newPath${widget.contacts![widget.index].id}.jpg'),
                              height: 0.048 * height,
                              width: 0.048 * height,
                              fit: BoxFit.fill,
                            ),
                    ),
                    Padding(padding: EdgeInsets.only(right: 8 * hsf)),
                    Text(
                      widget.contacts![widget.index].name,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: CustomTextStyle(
                          context: context,
                          fontSz: 15,
                          fontWght: Fontweight.w400),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                child: AnimatedOpacity(
                    opacity: show ? 1.0 : 00,
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      height: 0.06 * height,
                      width: 0.427 * width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8 * hsf),
                          color: const Colour().lHint2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 0.048 * height,
                            width: 0.048 * height,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8 * hsf)),
                            child: Material(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(8 * hsf),
                              child: InkWell(
                                onTap: () async {
                                  final w = await changeContactCategory(
                                      context, true, false);
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: const Colour().green,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 0.048 * height,
                            width: 0.048 * height,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8 * hsf)),
                            child: Material(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(8 * hsf),
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    show = false;
                                  });
                                  deleteContact(context, null)
                                      .then((value) async {
                                    if (value) {
                                      if (widget.isHomeContact) {
                                        await widget.contact.deleteHomeContact(
                                            userId: widget
                                                .contacts![widget.index].id);
                                      } else {
                                        await widget.contact.deleteWorkContact(
                                            userId: widget
                                                .contacts![widget.index].id);
                                      }
                                    }
                                    return;
                                  });
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: const Colour().red,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 0.048 * height,
                            width: 0.048 * height,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8 * hsf)),
                            child: Material(
                              //clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(8 * hsf),
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    show = false;
                                  });
                                  changeContactCategory(context, true, false)
                                      .then((value) async {
                                    if (value) {
                                      if (widget.isHomeContact) {
                                        LoadingScreen().show(
                                            context: context,
                                            text:
                                                context.loc.pleasewaitamoment);
                                        await widget.contact.exchangehometowork(
                                            userId: widget
                                                .contacts![widget.index].id,
                                            userEmail: widget
                                                .contacts![widget.index].email,
                                            name: widget
                                                .contacts![widget.index].name,
                                            isppicAvailable: widget
                                                .contacts![widget.index]
                                                .ppicAvailable);
                                        LoadingScreen().hide();
                                      } else {
                                        LoadingScreen().show(
                                            context: context,
                                            text:
                                                context.loc.pleasewaitamoment);
                                        await widget.contact.exchangeworktohome(
                                            userId: widget
                                                .contacts![widget.index].id,
                                            userEmail: widget
                                                .contacts![widget.index].email,
                                            name: widget
                                                .contacts![widget.index].name,
                                            isppicAvailable: widget
                                                .contacts![widget.index]
                                                .ppicAvailable);
                                        LoadingScreen().hide();
                                      }
                                    }
                                  });
                                },
                                child: Icon(
                                  Icons.switch_account,
                                  color: const Colour().purple,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 0.048 * height,
                            width: 0.048 * height,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8 * hsf)),
                            child: Material(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(8 * hsf),
                              child: InkWell(
                                child: Center(
                                    child: Text(
                                  '2A',
                                  style: CustomTextStyle(
                                      context: context,
                                      fontSz: 15,
                                      fontWght: Fontweight.w600,
                                      colour: FontColour.primary),
                                )),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
              Center(
                child: SizedBox(
                  height: 0.06 * height,
                  width: 0.789 * width,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
