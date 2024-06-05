// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:two_a/ads/ads_state.dart';
import 'package:two_a/components/DateOnPress/contacts_container.dart';
import 'package:two_a/components/DateOnPress/filter_row.dart';
import 'package:two_a/components/DateOnPress/switch_bar2do.dart';
import 'package:two_a/components/DateOnPress/to_acc.dart';
import 'package:two_a/components/DateOnPress/todo_list_view.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/calendar.dart';
import 'package:two_a/components/cloudOnlineprofile/contact.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/database/cloud/cloud_work.dart';
import 'package:two_a/database/cloud/firebase_cloud_storage.dart';
import 'package:two_a/database/local/database_service.dart';
import 'package:two_a/database/local/database_tables/online_userTable.dart';
import 'package:two_a/database/local/database_tables/personal_diary.dart';
import 'package:two_a/database/local/database_tables/personal_task_table.dart';
import 'package:two_a/database/local/database_tables/user_table.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/firebase/authentication/fireauth.dart';
import 'package:two_a/firebase/authentication/service.dart';
import 'package:two_a/firebase/bloc/auth_bloc.dart';
import 'package:two_a/main.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';
import 'package:two_a/views/home/components.dart';
import 'package:two_a/views/personal/Account/diary.dart';
import 'package:two_a/views/personal/Account/todo.dart';
import 'package:two_a/views/personal/Assign/assign.dart';
import 'package:two_a/views/personal/create_todo.dart';
import 'package:two_a/views/profile/user_profile.dart';
import 'package:two_a/views/profile/why_twoa.dart';

class DateOnPress2 extends StatefulWidget {
  final DateTime date;
  final bool? onTutorial;
  final bool main;
  final int? v;
  final List<DateTime>? week;
  final bool? isWeek;
  final String? month;
  final String? year;
  final BuildContext context;
  const DateOnPress2(
      {required this.date,
      super.key,
      required this.context,
      this.week,
      this.isWeek,
      required this.main,
      this.month,
      this.year,
      this.onTutorial,
      this.v});

  static const String routeName = '/dateOnPress2';

  @override
  State<DateOnPress2> createState() => _DateOnPress2State();
}

