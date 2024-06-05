import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/database/cloud/cloud_work.dart';
import 'package:two_a/database/local/database_exceptions.dart';
import 'package:two_a/database/local/database_service.dart';
import 'package:two_a/database/local/database_tables/online_userTable.dart';
import 'package:two_a/database/local/database_tables/personal_task_table.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';
import 'package:two_a/views/dateonpress2.dart';
import 'package:two_a/views/homepage_view.dart';
import 'package:two_a/views/personal/Assign/assign_on_press.dart';
import 'package:two_a/views/personal/create_todo.dart';
import 'package:two_a/views/profile/add_new_contact.dart';

class TodoListView extends StatefulWidget {
  final List<Object> todo;
  final bool isweek;

  const TodoListView({
    super.key,
    required this.todo,
    required this.isweek,
  });

  @override
  State<TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  late List shows;
  late LocalDatabaseService localService;

  @override
  void initState() {
    shows = List.generate(widget.todo.length, (index) => false);
    localService = LocalDatabaseService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hsf = context.scaleFactor.hsf;
    final height = context.scaleFactor.height;
    final width = context.scaleFactor.width;

    return ListView.builder(
      itemCount: widget.todo.length,
      itemBuilder: (context, index) {
        if (shows.length < widget.todo.length) {
          shows.add(false);
        }
        if (widget.todo[index] is PersonalTodo) {
          PersonalTodo cloudWork = widget.todo[index] as PersonalTodo;
          DateTime date = DateTime.parse(cloudWork.dateOfCreation);

          String duration = widget.isweek
              ? '${cloudWork.startTime} - ${cloudWork.endTime}   (${date.day}/${date.month}/${date.year})'
              : '${cloudWork.startTime} - ${cloudWork.endTime}';

          return Stack(alignment: Alignment.center, children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              titleTextStyle: cloudWork.done
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
              onTap: () {
                setState(() {
                  for (var i = 0; i < shows.length; i++) {
                    shows[i] = false;
                  }
                });
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (context) => CreatePersonalTodo(
                              date: DateTime.parse(cloudWork.dateOfCreation),
                              todo: cloudWork,
                            )));
              },
              onLongPress: () {
                setState(() {
                  for (var i = 0; i < shows.length; i++) {
                    shows[i] = false;
                  }
                  shows[index] = true;
                });
              },
              leading: cloudWork.done
                  ? SizedBox(
                      height: double.infinity,
                      child: Icon(
                        Icons.check_circle,
                        size: 26 * hsf,
                        color: const Colour().black,
                      ),
                    )
                  : SizedBox(
                      height: double.infinity,
                      child: Container(
                        alignment: Alignment.center,
                        width: 22 * hsf,
                        height: 22 * hsf,
                        decoration: ShapeDecoration(
                            shape: CircleBorder(
                                side: cloudWork.done
                                    ? BorderSide.none
                                    : BorderSide(
                                        color: const Colour().lBorder))),
                      ),
                    ),
              title: Text(
                cloudWork.title,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyle(
                    context: context,
                    fontSz: 15,
                    fontWght: Fontweight.w400,
                    colour: FontColour.black,
                    normalSpacing: true),
              ),
              subtitle: Text(
                duration,
                style: CustomTextStyle(
                    context: context,
                    fontSz: 10,
                    fontWght: Fontweight.w400,
                    colour: FontColour.hintblack,
                    normalSpacing: true),
              ),
            ),
            Positioned(
              right: 0,
              child: AnimatedOpacity(
                  opacity: shows[index] ? 1.0 : 0.0,
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
                              onTap: shows[index]
                                  ? () {
                                      setState(() {
                                        shows[index] = false;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                              builder: (context) =>
                                                  CreatePersonalTodo(
                                                      date: DateTime.parse(
                                                          cloudWork
                                                              .dateOfCreation),
                                                      todo: cloudWork)));
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8 * hsf)),
                          child: Material(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(8 * hsf),
                            child: InkWell(
                              onTap: shows[index]
                                  ? () async {
                                      setState(() {
                                        shows[index] = false;
                                      });
                                      bool proceed = await deleteContact(
                                          context, context.loc.deletetask);
                                      if (proceed) {
                                        try {
                                          await localService.deleteTodo(
                                              id: cloudWork.taskId);
                                        } catch (e) {
                                          throw CouldnotDeleteTodo();
                                        }
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8 * hsf)),
                          child: Material(
                            //clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(8 * hsf),
                            child: InkWell(
                              onTap: shows[index]
                                  ? () async {
                                      setState(() {
                                        shows[index] = false;
                                      });
                                      if (cloudWork.archived) {
                                        try {
                                          await localService.updateTodo(
                                              todo: cloudWork, archived: false);
                                        } catch (e) {
                                          throw CouldNotUpdateTodo();
                                        }
                                      } else {
                                        try {
                                          await localService.updateTodo(
                                              todo: cloudWork, archived: true);
                                        } catch (e) {
                                          throw CouldNotUpdateTodo();
                                        }
                                      }
                                    }
                                  : null,
                              child: Icon(
                                Icons.archive_rounded,
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
                              onTap: shows[index]
                                  ? () {
                                      setState(() {
                                        shows[index] = false;
                                      });
                                    }
                                  : null,
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: const Colour().primary,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ]);
        } else {
          return SizedBox(
            width: 0.859 * context.scaleFactor.width,
            height: 50 * hsf,
            child: AdWidget(ad: widget.todo[index] as BannerAd),
          );
        }
      },
    );
  }
}

class CloudTodoListView extends StatefulWidget {
  final List<Object> todo;
  final VoidCallback? onTap;
  final bool isAssigner;
  final OnlineUser? user;
  final DateTime date;
  final ScrollController controller;

  const CloudTodoListView({
    super.key,
    required this.todo,
    required this.isAssigner,
    this.user,
    this.onTap,
    required this.date,
    //required this.databaseService,
    required this.controller,
  });

  @override
  State<CloudTodoListView> createState() => _CloudTodoListViewState();
}

class _CloudTodoListViewState extends State<CloudTodoListView> {
  late final LocalDatabaseService databaseService;
  late Future<OnlineUser> onlineUser;

  @override
  void initState() {
    databaseService = LocalDatabaseService();
    onlineUser = databaseService.getOnlineUser(id: widget.user!.onlineUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hsf = context.scaleFactor.hsf;
    final wsf = context.scaleFactor.wsf;
    final height = context.scaleFactor.height;
    final width = context.scaleFactor.width;

    return FutureBuilder(
        future: Future.wait([
          pathtoProfilePicture(null),
          onlineUser,
        ]),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final path = snapshot.data![0];
              final OnlineUser onlineUser = snapshot.data![1] as OnlineUser;

              return StreamBuilder<
                      Map<String,
                          ({String message, int messageCount, String upload})>>(
                  stream: databaseService.allCloudWorkStatuses,
                  builder: (context, snapshot) {
                    Map<
                        String,
                        ({
                          String message,
                          int messageCount,
                          String upload
                        })>? map = {
                      '': ((message: '', messageCount: 0, upload: ''))
                    };
                    if (snapshot.hasData) {
                      map = snapshot.data;
                      return ListView.builder(
                        dragStartBehavior: DragStartBehavior.down,
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: widget.controller,
                        itemCount: widget.todo.length,
                        itemBuilder: (context, index) {
                          if (widget.todo[index] is CloudWork) {
                            CloudWork cloudWork =
                                widget.todo[index] as CloudWork;
                            return ListTile(
                              minVerticalPadding: 8 * hsf,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              titleTextStyle: cloudWork.completed
                                  ? const TextStyle(
                                      decoration: TextDecoration.lineThrough)
                                  : null,
                              onTap: () {
                                if (widget.onTap != null) {
                                  widget.onTap!();
                                }
                                if (widget.isAssigner == false) {
                                  if (existsinHomeContacts(onlineUser,
                                              cloudWork.assignerId) ==
                                          true ||
                                      existsinWorkContacts(onlineUser,
                                              cloudWork.assignerId) ==
                                          true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                            builder: (context) => AssignOnPress(
                                                  cloudWork: cloudWork,
                                                  isAssigner: widget.isAssigner,
                                                  user: widget.user,
                                                  date: widget.date,
                                                  databaseService:
                                                      databaseService,
                                                )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddNewContact(
                                                  onlineUser: widget.user!,
                                                  userEmail:
                                                      cloudWork.assignerEmail,
                                                )));
                                  }
                                } else {
                                  if (existsinHomeContacts(onlineUser,
                                              cloudWork.assignedId) ==
                                          true ||
                                      existsinWorkContacts(onlineUser,
                                              cloudWork.assignedId) ==
                                          true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                            builder: (context) => AssignOnPress(
                                                  cloudWork: cloudWork,
                                                  isAssigner: widget.isAssigner,
                                                  user: widget.user,
                                                  date: widget.date,
                                                  databaseService:
                                                      databaseService,
                                                )));
                                  } else {
                                    if (widget.onTap != null) {
                                      widget.onTap!();
                                    }
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddNewContact(
                                                  onlineUser: widget.user!,
                                                  userEmail:
                                                      cloudWork.assignedEmail,
                                                )));
                                  }
                                }
                              },
                              leading: cloudWork.pending
                                  ? SizedBox(
                                      height: double.infinity,
                                      child: Icon(
                                        Icons.pending,
                                        size: 26 * hsf,
                                        color: const Colour().green,
                                      ),
                                    )
                                  : cloudWork.declined
                                      ? SizedBox(
                                          height: double.infinity,
                                          child: Icon(
                                            Icons.cancel,
                                            size: 26 * hsf,
                                            color: const Colour().red,
                                          ),
                                        )
                                      : cloudWork.archived
                                          ? SizedBox(
                                              height: double.infinity,
                                              child: Container(
                                                height: 26 * hsf,
                                                width: 26 * hsf,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        const Colour().primary),
                                                child: Icon(
                                                  Icons.archive_rounded,
                                                  size: 18 * hsf,
                                                  color: const Colour().white,
                                                ),
                                              ),
                                            )
                                          : cloudWork.open
                                              ? SizedBox(
                                                  height: double.infinity,
                                                  child: Icon(
                                                    Icons.circle_outlined,
                                                    size: 26 * hsf,
                                                  ))
                                              : cloudWork.completed
                                                  ? SizedBox(
                                                      height: double.infinity,
                                                      child: Icon(
                                                        Icons.check_circle,
                                                        size: 26 * hsf,
                                                        color: const Colour()
                                                            .primary,
                                                      ),
                                                    )
                                                  : cloudWork.expired
                                                      ? SizedBox(
                                                          height:
                                                              double.infinity,
                                                          child: Icon(
                                                            Icons
                                                                .timelapse_sharp,
                                                            size: 26 * hsf,
                                                            color:
                                                                const Colour()
                                                                    .red,
                                                          ),
                                                        )
                                                      : SizedBox(
                                                          height:
                                                              double.infinity,
                                                          child: Container(
                                                            height: 26 * hsf,
                                                            width: 26 * hsf,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    const Colour()
                                                                        .amber),
                                                            child: Icon(
                                                              Icons
                                                                  .work_history_outlined,
                                                              size: 18 * hsf,
                                                              color:
                                                                  const Colour()
                                                                      .white,
                                                            ),
                                                          ),
                                                        ),
                              title: SizedBox(
                                height: 0.049 * height,
                                width: 0.512 * width,
                                child: Row(
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      width: 32 * hsf,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 0.6,
                                            color: const Colour().black),
                                      ),
                                      child: isImageAvailable(widget.isAssigner
                                              ? '$path/${cloudWork.assignedId}.jpg'
                                              : '$path/${cloudWork.assignerId}.jpg')
                                          ? Image.file(
                                              File(widget.isAssigner
                                                  ? '$path/${cloudWork.assignedId}.jpg'
                                                  : '$path/${cloudWork.assignerId}.jpg'),
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
                                        padding:
                                            EdgeInsets.only(right: 8 * wsf)),
                                    SizedBox(
                                      width: 0.5 * width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cloudWork.title,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: CustomTextStyle(
                                                context: context,
                                                fontSz: 15,
                                                lineThrough:
                                                    cloudWork.expired ||
                                                        cloudWork.completed ||
                                                        cloudWork.declined),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              durationOfTask(
                                                  cloudWork.beginTime,
                                                  cloudWork.finishTime),
                                              style: CustomTextStyle(
                                                  context: context,
                                                  fontSz: 10,
                                                  colour: FontColour.hintblack),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              trailing: messagenotification(map, cloudWork)
                                  ? Container(
                                      alignment: Alignment.center,
                                      width: 0.053 * width,
                                      height: 0.024 * height,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8 * hsf),
                                          color: const Colour().primary),
                                      child: Text(
                                        '${cloudWork.message.length - numberofreadmessages(map, cloudWork)}',
                                        style: CustomTextStyle(
                                            context: context,
                                            fontSz: 10,
                                            colour: FontColour.white),
                                      ),
                                    )
                                  : null,
                            );
                          } else {
                            return SizedBox(
                              width: 0.859 * context.scaleFactor.width,
                              height: 50 * hsf,
                              child:
                                  AdWidget(ad: widget.todo[index] as BannerAd),
                            );
                          }
                        },
                      );
                    }
                    return Container();
                  });

            default:
              return Container();
          }
        });
  }
}

