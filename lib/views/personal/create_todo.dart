import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/calendar.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/createtodo/alert_container.dart';
import 'package:two_a/components/createtodo/date_text_field.dart';
import 'package:two_a/components/createtodo/description.dart';
import 'package:two_a/components/createtodo/time_allday.dart';
import 'package:two_a/components/createtodo/title_text_field.dart';
import 'package:two_a/components/createtodo/upload.dart';
import 'package:two_a/components/notifications/todonotifications.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/database/local/database_service.dart';
import 'package:two_a/database/local/database_tables/personal_task_table.dart';
import 'package:two_a/database/local/database_tables/user_table.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/firebase/authentication/fireauth.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';
import 'package:two_a/views/personal/Account/todo_on_press.dart';
import 'package:two_a/views/profile/user_profile.dart';

class CreatePersonalTodo extends StatefulWidget {
  final DateTime date;
  final DatabaseUser? user;
  final bool? onTutorial;
  final PersonalTodo? todo;
  const CreatePersonalTodo(
      {super.key,
      required this.date,
      required this.todo,
      this.user,
      this.onTutorial});

  @override
  State<CreatePersonalTodo> createState() => _CreatePersonalTodoState();
}

class _CreatePersonalTodoState extends State<CreatePersonalTodo> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();
  final GlobalKey _six = GlobalKey();
  final GlobalKey _seven = GlobalKey();
  final GlobalKey _eight = GlobalKey();
  final GlobalKey _nine = GlobalKey();

  late PersonalTodo? _todo;
  late final TextEditingController titlecontroller,
      begincontroller,
      finishcontroller,
      alldaytoggle,
      alertTime,
      alertFrequency,
      descriptioncontroller,
      alertTextController,
      imageContoller;
  late bool saved;
  late final bool update;
  late bool isAllDay = _todo?.isAllDay ?? false;
  late final LocalDatabaseService _todoService;
  late Future _futureTodo;
  BuildContext? myContext;
  @override
  void initState() {
    update = !(widget.todo == null);
    saved = !(widget.todo == null);
    _todo = widget.todo;
    titlecontroller = TextEditingController();
    begincontroller = TextEditingController();
    finishcontroller = TextEditingController();
    alertTextController = TextEditingController();
    descriptioncontroller = TextEditingController();
    alldaytoggle = TextEditingController();
    alertTime = TextEditingController();
    alertFrequency = TextEditingController();
    imageContoller = TextEditingController();
    _todoService = LocalDatabaseService();
    _futureTodo = createNewTodo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        widget.onTutorial ?? false
            ? ShowCaseWidget.of(myContext!).startShowCase([_one])
            : null;
      });
    });
    super.initState();
  }

  void _update() async {
    if (update && (_todo != null)) {
      DateTime begintime = DateTime(
          widget.date.year,
          widget.date.month,
          widget.date.day,
          (int.parse(_todo!.startTime![0] + _todo!.startTime![1])),
          (int.parse(_todo!.startTime![3] + _todo!.startTime![4])));
      cancelNotification(_todo!.taskId);
      setupnotification(
          _todo!.taskId,
          updatealalarmtime(begintime, _todo?.alertTime! ?? ''),
          titlecontroller.text,
          descriptioncontroller.text,
          alertFrequency.text);
      _todoService.updateTodo(
          todo: _todo!,
          title: titlecontroller.text,
          done: null,
          isAllDay: isAllDay,
          startTime: begincontroller.text,
          endTime: finishcontroller.text,
          dateOfCreation: _todo!.dateOfCreation,
          alertTime: alertTextController.text,
          alertFrequency: alertFrequency.text,
          fileAttachment: imageContoller.text,
          description: descriptioncontroller.text,
          archived: null,
          accountAttachment: null,
          accountMessage: null);
    } else {
      return;
    }
  }

  @override
  void didChangeDependencies() {
    titlecontroller;
    super.didChangeDependencies();
  }

  @override
  void dispose() async {
    _update();
    if (titlecontroller.text.isEmpty) {
      _todoService.deleteTodo(id: _todo!.taskId);
    }
    if (!saved) {
      _todoService.deleteTodo(id: _todo!.taskId);
    }
    descriptioncontroller.dispose();
    alldaytoggle.dispose();
    begincontroller.dispose();
    finishcontroller.dispose();
    imageContoller.dispose();
    alertTime.dispose();
    super.dispose();
  }

  Future<PersonalTodo> createNewTodo() async {
    final existingTodo = _todo;
    if (existingTodo != null) return existingTodo;

    final currentUserEmail = FireAuth().currentUser!.email;
    final currentUserId = FireAuth().currentUser!.id;
    await _todoService.getorCreateUser(
      email: currentUserEmail,
      id: currentUserId,
    );
    return await _todoService.createTodo(date: widget.date);
  }

  void alldaytoggling() {
    if (alldaytoggle.text == 'true') {
      begincontroller.text = '00:00';
      finishcontroller.text = '23:59';
    } else {
      begincontroller.text = '';
      finishcontroller.text = '';
    }
  }

  DateTime alarmtime(DateTime begintime, String alert) {
    List<String> lengthTime;
    lengthTime = alert.split(',');
    int days = 0, hours = 0, minutes = 0, seconds = 0;
    if (alert.contains('month')) {
      days = 30 * int.parse(alert[0]);
    } else if (alert.contains('week')) {
      days = 7 * int.parse(alert[0]);
    } else if (alert.contains('day')) {
      days = int.parse(alert[0]);
    } else if (alert.contains('hour')) {
      hours = int.parse(lengthTime[0]);
    } else if (alert.contains('minute')) {
      minutes = int.parse(lengthTime[0]);
    } else if (alert.contains('second')) {
      seconds = int.parse(lengthTime[0]);
    }

    return begintime.subtract(Duration(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    ));
  }

  DateTime updatealalarmtime(DateTime begintime, String alert) {
    List<String> lengthTime;
    lengthTime = alert.split(' ');
    int days = 0, hours = 0, minutes = 0, seconds = 0;
    if (alert.contains('month')) {
      days = 30 * int.parse(alert[0]);
    } else if (alert.contains('week')) {
      days = 7 * int.parse(alert[0]);
    } else if (alert.contains('day')) {
      days = int.parse(alert[0]);
    } else if (alert.contains('hour')) {
      hours = int.parse(lengthTime[0]);
    } else if (alert.contains('minute')) {
      minutes = int.parse(lengthTime[0]);
    } else if (alert.contains('second')) {
      seconds = int.parse(lengthTime[0]);
    }

    return begintime.subtract(Duration(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    ));
  }

  @override
  Widget build(BuildContext context) {
    late var titleComponent = TitleTextField(
      titleController: titlecontroller,
      text: _todo?.title ?? '',
    );
    late var beginComponent = DateTextField(
        isAllDay: isAllDay,
        begin: true,
        controller: begincontroller,
        date: widget.date,
        text: _todo?.startTime);
    late var finishComponent = DateTextField(
        isAllDay: isAllDay,
        begin: false,
        controller: finishcontroller,
        date: widget.date,
        text: _todo?.endTime);
    late var descriptionComponent = Description(
      controller: descriptioncontroller,
      text: _todo?.description,
    );
    late var alertComponent = AlertContainer(
      controller: alertTime,
      alertTextController: alertTextController,
      alertFrequency: _todo?.alertFrequency ?? context.loc.once,
      alertText: _todo?.alertTime ?? context.loc.createalert,
      alertFrequencyController: alertFrequency,
    );
    late var uploadComponent = Upload(
      controller: imageContoller,
      images: _todo?.fileAttachment ?? '',
    );
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
        enableShowcase:
            (widget.user?.hintsEnabled ?? false) && (widget.onTutorial ?? false)
                ? true
                : false,
        builder: Builder(builder: (context) {
          myContext = context;
          return Scaffold(
            appBar: appBa,
            body: FutureBuilder(
                future: _futureTodo,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      _todo = snapshot.data as PersonalTodo;
                      // alldaytoggle.removeListener(alldaytoggling);
                      // alldaytoggle.addListener(alldaytoggling);
                      return SingleChildScrollView(
                        child: Stack(
                          children: [
                            Positioned(
                                top: isLandScape ? 15 * hmf : 15 * hsf,
                                left: (width - .904 * width) / 2 +
                                    MediaQuery.of(context).viewPadding.left,
                                child: Showcase(
                                  key: _one,
                                  description:
                                      'Hey 😃 here you enter the title of your task\nFor some reason I throw errors 😬 when left blank\nNow that we are friends never leave me blank 🙏🏽\nJust for today I will create a title for you\nTap me to proceed  ',
                                  disposeOnTap: false,
                                  onTargetClick: () {
                                    setState(() {
                                      titlecontroller.text =
                                          'My first Task created by my Pal 2A';
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_two]);
                                    });
                                  },
                                  onToolTipClick: () {
                                    setState(() {
                                      titlecontroller.text =
                                          'My first Task created by my Pal 2A';
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_two]);
                                    });
                                  },
                                  child: TitleTextField(
                                    titleController: titlecontroller,
                                    text: _todo?.title ?? '',
                                  ),
                                )),
                            Positioned(
                                top: 80 * hsf,
                                left: 0.082 * width +
                                    MediaQuery.of(context).viewPadding.left,
                                //child: Container()),
                                child: Showcase(
                                    key: _four,
                                    description:
                                        'Tap here to set when the task begins\nDon\'t sweat it, its all on me today 🤜🏽🤛🏽\nI\'ve set up an alert ⏰ ten minutes after you tap me,\nLater on,on your own 🚶🏽\nIf you select [time] and leave [begin] empty😏...\nI\'ll scream 😱 hurling all manner of errors',
                                    disposeOnTap: true,
                                    targetBorderRadius:
                                        BorderRadius.circular(8 * hsf),
                                    onTargetClick: () {
                                      setState(() {
                                        begincontroller.text = time();
                                      });
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_five]);
                                    },
                                    onToolTipClick: () {
                                      setState(() {
                                        begincontroller.text = time();
                                      });
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_five]);
                                    },
                                    disableBarrierInteraction: true,
                                    child: beginComponent)),
                            Positioned(
                                top: 127 * hsf,
                                left: 0.082 * width +
                                    MediaQuery.of(context).viewPadding.left,
                                //child: Container()),

                                child: Showcase(
                                    key: _five,
                                    description:
                                        'Now that we are done with begin \nthis becomes a no-brainer 👶🏼\nBe advised, 😳 I also scream!\nif i\'m empty with [time] selected ',
                                    disposeOnTap: true,
                                    targetBorderRadius:
                                        BorderRadius.circular(8 * hsf),
                                    onTargetClick: () {
                                      setState(() {
                                        finishcontroller.text = '23:59';
                                      });
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_six]);
                                    },
                                    onToolTipClick: () {
                                      setState(() {
                                        finishcontroller.text = '23:59';
                                      });
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_six]);
                                    },
                                    disableBarrierInteraction: true,
                                    child: finishComponent)),
                            Positioned(
                                top: 174 * hsf,
                                left: 0.64 * width +
                                    MediaQuery.of(context).viewPadding.left,
                                child: SizedBox(
                                    height: 48 * hsf,
                                    width: 102 * wsf,
                                    child: Row(
                                      children: [
                                        Showcase(
                                          key: _three,
                                          description:
                                              'However, if the task has a specific time frame 🚑\nTap this is button\nAt the appointed time, an alert will pop\nDisclaimer:⛔ An alert will only show if you have\nenabled notifications for this app',
                                          disposeOnTap: true,
                                          targetBorderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(24 * hsf),
                                              bottomLeft:
                                                  Radius.circular(24 * hsf)),
                                          onTargetClick: () {
                                            ShowCaseWidget.of(context)
                                                .startShowCase([_four]);
                                          },
                                          onToolTipClick: () {
                                            ShowCaseWidget.of(context)
                                                .startShowCase([_four]);
                                          },
                                          disableBarrierInteraction: true,
                                          child: Container(
                                            clipBehavior: Clip.hardEdge,
                                            height: 48 * hsf,
                                            width: 51 * wsf,
                                            decoration: BoxDecoration(
                                                color: isAllDay
                                                    ? const Colour().lHint2
                                                    : const Colour().primary,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        24 * hsf),
                                                    bottomLeft: Radius.circular(
                                                        24 * hsf))),
                                            child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  isAllDay = false;
                                                  begincontroller.text = '';
                                                  finishcontroller.text = '';
                                                });
                                              },
                                              child:
                                                  TimeText(isAllDay: isAllDay),
                                            ),
                                          ),
                                        ),
                                        Showcase(
                                          key: _two,
                                          description:
                                              'If the task has no specific time frame🌴🏖\nTap this button\nAlso when you are feeling lazy 😉 and you want to create a task quick\nThis is your go to',
                                          disposeOnTap: true,
                                          targetBorderRadius: BorderRadius.only(
                                              topRight:
                                                  Radius.circular(24 * hsf),
                                              bottomRight:
                                                  Radius.circular(24 * hsf)),
                                          onTargetClick: () {
                                            ShowCaseWidget.of(context)
                                                .startShowCase([_three]);
                                          },
                                          onToolTipClick: () {
                                            ShowCaseWidget.of(context)
                                                .startShowCase([_three]);
                                          },
                                          disableBarrierInteraction: true,
                                          child: Container(
                                            clipBehavior: Clip.hardEdge,
                                            height: 48 * hsf,
                                            width: 51 * wsf,
                                            decoration: BoxDecoration(
                                                color: isAllDay
                                                    ? const Colour().primary
                                                    : const Colour().lHint2,
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(
                                                        24 * hsf),
                                                    bottomRight:
                                                        Radius.circular(
                                                            24 * hsf))),
                                            child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  isAllDay = true;
                                                  begincontroller.text =
                                                      '00:00';
                                                  finishcontroller.text =
                                                      '23:59';
                                                });
                                              },
                                              child: AlldayText(
                                                  isAllDay: isAllDay),
                                            ),
                                          ),
                                        )
                                      ],
                                    ))),
                            Positioned(
                                top: 245 * hsf,
                                left: 0.051 * width +
                                    MediaQuery.of(context).viewPadding.left,
                                child: Showcase(
                                    key: _six,
                                    description:
                                        'This is where you configure your alert ⏰.\n\nDepending on the date of your alert;\nYou can be alerted once, daily, weekly\nor monthly.\n\nDepending on begin time, the alert\ncan be some seconds, minutes,\nhours, days, weeks or months before time.\n\nYour head may be rolling now 😖.\nDon\'t worry,be... 🎶🎶 \nThis one of the rare, easier done than saids',
                                    disposeOnTap: true,
                                    targetBorderRadius:
                                        BorderRadius.circular(8 * hsf),
                                    onTargetClick: () {
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_seven]);
                                    },
                                    onToolTipClick: () {
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_seven]);
                                    },
                                    disableBarrierInteraction: true,
                                    child: alertComponent)),
                            Positioned(
                                top: isLandScape ? 367 * hsf : 367 * hsf,
                                left: 0.051 * width +
                                    MediaQuery.of(context).viewPadding.left,
                                child: Showcase(
                                    key: _seven,
                                    description:
                                        'Tap here to enter description of your task\nbut, for today I\'ll write what i feel about you😌\nDont mind my language',
                                    disposeOnTap: true,
                                    targetBorderRadius:
                                        BorderRadius.circular(8 * hsf),
                                    onTargetClick: () {
                                      setState(() {
                                        descriptioncontroller.text =
                                            '${nameGeneratedFromEmail(widget.user?.email ?? '')} thank you so much for downloading, 2A app, my home🤖 and coming this far in this walkthrough. 2A grateful😭, happy and feeling special👼🏼';
                                      });
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_eight]);
                                    },
                                    onToolTipClick: () {
                                      setState(() {
                                        descriptioncontroller.text =
                                            '${nameGeneratedFromEmail(widget.user?.email ?? '')} thank you so much for downloading, 2A app, my home🤖 and coming this far in this walkthrough. 2A grateful😭, happy and feeling special👼🏼';
                                      });
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_eight]);
                                    },
                                    disableBarrierInteraction: true,
                                    child: descriptionComponent)),
                            Positioned(
                              top: isLandScape ? 483 * hsf : 483 * hsf,
                              left: 0.051 * width +
                                  MediaQuery.of(context).viewPadding.left,
                              child: Showcase(
                                  key: _eight,
                                  description:
                                      'Here attach any file from your device\nby tapping the blue button.\nAttached files can be opened onTap\nand deleted onLongpress\nI would have attached my profile pic 😌\nBut i\'m feeling cute 🙈',
                                  disposeOnTap: true,
                                  targetBorderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(14 * hsf),
                                    topLeft: Radius.circular(14 * hsf),
                                    bottomRight: Radius.circular(48 * hsf),
                                    topRight: Radius.circular(48 * hsf),
                                  ),
                                  onTargetClick: () {
                                    ShowCaseWidget.of(context)
                                        .startShowCase([_nine]);
                                  },
                                  onToolTipClick: () {
                                    ShowCaseWidget.of(context)
                                        .startShowCase([_nine]);
                                  },
                                  child: uploadComponent),
                            ),
                            Positioned(
                                top: isLandScape ? 565 * hsf : 565 * hsf,
                                left: 0.051 * width +
                                    MediaQuery.of(context).viewPadding.left,
                                child: update
                                    ? TextButton(
                                        onPressed: () {
                                          setState(() {
                                            saved = false;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          context.loc.delete,
                                          style: CustomTextStyle(
                                              context: context,
                                              fontSz: 17,
                                              fontWght: Fontweight.w500,
                                              colour: FontColour.red,
                                              normalSpacing: true),
                                        ))
                                    : TextButton(
                                        onPressed: () {
                                          if (!saved) {
                                            _todoService.deleteTodo(
                                                id: _todo!.taskId);
                                          }
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          context.loc.cancel,
                                          style: CustomTextStyle(
                                              context: context,
                                              fontSz: 17,
                                              fontWght: Fontweight.w500,
                                              colour: FontColour.red,
                                              normalSpacing: true),
                                        ))),
                            Positioned(
                                top: isLandScape ? 565 * hsf : 565 * hsf,
                                right: 0.051 * width +
                                    MediaQuery.of(context).viewPadding.right,
                                child: update
                                    ? TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                  builder: (context) =>
                                                      AccountPersonalTask(
                                                        todo: _todo!,
                                                        date: dateinWords(
                                                            widget.date,
                                                            context),
                                                      )));
                                        },
                                        child: Text(
                                          context.loc.account,
                                          style: CustomTextStyle(
                                              context: context,
                                              fontSz: 17,
                                              fontWght: Fontweight.w500,
                                              colour: FontColour.black,
                                              normalSpacing: true),
                                        ))
                                    : Showcase(
                                        key: _nine,
                                        description:
                                            'and just like that 🎉💃🏽CONGRATULATIONS🕺🏽🎉 on creating you first personal task\nKhaby lame reaction 🤷🏿',
                                        disposeOnTap: false,
                                        targetBorderRadius:
                                            BorderRadius.circular(8 * hsf),
                                        onTargetClick: () {
                                          FlutterLocalNotificationsPlugin
                                              flutterLocalNotificationsPlugin =
                                              FlutterLocalNotificationsPlugin();
                                          flutterLocalNotificationsPlugin
                                              .resolvePlatformSpecificImplementation<
                                                  AndroidFlutterLocalNotificationsPlugin>()
                                              ?.requestNotificationsPermission();
                                          setState(() async {
                                            if (titleComponent
                                                .titleText.isEmpty) {
                                              await showErrorDialog(context,
                                                  context.loc.titleEmpty);
                                              return;
                                            } else if (beginComponent
                                                .controller.text.isEmpty) {
                                              await showErrorDialog(context,
                                                  context.loc.beginEmpty);
                                              return;
                                            } else if (finishComponent
                                                .controller.text.isEmpty) {
                                              await showErrorDialog(context,
                                                  context.loc.finishEmpty);
                                              return;
                                            } else if (alertFrequency
                                                .text.isEmpty) {
                                              await showErrorDialog(
                                                  context, 'alert frequency');
                                              return;
                                            }
                                            setupnotification(
                                                _todo!.taskId,
                                                alarmtime(beginComponent.time,
                                                    alertTime.text),
                                                titleComponent.titleText,
                                                descriptioncontroller.text,
                                                alertFrequency.text);
                                            _todoService.updateTodo(
                                                todo: _todo!,
                                                title: titleComponent.titleText,
                                                done: false,
                                                startTime: beginComponent
                                                    .controller.text,
                                                endTime: finishComponent
                                                    .controller.text,
                                                dateOfCreation: null,
                                                alertTime: alertTextController
                                                        .text.isNotEmpty
                                                    ? alertTextController.text
                                                    : context.loc.createalert,
                                                alertFrequency: alertFrequency
                                                        .text.isNotEmpty
                                                    ? alertFrequency.text
                                                    : 'once',
                                                fileAttachment:
                                                    imageContoller.text,
                                                description:
                                                    descriptioncontroller.text,
                                                isAllDay: isAllDay,
                                                archived: null,
                                                accountAttachment: null,
                                                accountMessage: null);
                                            setState(() {
                                              saved = true;
                                              Navigator.of(context).pop();
                                            });
                                          });
                                        },
                                        onToolTipClick: null,
                                        child: TextButton(
                                            onPressed: () async {
                                              FlutterLocalNotificationsPlugin
                                                  flutterLocalNotificationsPlugin =
                                                  FlutterLocalNotificationsPlugin();
                                              flutterLocalNotificationsPlugin
                                                  .resolvePlatformSpecificImplementation<
                                                      AndroidFlutterLocalNotificationsPlugin>()
                                                  ?.requestNotificationsPermission();
                                              if (titleComponent
                                                  .titleText.isEmpty) {
                                                await showErrorDialog(context,
                                                    context.loc.titleEmpty);
                                                return;
                                              } else if (beginComponent
                                                  .controller.text.isEmpty) {
                                                await showErrorDialog(context,
                                                    context.loc.beginEmpty);
                                                return;
                                              } else if (finishComponent
                                                  .controller.text.isEmpty) {
                                                await showErrorDialog(context,
                                                    context.loc.finishEmpty);
                                                return;
                                              } else if (alertFrequency
                                                  .text.isEmpty) {
                                                await showErrorDialog(
                                                    context, 'alert frequency');
                                                return;
                                              }
                                              setupnotification(
                                                  _todo!.taskId,
                                                  alarmtime(beginComponent.time,
                                                      alertTime.text),
                                                  titleComponent.titleText,
                                                  descriptioncontroller.text,
                                                  alertFrequency.text);
                                              _todoService.updateTodo(
                                                  todo: _todo!,
                                                  title:
                                                      titleComponent.titleText,
                                                  done: false,
                                                  startTime: beginComponent
                                                      .controller.text,
                                                  endTime: finishComponent
                                                      .controller.text,
                                                  dateOfCreation: null,
                                                  alertTime: alertTextController
                                                          .text.isNotEmpty
                                                      ? alertTextController.text
                                                      : context.loc.createalert,
                                                  alertFrequency: alertFrequency
                                                          .text.isNotEmpty
                                                      ? alertFrequency.text
                                                      : 'once',
                                                  fileAttachment:
                                                      imageContoller.text,
                                                  description:
                                                      descriptioncontroller
                                                          .text,
                                                  isAllDay: isAllDay,
                                                  archived: null,
                                                  accountAttachment: null,
                                                  accountMessage: null);
                                              setState(() {
                                                saved = true;
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Text(
                                              context.loc.create,
                                              style: CustomTextStyle(
                                                  context: context,
                                                  fontSz: 17,
                                                  fontWght: Fontweight.w500,
                                                  colour: FontColour.black,
                                                  normalSpacing: true),
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
                      );
                    default:
                      return Scaffold(
                        body: Center(
                          child: Text(context.loc.while_we_can,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyle(
                                  context: context,
                                  fontSz: 16,
                                  fontWght: Fontweight.w300,
                                  colour: FontColour.black,
                                  normalSpacing: true)),
                        ),
                      );
                  }
                }),
          );
        }));
  }
}

String dateinWords(DateTime date, BuildContext context) {
  String weekday, day, month, year;
  weekday =
      Calendar(year: date.year, context: context).months[date.weekday]!.weekday;
  day = date.day.toString();
  month =
      Calendar(year: date.year, context: context).months[date.month]!.monthName;
  year = date.year.toString();
  return '$weekday, $day, $month, $year';
}

String time() {
  DateTime time = DateTime.now();
  String hour;
  String minute;
  if (time.hour < 10) {
    hour = '0${time.hour}';
  } else {
    hour = '${time.hour}';
  }
  if (time.minute <= 50) {
    minute = '${time.minute + 10}';
  } else {
    minute = '0${10 + (time.minute - 60)}';
    if (time.hour == 23) {
      hour = '00';
    } else if (time.hour < 9) {
      hour = '0${time.hour + 1}';
    } else {
      hour = '${time.hour + 1}';
    }
  }
  return '$hour:$minute';
}