class _DateOnPress2State extends State<DateOnPress2>
    with TickerProviderStateMixin {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();
  final GlobalKey _six = GlobalKey();
  final GlobalKey _seven = GlobalKey();
  final GlobalKey _eight = GlobalKey();
  final GlobalKey _nine = GlobalKey();
  final GlobalKey _ten = GlobalKey();
  final GlobalKey _eleven = GlobalKey();
  final GlobalKey _twelve = GlobalKey();
  final GlobalKey _thirteen = GlobalKey();
  final GlobalKey _fourteen = GlobalKey();
  final GlobalKey _fifteen = GlobalKey();
  final GlobalKey _sixteen = GlobalKey();
  final GlobalKey _seventeen = GlobalKey();

  bool revealwalkthrough = false;
  late bool hintsEnabled;
  int v = 1;
  late final LocalDatabaseService _databaseService;
  late final FirebaseCloudStorage _cloudService;
  late final OnlineUser onlineUser;
  String get userEmail => Service(FireAuth()).currentUser!.email;
  String get userId => Service(FireAuth()).currentUser!.id;
  int index = 1;
  final GlobalKey<RefreshIndicatorState> _trigger =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _trigger1 =
      GlobalKey<RefreshIndicatorState>();
  late Future<List> futurelist;
  bool all = false;
  bool open = true;
  bool archived = false;
  bool closed = false;
  List<bool> home = List.filled(5, false);
  late int allCount;
  late int openCount;
  late int archivedCount;
  late int closedCount;
  bool scrolllimitreached = false;
  bool reveal = false;
  List<CloudWork> asynchome = [];
  List<CloudWork> asyncwork = [];
  Map<String, CloudWork> asyncmap = {};
  ScrollController scrollController = ScrollController();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  StreamController<List<CloudWork>> assignedcontroller =
      StreamController<List<CloudWork>>.broadcast();

  late List<BannerAd> banner = [];
  BuildContext? myContext;
  @override
  void initState() {
    v = widget.v ?? 1;
    _databaseService = LocalDatabaseService();
    _cloudService = FirebaseCloudStorage();
    futurelist = flist(_databaseService, userEmail, userId, widget.main);

    home[0] = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      (widget.main == false && widget.onTutorial == null)
          ? null
          : Future.delayed(const Duration(milliseconds: 200), () {
              widget.onTutorial ?? false
                  ? ShowCaseWidget.of(myContext!).startShowCase([_seventeen])
                  : ShowCaseWidget.of(myContext!).startShowCase(
                      [_one, _two, _three, _four, _twelve, _fifteen, _sixteen]);
            });
    });
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   ShowCaseWidget.of(context)
    //       .startShowCase([_one, _two, _three, _four, _twelve, _fifteen]);
    // });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    _databaseService;
    _cloudService;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> days = [
      context.loc.monday,
      context.loc.tuesday,
      context.loc.wednesday,
      context.loc.thursday,
      context.loc.friday,
      context.loc.saturday,
      context.loc.sunday,
    ];
    List<String> actions = [
      context.loc.tassign,
      context.loc.tdo,
      context.loc.toaccount
    ];
    String dayInWords = days[widget.date.weekday - 1];
    String dateNumber = (widget.date.day).toString();
    String monthName = Calendar(year: DateTime.now().year, context: context)
        .months[widget.date.month]!
        .monthName;
    List<CloudWork> openCloudAssigns = [];
    List<CloudWork> allCloudAssigns = [];

    String year = widget.date.year.toString();
    final width = context.scaleFactor.width;
    final height = context.scaleFactor.height;
    final hsf = context.scaleFactor.hsf;
    final wsf = context.scaleFactor.wsf;
    final length = 98 * hsf;

    var appBa = CustomAppbar(
      context: widget.context,
      locTitle: null,
      tab: true,
      back: widget.main ? false : true,
      appBarRequired: widget.main ? false : true,
      main: widget.main,
      onTap: () {
        setState(() {
          v = 1;
          DefaultTabController.of(context).animateTo(1);
        });
      },
    );
    final h = height - appBa.preferredSize.height - length;
    final bool OnTut;
    if (widget.onTutorial == null || widget.onTutorial == false) {
      OnTut = false;
    } else {
      OnTut = true;
    }
    return ShowCaseWidget(
      enableShowcase: widget.main || OnTut,
      builder: Builder(builder: (context) {
        myContext = context;
        return FutureBuilder(
            future: futurelist,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  DatabaseUser databaseUser = snapshot.data![0];

                  OnlineUser onlineUser = snapshot.data![1];
                  Stream start = _databaseService.theDaysTodos(
                      databaseUser, widget.date, widget.isWeek, widget.week);
                  Stream start2 = _databaseService.theDaysTodos2(
                      databaseUser, widget.date, widget.isWeek, widget.week);
                  return DefaultTabController(
                    initialIndex: index,
                    length: 3,
                    child: Builder(
                      builder: (BuildContext context) {
                        DefaultTabController.of(context).addListener(
                          () {
                            switch (DefaultTabController.of(context).index) {
                              case 0:
                              case 1:
                              case 2:
                                setState(() {
                                  v = 1;
                                });
                                break;
                              default:
                            }
                          },
                        );

                        return Scaffold(
                          appBar: AppBar(
                            toolbarHeight: 91 * hsf - 48,
                            actions: [
                              Showcase(
                                key: _fifteen,
                                description:
                                    'finding your work, done in the past 🗿\nor planned for the future 🚀',
                                disposeOnTap: true,
                                targetBorderRadius:
                                    BorderRadius.circular(32 * hsf),
                                onTargetClick: () {
                                  setState(() {
                                    v = 1;
                                    DefaultTabController.of(context)
                                        .animateTo(1);
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (contex) => UserProfile(
                                          contexti: context,
                                          onTutorial: true,
                                          addContactTutorial: false,
                                        ),
                                      )).then((_) async {
                                    await Future.delayed(
                                        const Duration(milliseconds: 1000));
                                    ShowCaseWidget.of(context)
                                        .startShowCase([_sixteen]);
                                  });
                                },
                                onToolTipClick: () {
                                  setState(() {
                                    v = 1;
                                    DefaultTabController.of(context)
                                        .animateTo(1);
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (contex) => UserProfile(
                                          contexti: context,
                                          onTutorial: true,
                                          addContactTutorial: false,
                                        ),
                                      )).then((_) async {
                                    await Future.delayed(
                                        const Duration(milliseconds: 1000));
                                    ShowCaseWidget.of(context)
                                        .startShowCase([_sixteen]);
                                  });
                                },
                                child: Showcase(
                                  key: _three,
                                  onTargetClick: () {
                                    setState(() {
                                      v = 1;
                                      DefaultTabController.of(context)
                                          .animateTo(1);
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (contex) => UserProfile(
                                            contexti: context,
                                            onTutorial: true,
                                            addContactTutorial: true,
                                          ),
                                        )).then((_) async {
                                      await Future.delayed(
                                          const Duration(milliseconds: 1000));
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_four]);
                                    });
                                  },
                                  onToolTipClick: () {
                                    setState(() {
                                      v = 1;
                                      DefaultTabController.of(context)
                                          .animateTo(1);
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (contex) => UserProfile(
                                            contexti: context,
                                            onTutorial: true,
                                            addContactTutorial: true,
                                          ),
                                        )).then((_) async {
                                      await Future.delayed(
                                          const Duration(milliseconds: 1000));
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_four]);
                                    });
                                  },
                                  disposeOnTap: true,
                                  description: 'Add a home contact ☎️',
                                  targetBorderRadius:
                                      BorderRadius.circular(32 * hsf),
                                  child: Material(
                                    color: const Colour().lbg,
                                    borderRadius: BorderRadius.circular(
                                        48 * context.scaleFactor.hsf),
                                    clipBehavior: Clip.hardEdge,
                                    child: InkWell(
                                      onTap: widget.main
                                          ? () {
                                              setState(() {
                                                v = 1;
                                                DefaultTabController.of(context)
                                                    .animateTo(1);
                                              });
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                    builder: (contex) =>
                                                        UserProfile(
                                                      contexti: context,
                                                    ),
                                                  ));
                                            }
                                          : null,
                                      child: Semantics(
                                        label: context.loc.menu,
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              6 * context.scaleFactor.hsf),
                                          child: Container(
                                            width: 42 * context.scaleFactor.hsf,
                                            height:
                                                42 * context.scaleFactor.hsf,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: .6,
                                                color: const Colour().lHint,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.person_rounded,
                                              size:
                                                  22 * context.scaleFactor.hsf,
                                              color: widget.main
                                                  ? const Colour().black
                                                  : const Colour().lHint,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            backgroundColor: const Colour().lbg,
                            bottom: TabBar(
                              //isScrollable: true,
                              dividerColor: const Colour().black,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorColor: const Colour().black,
                              indicatorWeight: 2.0,
                              labelColor: const Colour().black,
                              labelStyle: CustomTextStyle(
                                  context: context,
                                  fontSz: 16,
                                  fontWght: Fontweight.w700,
                                  colour: FontColour.black,
                                  normalSpacing: true),
                              unselectedLabelColor: const Colour().lHint,
                              tabs: <Widget>[
                                Showcase(
                                  key: _eight,
                                  disableBarrierInteraction: true,
                                  description:
                                      'Hurray we are done delegating, a little dance\nwont hurt anyone 💃🏾🕺\nWait a minute ✋🏽 your contacts may also have\nwork for you.To view 👀 tasks from home contacts\ntap "Home" on the navigation bar',
                                  disposeOnTap: true,
                                  onTargetClick: () {
                                    setState(() {
                                      DefaultTabController.of(context)
                                          .animateTo(0);
                                      v = 0;
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_nine]);
                                    });
                                  },
                                  onToolTipClick: () {
                                    setState(() {
                                      DefaultTabController.of(context)
                                          .animateTo(0);
                                      v = 0;
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_nine]);
                                    });
                                  },
                                  child: Container(
                                    height: 48,
                                    width: 0.3 * context.scaleFactor.width,
                                    alignment: Alignment.bottomCenter,
                                    child: Tab(
                                      height: 26 * context.scaleFactor.hsf,
                                      text: context.loc.home,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 48,
                                  width: 0.4 * context.scaleFactor.width,
                                  alignment: Alignment.bottomCenter,
                                  child: Tab(
                                    height: 26 * context.scaleFactor.hsf,
                                    text: context.loc.personal,
                                  ),
                                ),
                                Showcase(
                                  key: _ten,
                                  description:
                                      'Just like it was at "Home", tasks assigned\nto you by work contacts will appear here.\nTo view 👀 tasks from work contacts,\ntap "Work" on the navigation bar ',
                                  disableBarrierInteraction: true,
                                  disposeOnTap: true,
                                  onTargetClick: () {
                                    setState(() {
                                      DefaultTabController.of(context)
                                          .animateTo(2);
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_eleven]);
                                    });
                                  },
                                  onToolTipClick: () {
                                    setState(() {
                                      DefaultTabController.of(context)
                                          .animateTo(2);
                                      ShowCaseWidget.of(context)
                                          .startShowCase([_eleven]);
                                    });
                                  },
                                  child: Container(
                                    height: 48,
                                    width: 0.3 * context.scaleFactor.width,
                                    alignment: Alignment.bottomCenter,
                                    child: Tab(
                                      height: 26 * context.scaleFactor.hsf,
                                      text: context.loc.work,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            elevation: 3,
                            leading: Material(
                              borderRadius: BorderRadius.circular(48 * hsf),
                              clipBehavior: Clip.hardEdge,
                              color: const Colour().lbg,
                              child: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const StaticTextWidget())),
                                child: Showcase(
                                  key: _sixteen,
                                  description: 'Why 2A 🤷?',
                                  targetBorderRadius:
                                      BorderRadius.circular(48 * hsf),
                                  disposeOnTap: true,
                                  onTargetClick: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const StaticTextWidget()));
                                  },
                                  onToolTipClick: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const StaticTextWidget()));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        6.0 * context.scaleFactor.hsf),
                                    child: Image.asset(
                                      'images/logo/logo1.png',
                                      height: 48 * context.scaleFactor.hsf,
                                      width: 48 * context.scaleFactor.hsf,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          body: GestureDetector(
                            onTap: () {
                              if (_controller.isCompleted) {
                                _controller.reverse();
                              }
                            },
                            child: TabBarView(
                              physics: widget.isWeek ?? false
                                  ? const NeverScrollableScrollPhysics()
                                  : null,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    databaseUser.hintsEnabled
                                        ? Positioned(
                                            top: 0,
                                            child: Material(
                                              color: const Colour().lbg,
                                              child: InkWell(
                                                onTap: () async {
                                                  await infoDialog(
                                                      context,
                                                      context.loc.info,
                                                      context.loc.disableInfo);
                                                },
                                                child: databaseUser.hintsEnabled
                                                    ? Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 48 * hsf,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.info,
                                                              size: 14 * hsf,
                                                              color:
                                                                  const Colour()
                                                                      .purple,
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 6 *
                                                                            wsf)),
                                                            Text(
                                                                context.loc
                                                                    .homeinfoassigned,
                                                                style: CustomTextStyle(
                                                                    context:
                                                                        context,
                                                                    fontSz:
                                                                        11.6,
                                                                    colour: FontColour
                                                                        .purple))
                                                          ],
                                                        ),
                                                      )
                                                    : Container(),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Positioned(
                                        top: databaseUser.hintsEnabled
                                            ? 48 * hsf
                                            : 32 * hsf,
                                        child: HomeTitle(
                                          date: widget.date,
                                        )),
                                    Positioned(
                                        top: databaseUser.hintsEnabled
                                            ? 0.156 * height
                                            : 0.14 * height,
                                        child: SizedBox(
                                          width: 0.933 * width,
                                          height: 48 * hsf,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Material(
                                                color: const Colour().lbg,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8 * hsf),
                                                clipBehavior: Clip.hardEdge,
                                                child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        for (var i = 0;
                                                            i < 5;
                                                            i++) {
                                                          home[i] = false;
                                                        }
                                                        home[0] = true;
                                                      });
                                                    },
                                                    child: FilterRowPrimary(
                                                      text: context.loc.open,
                                                      active: home[0],
                                                      count: categoryNumbers(
                                                          asynchome, 'open'),
                                                      boxwidth: 0.083 * width,
                                                    )),
                                              ),
                                              Material(
                                                color: const Colour().lbg,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8 * hsf),
                                                clipBehavior: Clip.hardEdge,
                                                child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        for (var i = 0;
                                                            i < 5;
                                                            i++) {
                                                          home[i] = false;
                                                        }
                                                        home[1] = true;
                                                      });
                                                    },
                                                    child: FilterRowPrimary(
                                                      text: context.loc.todo,
                                                      active: home[1],
                                                      count: categoryNumbers(
                                                          asynchome, 'todo'),
                                                      boxwidth: 0.078 * width,
                                                    )),
                                              ),
                                              Material(
                                                color: const Colour().lbg,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8 * hsf),
                                                clipBehavior: Clip.hardEdge,
                                                child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        for (var i = 0;
                                                            i < 5;
                                                            i++) {
                                                          home[i] = false;
                                                        }
                                                        home[2] = true;
                                                      });
                                                    },
                                                    child: FilterRowPrimary(
                                                      text: context.loc.pending,
                                                      active: home[2],
                                                      count: categoryNumbers(
                                                          asynchome, 'pending'),
                                                      boxwidth: 0.132 * width,
                                                    )),
                                              ),
                                              Material(
                                                color: const Colour().lbg,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8 * hsf),
                                                clipBehavior: Clip.hardEdge,
                                                child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        for (var i = 0;
                                                            i < 5;
                                                            i++) {
                                                          home[i] = false;
                                                        }
                                                        home[3] = true;
                                                      });
                                                    },
                                                    child: FilterRowPrimary(
                                                      text: context.loc.done,
                                                      active: home[3],
                                                      count: categoryNumbers(
                                                          asynchome, 'done'),
                                                      boxwidth: 0.084 * width,
                                                    )),
                                              ),
                                              Material(
                                                color: const Colour().lbg,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8 * hsf),
                                                clipBehavior: Clip.hardEdge,
                                                child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        for (var i = 0;
                                                            i < 5;
                                                            i++) {
                                                          home[i] = false;
                                                        }
                                                        home[4] = true;
                                                      });
                                                    },
                                                    child: FilterRowPrimary(
                                                      text:
                                                          context.loc.archived,
                                                      active: home[4],
                                                      count: categoryNumbers(
                                                          asynchome,
                                                          'archived'),
                                                      boxwidth: 0.140 * width,
                                                    )),
                                              )
                                            ],
                                          ),
                                        )),
                                    Positioned(
                                        top: 0.249 * height,
                                        child: Showcase(
                                          key: _nine,
                                          description:
                                              'Tasks assigned to you by your home 🏡 contacts\nwill appear here. \nTasks also assigned to you by contacts not on your contact lists 🕵🏽 will appear here. However, such tasks upon opening. You will be directed to  the "add contact" page first. Then you may proceed to view 👀 the task.\nFor all delegated tasks you have the liberty to accept or deny them.\nYou also can chat 🗨 with the assigner before\naccepting or declining. \nThe time of the tasks, are local time regardless of the assigner\'s location 🌍. 2A synchronizes time for you.',
                                          disableBarrierInteraction: true,
                                          onTargetClick: () {
                                            ShowCaseWidget.of(context)
                                                .startShowCase([_ten]);
                                          },
                                          onToolTipClick: () {
                                            ShowCaseWidget.of(context)
                                                .startShowCase([_ten]);
                                          },
                                          disposeOnTap: true,
                                          child: Container(
                                            alignment: Alignment.topCenter,
                                            height: height -
                                                appBa.preferredSize.height -
                                                .249 * height,
                                            width: 0.933 * width,
                                            child: StreamBuilder<
                                                    List<CloudWork>>(
                                                stream: widget.main
                                                    ? _cloudService
                                                        .allAssignedCloudWorks(
                                                        assignedId: userId,
                                                      )
                                                    : _cloudService
                                                        .allAssignedCloudWorks2(
                                                        assignedId: userId,
                                                        date: widget.date,
                                                      ),
                                                builder: (context, snapshot) {
                                                  switch (snapshot
                                                      .connectionState) {
                                                    case ConnectionState
                                                          .waiting:
                                                    case ConnectionState.active:
                                                      if (snapshot.hasData) {
                                                        final cloudWorks =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'CloudWorks');

                                                        for (CloudWork element
                                                            in snapshot.data ??
                                                                []) {
                                                          asyncmap.addAll({
                                                            element.documentId:
                                                                element
                                                          });
                                                        }

                                                        asynchome.clear();
                                                        asyncwork.clear();
                                                        asyncmap.forEach(
                                                            (key, value) {
                                                          if (existsinWorkContacts(
                                                              onlineUser,
                                                              value
                                                                  .assignerId)) {
                                                            asyncwork
                                                                .add(value);
                                                            asyncwork.sort(
                                                                ((a, b) => b
                                                                    .beginTime
                                                                    .compareTo(a
                                                                        .beginTime)));
                                                          } else {
                                                            asynchome
                                                                .add(value);
                                                            asynchome.sort(
                                                                ((a, b) => b
                                                                    .beginTime
                                                                    .compareTo(a
                                                                        .beginTime)));
                                                          }
                                                        });

                                                        return NotificationListener<
                                                            OverscrollNotification>(
                                                          onNotification:
                                                              (notification) {
                                                            if (notification
                                                                    .overscroll >
                                                                20) {
                                                              _trigger
                                                                  .currentState
                                                                  ?.show();
                                                            }
                                                            return true;
                                                          },
                                                          child:
                                                              RefreshIndicator(
                                                            displacement: 0,
                                                            edgeOffset:
                                                                height * 0.27,
                                                            color:
                                                                const Colour()
                                                                    .white,
                                                            backgroundColor:
                                                                const Colour()
                                                                    .primary,
                                                            key: _trigger,
                                                            notificationPredicate:
                                                                (ScrollNotification
                                                                    notification) {
                                                              return false;
                                                            },
                                                            onRefresh:
                                                                () async {
                                                              Stream
                                                                  streamtoUse;
                                                              int numbertoadd =
                                                                  refreshLimit(
                                                                      asyncmap
                                                                          .length);
                                                              DocumentSnapshot
                                                                  startAfterDocument =
                                                                  await cloudWorks
                                                                      .doc(asyncmap
                                                                          .entries
                                                                          .last
                                                                          .value
                                                                          .documentId)
                                                                      .get();
                                                              Stream stream1 = cloudService.secondAllAssignedCloudWorks(
                                                                  assignedId:
                                                                      userId,
                                                                  documentSnapshot:
                                                                      startAfterDocument,
                                                                  numbertoadd:
                                                                      numbertoadd);
                                                              Stream stream2 = cloudService.secondAllAssignedCloudWorks2(
                                                                  assignedId:
                                                                      userId,
                                                                  date: widget
                                                                      .date,
                                                                  documentSnapshot:
                                                                      startAfterDocument,
                                                                  numbertoadd:
                                                                      numbertoadd);
                                                              widget.main
                                                                  ? streamtoUse =
                                                                      stream1
                                                                  : streamtoUse =
                                                                      stream2;
                                                              streamtoUse
                                                                  .listen(
                                                                      (event) {
                                                                for (CloudWork element
                                                                    in event) {
                                                                  asyncmap
                                                                      .addAll({
                                                                    element.documentId:
                                                                        element
                                                                  });
                                                                }
                                                                setState(() {});
                                                                asynchome
                                                                    .clear();
                                                                asyncwork
                                                                    .clear();
                                                                asyncmap.forEach(
                                                                    (key,
                                                                        value) {
                                                                  if (existsinWorkContacts(
                                                                      onlineUser,
                                                                      value
                                                                          .assignerId)) {
                                                                    asyncwork.add(
                                                                        value);
                                                                    asyncwork.sort(((a, b) => b
                                                                        .beginTime
                                                                        .compareTo(
                                                                            a.beginTime)));
                                                                  } else {
                                                                    asynchome.add(
                                                                        value);
                                                                    asynchome.sort(((a, b) => b
                                                                        .beginTime
                                                                        .compareTo(
                                                                            a.beginTime)));
                                                                  }
                                                                });
                                                              });
                                                            },
                                                            child:
                                                                CloudTodoListView(
                                                              isAssigner: false,
                                                              todo: listwithads(
                                                                  categorymessages(
                                                                      asynchome,
                                                                      home)),
                                                              user: onlineUser,
                                                              date: widget.date,
                                                              controller:
                                                                  scrollController,
                                                              onTap: () {
                                                                setState(() {
                                                                  v = 1;
                                                                  DefaultTabController.of(
                                                                          context)
                                                                      .animateTo(
                                                                          1);
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      return Container();
                                                    default:
                                                      return Container();
                                                  }
                                                }),
                                          ),
                                        )),
                                    Center(
                                      child: SizedBox(
                                        height:
                                            height - appBa.preferredSize.height,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    databaseUser.hintsEnabled
                                        ? Material(
                                            color: const Colour().lbg,
                                            child: InkWell(
                                              onTap: () {
                                                ShowCaseWidget.of(context)
                                                    .startShowCase([
                                                  _two,
                                                  _three,
                                                  _four,
                                                  _twelve,
                                                  _fifteen,
                                                  _sixteen
                                                ]);
                                              },
                                              child: Showcase(
                                                key: _one,
                                                onTargetLongPress: () {
                                                  ShowCaseWidget.of(context)
                                                      .dismiss();
                                                },
                                                description:
                                                    'Hi 👋🏽 i\'m 2A, welcome home 😀.\nI\'ll guide 🧭 you through the app on the following:\n\n#1. Creating a personal task\n#2. Adding a home contact\n#3. Assigning work to a contact\n#4. Accounting for a personal task\n#5. Retrieving your work stored in the app\n#6. Why 2A?\n\nTap on the tab above 👆🏼 to proceed\nYou can also jump steps by taping the inactive areas\nThere\'ll be lots of dry jokes 🤓 through out the tour\nBut if you want to cut to the chase\nLongpress the tab above to skip entire walkthrough',
                                                disableBarrierInteraction: true,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 0.0719 * height,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.info,
                                                        size: 14 * hsf,
                                                        color: const Colour()
                                                            .purple,
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left:
                                                                      6 * wsf)),
                                                      Text(
                                                          v == 0
                                                              ? context.loc
                                                                  .personalinfoassign
                                                              : v == 1
                                                                  ? context.loc
                                                                      .personalinfotodo
                                                                  : context.loc
                                                                      .personalinfoaccount,
                                                          style: CustomTextStyle(
                                                              context: context,
                                                              fontSz: 11.6,
                                                              colour: FontColour
                                                                  .purple))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 0.0449 * height,
                                          ),
                                    databaseUser.hintsEnabled
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 0.0149 * height))
                                        : Container(),
                                    SizedBox(
                                      height: 0.0719 * height,
                                      width: 0.928 * width,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Material(
                                            clipBehavior: Clip.hardEdge,
                                            borderRadius:
                                                BorderRadius.circular(48 * hsf),
                                            color: const Colour().lHint2,
                                            child: InkWell(
                                              splashColor:
                                                  const Colour().primary,
                                              onTap: (v == 0)
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        if (v >= 1) {
                                                          v--;
                                                        }
                                                      });
                                                    },
                                              child: Showcase(
                                                key: _four,
                                                description:
                                                    'Assign 📝 work to a contact 🚵🏾',
                                                targetBorderRadius:
                                                    BorderRadius.circular(
                                                        48 * hsf),
                                                onTargetClick: () {
                                                  setState(() {
                                                    if (v >= 1) {
                                                      v--;
                                                    }
                                                  });
                                                  ShowCaseWidget.of(context)
                                                      .startShowCase([_five]);
                                                },
                                                onToolTipClick: () {
                                                  setState(() {
                                                    if (v >= 1) {
                                                      v--;
                                                    }
                                                  });
                                                  ShowCaseWidget.of(context)
                                                      .startShowCase([_five]);
                                                },
                                                disposeOnTap: true,
                                                child: SizedBox(
                                                    width: 48 * hsf,
                                                    height: 48 * hsf,
                                                    child: Semantics(
                                                      label: context
                                                          .loc.navigateleft,
                                                      child: Icon(
                                                        Icons
                                                            .chevron_left_rounded,
                                                        color: (v == 0)
                                                            ? const Colour()
                                                                .lHint
                                                            : const Colour()
                                                                .black,
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          ),
                                          Showcase(
                                            key: _seventeen,
                                            disableBarrierInteraction: true,
                                            description:
                                                'As you can see the year is now 1997 🚂 and most probably theres nothing to see 👻 right? that is because no entries were made on that year 🤔. However, the takeaway is that the app enables you to have a concise record 📓 through your years🍂.Try to imagine 💭how difficult it is to know what you did three years ago.This, becomes even more daunting 😩 as the years pile on.\nHowever, with a tap, 2A comes to the rescue💪🏾,\nThis feature will not only be limited to personal tasks you also will have a record of your daily diary entries and all your task accounts',
                                            targetPadding: EdgeInsets.only(
                                                top: 12 * hsf,
                                                right: 36 * wsf,
                                                left: 36 * wsf),
                                            targetBorderRadius:
                                                BorderRadius.circular(8 * hsf),
                                            disposeOnTap: true,
                                            onTargetClick: () {
                                              Navigator.of(context).pop();
                                            },
                                            onToolTipClick: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: SwitchColumn(
                                                isWeek: widget.isWeek,
                                                month: widget.month,
                                                year: widget.year,
                                                week: widget.week,
                                                text1: actions[v],
                                                text2: dayInWords,
                                                text3: dateNumber,
                                                text4: monthName,
                                                text5: year),
                                          ),
                                          Material(
                                            clipBehavior: Clip.hardEdge,
                                            borderRadius:
                                                BorderRadius.circular(48 * hsf),
                                            color: const Colour().lHint2,
                                            child: InkWell(
                                              splashColor:
                                                  const Colour().primary,
                                              onTap: (v == 2)
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        if (v < 2) v++;
                                                      });
                                                    },
                                              child: Showcase(
                                                key: _twelve,
                                                description:
                                                    'Account 📝 for a personal task or create\na diary',
                                                targetBorderRadius:
                                                    BorderRadius.circular(
                                                        48 * hsf),
                                                disposeOnTap: true,
                                                onToolTipClick: () {
                                                  setState(() {
                                                    v = 2;
                                                  });
                                                  ShowCaseWidget.of(context)
                                                      .startShowCase(
                                                          [_thirteen]);
                                                },
                                                onTargetClick: () {
                                                  setState(() {
                                                    v = 2;
                                                  });
                                                  ShowCaseWidget.of(context)
                                                      .startShowCase(
                                                          [_thirteen]);
                                                },
                                                child: SizedBox(
                                                    width: 48 * hsf,
                                                    height: 48 * hsf,
                                                    child: Semantics(
                                                      label: context
                                                          .loc.navigateright,
                                                      child: Icon(
                                                        Icons
                                                            .chevron_right_rounded,
                                                        color: (v == 2)
                                                            ? const Colour()
                                                                .lHint
                                                            : const Colour()
                                                                .black,
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    StreamBuilder(
                                      stream: start,
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                          case ConnectionState.active:
                                            if (snapshot.hasData) {
                                              final allTodos = snapshot.data
                                                  as List<PersonalTodo>;
                                              allTodos.sort((a, b) => (DateTime
                                                          .parse(
                                                              b.dateOfCreation)
                                                      .microsecondsSinceEpoch)
                                                  .compareTo((DateTime.parse(
                                                          a.dateOfCreation)
                                                      .microsecondsSinceEpoch)));
                                              allCount = allTodos.length;
                                              final openTodos = allTodos
                                                  .where((element) =>
                                                      element.done == false &&
                                                      element.archived == false)
                                                  .toList();
                                              openCount = openTodos.length;
                                              final closedTodos = allTodos
                                                  .where((element) =>
                                                      element.done == true)
                                                  .toList();
                                              closedCount = closedTodos.length;
                                              final archivedTodos = allTodos
                                                  .where((element) =>
                                                      element.archived == true)
                                                  .toList();
                                              archivedCount =
                                                  archivedTodos.length;

                                              return v == 0
                                                  ? StreamBuilder<
                                                          List<CloudWork>>(
                                                      stream: widget.main
                                                          ? _cloudService
                                                              .allAssignerCloudWorks(
                                                              date: widget.date,
                                                              assignerId:
                                                                  userId.trim(),
                                                            )
                                                          : _cloudService
                                                              .allAssignerCloudWorks2(
                                                              date: widget.date,
                                                              assignerId:
                                                                  userId.trim(),
                                                            ),
                                                      builder:
                                                          (context, snapshot) {
                                                        switch (snapshot
                                                            .connectionState) {
                                                          case ConnectionState
                                                                .waiting:
                                                          case ConnectionState
                                                                .active:
                                                            if (snapshot
                                                                .hasData) {
                                                              allCloudAssigns = snapshot
                                                                  .data!
                                                                  .where((element) =>
                                                                      withinDate(
                                                                          element,
                                                                          widget
                                                                              .date))
                                                                  .toList();
                                                            }
                                                            return StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    StateSetter
                                                                        setState) {
                                                              return Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          Container(
                                                                        height: databaseUser.hintsEnabled
                                                                            ? (height -
                                                                                appBa.preferredSize.height -
                                                                                0.159 * height)
                                                                            : (height - appBa.preferredSize.height - 0.1169 * height),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: 0.0389 *
                                                                          height,
                                                                      child:
                                                                          Showcase(
                                                                        key:
                                                                            _seven,
                                                                        disableBarrierInteraction:
                                                                            true,
                                                                        description:
                                                                            "A list of the tasks you have assigned\nwill appear here 👇🏽. You will also be able to view \nthe status of the task.\nFor instance the delegate may decline 🙅,\nor accept 🙋 to do the task.They may also\nhave completed ✔ the task.\nEvery time the delegate completes a task.\nYou will be able to view their account and depending on whether ❓ you are satisfied 👍🏾 or not 👎🏾\nyou can mark as complete or 'still needs work'\nYou can also click the task to have real time\nconversation 💬 🗨 with the delegate by chatting",
                                                                        onTargetClick:
                                                                            () =>
                                                                                ShowCaseWidget.of(context).startShowCase([
                                                                          _eight
                                                                        ]),
                                                                        onToolTipClick:
                                                                            () =>
                                                                                ShowCaseWidget.of(context).startShowCase([
                                                                          _eight
                                                                        ]),
                                                                        disposeOnTap:
                                                                            true,
                                                                        child: SizedBox(
                                                                            height: databaseUser.hintsEnabled ? 0.6656 * height : 0.7076 * height,
                                                                            width: 0.859 * width,
                                                                            child: CloudTodoListView(
                                                                              user: onlineUser,
                                                                              isAssigner: true,
                                                                              todo: allCloudAssigns,
                                                                              date: widget.date,
                                                                              controller: scrollController,
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  v = 1;
                                                                                });
                                                                              },
                                                                            )),
                                                                      ),
                                                                    ),
                                                                    PositionedTransition(
                                                                        rect: RelativeRectTween(
                                                                            begin: RelativeRect.fromSize(
                                                                                Rect.fromLTWH(
                                                                                  0.776 * width,
                                                                                  databaseUser.hintsEnabled ? 0.5337 * height : 0.5757 * height,
                                                                                  0,
                                                                                  0.1439 * height,
                                                                                ),
                                                                                Size(
                                                                                  width,
                                                                                  databaseUser.hintsEnabled ? (height - appBa.preferredSize.height - 0.159 * height) : (height - appBa.preferredSize.height - 0.1169 * height),
                                                                                )),
                                                                            end: RelativeRect.fromSize(
                                                                                Rect.fromLTWH(
                                                                                  0.053 * width,
                                                                                  databaseUser.hintsEnabled ? 0.5337 * height : 0.5757 * height,
                                                                                  0.728 * width,
                                                                                  0.1439 * height,
                                                                                ),
                                                                                Size(
                                                                                  width,
                                                                                  databaseUser.hintsEnabled ? (height - appBa.preferredSize.height - 0.159 * height) : (height - appBa.preferredSize.height - 0.1169 * height),
                                                                                ))).animate(CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn)),
                                                                        child: Showcase(
                                                                          key:
                                                                              _six,
                                                                          disableBarrierInteraction:
                                                                              true,
                                                                          onTargetClick:
                                                                              () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute<void>(
                                                                                    builder: (context) => AssignWork(
                                                                                          isHome: true,
                                                                                          onTutorial: true,
                                                                                          contactEmail: databaseUser.email,
                                                                                          contactId: databaseUser.id,
                                                                                          ppicPath: null,
                                                                                          name: '2A_was_here',
                                                                                          date: widget.date,
                                                                                        ))).then((value) => ShowCaseWidget.of(context).startShowCase([_seven]));
                                                                          },
                                                                          onToolTipClick:
                                                                              () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute<void>(
                                                                                    builder: (context) => AssignWork(
                                                                                          isHome: true,
                                                                                          onTutorial: true,
                                                                                          contactEmail: databaseUser.email,
                                                                                          contactId: databaseUser.id,
                                                                                          ppicPath: null,
                                                                                          name: '2A_was_here',
                                                                                          date: widget.date,
                                                                                        ))).then((value) => ShowCaseWidget.of(context).startShowCase([_seven]));
                                                                          },
                                                                          disposeOnTap:
                                                                              true,
                                                                          targetBorderRadius:
                                                                              BorderRadius.circular(32 * hsf),
                                                                          description:
                                                                              'Sliding through 🏄🏾 give way 😎\nThis tab will host both the home 🏠 and work 💼 contacts.\nBy default, home contacts will appear, \nwork contacts can be viewed by selecting the briefcase icon 💼\nThe tab allows you to select the contact whom \nyou would like to delegate a task.\n\nDisclaimer📢: If you skipped the previous tutorial on "adding a home contact" chances are, the tab will be empty\n\nI will select on your behalf a contact by the name \n"2A_was_here" 🤓\nTap to continue',
                                                                          child: ClipRect(
                                                                              child: ContactsContainer(
                                                                            date:
                                                                                widget.date,
                                                                          )),
                                                                        )),
                                                                    Positioned(
                                                                      bottom: 0.0629 *
                                                                          height,
                                                                      right: 18 *
                                                                          wsf,
                                                                      child:
                                                                          Showcase(
                                                                        disableBarrierInteraction:
                                                                            true,
                                                                        key:
                                                                            _five,
                                                                        description:
                                                                            'Glad you made it this far 👏🏽\nThank you\nPreviously, we created a personal task remember?\nThat task is personal in the sense that\nyou will do it on your own\nHowever, at times you may have work todo📚\nBut🤦🏽, not in a position to do it\nThat is where "2 Assign" comes to the rescue🏋🏽\nas it enables you to delegate your tasks to others\nJust make sure you have an internet connection\nThen tap me to show you how',
                                                                        targetBorderRadius:
                                                                            BorderRadius.circular(48 *
                                                                                hsf),
                                                                        onTargetClick: (allCloudAssigns.length >=
                                                                                5)
                                                                            ? () async {
                                                                                await showErrorDialog(context, context.loc.dailyassignlimit);
                                                                              }
                                                                            : () async {
                                                                                if (_controller.isCompleted) {
                                                                                  await _controller.reverse();
                                                                                }
                                                                                if (await hasNetwork()) {
                                                                                  if (_controller.isDismissed) {
                                                                                    _controller.forward();
                                                                                    ShowCaseWidget.of(context).startShowCase([_six]);
                                                                                  }
                                                                                  if (_controller.isCompleted) {
                                                                                    _controller.reverse();
                                                                                  }
                                                                                } else {
                                                                                  await showErrorDialog(context, context.loc.unabletofetchinternet);
                                                                                }
                                                                              },
                                                                        onToolTipClick: (allCloudAssigns.length >=
                                                                                5)
                                                                            ? () async {
                                                                                await showErrorDialog(context, context.loc.dailyassignlimit);
                                                                              }
                                                                            : () async {
                                                                                if (_controller.isCompleted) {
                                                                                  await _controller.reverse();
                                                                                }
                                                                                if (await hasNetwork()) {
                                                                                  if (_controller.isDismissed) {
                                                                                    _controller.forward();
                                                                                    ShowCaseWidget.of(context).startShowCase([_six]);
                                                                                  }
                                                                                  if (_controller.isCompleted) {
                                                                                    _controller.reverse();
                                                                                  }
                                                                                } else {
                                                                                  await showErrorDialog(context, context.loc.unabletofetchinternet);
                                                                                }
                                                                              },
                                                                        disposeOnTap:
                                                                            true,
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              48 * hsf,
                                                                          width:
                                                                              48 * hsf,
                                                                          child: widget.main
                                                                              ? FloatingActionButton(
                                                                                  backgroundColor: (allCloudAssigns.length >= 5) ? const Colour().lHint : const Colour().purple,
                                                                                  onPressed: (allCloudAssigns.length >= 5)
                                                                                      ? () async {
                                                                                          await showErrorDialog(context, context.loc.dailyassignlimit);
                                                                                        }
                                                                                      : () async {
                                                                                          if (await hasNetwork()) {
                                                                                            if (_controller.isDismissed) {
                                                                                              _controller.forward();
                                                                                            }
                                                                                            if (_controller.isCompleted) {
                                                                                              _controller.reverse();
                                                                                            }
                                                                                          } else {
                                                                                            await showErrorDialog(context, context.loc.unabletofetchinternet);
                                                                                          }
                                                                                        },
                                                                                  child: Semantics(
                                                                                    label: context.loc.addassign,
                                                                                    child: Icon(
                                                                                      Icons.add,
                                                                                      color: const Colour().white,
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : null,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ]);
                                                            });

                                                          default:
                                                            return Container();
                                                        }
                                                      })
                                                  : v == 1
                                                      ? Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Center(
                                                              child: Container(
                                                                height: databaseUser
                                                                        .hintsEnabled
                                                                    ? (height -
                                                                        appBa
                                                                            .preferredSize
                                                                            .height -
                                                                        0.159 *
                                                                            height)
                                                                    : (height -
                                                                        appBa
                                                                            .preferredSize
                                                                            .height -
                                                                        0.1169 *
                                                                            height),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: .0209 *
                                                                  height,
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .topCenter,
                                                                height:
                                                                    48 * hsf,
                                                                width: width,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          archived =
                                                                              false;
                                                                          closed =
                                                                              false;
                                                                          open =
                                                                              true;
                                                                          all =
                                                                              false;
                                                                        });
                                                                      },
                                                                      style: TextButton.styleFrom(
                                                                          foregroundColor: const Colour()
                                                                              .black,
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              0)),
                                                                      child: FilterRow(
                                                                          text: context
                                                                              .loc
                                                                              .open,
                                                                          active:
                                                                              open,
                                                                          count:
                                                                              openCount),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          archived =
                                                                              false;
                                                                          closed =
                                                                              true;
                                                                          open =
                                                                              false;
                                                                          all =
                                                                              false;
                                                                        });
                                                                      },
                                                                      style: TextButton.styleFrom(
                                                                          foregroundColor: const Colour()
                                                                              .black,
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              0)),
                                                                      child: FilterRow(
                                                                          text: context
                                                                              .loc
                                                                              .closed,
                                                                          active:
                                                                              closed,
                                                                          count:
                                                                              closedCount),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          archived =
                                                                              true;
                                                                          closed =
                                                                              false;
                                                                          open =
                                                                              false;
                                                                          all =
                                                                              false;
                                                                        });
                                                                      },
                                                                      style: TextButton.styleFrom(
                                                                          foregroundColor: const Colour()
                                                                              .black,
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              0)),
                                                                      child: FilterRow(
                                                                          text: context
                                                                              .loc
                                                                              .archived,
                                                                          active:
                                                                              archived,
                                                                          count:
                                                                              archivedCount),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          archived =
                                                                              false;
                                                                          closed =
                                                                              false;
                                                                          open =
                                                                              false;
                                                                          all =
                                                                              true;
                                                                        });
                                                                      },
                                                                      style: TextButton.styleFrom(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              0),
                                                                          minimumSize: Size.fromWidth(40 *
                                                                              wsf),
                                                                          foregroundColor:
                                                                              const Colour().black),
                                                                      child: FilterRow(
                                                                          text: context
                                                                              .loc
                                                                              .all,
                                                                          active:
                                                                              all,
                                                                          count:
                                                                              allCount),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 0.1139 *
                                                                  height,
                                                              child: SizedBox(
                                                                height: databaseUser
                                                                        .hintsEnabled
                                                                    ? 0.5907 *
                                                                        height
                                                                    : 0.6326 *
                                                                        height,
                                                                width: 0.859 *
                                                                    width,
                                                                child:
                                                                    TodoListView(
                                                                  todo: all
                                                                      ? listwithads(
                                                                          allTodos)
                                                                      : open
                                                                          ? listwithads(
                                                                              openTodos)
                                                                          : closed
                                                                              ? listwithads(closedTodos)
                                                                              : archived
                                                                                  ? listwithads(archivedTodos)
                                                                                  : listwithads(allTodos),
                                                                  isweek: widget
                                                                          .isWeek ??
                                                                      false,
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                                bottom: 0.0629 *
                                                                    height,
                                                                right: 18 * wsf,
                                                                child: Showcase(
                                                                  key: _two,
                                                                  description:
                                                                      'create your first personal task',
                                                                  disposeOnTap:
                                                                      true,
                                                                  onTargetClick:
                                                                      () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute<void>(
                                                                          builder: (_) =>
                                                                              CreatePersonalTodo(
                                                                            date:
                                                                                widget.date,
                                                                            todo:
                                                                                null,
                                                                            user:
                                                                                databaseUser,
                                                                            onTutorial:
                                                                                true,
                                                                          ),
                                                                        )).then((_) async {
                                                                      await Future.delayed(const Duration(
                                                                          milliseconds:
                                                                              1000));
                                                                      ShowCaseWidget.of(
                                                                              context)
                                                                          .startShowCase([
                                                                        _three
                                                                      ]);
                                                                    });
                                                                  },
                                                                  onToolTipClick:
                                                                      () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute<void>(
                                                                          builder: (_) =>
                                                                              CreatePersonalTodo(
                                                                            date:
                                                                                widget.date,
                                                                            todo:
                                                                                null,
                                                                            user:
                                                                                databaseUser,
                                                                            onTutorial:
                                                                                true,
                                                                          ),
                                                                        )).then((_) async {
                                                                      await Future.delayed(const Duration(
                                                                          milliseconds:
                                                                              1000));
                                                                      ShowCaseWidget.of(
                                                                              context)
                                                                          .startShowCase([
                                                                        _three
                                                                      ]);
                                                                    });
                                                                  },
                                                                  targetShapeBorder:
                                                                      const CircleBorder(),
                                                                  child:
                                                                      SizedBox(
                                                                    height: 48 *
                                                                        hsf,
                                                                    width: 48 *
                                                                        hsf,
                                                                    child:
                                                                        FloatingActionButton(
                                                                      tooltip: context
                                                                          .loc
                                                                          .addtodo,
                                                                      backgroundColor:
                                                                          const Colour()
                                                                              .primary,
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute<void>(
                                                                              builder: (context) => CreatePersonalTodo(
                                                                                date: widget.date,
                                                                                todo: null,
                                                                                user: databaseUser,
                                                                              ),
                                                                            ));
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        semanticLabel: context
                                                                            .loc
                                                                            .addtodo,
                                                                        Icons
                                                                            .add,
                                                                        color: const Colour()
                                                                            .lbg,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )),
                                                          ],
                                                        )
                                                      : Column(
                                                          children: [
                                                            Padding(
                                                                padding: EdgeInsets.only(
                                                                    bottom: 60 *
                                                                        hsf)),
                                                            widget.isWeek ??
                                                                    false
                                                                ? StreamBuilder<
                                                                        List<
                                                                            PersonalDiary>>(
                                                                    stream: localService.diarycollection(
                                                                        databaseUser,
                                                                        widget
                                                                            .week!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      switch (snapshot
                                                                          .connectionState) {
                                                                        case ConnectionState
                                                                              .active:
                                                                        case ConnectionState
                                                                              .waiting:
                                                                          List<PersonalDiary>
                                                                              diaries =
                                                                              [];
                                                                          if (snapshot
                                                                              .hasData) {
                                                                            diaries =
                                                                                snapshot.data ?? [];
                                                                            return TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute<void>(
                                                                                        builder: (context) => AccountPersonalTasks(
                                                                                          userEmail: userEmail,
                                                                                          userId: userId,
                                                                                          todos: allTodos,
                                                                                          diaries: diaries,
                                                                                          isweek: true,
                                                                                          month: widget.month,
                                                                                          year: widget.year,
                                                                                          date: widget.date.toString(),
                                                                                          forDiary: true,
                                                                                          week: widget.week,
                                                                                        ),
                                                                                      ));
                                                                                },
                                                                                child: ButtonContainer(buttonText: context.loc.diary));
                                                                          }
                                                                          {
                                                                            return Container();
                                                                          }

                                                                        default:
                                                                          return Container();
                                                                      }
                                                                    })
                                                                : Showcase(
                                                                    key:
                                                                        _thirteen,
                                                                    disableBarrierInteraction:
                                                                        true,
                                                                    description:
                                                                        '2A supports journaling as well, and\nas you can tell, I live alone here 🙇🏾\n🤷🏿and it goes without saying\nyour secrets are safe 💯 with me\nTap to add a diary entry.',
                                                                    onTargetClick:
                                                                        () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute<void>(
                                                                              builder: (context) => AccountPersonalDiary(
                                                                                    onTutorial: true,
                                                                                    date: widget.date.toString(),
                                                                                    email: userEmail,
                                                                                    id: userId,
                                                                                  ))).then((value) async {
                                                                        await Future.delayed(const Duration(
                                                                            milliseconds:
                                                                                800));
                                                                        ShowCaseWidget.of(context)
                                                                            .startShowCase([
                                                                          _fourteen
                                                                        ]);
                                                                      });
                                                                    },
                                                                    onToolTipClick:
                                                                        () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute<void>(
                                                                              builder: (context) => AccountPersonalDiary(
                                                                                    onTutorial: true,
                                                                                    date: widget.date.toString(),
                                                                                    email: userEmail,
                                                                                    id: userId,
                                                                                  ))).then((value) async {
                                                                        await Future.delayed(const Duration(
                                                                            milliseconds:
                                                                                800));
                                                                        ShowCaseWidget.of(context)
                                                                            .startShowCase([
                                                                          _fourteen
                                                                        ]);
                                                                      });
                                                                    },
                                                                    disposeOnTap:
                                                                        true,
                                                                    child: TextButton(
                                                                        onPressed: () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute<void>(
                                                                                  builder: (context) => AccountPersonalDiary(
                                                                                        date: widget.date.toString(),
                                                                                        email: userEmail,
                                                                                        id: userId,
                                                                                      )));
                                                                        },
                                                                        child: ButtonContainer(buttonText: context.loc.diary)),
                                                                  ),
                                                            Padding(
                                                                padding: EdgeInsets.only(
                                                                    bottom: 30 *
                                                                        hsf)),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute<void>(
                                                                        builder:
                                                                            (context) =>
                                                                                AccountPersonalTasks(
                                                                          todos:
                                                                              allTodos,
                                                                          date:
                                                                              '$dayInWords $dateNumber, $monthName, $year.',
                                                                          forDiary:
                                                                              false,
                                                                          isweek:
                                                                              widget.isWeek ?? false,
                                                                          week:
                                                                              widget.week,
                                                                          month:
                                                                              widget.month,
                                                                          year:
                                                                              widget.year,
                                                                          userEmail:
                                                                              userEmail,
                                                                          userId:
                                                                              userId,
                                                                        ),
                                                                      ));
                                                                },
                                                                child: Showcase(
                                                                  key:
                                                                      _fourteen,
                                                                  disableBarrierInteraction:
                                                                      true,
                                                                  description:
                                                                      'What does 2-Account mean 🤔 in the first place.\nRemember we created a "Personal Task"?\nWhile doing the personal task, you may have some notes about how you did the task or even files. Accounting is the process of recording this data for future reference😮.\nBy tapping "Tasks" you can view a list of that days\' "Personal Todos" and write an account of the task you wish.The interface is similar to the diary entry. \nTherefore, for accounting, I will leave it there as it is straight forward👉🏽',
                                                                  onTargetClick:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      v = 1;
                                                                    });
                                                                    ShowCaseWidget.of(
                                                                            context)
                                                                        .startShowCase([
                                                                      _fifteen
                                                                    ]);
                                                                  },
                                                                  onToolTipClick:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      v = 1;
                                                                    });
                                                                    ShowCaseWidget.of(
                                                                            context)
                                                                        .startShowCase([
                                                                      _fifteen
                                                                    ]);
                                                                  },
                                                                  disposeOnTap:
                                                                      true,
                                                                  child: ButtonContainer(
                                                                      buttonText:
                                                                          context
                                                                              .loc
                                                                              .tasks),
                                                                )),
                                                          ],
                                                        );
                                            } else {
                                              return StreamBuilder(
                                                  stream: widget.main
                                                      ? start
                                                      : start2,
                                                  builder: (context, snapshot) {
                                                    switch (snapshot
                                                        .connectionState) {
                                                      case ConnectionState
                                                            .waiting:
                                                      case ConnectionState
                                                            .active:
                                                        if (snapshot.hasData) {
                                                          final allTodos = snapshot
                                                                  .data
                                                              as List<
                                                                  PersonalTodo>;
                                                          allTodos.sort((a, b) => (DateTime
                                                                      .parse(b
                                                                          .dateOfCreation)
                                                                  .microsecondsSinceEpoch)
                                                              .compareTo((DateTime
                                                                      .parse(a
                                                                          .dateOfCreation)
                                                                  .microsecondsSinceEpoch)));
                                                          allCount =
                                                              allTodos.length;
                                                          final openTodos = allTodos
                                                              .where((element) =>
                                                                  element.done ==
                                                                      false &&
                                                                  element.archived ==
                                                                      false)
                                                              .toList();
                                                          openCount =
                                                              openTodos.length;
                                                          final closedTodos = allTodos
                                                              .where((element) =>
                                                                  element
                                                                      .done ==
                                                                  true)
                                                              .toList();
                                                          closedCount =
                                                              closedTodos
                                                                  .length;
                                                          final archivedTodos = allTodos
                                                              .where((element) =>
                                                                  element
                                                                      .archived ==
                                                                  true)
                                                              .toList();
                                                          archivedCount =
                                                              archivedTodos
                                                                  .length;
                                                          return v == 0
                                                              ? StreamBuilder<
                                                                      List<
                                                                          CloudWork>>(
                                                                  stream: widget
                                                                          .main
                                                                      ? _cloudService
                                                                          .allAssignerCloudWorks(
                                                                          date:
                                                                              widget.date,
                                                                          assignerId:
                                                                              userId.trim(),
                                                                        )
                                                                      : _cloudService
                                                                          .allAssignerCloudWorks2(
                                                                          date:
                                                                              widget.date,
                                                                          assignerId:
                                                                              userId.trim(),
                                                                        ),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    switch (snapshot
                                                                        .connectionState) {
                                                                      case ConnectionState
                                                                            .waiting:
                                                                      case ConnectionState
                                                                            .active:
                                                                        if (snapshot
                                                                            .hasData) {
                                                                          allCloudAssigns = snapshot
                                                                              .data!
                                                                              .where((element) => withinDate(element, widget.date))
                                                                              .toList();
                                                                        }
                                                                        return StatefulBuilder(builder: (BuildContext
                                                                                context,
                                                                            StateSetter
                                                                                setState) {
                                                                          return Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Center(
                                                                                  child: Container(
                                                                                    height: databaseUser.hintsEnabled ? (height - appBa.preferredSize.height - 0.159 * height) : (height - appBa.preferredSize.height - 0.1169 * height),
                                                                                  ),
                                                                                ),
                                                                                Positioned(
                                                                                  top: 0.0389 * height,
                                                                                  child: SizedBox(
                                                                                      height: databaseUser.hintsEnabled ? 0.6656 * height : 0.7076 * height,
                                                                                      width: 0.859 * width,
                                                                                      child: CloudTodoListView(
                                                                                        user: onlineUser,
                                                                                        isAssigner: true,
                                                                                        todo: allCloudAssigns,
                                                                                        date: widget.date,
                                                                                        controller: scrollController,
                                                                                      )),
                                                                                ),
                                                                                PositionedTransition(
                                                                                    rect: RelativeRectTween(
                                                                                        begin: RelativeRect.fromSize(
                                                                                            Rect.fromLTWH(
                                                                                              0.776 * width,
                                                                                              databaseUser.hintsEnabled ? 0.5337 * height : 0.5757 * height,
                                                                                              0,
                                                                                              0.1439 * height,
                                                                                            ),
                                                                                            Size(
                                                                                              width,
                                                                                              databaseUser.hintsEnabled ? (height - appBa.preferredSize.height - 0.159 * height) : (height - appBa.preferredSize.height - 0.1169 * height),
                                                                                            )),
                                                                                        end: RelativeRect.fromSize(
                                                                                            Rect.fromLTWH(
                                                                                              0.053 * width,
                                                                                              databaseUser.hintsEnabled ? 0.5337 * height : 0.5757 * height,
                                                                                              0.728 * width,
                                                                                              0.1439 * height,
                                                                                            ),
                                                                                            Size(
                                                                                              width,
                                                                                              databaseUser.hintsEnabled ? (height - appBa.preferredSize.height - 0.159 * height) : (height - appBa.preferredSize.height - 0.1169 * height),
                                                                                            ))).animate(CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn)),
                                                                                    child: ClipRect(
                                                                                        child: ContactsContainer(
                                                                                      date: widget.date,
                                                                                    ))),
                                                                                Positioned(
                                                                                  bottom: 0.0629 * height,
                                                                                  right: 18 * wsf,
                                                                                  child: SizedBox(
                                                                                    height: 48 * hsf,
                                                                                    width: 48 * hsf,
                                                                                    child: widget.main
                                                                                        ? FloatingActionButton(
                                                                                            backgroundColor: (allCloudAssigns.length >= 5) ? const Colour().lHint : const Colour().red,
                                                                                            onPressed: (allCloudAssigns.length >= 5)
                                                                                                ? () async {
                                                                                                    await showErrorDialog(context, context.loc.dailyassignlimit);
                                                                                                  }
                                                                                                : () async {
                                                                                                    if (await hasNetwork()) {
                                                                                                      if (_controller.isDismissed) {
                                                                                                        _controller.forward();
                                                                                                      }
                                                                                                      if (_controller.isCompleted) {
                                                                                                        _controller.reverse();
                                                                                                      }
                                                                                                    } else {
                                                                                                      await showErrorDialog(context, context.loc.unabletofetchinternet);
                                                                                                    }
                                                                                                  },
                                                                                            child: Semantics(
                                                                                              label: context.loc.addassign,
                                                                                              child: Icon(
                                                                                                Icons.add,
                                                                                                color: const Colour().white,
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        : null,
                                                                                  ),
                                                                                ),
                                                                              ]);
                                                                        });

                                                                      default:
                                                                        return Container();
                                                                    }
                                                                  })
                                                              : v == 1
                                                                  ? Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      children: [
                                                                        Center(
                                                                          child:
                                                                              Container(
                                                                            height: databaseUser.hintsEnabled
                                                                                ? (height - appBa.preferredSize.height - 0.159 * height)
                                                                                : (height - appBa.preferredSize.height - 0.1169 * height),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          top: .0209 *
                                                                              height,
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.topCenter,
                                                                            height:
                                                                                48 * hsf,
                                                                            width:
                                                                                width,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              children: [
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      archived = false;
                                                                                      closed = false;
                                                                                      open = false;
                                                                                      all = true;
                                                                                    });
                                                                                  },
                                                                                  style: TextButton.styleFrom(padding: const EdgeInsets.all(0), minimumSize: Size.fromWidth(40 * wsf), foregroundColor: const Colour().black),
                                                                                  child: FilterRow(text: context.loc.all, active: all, count: allCount),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      archived = false;
                                                                                      closed = false;
                                                                                      open = true;
                                                                                      all = false;
                                                                                    });
                                                                                  },
                                                                                  style: TextButton.styleFrom(foregroundColor: const Colour().black, padding: const EdgeInsets.all(0)),
                                                                                  child: FilterRow(text: context.loc.open, active: open, count: openCount),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      archived = false;
                                                                                      closed = true;
                                                                                      open = false;
                                                                                      all = false;
                                                                                    });
                                                                                  },
                                                                                  style: TextButton.styleFrom(foregroundColor: const Colour().black, padding: const EdgeInsets.all(0)),
                                                                                  child: FilterRow(text: context.loc.closed, active: closed, count: closedCount),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      archived = true;
                                                                                      closed = false;
                                                                                      open = false;
                                                                                      all = false;
                                                                                    });
                                                                                  },
                                                                                  style: TextButton.styleFrom(foregroundColor: const Colour().black, padding: const EdgeInsets.all(0)),
                                                                                  child: FilterRow(text: context.loc.archived, active: archived, count: archivedCount),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          top: 0.1139 *
                                                                              height,
                                                                          child:
                                                                              SizedBox(
                                                                            height: databaseUser.hintsEnabled
                                                                                ? 0.5907 * height
                                                                                : 0.6326 * height,
                                                                            width:
                                                                                0.859 * width,
                                                                            child:
                                                                                TodoListView(
                                                                              todo: all
                                                                                  ? listwithads(allTodos)
                                                                                  : open
                                                                                      ? listwithads(openTodos)
                                                                                      : closed
                                                                                          ? listwithads(closedTodos)
                                                                                          : archived
                                                                                              ? listwithads(archivedTodos)
                                                                                              : listwithads(allTodos),
                                                                              isweek: widget.isWeek ?? false,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                            bottom: 0.0629 *
                                                                                height,
                                                                            right: 18 *
                                                                                wsf,
                                                                            child:
                                                                                SizedBox(
                                                                              height: 48 * hsf,
                                                                              width: 48 * hsf,
                                                                              child: !(widget.isWeek == true)
                                                                                  ? FloatingActionButton(
                                                                                      tooltip: context.loc.addtodo,
                                                                                      backgroundColor: const Colour().primary,
                                                                                      onPressed: () {
                                                                                        Navigator.push(
                                                                                            context,
                                                                                            MaterialPageRoute<void>(
                                                                                              builder: (context) => CreatePersonalTodo(
                                                                                                date: widget.date,
                                                                                                todo: null,
                                                                                                user: databaseUser,
                                                                                              ),
                                                                                            ));
                                                                                      },
                                                                                      child: Icon(
                                                                                        semanticLabel: context.loc.addtodo,
                                                                                        Icons.add,
                                                                                        color: const Colour().lbg,
                                                                                      ),
                                                                                    )
                                                                                  : Container(),
                                                                            )),
                                                                        //
                                                                      ],
                                                                    )
                                                                  : Column(
                                                                      children: [
                                                                        Padding(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: 60 * hsf)),
                                                                        widget.isWeek ??
                                                                                false
                                                                            ? StreamBuilder<List<PersonalDiary>>(
                                                                                stream: localService.diarycollection(databaseUser, widget.week!),
                                                                                builder: (context, snapshot) {
                                                                                  switch (snapshot.connectionState) {
                                                                                    case ConnectionState.active:
                                                                                    case ConnectionState.waiting:
                                                                                      List<PersonalDiary> diaries = [];
                                                                                      if (snapshot.hasData) {
                                                                                        diaries = snapshot.data ?? [];
                                                                                        diaries.sort((a, b) => (DateTime.parse(b.dateOfCreation).microsecondsSinceEpoch).compareTo((DateTime.parse(a.dateOfCreation).microsecondsSinceEpoch)));
                                                                                        return TextButton(
                                                                                            onPressed: () {
                                                                                              Navigator.push(
                                                                                                  context,
                                                                                                  MaterialPageRoute<void>(
                                                                                                    builder: (context) => AccountPersonalTasks(
                                                                                                      userEmail: userEmail,
                                                                                                      userId: userId,
                                                                                                      todos: allTodos,
                                                                                                      diaries: diaries,
                                                                                                      isweek: true,
                                                                                                      month: widget.month,
                                                                                                      year: widget.year,
                                                                                                      date: widget.date.toString(),
                                                                                                      forDiary: true,
                                                                                                      week: widget.week,
                                                                                                    ),
                                                                                                  ));
                                                                                            },
                                                                                            child: ButtonContainer(buttonText: context.loc.diary));
                                                                                      }
                                                                                      {
                                                                                        return Container();
                                                                                      }

                                                                                    default:
                                                                                      return Container();
                                                                                  }
                                                                                })
                                                                            : TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute<void>(
                                                                                          builder: (context) => AccountPersonalDiary(
                                                                                                date: widget.date.toString(),
                                                                                                email: userEmail,
                                                                                                id: userId,
                                                                                              )));
                                                                                },
                                                                                child: ButtonContainer(buttonText: context.loc.diary)),
                                                                        Padding(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: 30 * hsf)),
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute<void>(
                                                                                    builder: (context) => AccountPersonalTasks(
                                                                                      todos: allTodos,
                                                                                      date: '$dayInWords $dateNumber, $monthName, $year.',
                                                                                      forDiary: false,
                                                                                      isweek: widget.isWeek ?? false,
                                                                                      week: widget.week,
                                                                                      month: widget.month,
                                                                                      year: widget.year,
                                                                                      userEmail: userEmail,
                                                                                      userId: userId,
                                                                                    ),
                                                                                  ));
                                                                            },
                                                                            child:
                                                                                ButtonContainer(buttonText: context.loc.tasks)),
                                                                      ],
                                                                    );
                                                        } else {
                                                          return Container();
                                                        }
                                                      default:
                                                        return Container();
                                                    }
                                                  });
                                            }
                                          default:
                                            return Container();
                                        }
                                      },
                                    )
                                  ],
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    databaseUser.hintsEnabled
                                        ? Positioned(
                                            top: 0,
                                            child: Material(
                                              color: const Colour().lbg,
                                              child: InkWell(
                                                onTap: () async {
                                                  await infoDialog(
                                                      context,
                                                      context.loc.info,
                                                      context.loc.disableInfo);
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 48 * hsf,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.info,
                                                        size: 14 * hsf,
                                                        color: const Colour()
                                                            .purple,
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left:
                                                                      6 * wsf)),
                                                      Text(
                                                          context.loc
                                                              .workinfoassigned,
                                                          style: CustomTextStyle(
                                                              context: context,
                                                              fontSz: 11.6,
                                                              colour: FontColour
                                                                  .purple))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Positioned(
                                        top: databaseUser.hintsEnabled
                                            ? 48 * hsf
                                            : 32 * hsf,
                                        child: HomeTitle(
                                          isHome: false,
                                          date: widget.date,
                                        )),
                                    Positioned(
                                        top: databaseUser.hintsEnabled
                                            ? 0.156 * height
                                            : 0.14 * height,
                                        child: SizedBox(
                                          width: 0.933 * width,
                                          height: 48 * hsf,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Material(
                                                color: const Colour().lbg,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8 * hsf),
                                                clipBehavior: Clip.hardEdge,
                                                child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        for (var i = 0;
                                                            i < 5;
                                                            i++) {
                                                          home[i] = false;
                                                        }
                                                        home[0] = true;
                                                      });
                                                    },
                                                    child: FilterRowPrimary(
                                                        isHome: false,
                                                        text: context.loc.open,
                                                        active: home[0],
                                                        boxwidth: 0.083 * width,
                                                        count: categoryNumbers(
                                                            asyncwork,
                                                            'open'))),
                                              ),
                                              Material(
                                                color: const Colour().lbg,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8 * hsf),
                                                clipBehavior: Clip.hardEdge,
                                                child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        for (var i = 0;
                                                            i < 5;
                                                            i++) {
                                                          home[i] = false;
                                                        }
                                                        home[1] = true;
                                                      });
                                                    },
                                                    child: FilterRowPrimary(
                                                        isHome: false,
                                                        text: context.loc.todo,
                                                        active: home[1],
                                                        boxwidth: 0.078 * width,
                                                        count: categoryNumbers(
                                                            asyncwork,
                                                            'todo'))),
                                              ),
                                              Material(
                                                color: const Colour().lbg,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8 * hsf),
                                                clipBehavior: Clip.hardEdge,
                                                child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        for (var i = 0;
                                                            i < 5;
                                                            i++) {
                                                          home[i] = false;
                                                        }
                                                        home[2] = true;
                                                      });
                                                    },
                                                    child: FilterRowPrimary(
                                                        isHome: false,
                                                        text:
                                                            context.loc.pending,
                                                        active: home[2],
                                                        boxwidth: 0.132 * width,
                                                        count: categoryNumbers(
                                                            asyncwork,
                                                            'pending'))),
                                              ),
                                              Material(
                                                color: const Colour().lbg,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8 * hsf),
                                                clipBehavior: Clip.hardEdge,
                                                child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        for (var i = 0;
                                                            i < 5;
                                                            i++) {
                                                          home[i] = false;
                                                        }
                                                        home[3] = true;
                                                      });
                                                    },
                                                    child: FilterRowPrimary(
                                                        isHome: false,
                                                        text: context.loc.done,
                                                        active: home[3],
                                                        boxwidth: 0.084 * width,
                                                        count: categoryNumbers(
                                                            asyncwork,
                                                            'done'))),
                                              ),
                                              Material(
                                                color: const Colour().lbg,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8 * hsf),
                                                clipBehavior: Clip.hardEdge,
                                                child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        for (var i = 0;
                                                            i < 5;
                                                            i++) {
                                                          home[i] = false;
                                                        }
                                                        home[4] = true;
                                                      });
                                                    },
                                                    child: FilterRowPrimary(
                                                        isHome: false,
                                                        text: context
                                                            .loc.archived,
                                                        active: home[4],
                                                        boxwidth: 0.140 * width,
                                                        count: categoryNumbers(
                                                            asyncwork,
                                                            'archived'))),
                                              )
                                            ],
                                          ),
                                        )),
                                    Positioned(
                                        top: 0.249 * height,
                                        child: Showcase(
                                          key: _eleven,
                                          description:
                                              'Tasks assigned to you by your work contacts\nwill appear here 👇🏽 .\nfor now it might be empty 👻 because you may not have tasks from work contacts\n😌 I must admit this was quite a walkthrough 🚶🏾\nif it may have seemed overwhelming 🙆🏾, you are\nnot alone.One thing I know, it gets easier with use.',
                                          disposeOnTap: true,
                                          onTargetClick: () {
                                            setState(() async {
                                              DefaultTabController.of(context)
                                                  .animateTo(1);
                                              await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 1000));
                                              ShowCaseWidget.of(context)
                                                  .startShowCase([_twelve]);
                                            });
                                          },
                                          onToolTipClick: () {
                                            setState(() async {
                                              DefaultTabController.of(context)
                                                  .animateTo(1);
                                              await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 1000));
                                              ShowCaseWidget.of(context)
                                                  .startShowCase([_twelve]);
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.topCenter,
                                            height: height -
                                                appBa.preferredSize.height -
                                                .249 * height,
                                            width: 0.933 * width,
                                            child: StreamBuilder<
                                                    List<CloudWork>>(
                                                stream: widget.main
                                                    ? _cloudService
                                                        .allAssignedCloudWorks(
                                                        assignedId: userId,
                                                      )
                                                    : _cloudService
                                                        .allAssignedCloudWorks2(
                                                            assignedId: userId,
                                                            date: widget.date),
                                                builder: (context, snapshot) {
                                                  switch (snapshot
                                                      .connectionState) {
                                                    case ConnectionState
                                                          .waiting:
                                                    case ConnectionState.active:
                                                      if (snapshot.hasData) {
                                                        final cloudWorks =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'CloudWorks');
                                                        if (snapshot
                                                            .data!.isNotEmpty) {
                                                          //showNotification();
                                                        }

                                                        for (CloudWork element
                                                            in snapshot.data ??
                                                                []) {
                                                          asyncmap.addAll({
                                                            element.documentId:
                                                                element
                                                          });
                                                        }

                                                        asynchome.clear();
                                                        asyncwork.clear();
                                                        asyncmap.forEach(
                                                            (key, value) {
                                                          if (existsinWorkContacts(
                                                              onlineUser,
                                                              value
                                                                  .assignerId)) {
                                                            asyncwork
                                                                .add(value);
                                                            asyncwork.sort(
                                                                ((a, b) => b
                                                                    .beginTime
                                                                    .compareTo(a
                                                                        .beginTime)));
                                                          } else {
                                                            asynchome
                                                                .add(value);
                                                            asynchome.sort(
                                                                ((a, b) => b
                                                                    .beginTime
                                                                    .compareTo(a
                                                                        .beginTime)));
                                                          }
                                                        });
                                                        return NotificationListener<
                                                            OverscrollNotification>(
                                                          onNotification:
                                                              (notification) {
                                                            if (notification
                                                                    .overscroll >
                                                                20) {
                                                              _trigger1
                                                                  .currentState
                                                                  ?.show();
                                                            }
                                                            return true;
                                                          },
                                                          child:
                                                              RefreshIndicator(
                                                            displacement: 0,
                                                            edgeOffset:
                                                                height * 0.27,
                                                            color:
                                                                const Colour()
                                                                    .white,
                                                            backgroundColor:
                                                                const Colour()
                                                                    .primary,
                                                            key: _trigger1,
                                                            notificationPredicate:
                                                                (ScrollNotification
                                                                    notification) {
                                                              return false;
                                                            },
                                                            onRefresh:
                                                                () async {
                                                              Stream
                                                                  streamtoUse;
                                                              int numbertoadd =
                                                                  refreshLimit(
                                                                      asyncmap
                                                                          .length);
                                                              DocumentSnapshot
                                                                  startAfterDocument =
                                                                  await cloudWorks
                                                                      .doc(asyncmap
                                                                          .entries
                                                                          .last
                                                                          .value
                                                                          .documentId)
                                                                      .get();
                                                              Stream stream1 = cloudService.secondAllAssignedCloudWorks(
                                                                  assignedId:
                                                                      userId,
                                                                  documentSnapshot:
                                                                      startAfterDocument,
                                                                  numbertoadd:
                                                                      numbertoadd);
                                                              Stream stream2 = cloudService.secondAllAssignedCloudWorks2(
                                                                  assignedId:
                                                                      userId,
                                                                  date: widget
                                                                      .date,
                                                                  documentSnapshot:
                                                                      startAfterDocument,
                                                                  numbertoadd:
                                                                      numbertoadd);
                                                              widget.main
                                                                  ? streamtoUse =
                                                                      stream1
                                                                  : streamtoUse =
                                                                      stream2;
                                                              streamtoUse
                                                                  .listen(
                                                                      (event) {
                                                                for (CloudWork element
                                                                    in event) {
                                                                  asyncmap
                                                                      .addAll({
                                                                    element.documentId:
                                                                        element
                                                                  });
                                                                }
                                                                setState(() {});
                                                                asynchome
                                                                    .clear();
                                                                asyncwork
                                                                    .clear();
                                                                asyncmap.forEach(
                                                                    (key,
                                                                        value) {
                                                                  if (existsinWorkContacts(
                                                                      onlineUser,
                                                                      value
                                                                          .assignerId)) {
                                                                    asyncwork.add(
                                                                        value);
                                                                    asyncwork.sort(((a, b) => b
                                                                        .beginTime
                                                                        .compareTo(
                                                                            a.beginTime)));
                                                                  } else {
                                                                    asynchome.add(
                                                                        value);
                                                                    asynchome.sort(((a, b) => b
                                                                        .beginTime
                                                                        .compareTo(
                                                                            a.beginTime)));
                                                                  }
                                                                });
                                                              });
                                                            },
                                                            child:
                                                                CloudTodoListView(
                                                              isAssigner: false,
                                                              todo: listwithads(
                                                                  categorymessages(
                                                                      asyncwork,
                                                                      home)),
                                                              user: onlineUser,
                                                              date: widget.date,
                                                              controller:
                                                                  scrollController,
                                                              onTap: () {
                                                                setState(() {
                                                                  v = 1;
                                                                  DefaultTabController.of(
                                                                          context)
                                                                      .animateTo(
                                                                          1);
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      return Container();
                                                    default:
                                                      return Container();
                                                  }
                                                }),
                                          ),
                                        )),
                                    Center(
                                      child: SizedBox(
                                        height:
                                            height - appBa.preferredSize.height,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
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
            });
      }),
    );
  }

  List<Object> listwithads(List<Object> list) {
    final adState = Provider.of<AdState>(context);
    List<Object> kist = [];
    for (var element in list) {
      kist.add(element);
    }
    for (var i = 2; i < kist.length; i += 7) {
      kist.insert(
          i,
          BannerAd(
              size: AdSize.banner,
              adUnitId: adState.bannerAdUnit,
              listener: adState.adListener,
              request: const AdRequest())
            ..load());
    }
    return kist;
  }
}

