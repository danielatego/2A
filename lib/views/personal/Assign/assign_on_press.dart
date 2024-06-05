import 'dart:io';
import 'package:flutter/material.dart';
import 'package:two_a/components/DateOnPress/todo_list_view.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/assign/desc_attach_toggle.dart';
import 'package:two_a/components/cloudOnlineprofile/contact.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/notifications/todonotifications.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/database/cloud/cloud_work.dart';
import 'package:two_a/database/cloud/firebase_cloud_storage.dart';
import 'package:two_a/database/local/database_service.dart';
import 'package:two_a/database/local/database_tables/cloud_work_status.dart';
import 'package:two_a/database/local/database_tables/online_userTable.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/firebase/authentication/fireauth.dart';
import 'package:two_a/firebase/authentication/service.dart';
import 'package:two_a/firebase/bloc/auth_bloc.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';
import 'package:two_a/views/home/home_account.dart';
import 'package:two_a/views/profile/add_new_contact.dart';

class AssignOnPress extends StatefulWidget {
  final bool isAssigner;
  final CloudWork cloudWork;
  final OnlineUser? user;
  final LocalDatabaseService databaseService;
  final DateTime date;

  const AssignOnPress(
      {super.key,
      required this.isAssigner,
      required this.cloudWork,
      this.user,
      required this.date,
      required this.databaseService});

  @override
  State<AssignOnPress> createState() => _AssignOnPressState();
}

class _AssignOnPressState extends State<AssignOnPress> {
  late final LocalDatabaseService databaseService;
  bool isDescription = true;
  bool accepted = false;
  bool declined = false;
  late Future _contacts;
  late List<CloudWork> cloudWorkStream;
  late TextEditingController messageController;
  late final FirebaseCloudStorage _cloudService;
  String get userId => Service(FireAuth()).currentUser!.id;
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  @override
  void initState() {
    databaseService = LocalDatabaseService();
    messageController = TextEditingController();
    _cloudService = FirebaseCloudStorage();
    _contacts = Contact().litehomeContacts;
    localCloudWorkStatusCreation(
      databaseService,
      widget.cloudWork,
    );
    super.initState();
  }

