import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/calendar.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/date.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/components/weeks.dart';
import 'package:two_a/components/years.dart';
import 'package:two_a/database/local/database_tables/user_table.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/firebase/authentication/fireauth.dart';
import 'package:two_a/firebase/authentication/service.dart';
import 'package:two_a/main.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';
import 'package:two_a/views/dateonpress2.dart';

class LandingPage extends StatefulWidget {
  final DatabaseUser user;
  final bool? onTutorial;
  final bool? nextTutorial;
  const LandingPage(
      {super.key, required this.user, this.onTutorial, this.nextTutorial});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();
  final GlobalKey _six = GlobalKey();
  final GlobalKey _seven = GlobalKey();
  String get userId => Service(FireAuth()).currentUser!.id;
  FixedExtentScrollController scrollController =
      FixedExtentScrollController(onAttach: (position) {});

  int v = DateTime.now().month;
  int year = DateTime.now().year;
  BuildContext? myContext;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onTutorial ?? false
          ? ShowCaseWidget.of(myContext!).startShowCase([_one])
          : null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hsf = context.scaleFactor.hsf;
    final hmf = context.scaleFactor.hmf;
    final wsf = context.scaleFactor.wsf;

    return ShowCaseWidget(
      enableShowcase: widget.onTutorial ?? false,
      disableBarrierInteraction: true,
      builder: Builder(builder: (context) {
        myContext = context;
        return Scaffold(
          appBar: CustomAppbar(
            refresh: true,
            context: context,
            locTitle: null,
            tab: false,
            back: true,
            onTap: () {
              setState(() {
                v = DateTime.now().month;
                year = DateTime.now().year;
                scrollController.jumpTo(0);
              });
            },
          ),
          backgroundColor: const Colour().lbg,
          body: SingleChildScrollView(
            child: Column(
              children: [
                widget.user.hintsEnabled
                    ? Material(
                        color: const Colour().lbg,
                        child: InkWell(
                          onTap: () async {
                            await infoDialog(context, context.loc.info,
                                context.loc.disableInfo);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 36 * hmf,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info,
                                  size: 14 * hsf,
                                  color: const Colour().purple,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 6 * wsf)),
                                Text(context.loc.calendarinfoyear,
                                    style: CustomTextStyle(
                                        context: context,
                                        fontSz: 11.6,
                                        colour: FontColour.purple))
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 36 * hmf,
                      ),
                Showcase(
                  key: _one,
                  description:
                      'Welcome 😁 to the calendar page. There\'s alot 🙌🏾 you can do on this page than meets the eye 👀.Currently you have the years tab selected.Here you can scroll to whatever year of choice:Future or past.\nif you scroll say to "1997" and tap. you will be able to see all your tasks and memories of that year.\nlets try it 👉🏽',
                  disposeOnTap: true,
                  onTargetClick: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DateOnPress2(
                                    onTutorial: true,
                                    main: false,
                                    date: DateTime.now(),
                                    context: context,
                                    isWeek: true,
                                    year: '1997',
                                    week: [
                                      DateTime(1997, 1, 1),
                                      DateTime(1997, 12, 31)
                                    ]))).then((value) => Future.delayed(
                        const Duration(milliseconds: 200),
                        () =>
                            ShowCaseWidget.of(context).startShowCase([_two])));
                  },
                  onToolTipClick: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DateOnPress2(
                                    onTutorial: true,
                                    main: false,
                                    date: DateTime.now(),
                                    context: context,
                                    isWeek: true,
                                    year: '1997',
                                    week: [
                                      DateTime(1997, 1, 1),
                                      DateTime(1997, 12, 31)
                                    ]))).then((value) => Future.delayed(
                        const Duration(milliseconds: 200),
                        () =>
                            ShowCaseWidget.of(context).startShowCase([_two])));
                  },
                  child: SizedBox(
                    height: 80,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 30,
                      controller: scrollController,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          year = const Scroll().listyears[value];
                        });
                      },
                      diameterRatio: 2,
                      physics: CustomScrollPhysics(),
                      useMagnifier: true,
                      magnification: 1.5,
                      overAndUnderCenterOpacity: 0.48,
                      childDelegate: ListWheelChildLoopingListDelegate(
                        children: List<Widget>.generate(
                          const Scroll().listyears.length,
                          (index) => const Scroll()
                              .format(context, const Scroll().listyears[index]),
                        ),
                      ),
                    ),
                  ),
                ),
                widget.user.hintsEnabled
                    ? Material(
                        color: const Colour().lbg,
                        child: InkWell(
                          onTap: () async {
                            await infoDialog(context, context.loc.info,
                                context.loc.disableInfo);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 36 * hmf,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info,
                                  size: 14 * hsf,
                                  color: const Colour().purple,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 6 * wsf)),
                                Text(context.loc.calendarinfomonth,
                                    style: CustomTextStyle(
                                        context: context,
                                        fontSz: 11.6,
                                        colour: FontColour.purple))
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 36 * hmf,
                      ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0.05 * context.scaleFactor.width * wsf,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(36 * hsf),
                        color: const Colour().lHint2,
                        child: InkWell(
                          highlightColor: const Colour().primary,
                          onTap: (v == 1)
                              ? null
                              : () {
                                  setState(() {
                                    if (v > 1) {
                                      v--;
                                    }
                                  });
                                },
                          child: SizedBox(
                              width: 36 * hsf,
                              height: 36 * hsf,
                              child: Icon(
                                Icons.chevron_left_rounded,
                                color: (v == 1)
                                    ? const Colour().lHint
                                    : const Colour().black,
                              )),
                        ),
                      ),
                      Material(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DateOnPress2(
                                            main: false,
                                            date: datenow(),
                                            context: context,
                                            isWeek: true,
                                            month:
                                                '${Calendar(year: year, context: context).months[v]!.monthName} $year',
                                            week: [
                                              DateTime(year, v, 1),
                                              DateTime(
                                                  year,
                                                  v,
                                                  Calendar(
                                                          year: year,
                                                          context: context)
                                                      .months[v]!
                                                      .monthDays)
                                            ])));
                          },
                          child: Showcase(
                            key: _two,
                            description:
                                'Just as you can tap the year and see your year\'s activities 🙂. The same can also be done for the month when tapped.\nYou can also scroll through other months by tapping the navigation buttons\n on the sides 👉🏾',
                            targetPadding: EdgeInsets.all(8 * hsf),
                            targetBorderRadius: BorderRadius.circular(8 * hsf),
                            disposeOnTap: true,
                            onTargetClick: () {
                              ShowCaseWidget.of(context)
                                  .startShowCase([_three]);
                            },
                            onToolTipClick: () {
                              ShowCaseWidget.of(context)
                                  .startShowCase([_three]);
                            },
                            child: Text(
                              Calendar(year: year, context: context)
                                  .months[v]!
                                  .monthName,
                              textAlign: TextAlign.center,
                              style: CustomTextStyle(
                                  context: context,
                                  fontSz: 17,
                                  fontWght: Fontweight.w600,
                                  colour: FontColour.black,
                                  normalSpacing: true),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(36 * hsf),
                        color: const Colour().lHint2,
                        child: InkWell(
                          highlightColor: const Colour().primary,
                          onTap: (v == 12)
                              ? null
                              : () {
                                  setState(() {
                                    if (v < 12) v++;
                                  });
                                },
                          child: SizedBox(
                              width: 36 * hsf,
                              height: 36 * hsf,
                              child: Icon(
                                Icons.chevron_right_rounded,
                                color: (v == 12)
                                    ? const Colour().lHint
                                    : const Colour().black,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                widget.user.hintsEnabled
                    ? Material(
                        color: const Colour().lbg,
                        child: InkWell(
                          onTap: () async {
                            await infoDialog(context, context.loc.info,
                                context.loc.disableInfo);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 36 * hmf,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info,
                                  size: 14 * hsf,
                                  color: const Colour().purple,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 6 * wsf)),
                                Text(context.loc.calendarinfodays,
                                    style: CustomTextStyle(
                                        context: context,
                                        fontSz: 11.6,
                                        colour: FontColour.purple))
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 36 * hmf,
                      ),
                Showcase(
                  key: _three,
                  description:
                      'I\'m sure you can already guess it. 😀\nYes, you can tap on any date and see 🤓 that days actions whether it be personal tasks, diary entry or personal task accounts.\nYou can also select a specific date in the future 🚀 and create a personal task to be done then. Yeah 😉 and 2A will alert you when or before the day comes.',
                  disposeOnTap: true,
                  onTargetClick: () {
                    ShowCaseWidget.of(context).startShowCase([_four]);
                  },
                  onToolTipClick: () {
                    ShowCaseWidget.of(context).startShowCase([_four]);
                  },
                  targetBorderRadius: BorderRadius.circular(16 * hsf),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Gridview(
                        yEar: year,
                        moNth: v,
                        context: context,
                      ),
                    ],
                  ),
                ),
                widget.user.hintsEnabled
                    ? Material(
                        color: const Colour().lbg,
                        child: InkWell(
                          onTap: () async {
                            await infoDialog(context, context.loc.info,
                                context.loc.disableInfo);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 36 * hmf,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info,
                                  size: 14 * hsf,
                                  color: const Colour().purple,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 6 * wsf)),
                                Text(context.loc.calendarinfoweekss,
                                    style: CustomTextStyle(
                                        context: context,
                                        fontSz: 11.6,
                                        colour: FontColour.purple))
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 36 * hmf,
                      ),
                Showcase(
                  key: _four,
                  description:
                      'These are week buttons. They give a weekly overview 🔭 of personal tasks,diary,and task accounts.\nThe highlited 🟦 week button shows the current week we are on.\nThere you have it 😀 friend. This marks the final stages 🌇 of this tutorial. I haven\'t covered most of the app.\nThe rest 😊 I\'ve left it for your adventure👣.\nMany thanks 🙏🏽 for coming this far.',
                  onTargetClick: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  onToolTipClick: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  disposeOnTap: true,
                  targetBorderRadius: BorderRadius.circular(16 * hsf),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20 * wsf),
                    child: WeekConstructor(
                        monthWeeks:
                            Weeks(month: v - 1, year: year, context: context)
                                .monthWeekList),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

void profilePicture(String userId) async {
  final Directory docPath;
  final String pathtoImagesDirectory;
  final String pathtoProfilePictureDirectory;
  final String fullPathToProfilePicture;
  final String fullPathTolocalUploadedDocuments;

  docPath = await getApplicationDocumentsDirectory();
  pathtoImagesDirectory = join(docPath.path, 'images');
  pathtoProfilePictureDirectory =
      join(docPath.path, 'images', 'profilepictures');
  fullPathToProfilePicture =
      join(docPath.path, 'images', 'profilepictures', '$userId.jpg');
  fullPathTolocalUploadedDocuments =
      join(docPath.path, 'cache', 'localUploads', 'documents');

  try {
    File(fullPathToProfilePicture).lengthSync();
  } on FileSystemException catch (e) {
    if (e.message == 'Cannot retrieve length of file') {
      await Directory(pathtoImagesDirectory).create();
      await Directory(pathtoProfilePictureDirectory).create();
      await Directory(fullPathTolocalUploadedDocuments).create(recursive: true);

      final file = File(fullPathToProfilePicture);
      final storageRef = FirebaseStorage.instance.ref();
      final onlineprofpic =
          storageRef.child("images/profilepictures/$userId.jpg");
      try {
        onlineprofpic.writeToFile(file);
      } catch (e) {
        null;
      }
    }
  }
}

Future<String> pathtoProfilePicture(String? userId) async {
  final docPath = await getApplicationDocumentsDirectory();
  if (userId == null) {
    return join(
      docPath.path,
      'images',
      'profilepictures',
    );
  }
  return join(docPath.path, 'images', 'profilepictures', '$userId.jpg');
}

Future<String> pathtoLocalUploadedFile() async {
  final docPath = await getApplicationDocumentsDirectory();
  String path = docPath.path.substring(0, docPath.path.lastIndexOf('/'));
  return join(path, 'cache', 'localUploads', 'documents');
}

Future<bool> pathtoContactProfilePic(String userId) async {
  String picLocalStoragePath = await pathtoProfilePicture(userId);
  bool path = false;
  File localfile;
  final storageRef = FirebaseStorage.instance.ref();
  final onlineprofpic = storageRef.child("images/profilepictures/$userId.jpg");

  //checking whether the file exists in the local storage
  localfile = File(picLocalStoragePath);
  bool localExists = await localfile.exists();

  if (localExists) {
    //the local file exists
    //'the local file exists');
    path = true;
    try {
      //checking whether the file exists in the cloud storage
      var meta = await onlineprofpic.getMetadata();
      if (meta.size != localfile.lengthSync()) {
        try {
          //downloading the file to the local storage because of difference in files
          onlineprofpic.writeToFile(localfile);
          //the upload of the file difference was a success');
          path = true;
        } catch (e) {
          //yes the file difference exists but downloading failed');
          path = true;
        }
      }
    } catch (e) {
      //'this file does not exist in cloud storage');
      path = true;
    }
  } else {
    //'the local file does not exist');
    try {
      // checking whether the file exists in the cloud storage
      //'checking whether the file exists in the cloud storage 2');
      var meta = await onlineprofpic.getMetadata();
      try {
        //downloading the file to the local storage because file exists in cloud only
        onlineprofpic.writeToFile(localfile);
        //'the upload from the cloud was a success');
        path = true;
      } catch (e) {
        //'yes the file exists only in the cloud but downloading failed');
        path = false;
      }
    } catch (e) {
      //the file exists neither in the cloud nor in the local file
      path = false;
    }
  }
  return path;
}

class CustomScrollPhysics extends FixedExtentScrollPhysics {
  @override
  double get minFlingVelocity => 100.0; // Adjust the minimum fling velocity
}