bool withinDate(CloudWork element, DateTime currentDate) {
  int upperlimit = DateTime(
          currentDate.year, currentDate.month, currentDate.day, 23, 59, 999)
      .microsecondsSinceEpoch;
  int lowerlimit =
      DateTime(currentDate.year, currentDate.month, currentDate.day, 00, 00, 1)
          .microsecondsSinceEpoch;

  if (element.beginTime < upperlimit && element.finishTime > lowerlimit) {
    return true;
  }
  return false;
}

Future<List> flist(
    LocalDatabaseService database, String email, String id, bool main) async {
  await MobileAds.instance.initialize();
  final DatabaseUser localUser = await database.getUser(email: email, id: id);
  final OnlineUser onlineUser = await database.getOnlineUser(id: id);
  if (await hasNetwork() && main) {
    Contact().heavyhomeContacts;
    Contact().heavyworkContacts;
  }
  return [localUser, onlineUser];
}

bool existsinWorkContacts(OnlineUser user, String idToCheck) {
  if (user.workContacts != null) {
    return user.workContacts!.contains(idToCheck);
  }
  return false;
}

bool existsinHomeContacts(OnlineUser user, String idToCheck) {
  if (user.homeContacts != null) {
    return user.homeContacts!.contains(idToCheck);
  }
  return false;
}