  @override
  void dispose() {
    updateCloudWorkStatus(
      databaseService,
      cloudWorkStream[0].message.length,
      widget.cloudWork,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = context.scaleFactor.width;
    final hsf = context.scaleFactor.hsf;
    final wsf = context.scaleFactor.wsf;
    final height = context.scaleFactor.height;
    final Appba = CustomAppbar(
      back: true,
      tab: false,
      context: context,
      locTitle: null,
      appBarRequired: true,
    );
    return Scaffold(
        appBar: Appba,
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: _contacts,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
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
                            height: height - Appba.preferredSize.height,
                            width: width,
                            //color: const Colour().red,
                          ),
                        )
                      ],
                    );
                  case ConnectionState.done:
                    try {
                      final contactMap = snapshot.data as Map<String,
                          (String, String, String, String, String)>;
                    } catch (e) {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddNewContact(
                                    onlineUser: widget.user!,
                                    userEmail: widget.cloudWork.assignerEmail,
                                  )));
                    }
                    final contactMap = snapshot.data as Map<String,
                        (String, String, String, String, String)>;
                    final path = widget.isAssigner
                        ? contactMap[widget.cloudWork.assignedId]!.$4
                        : contactMap[widget.cloudWork.assignerId]!.$4;
                    final uploadPath = widget.isAssigner
                        ? contactMap[widget.cloudWork.assignedId]!.$5
                        : contactMap[widget.cloudWork.assignerId]!.$5;

                    return StreamBuilder<List<CloudWork>>(
                        stream: widget.isAssigner
                            ? _cloudService.allAssignerCloudWorks(
                                date: widget.date,
                                assignerId: userId.trim(),
                              )
                            : _cloudService.assignedSingleStream(
                                assignedId: userId.trim(),
                                beginTime: widget.cloudWork.beginTime,
                              ),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.active:
                            case ConnectionState.waiting:
                              if (snapshot.hasData) {
                                cloudWorkStream = snapshot.data!
                                    .where((element) =>
                                        element.documentId ==
                                        widget.cloudWork.documentId)
                                    .toList();
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                        top: 0.009 * height,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 0.8 * width,
                                          child: Text(
                                            widget.cloudWork.title,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: CustomTextStyle(
                                                context: context,
                                                fontSz: 16,
                                                fontWght: Fontweight.w600),
                                          ),
                                        )),
                                    Positioned(
                                        top: 0.075 * height,
                                        left: 0.048 * width,
                                        child: Row(
                                          children: [
                                            Container(
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              width: 32 * hsf,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 0.6,
                                                    color:
                                                        const Colour().black),
                                              ),
                                              child: isImageAvailable(widget
                                                          .isAssigner
                                                      ? '$path/${widget.cloudWork.assignedId}.jpg'
                                                      : '$path/${widget.cloudWork.assignerId}.jpg')
                                                  ? Image.file(
                                                      File(widget.isAssigner
                                                          ? '$path/${widget.cloudWork.assignedId}.jpg'
                                                          : '$path/${widget.cloudWork.assignerId}.jpg'),
                                                      height: 32 * hsf,
                                                      width: 32 * hsf,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Icon(
                                                      Icons.person_rounded,
                                                      size: 32 * hsf,
                                                    ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8 * wsf)),
                                            Text(
                                              widget.isAssigner
                                                  ? contactMap[widget.cloudWork
                                                          .assignedId]!
                                                      .$2
                                                  : contactMap[widget.cloudWork
                                                          .assignerId]!
                                                      .$2,
                                              style: CustomTextStyle(
                                                  context: context,
                                                  fontSz: 16,
                                                  colour: FontColour.hintblack),
                                            )
                                          ],
                                        )),
                                    Positioned(
                                        top: 0.135 * height,
                                        left: 0.048 * width,
                                        child: Text(
                                          durationOfTask(
                                              widget.cloudWork.beginTime,
                                              widget.cloudWork.finishTime),
                                          style: CustomTextStyle(
                                              context: context,
                                              fontSz: 12,
                                              colour: FontColour.hintblack),
                                        )),
                                    Positioned(
                                      top: 0.192 * height,
                                      child: DescriptionAttachToggle(
                                        description:
                                            widget.cloudWork.description,
                                        attachedFiles:
                                            widget.cloudWork.attachedFiles,
                                        path: uploadPath,
                                        isAssigner: widget.isAssigner,
                                      ),
                                    ),
                                    Positioned(
                                        top: 0.370 * height,
                                        child: Container(
                                          padding: EdgeInsets.all(8 * hsf),
                                          height: 0.442 * height,
                                          width: 0.936 * width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8 * hsf),
                                              color: const Colour().lHint2),
                                          child: Stack(
                                            alignment: Alignment.bottomLeft,
                                            children: [
                                              Positioned(
                                                  top: 0,
                                                  child: SizedBox(
                                                      height: 0.36 * height,
                                                      width: 0.9 * width,
                                                      child:
                                                          SingleChildScrollView(
                                                        reverse: true,
                                                        controller:
                                                            _scrollController,
                                                        child: Column(
                                                          children: List<
                                                                  Widget>.generate(
                                                              cloudWorkStream[0]
                                                                  .message
                                                                  .length,
                                                              (index) {
                                                            if (cloudWorkStream[
                                                                            0]
                                                                        .message[
                                                                    '${index + 1}'][0] ==
                                                                userId) {
                                                              return Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(
                                                                      bottom: hsf *
                                                                          8.0),
                                                                  child: ClipPath(
                                                                      clipper: RightMessageClipper(),
                                                                      child: Container(
                                                                          constraints: BoxConstraints(maxHeight: 80 * hsf, maxWidth: 240 * hsf, minWidth: 50 * wsf),
                                                                          padding: EdgeInsets.only(right: 16 * wsf, top: 6 * wsf, left: 6 * hsf, bottom: 3.15 * hsf),
                                                                          color: const Colour().white,
                                                                          child: Stack(children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(bottom: 12.0 * hsf),
                                                                              child: Text(
                                                                                cloudWorkStream[0].message['${index + 1}'][2],
                                                                                style: CustomTextStyle(context: context, fontSz: 14, colour: FontColour.black),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                                right: 0,
                                                                                bottom: 0,
                                                                                child: Text(
                                                                                  timePast(int.parse(cloudWorkStream[0].message['${index + 1}'][3])),
                                                                                  style: CustomTextStyle(context: context, fontSz: 10, colour: FontColour.hintblack),
                                                                                ))
                                                                          ]))),
                                                                ),
                                                              );
                                                            }
                                                            return Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom: hsf *
                                                                            8.0),
                                                                child: ClipPath(
                                                                    clipper:
                                                                        MessageClipper(),
                                                                    child: Container(
                                                                        constraints: BoxConstraints(maxHeight: 80 * hsf, minWidth: 32 * wsf, maxWidth: 240 * hsf),
                                                                        padding: EdgeInsets.only(left: 16 * wsf, top: 6 * wsf, right: 6 * hsf, bottom: 3.15 * hsf),
                                                                        color: const Colour().primary,
                                                                        child: Stack(children: [
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: 12.0 * hsf),
                                                                            child:
                                                                                Text(
                                                                              cloudWorkStream[0].message['${index + 1}'][2],
                                                                              style: CustomTextStyle(context: context, fontSz: 14, colour: FontColour.white),
                                                                            ),
                                                                          ),
                                                                          Positioned(
                                                                              right: 0,
                                                                              bottom: 0,
                                                                              child: Text(
                                                                                timePast(int.parse(cloudWorkStream[0].message['${index + 1}'][3])),
                                                                                style: CustomTextStyle(context: context, fontSz: 10, colour: FontColour.white),
                                                                              ))
                                                                        ]))),
                                                              ),
                                                            );
                                                          }),
                                                        ),
                                                      ))),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            const Colour().lbg,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    8 * hsf)),
                                                    width: 0.772 * width,
                                                    child: TextField(
                                                      onTapOutside: (event) => {
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus()
                                                      },
                                                      controller:
                                                          messageController,
                                                      scrollPadding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      style: CustomTextStyle(
                                                          context: context,
                                                          fontSz: 15.0,
                                                          fontWght:
                                                              Fontweight.w400,
                                                          colour:
                                                              FontColour.black,
                                                          normalSpacing: true),
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      maxLines: 4,
                                                      minLines: 1,
                                                      maxLength: 120,
                                                      readOnly:
                                                          cloudWorkStream[0]
                                                                      .message
                                                                      .length >=
                                                                  10 ||
                                                              cloudWorkStream[0]
                                                                  .expired ||
                                                              cloudWorkStream[0]
                                                                  .declined,
                                                      decoration:
                                                          InputDecoration(
                                                              counterText: '',
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText: context
                                                                  .loc.message,
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(9 *
                                                                          hsf)),
                                                    ),
                                                  ),
                                                  Material(
                                                    color: cloudWorkStream[0]
                                                                .expired ||
                                                            cloudWorkStream[0]
                                                                .declined ||
                                                            cloudWorkStream[0]
                                                                    .message
                                                                    .length >=
                                                                10
                                                        ? const Colour().lHint
                                                        : const Colour().green,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                32 * hsf)),
                                                    child: InkWell(
                                                      onTap: cloudWorkStream[0]
                                                                  .expired ||
                                                              cloudWorkStream[0]
                                                                  .declined ||
                                                              cloudWorkStream[0]
                                                                      .message
                                                                      .length >=
                                                                  10
                                                          ? null
                                                          : () {
                                                              if (messageController
                                                                  .text
                                                                  .isNotEmpty) {
                                                                String sender =
                                                                    userId;
                                                                String
                                                                    assignedId =
                                                                    widget
                                                                        .cloudWork
                                                                        .assignedId;
                                                                String message =
                                                                    messageController
                                                                        .text;
                                                                String time = DateTime
                                                                        .now()
                                                                    .microsecondsSinceEpoch
                                                                    .toString();
                                                                List
                                                                    messageItems =
                                                                    [
                                                                  sender,
                                                                  assignedId,
                                                                  message,
                                                                  time
                                                                ];
                                                                List oldMap = [
                                                                  '${cloudWorkStream[0].message.length + 1}',
                                                                  messageItems
                                                                ];
                                                                _cloudService.updateCloudWork(
                                                                    documentId: widget
                                                                        .cloudWork
                                                                        .documentId,
                                                                    message:
                                                                        oldMap);
                                                                messageController
                                                                    .clear();
                                                              } else {
                                                                return;
                                                              }
                                                            },
                                                      customBorder:
                                                          const CircleBorder(),
                                                      highlightColor:
                                                          const Colour().white,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 32 * hsf,
                                                        width: 32 * hsf,
                                                        child: Icon(
                                                          Icons.send,
                                                          size: 16 * hsf,
                                                          color: const Colour()
                                                              .white,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                                    Positioned(
                                        top: 0.86 * height,
                                        child: widget.isAssigner
                                            ? cloudWorkStream[0].declined ||
                                                    cloudWorkStream[0].archived
                                                ? Textbutton(
                                                    text: cloudWorkStream[0]
                                                            .archived
                                                        ? context.loc.archived
                                                        : context.loc.declined,
                                                    cancel: true,
                                                  )
                                                : Material(
                                                    child: InkWell(
                                                        onTap: () async {
                                                          cloudWorkStream[0]
                                                                      .open ==
                                                                  false
                                                              ? Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              CloudWorkAccounting(
                                                                                path: path,
                                                                                isAssigner: widget.isAssigner,
                                                                                cloudWork: cloudWorkStream[0],
                                                                                localDatabaseService: localService,
                                                                                cloudService: cloudService,
                                                                              )))
                                                              : await _cloudService
                                                                  .updateCloudWork(
                                                                      documentId:
                                                                          cloudWorkStream[0]
                                                                              .documentId,
                                                                      archived:
                                                                          true);
                                                        },
                                                        child: Textbutton(
                                                          text: cloudWorkStream[
                                                                          0]
                                                                      .open ==
                                                                  false
                                                              ? context.loc
                                                                  .viewaccount
                                                              : context
                                                                  .loc.archive,
                                                        )),
                                                  )
                                            : cloudWorkStream[0].declined ||
                                                    cloudWorkStream[0].archived
                                                ? Textbutton(
                                                    text: cloudWorkStream[0]
                                                            .archived
                                                        ? context.loc.archived
                                                        : context.loc.declined,
                                                    cancel: true,
                                                  )
                                                : cloudWorkStream[0].open ==
                                                        false
                                                    ? Material(
                                                        child: InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          CloudWorkAccounting(
                                                                            path:
                                                                                uploadPath,
                                                                            isAssigner:
                                                                                widget.isAssigner,
                                                                            cloudWork:
                                                                                cloudWorkStream[0],
                                                                            localDatabaseService:
                                                                                localService,
                                                                            cloudService:
                                                                                cloudService,
                                                                          )));
                                                            },
                                                            child: Textbutton(
                                                              text: context
                                                                  .loc.account,
                                                            )),
                                                      )
                                                    : SizedBox(
                                                        width: 0.936 * width,
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Material(
                                                                child: InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      await _cloudService.updateCloudWork(
                                                                          documentId: widget
                                                                              .cloudWork
                                                                              .documentId,
                                                                          declined:
                                                                              true);
                                                                    },
                                                                    child:
                                                                        Textbutton(
                                                                      cancel:
                                                                          true,
                                                                      text: context
                                                                          .loc
                                                                          .decline,
                                                                    )),
                                                              ),
                                                              Material(
                                                                child: InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      notificationid(widget
                                                                          .cloudWork
                                                                          .beginTime);
                                                                      await setupnotification(
                                                                        notificationid(widget
                                                                            .cloudWork
                                                                            .beginTime),
                                                                        DateTime.fromMicrosecondsSinceEpoch(widget
                                                                            .cloudWork
                                                                            .beginTime),
                                                                        widget
                                                                            .cloudWork
                                                                            .title,
                                                                        widget
                                                                            .cloudWork
                                                                            .description,
                                                                        'once',
                                                                      );
                                                                      await _cloudService.updateCloudWork(
                                                                          documentId: widget
                                                                              .cloudWork
                                                                              .documentId,
                                                                          open:
                                                                              false);
                                                                    },
                                                                    child:
                                                                        Textbutton(
                                                                      text: context
                                                                          .loc
                                                                          .accept,
                                                                    )),
                                                              )
                                                            ]),
                                                      )),
                                    Center(
                                      child: SizedBox(
                                        height:
                                            height - Appba.preferredSize.height,
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            default:
                              return Container();
                          }
                        });
                  default:
                    Container();
                }
                return Container();
              }),
        ));
  }
}

class MessageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(8, 2, 12, 8);
    path.lineTo(12, size.height - 8);
    path.quadraticBezierTo(12, size.height, 20, size.height);
    path.lineTo(size.width - 8, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 8);
    path.lineTo(size.width, 8);
    path.quadraticBezierTo(size.width, 0, size.width - 8, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class RightMessageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(8, 0);
    path.quadraticBezierTo(0, 0, 0, 8);
    path.lineTo(0, size.height - 8);
    path.quadraticBezierTo(0, size.height, 8, size.height);
    path.lineTo(size.width - 20, size.height);
    path.quadraticBezierTo(
        size.width - 12, size.height, size.width - 12, size.height - 8);
    path.lineTo(size.width - 12, 8);
    path.quadraticBezierTo(size.width - 8, 2, size.width, 0);
    path.lineTo(8, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

String timePast(int beginTime) {
  DateTime begin = DateTime.fromMicrosecondsSinceEpoch(beginTime);

  return '${begin.hour < 10 ? '0${begin.hour}' : begin.hour}:${begin.minute < 10 ? '0${begin.minute}' : begin.minute}';
}

class Textbutton extends StatelessWidget {
  final String text;
  final bool? cancel;
  const Textbutton({super.key, required this.text, this.cancel});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: CustomTextStyle(
          context: context,
          fontSz: 17,
          fontWght: Fontweight.w600,
          colour: cancel ?? false ? FontColour.red : FontColour.black),
    );
  }
}

Future<void> localCloudWorkStatusCreation(
    LocalDatabaseService localDatabaseService, CloudWork cloudWork) async {
  await localDatabaseService.getorCreateCloudWorkStatus(
      documentId: cloudWork.documentId);
}

Future<void> updateCloudWorkStatus(LocalDatabaseService localDatabaseService,
    int numberofreadmessages, CloudWork cloudWork) async {
  CloudWorkStatus cloudWorkStatus = await localDatabaseService
      .getorCreateCloudWorkStatus(documentId: cloudWork.documentId);
  await localDatabaseService.updateCloudWorkStatus(
      cloudWorkStatus: cloudWorkStatus, messageCount: numberofreadmessages);
}

int notificationid(int longInteger) {
  var f = longInteger.toString();
  String t = '';
  for (int i = (f.length / 2).round(); i < f.length; i++) {
    t += f[i];
  }
  return int.parse(t);
}