String durationOfTask(int beginTime, int finishTime) {
  DateTime begin = DateTime.fromMicrosecondsSinceEpoch(beginTime);
  DateTime finish = DateTime.fromMicrosecondsSinceEpoch(finishTime);

  return '${begin.hour < 10 ? '0${begin.hour}' : begin.hour}:${begin.minute < 10 ? '0${begin.minute}' : begin.minute} - ${finish.hour < 10 ? '0${finish.hour}' : finish.hour}:${finish.minute < 10 ? '0${finish.minute}' : finish.minute} (${finish.day}/${finish.month}/${finish.year}.) ';
}

bool isImageAvailable(String path) {
  try {
    File(path).lengthSync();
    return true;
  } catch (e) {
    return false;
  }
}

int numberofreadmessages(
    Map<String, ({String message, int messageCount, String upload})>? map,
    CloudWork todo) {
  if (map != null) {
    return map[todo.documentId]?.messageCount ?? 0;
  }
  return 0;
}

bool messagenotification(
    Map<String, ({String message, int messageCount, String upload})>? map,
    CloudWork todo) {
  if (todo.message.isEmpty) {
    return false;
  }
  if ((todo.message.length - numberofreadmessages(map, todo)) == 0) {
    return false;
  }
  if ((todo.message.length - numberofreadmessages(map, todo)) > 0) {
    return true;
  }
  return false;
}
