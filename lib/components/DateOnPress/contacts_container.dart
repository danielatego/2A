import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:two_a/components/cloudOnlineprofile/contact.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/views/homepage_view.dart';
import 'package:two_a/views/personal/Assign/assign.dart';

class ContactsContainer extends StatefulWidget {
  final DateTime date;
  const ContactsContainer({super.key, required this.date});

  @override
  State<ContactsContainer> createState() => _ContactsContainerState();
}

class _ContactsContainerState extends State<ContactsContainer> {
  bool isHome = true;
  late Contact _contact;

  @override
  void initState() {
    _contact = Contact();
    super.initState();
  }

  @override
  void dispose() {
    _contact;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = context.scaleFactor.height;
    final width = context.scaleFactor.width;
    final hsf = context.scaleFactor.hsf;
    final wsf = context.scaleFactor.wsf;

    return FutureBuilder(
        future: Future.wait([
          _contact.contactList(homecontacts: isHome),
          pathtoProfilePicture(null)
        ]),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                  padding: const EdgeInsets.all(0),
                  clipBehavior: Clip.hardEdge,
                  height: 0.1439 * height,
                  width: 0.728 * width,
                  decoration: BoxDecoration(
                      color: const Colour().lHint2,
                      borderRadius: BorderRadius.circular(32.0 * hsf)),
                  child: LinearProgressIndicator(
                    color:
                        isHome ? const Colour().green : const Colour().primary,
                    backgroundColor: isHome
                        ? const Color.fromARGB(100, 76, 218, 11)
                        : const Color.fromARGB(100, 11, 170, 218),
                  ));
            case ConnectionState.done:
              if (snapshot.hasData) {
                String path = snapshot.data![1] as String;
                List<
                        ({
                          String id,
                          String email,
                          String name,
                          String ppicAvailable
                        })>? contactList =
                    snapshot.data?[0] as List<
                        ({
                          String id,
                          String email,
                          String name,
                          String ppicAvailable
                        })>?;

                return Container(
                  padding: const EdgeInsets.all(0),
                  clipBehavior: Clip.hardEdge,
                  height: 0.1439 * height,
                  width: 0.728 * width,
                  decoration: BoxDecoration(
                      color: const Colour().lHint2,
                      borderRadius: BorderRadius.circular(32 * hsf)),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 16,
                        child: SizedBox(
                          height: 0.1439 * height,
                          width: 0.128 * width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Material(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isHome = true;
                                      });
                                    },
                                    child: Container(
                                      height: 0.0719 * height,
                                      width: 0.128 * width,
                                      decoration: BoxDecoration(
                                          color: isHome
                                              ? const Colour().green
                                              : const Colour().lHint2,
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(32 * hsf))),
                                      child: Icon(
                                        semanticLabel: context.loc.homecontact,
                                        Icons.home_rounded,
                                        color: const Colour().white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isHome = false;
                                      });
                                    },
                                    child: Container(
                                      height: 0.0719 * height,
                                      width: 0.128 * width,
                                      decoration: BoxDecoration(
                                          color: isHome
                                              ? const Colour().lHint2
                                              : const Colour().primary,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(32 * hsf))),
                                      child: Icon(
                                        semanticLabel: context.loc.workcontact,
                                        Icons.work_rounded,
                                        color: const Colour().white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 75,
                        child: SizedBox(
                          width: 0.6 * width,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: wsf * 8),
                            child: Scrollbar(
                                scrollbarOrientation:
                                    ScrollbarOrientation.bottom,
                                child: ListView.separated(
                                  //physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: contactList?.length ?? 0,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          SizedBox(
                                    height: 0.091 * height,
                                    width: 0.128 * width,
                                    child: Material(
                                      color: const Colour().lHint2,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        splashColor: isHome
                                            ? const Colour().green
                                            : const Colour().primary,
                                        onTap: () {
                                          contactList != null
                                              ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                      builder:
                                                          (context) =>
                                                              AssignWork(
                                                                isHome: isHome,
                                                                contactEmail:
                                                                    contactList[
                                                                            index]
                                                                        .email,
                                                                contactId:
                                                                    contactList[
                                                                            index]
                                                                        .id,
                                                                ppicPath: contactList[index]
                                                                            .ppicAvailable ==
                                                                        'true'
                                                                    ? File(
                                                                        "$path/${contactList[index].id}.jpg")
                                                                    : null,
                                                                name: contactList[
                                                                        index]
                                                                    .name,
                                                                date:
                                                                    widget.date,
                                                              )))
                                              : null;
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              width: 0.0677 * height,
                                              height: 0.1204 * width,
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: contactList != null
                                                  ? contactList[index]
                                                              .ppicAvailable ==
                                                          'false'
                                                      ? Icon(
                                                          Icons.person,
                                                          size: 32 * hsf,
                                                        )
                                                      : Image.file(
                                                          File(
                                                              "$path/${contactList[index].id}.jpg"),
                                                          fit: BoxFit.fill,
                                                        )
                                                  : Container(),
                                            ),
                                            contactList != null
                                                ? Text(
                                                    contactList[index].name,
                                                    overflow: TextOverflow.fade,
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                        fontSize: 10 * wsf),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  right: 0.043 * width)),
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            default:
              return Container();
          }
        });
  }
}
