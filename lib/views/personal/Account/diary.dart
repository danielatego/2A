import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/createtodo/upload.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/database/local/database_service.dart';
import 'package:two_a/database/local/database_tables/personal_diary.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/views/home/components.dart';
import 'package:two_a/views/profile/user_profile.dart';

class AccountPersonalDiary extends StatefulWidget {
  final String date;
  final PersonalDiary? note;
  final String email;
  final bool? onTutorial;
  final String id;
  const AccountPersonalDiary(
      {super.key,
      required this.date,
      this.note,
      required this.email,
      required this.id,
      this.onTutorial});

  @override
  State<AccountPersonalDiary> createState() => _AccountPersonalDiaryState();
}

class _AccountPersonalDiaryState extends State<AccountPersonalDiary> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();
  late Future<PersonalDiary> _diaryfuture;
  late PersonalDiary? _diary;
  late final LocalDatabaseService _diaryService;
  late TextEditingController diaryText, images;
  BuildContext? myContext;

  Future<PersonalDiary> createDiary() async {
    final diary =
        await _diaryService.createDiary(widget.date, widget.email, widget.id);
    if (diary.diaryEntry != null) {
      diaryText.text = diary.diaryEntry ?? '';
    }
    return diary;
  }

  void updatediary() {
    _diaryService.updateDiary(
      diary: _diary!,
      diaryAttached: images.text,
      diaryEntry: diaryText.text,
    );
  }

  @override
  void initState() {
    _diaryService = LocalDatabaseService();
    _diaryfuture = createDiary();
    diaryText = TextEditingController();
    images = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        ShowCaseWidget.of(myContext!).startShowCase([_one]);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBa = CustomAppbar(
      back: true,
      tab: false,
      context: context,
      locTitle: null,
      appBarRequired: true,
    );
    final bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final height = context.scaleFactor.height;
    final width = context.scaleFactor.width;
    final hsf = context.scaleFactor.hsf;
    final wsf = context.scaleFactor.wsf;

    return ShowCaseWidget(
      disableBarrierInteraction: true,
      enableShowcase: widget.onTutorial ?? false,
      builder: Builder(builder: (context) {
        myContext = context;
        return Scaffold(
          appBar: appBa,
          body: FutureBuilder(
              future: _diaryfuture,
              builder: ((context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    _diary = snapshot.data as PersonalDiary;
                    //diaryText.text = _diary?.diaryEntry ?? '';
                    diaryText.addListener(updatediary);
                    images.addListener(updatediary);
                    return SingleChildScrollView(
                      child: Stack(
                        children: [
                          Positioned(
                            top: isLandScape ? 6 * hsf : 6 * hsf,
                            left: (0.083 * width) +
                                MediaQuery.of(context).viewPadding.left,
                            child: Text(
                              context.loc.diary,
                              style: CustomTextStyle(
                                  context: context,
                                  fontSz: 27.41,
                                  fontWght: Fontweight.w400,
                                  colour: FontColour.black,
                                  normalSpacing: true),
                            ),
                          ),
                          Positioned(
                            top: isLandScape ? 38 * hsf : 38 * hsf,
                            left: (0.083 * width) +
                                MediaQuery.of(context).viewPadding.left,
                            child: Text(
                              completeDate(
                                  DateTime.parse(widget.date), context),
                              style: CustomTextStyle(
                                  context: context,
                                  fontSz: 12,
                                  fontWght: Fontweight.w500,
                                  colour: FontColour.hintblack,
                                  normalSpacing: true),
                            ),
                          ),
                          Positioned(
                            top: isLandScape ? 71 * hsf : 71 * hsf,
                            left: (0.051 * width) +
                                MediaQuery.of(context).viewPadding.left,
                            child: Showcase(
                              key: _one,
                              description:
                                  'Here you can type in anything 🌏 from class\nnotes, secrets, quotes.just about anything🎡\nit is automatically saved when you leave\nthe page.Everyday the page is blank and\nyou cant fill it. Well, write on...🖋\nYour future self will thank you👍🏽',
                              disposeOnTap: true,
                              onToolTipClick: () {
                                setState(() {
                                  diaryText.text =
                                      'some times it feels pretty lonely here 👴. Living all by yourself in this metaverse. I know im just a bunch of lines of code 🤖. But it is what it is. But Im glad ${nameGeneratedFromEmail(widget.email)} allowed me to tak\'em on a tour through the app.I just feel appreciated, at least this once.I\'ll leave this here just so that I can always look back to remember this day.\nBack to number crunching 🚶🏼';
                                });
                                ShowCaseWidget.of(context)
                                    .startShowCase([_two]);
                              },
                              targetBorderRadius:
                                  BorderRadius.all(Radius.circular(8.0 * hsf)),
                              onTargetClick: () {
                                setState(() {
                                  diaryText.text =
                                      'some times it feels pretty lonely here 👴. Living all by yourself in this metaverse. I know im just a bunch of lines of code 🤖. But it is what it is. But Im glad ${nameGeneratedFromEmail(widget.email)} allowed me to tak\'em on a tour through the app.I just feel appreciated, at least this once.I\'ll leave this here just so that I can always look back to remember this day.\nBack to number crunching 🚶🏼';
                                });
                                ShowCaseWidget.of(context)
                                    .startShowCase([_two]);
                              },
                              child: Container(
                                height: isLandScape
                                    ? 0.637 * width
                                    : 0.637 * height,
                                width:
                                    isLandScape ? 0.899 * width : 0.899 * width,
                                decoration: BoxDecoration(
                                  color: const Colour().lHint2,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8.0 * hsf)),
                                ),
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16 * wsf),
                                  child: TextField(
                                    controller: diaryText,
                                    scrollPadding: const EdgeInsets.all(0),
                                    style: CustomTextStyle(
                                        context: context,
                                        fontSz: 15.0,
                                        fontWght: Fontweight.w400,
                                        colour: FontColour.black,
                                        normalSpacing: true),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: context.loc.abouttoday,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              top: isLandScape ? 528 * hsf : 528 * hsf,
                              left: (0.051 * width) +
                                  MediaQuery.of(context).viewPadding.left,
                              child: Showcase(
                                key: _two,
                                description:
                                    'here you can attach any media 📁\nit will be saved with this diary entry⬆\nPerfect for capturing every moment\nboth in text and in file\nthere you have it, Digital diary 🤗 ',
                                disposeOnTap: true,
                                onTargetClick: () {
                                  Navigator.of(context).pop();
                                },
                                onToolTipClick: () {
                                  Navigator.of(context).pop();
                                },
                                targetBorderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8 * hsf),
                                    bottomLeft: Radius.circular(8 * hsf),
                                    topRight: Radius.circular(48 * hsf),
                                    bottomRight: Radius.circular(48 * hsf)),
                                child: Upload(
                                    controller: images,
                                    images: _diary?.diaryAttached ?? ''),
                              )),
                          Center(
                              child: SizedBox(
                            height: isLandScape
                                ? width - appBa.preferredSize.height
                                : height - appBa.preferredSize.height,
                          ))
                        ],
                      ),
                    );
                  default:
                    return Container();
                }
              })),
        );
      }),
    );
  }
}