int categoryNumbers(List<CloudWork> asyncmap, String category) {
  int opencount = 0;
  int pendingcount = 0;
  int donecount = 0;
  int todocount = 0;
  int archivedcount = 0;

  for (var element in asyncmap) {
    if (element.open == true &&
        element.declined == false &&
        element.archived == false) {
      opencount += 1;
    }
    if (element.pending == true) {
      pendingcount += 1;
    }
    if (element.completed == true) {
      donecount += 1;
    }
    if (element.open == false &&
        element.declined == false &&
        element.completed == false &&
        element.pending == false) {
      todocount += 1;
    }
    if (element.declined == true || element.archived == true) {
      archivedcount += 1;
    }
  }
  if (category == 'open') {
    return opencount;
  }
  if (category == 'pending') {
    return pendingcount;
  }
  if (category == 'todo') {
    return todocount;
  }
  if (category == 'done') {
    return donecount;
  }
  if (category == 'archived') {
    return archivedcount;
  } else {
    return 99;
  }
}

List<CloudWork> categorymessages(List<CloudWork> asynclist, List<bool> home) {
  List<CloudWork> opencount = [];
  List<CloudWork> pendingcount = [];
  List<CloudWork> donecount = [];
  List<CloudWork> todocount = [];
  List<CloudWork> archivedcount = [];
  for (var element in asynclist) {
    if (element.open == true &&
        element.declined == false &&
        element.archived == false) {
      opencount.add(element);
    }
    if (element.pending == true) {
      pendingcount.add(element);
    }
    if (element.completed == true) {
      donecount.add(element);
    }
    if (element.open == false &&
        element.declined == false &&
        element.completed == false &&
        element.pending == false) {
      todocount.add(element);
    }
    if (element.declined == true || element.archived == true) {
      archivedcount.add(element);
    }
  }
  if (home[0]) {
    return opencount;
  }
  if (home[2]) {
    return pendingcount;
  }
  if (home[1]) {
    return todocount;
  }
  if (home[3]) {
    return donecount;
  }
  if (home[4]) {
    return archivedcount;
  } else {
    return [];
  }
}

int refreshLimit(int numbercloudWorks) {
  int maximumNumber = 60;
  if (maximumNumber - numbercloudWorks >= 10) {
    return 10;
  } else {
    return maximumNumber - numbercloudWorks;
  }
}
