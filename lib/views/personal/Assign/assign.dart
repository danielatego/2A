// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/calendar.dart';
import 'package:two_a/components/createtodo/description.dart';
import 'package:two_a/components/createtodo/title_text_field.dart';
import 'package:two_a/components/createtodo/upload.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/database/cloud/cloud_storage_exceptions.dart';
import 'package:two_a/database/cloud/cloud_user.dart';
import 'package:two_a/database/cloud/firebase_cloud_storage.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/firebase/authentication/fireauth.dart';
import 'package:two_a/helpers/loading/loading_screen.dart';
import 'package:two_a/main.dart';
import 'package:two_a/utilities/dialogs/date_dialog.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';

class AssignWork extends StatefulWidget {
  final bool isHome;
  final DateTime date;
  final String contactEmail;
  final String contactId;
  final File? ppicPath;
  final bool? onTutorial;
  final String name;
  const AssignWork(
      {super.key,
      required this.isHome,
      required this.contactEmail,
      required this.contactId,
      required this.ppicPath,
      required this.name,
      required this.date,
      this.onTutorial});

  @override
  State<AssignWork> createState() => _AssignWorkState();
}

class _AssignWorkState extends State<AssignWork> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();
  final GlobalKey _six = GlobalKey();
  final GlobalKey _seven = GlobalKey();
  final GlobalKey _eight = GlobalKey();
  final GlobalKey _nine = GlobalKey();

  late FirebaseCloudStorage cloudService;
  late TextEditingController titlecontroller;
  late TextEditingController begincontroller;
  late TextEditingController finishcontroller;
  late TextEditingController descriptionController;
  late TextEditingController uploadcontroller;

  DateTime beginTime = DateTime.now();
  DateTime finishTime = DateTime.now();
  bool deleteUploadedFiles = true;
  final user = FireAuth().currentUser;
  BuildContext? myContext;

  @override
  void initState() {
    widget.onTutorial ?? false
        ? finishTime = beginTime.add(const Duration(minutes: 30))
        : DateTime.now();
    cloudService = FirebaseCloudStorage();
    titlecontroller = TextEditingController();
    begincontroller = TextEditingController();
    finishcontroller = TextEditingController();
    uploadcontroller = TextEditingController();
    descriptionController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        ShowCaseWidget.of(myContext!).startShowCase([_one]);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    titlecontroller.dispose();
    begincontroller.dispose();
    finishcontroller.dispose();
    uploadcontroller.dispose();
    deleteUploadedFiles
        ? deleteUploadedLocalFiles(uploadcontroller.text)
        : null;
    super.dispose();
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
    final height = context.scaleFactor.height;
    final width = context.scaleFactor.width;

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
                  top: 0.009 * height,
                  child: Column(
                    children: [
                      Showcase(
                        key: _one,
                        description:
                            'The picture 📸 of whom you are delegating\nappears here🧑🏾‍🎓\nSee how profile pictures are important 👨🏻\nfor now just bear with the icon',
                        targetShapeBorder: const CircleBorder(),
                        onTargetClick: () {
                          ShowCaseWidget.of(context).startShowCase([_two]);
                        },
                        onToolTipClick: () {
                          ShowCaseWidget.of(context).startShowCase([_two]);
                        },
                        disposeOnTap: true,
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          width: 0.096 * height,
                          height: 0.096 * height,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: widget.ppicPath == null
                              ? Icon(
                                  Icons.person,
                                  size: 0.064 * height,
                                )
                              : Image.file(
                                  widget.ppicPath!,
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 0.009 * height)),
                      Showcase(
                        key: _two,
                        description:
                            'This is the name of the delegate as it\nwas saved while adding the contact\nYou can always edit ✍🏽 this\nfrom "Contacts" in the main menu',
                        onTargetClick: () {
                          ShowCaseWidget.of(context).startShowCase([_three]);
                        },
                        onToolTipClick: () {
                          ShowCaseWidget.of(context).startShowCase([_three]);
                        },
                        disposeOnTap: true,
                        child: Text(
                          widget.name,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                          style: CustomTextStyle(
                              context: context,
                              fontSz: 16,
                              fontWght: Fontweight.w400,
                              colour: FontColour.hintblack,
                              normalSpacing: true),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                    top: 0.177 * height,
                    child: Showcase(
                        key: _three,
                        description:
                            'Here a brief title describing the task is entered\nI\'ll enter one on your behalf\nas before, kindly excuse my vanity😌',
                        onTargetClick: () {
                          titlecontroller.text =
                              'We demand that 2A be given a raise';
                          ShowCaseWidget.of(context).startShowCase([_four]);
                        },
                        onToolTipClick: () {
                          titlecontroller.text =
                              'We demand that 2A be given a raise';
                          ShowCaseWidget.of(context).startShowCase([_four]);
                        },
                        disposeOnTap: true,
                        child:
                            TitleTextField(titleController: titlecontroller))),
                Positioned(
                    top: 0.321 * height,
                    child: Showcase(
                      key: _four,
                      description:
                          'Here set ⌚ the begin time\nOne concern especially among remote workers \nmay be difference in timezones 🌍\nfor instance one may be in the Phillipines🌘\nand another in the Congo🌞\nDo not worry about this let 2A handle it 💪🏼\njust provide your localtime when the task begins\nTrust me💯 I got you\n2A will also give them an alert on this\nset time that is if they accept to do the task',
                      onTargetClick: () {
                        ShowCaseWidget.of(context).startShowCase([_five]);
                      },
                      onToolTipClick: () {
                        ShowCaseWidget.of(context).startShowCase([_five]);
                      },
                      disposeOnTap: true,
                      child: SizedBox(
                        width: 0.752 * width,
                        height: 0.03 * height,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.loc.begin,
                              style: CustomTextStyle(
                                  context: context,
                                  fontSz: 17,
                                  fontWght: Fontweight.w700,
                                  colour: FontColour.black,
                                  normalSpacing: true),
                            ),
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(0)),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: ((context) => DateSetDialog(
                                            date: widget.date,
                                            context: context,
                                            begin: true,
                                          ))).then((value) {
                                    setState(() {
                                      if (value != null) {
                                        beginTime = value;
                                      }
                                    });
                                  });
                                },
                                child: Text(
                                  begintime(beginTime, true),
                                  style: CustomTextStyle(
                                      context: context,
                                      fontSz: 15,
                                      fontWght: Fontweight.w400,
                                      colour: FontColour.black,
                                      normalSpacing: true),
                                ))
                          ],
                        ),
                      ),
                    )),
                Positioned(
                  top: 0.391 * height,
                  child: Showcase(
                    key: _five,
                    description:
                        'Set the task deadline here\n2A will hurl an error at you🙅🏾\nif the begin and end time are the same\nor if end time is before begin time🤷🏿',
                    onTargetClick: () {
                      setState(() {
                        finishTime = beginTime.add(const Duration(minutes: 30));
                      });
                      ShowCaseWidget.of(context).startShowCase([_six]);
                      setState(() {
                        finishTime = beginTime.add(const Duration(minutes: 30));
                      });
                    },
                    onToolTipClick: () {
                      ShowCaseWidget.of(context).startShowCase([_six]);
                    },
                    disposeOnTap: true,
                    child: SizedBox(
                      width: 0.752 * width,
                      height: 0.03 * height,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.loc.finish,
                            style: CustomTextStyle(
                                context: context,
                                fontSz: 17,
                                fontWght: Fontweight.w700,
                                colour: FontColour.black,
                                normalSpacing: true),
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(0)),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: ((context) => DateSetDialog(
                                          date: widget.date,
                                          context: context,
                                          begin: false,
                                        ))).then((value) {
                                  setState(() {
                                    if (value != null) {
                                      finishTime = value;
                                    }
                                  });
                                });
                              },
                              child: Text(
                                begintime(finishTime, false),
                                style: CustomTextStyle(
                                    context: context,
                                    fontSz: 15,
                                    fontWght: Fontweight.w400,
                                    colour: FontColour.black,
                                    normalSpacing: true),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0.471 * height,
                  child: Showcase(
                    key: _six,
                    description:
                        'Here a description of the delegated task is entered\nI\'ve just come up with something amazing\non your behalf😉',
                    targetBorderRadius:
                        BorderRadius.circular(8 * context.scaleFactor.hsf),
                    onTargetClick: () {
                      setState(() {
                        descriptionController.text =
                            'It is a matter of concern, that I\'d like the creators of this app to address. Clearly, you main employee by the name "2A" is working really hard. His works speak for themselves. It is such a shame that his pay is peanuts. Kindly do something lest we initiate an app union strike. Let it be known to you that I am not ashamed to stand with a friend. \n\tYours ${widget.name}';
                      });
                      ShowCaseWidget.of(context).startShowCase([_eight]);
                    },
                    onToolTipClick: () {
                      setState(() {
                        descriptionController.text =
                            'It is a matter of concern, that I\'d like the creators of this app to address. Clearly, you main employee by the name "2A" is working really hard. His works speak for themselves. It is such a shame that his pay is peanuts. Kindly do something lest we initiate an app union strike. Let it be known to you that I am not ashamed to stand with a friend. \n\tYours ${widget.name}';
                      });
                      ShowCaseWidget.of(context).startShowCase([_eight]);
                    },
                    disposeOnTap: true,
                    child: Description(
                      controller: descriptionController,
                      text: null,
                      height: 0.205 * height,
                    ),
                  ),
                ),
                Positioned(
                    top: 0.724 * height,
                    child: Showcase(
                      key: _eight,
                      description:
                          'By tapping the blue 🔵 button\nyou can attach📎 any file to send the \ndelegate: image,xls,docs,pdf 📁 name it\nFor now I\'ll leave it as it is\nYourself, don\'t be shy 🤗.',
                      targetBorderRadius: BorderRadius.only(
                          bottomLeft:
                              Radius.circular(16 * context.scaleFactor.hsf),
                          bottomRight:
                              Radius.circular(48 * context.scaleFactor.hsf),
                          topRight:
                              Radius.circular(48 * context.scaleFactor.hsf),
                          topLeft:
                              Radius.circular(16 * context.scaleFactor.hsf)),
                      onTargetClick: () {
                        ShowCaseWidget.of(context).startShowCase([_nine]);
                      },
                      onToolTipClick: () {
                        ShowCaseWidget.of(context).startShowCase([_nine]);
                      },
                      disposeOnTap: true,
                      child: Upload(
                        controller: uploadcontroller,
                        images: '',
                        cloudUpload: true,
                      ),
                    )),
                Positioned(
                    top: 0.844 * height,
                    left: 0.049 * width,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        context.loc.cancel,
                        style: CustomTextStyle(
                            context: context,
                            fontSz: 17,
                            fontWght: Fontweight.w600,
                            colour: FontColour.red,
                            normalSpacing: true),
                      ),
                    )),
                Positioned(
                    top: 0.844 * height,
                    right: 0.049 * width,
                    child: Showcase(
                      key: _nine,
                      description:
                          'Just like that you have delegated a task 👍🏼\nthis data will be uploaded to the cloud and\nthe delegate will receive 📬  the task\nCongratulations 🎊🎉 its that easy 👶🏼\nTap Assign',
                      targetBorderRadius:
                          BorderRadius.circular(8 * context.scaleFactor.hsf),
                      onTargetClick: () async {
                        LoadingScreen().show(
                            context: context,
                            text: context.loc.uploadingtocloud);

                        if (await hasNetwork()) {
                          if (beginTime.isAfter(finishTime) ||
                              dateTimeWithoutSeconds(beginTime)
                                  .isAtSameMomentAs(
                                      dateTimeWithoutSeconds(finishTime))) {
                            LoadingScreen().hide();
                            await showErrorDialog(
                                context, context.loc.settimeperiod);
                            return;
                          }
                          CloudUser? cloudUser =
                              await cloudService.getcloudUserwithEmail(
                                  cloudUserEmail: widget.contactEmail);
                          if (cloudUser != null) {
                            final proceed =
                                await storageExceeded(uploadcontroller.text);
                            if (proceed.isUploadLimitExceeded) {
                              await uploadtoCloud(
                                  proceed.listOfFilesforUpload, proceed.path);

                              try {
                                await cloudService.createNewCloudWork(
                                  assignerId: user!.id,
                                  assignerEmail: user!.email,
                                  assignedId: widget.contactId,
                                  assignedEmail: widget.contactEmail,
                                  isHomeWork: widget.isHome,
                                  title: titlecontroller.text,
                                  beginTime: beginTime.microsecondsSinceEpoch,
                                  finishTime: finishTime.microsecondsSinceEpoch,
                                  description: descriptionController.text,
                                  attachedFiles: uploadcontroller.text,
                                );
                                setState(() {
                                  deleteUploadedFiles = false;
                                });
                                Navigator.of(context).pop();
                                LoadingScreen().hide();
                              } catch (e) {
                                LoadingScreen().hide();
                                throw CouldNotCreateCloudWorkException();
                              }
                            } else {
                              LoadingScreen().hide();
                              await showErrorDialog(
                                  context, context.loc.maximumcloudsize);
                            }
                          } else {
                            LoadingScreen().hide();
                            await showErrorDialog(
                                context, context.loc.accountdoesnotexist);
                          }
                        } else {
                          //no internet connection
                          LoadingScreen().hide();
                          await showErrorDialog(
                              context, context.loc.failedrequestinternet);
                        }
                      },
                      onToolTipClick: () async {
                        LoadingScreen().show(
                            context: context,
                            text: context.loc.uploadingtocloud);

                        if (await hasNetwork()) {
                          if (beginTime.isAfter(finishTime) ||
                              dateTimeWithoutSeconds(beginTime)
                                  .isAtSameMomentAs(
                                      dateTimeWithoutSeconds(finishTime))) {
                            LoadingScreen().hide();
                            await showErrorDialog(
                                context, context.loc.settimeperiod);
                            return;
                          }
                          CloudUser? cloudUser =
                              await cloudService.getcloudUserwithEmail(
                                  cloudUserEmail: widget.contactEmail);
                          if (cloudUser != null) {
                            final proceed =
                                await storageExceeded(uploadcontroller.text);
                            if (proceed.isUploadLimitExceeded) {
                              await uploadtoCloud(
                                  proceed.listOfFilesforUpload, proceed.path);

                              try {
                                await cloudService.createNewCloudWork(
                                  assignerId: user!.id,
                                  assignerEmail: user!.email,
                                  assignedId: widget.contactId,
                                  assignedEmail: widget.contactEmail,
                                  isHomeWork: widget.isHome,
                                  title: titlecontroller.text,
                                  beginTime: beginTime.microsecondsSinceEpoch,
                                  finishTime: finishTime.microsecondsSinceEpoch,
                                  description: descriptionController.text,
                                  attachedFiles: uploadcontroller.text,
                                );
                                setState(() {
                                  deleteUploadedFiles = false;
                                });
                                Navigator.of(context).pop();
                                LoadingScreen().hide();
                              } catch (e) {
                                LoadingScreen().hide();
                                throw CouldNotCreateCloudWorkException();
                              }
                            } else {
                              LoadingScreen().hide();
                              await showErrorDialog(
                                  context, context.loc.maximumcloudsize);
                            }
                          } else {
                            LoadingScreen().hide();
                            await showErrorDialog(
                                context, context.loc.accountdoesnotexist);
                          }
                        } else {
                          //no internet connection
                          LoadingScreen().hide();
                          await showErrorDialog(
                              context, context.loc.failedrequestinternet);
                        }
                      },
                      disposeOnTap: true,
                      child: TextButton(
                        onPressed: () async {
                          LoadingScreen().show(
                              context: context,
                              text: context.loc.uploadingtocloud);

                          if (await hasNetwork()) {
                            if (beginTime.isAfter(finishTime) ||
                                dateTimeWithoutSeconds(beginTime)
                                    .isAtSameMomentAs(
                                        dateTimeWithoutSeconds(finishTime))) {
                              LoadingScreen().hide();
                              await showErrorDialog(
                                  context, context.loc.settimeperiod);
                              return;
                            }
                            CloudUser? cloudUser =
                                await cloudService.getcloudUserwithEmail(
                                    cloudUserEmail: widget.contactEmail);
                            if (cloudUser != null) {
                              final proceed =
                                  await storageExceeded(uploadcontroller.text);
                              if (proceed.isUploadLimitExceeded) {
                                await uploadtoCloud(
                                    proceed.listOfFilesforUpload, proceed.path);

                                try {
                                  await cloudService.createNewCloudWork(
                                    assignerId: user!.id,
                                    assignerEmail: user!.email,
                                    assignedId: widget.contactId,
                                    assignedEmail: widget.contactEmail,
                                    isHomeWork: widget.isHome,
                                    title: titlecontroller.text,
                                    beginTime: beginTime.microsecondsSinceEpoch,
                                    finishTime:
                                        finishTime.microsecondsSinceEpoch,
                                    description: descriptionController.text,
                                    attachedFiles: uploadcontroller.text,
                                  );
                                  setState(() {
                                    deleteUploadedFiles = false;
                                  });
                                  Navigator.of(context).pop();
                                  LoadingScreen().hide();
                                } catch (e) {
                                  LoadingScreen().hide();
                                  throw CouldNotCreateCloudWorkException();
                                }
                              } else {
                                LoadingScreen().hide();
                                await showErrorDialog(
                                    context, context.loc.maximumcloudsize);
                              }
                            } else {
                              LoadingScreen().hide();
                              await showErrorDialog(
                                  context, context.loc.accountdoesnotexist);
                            }
                          } else {
                            //no internet connection
                            LoadingScreen().hide();
                            await showErrorDialog(
                                context, context.loc.failedrequestinternet);
                          }
                        },
                        child: Text(
                          context.loc.assign,
                          style: CustomTextStyle(
                              context: context,
                              fontSz: 17,
                              fontWght: Fontweight.w600,
                              colour: FontColour.black,
                              normalSpacing: true),
                        ),
                      ),
                    )),
                Center(
                  child:
                      SizedBox(height: (height - appBa.preferredSize.height)),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  String begintime(DateTime date, bool isBegintime) {
    String hour;
    String minute;
    String weekday = Calendar(year: date.year, context: context)
        .months[date.weekday]!
        .weekday;

    if (date.hour < 10) {
      hour = '0${date.hour}';
    } else {
      hour = '${date.hour}';
    }
    if (date.minute < 10) {
      minute = '0${date.minute}';
    } else {
      minute = '${date.minute}';
    }

    return isBegintime
        ? "${context.loc.today}, $hour:$minute"
        : "${date.day}, $weekday, $hour:$minute";
  }
}

Future<
    ({
      bool isUploadLimitExceeded,
      List<String> listOfFilesforUpload,
      String path
    })> storageExceeded(String uploadFileText) async {
  int storageRequired = 0;
  List<String> filelist = [];
  final path = await pathtoCloudUploadedPicture();
  String fileString = uploadFileText.trim();
  if (fileString.isNotEmpty) {
    filelist = fileString.split(',');
    for (String element in filelist) {
      storageRequired += File('$path/$element').lengthSync();
    }
  }
  if (storageRequired > 153600) {
    return (
      isUploadLimitExceeded: false,
      listOfFilesforUpload: filelist,
      path: path
    );
  }
  return (
    isUploadLimitExceeded: true,
    listOfFilesforUpload: filelist,
    path: path
  );
}

Future<void> uploadtoCloud(List<String> documents, String path) async {
  final storageRef = FirebaseStorage.instance.ref();
  for (String element in documents) {
    try {
      await storageRef
          .child("files/cloudWorkdocs/$element")
          .putFile(File('$path/${element.trim()}'));
    } catch (e) {
      print(e);
    }
  }
}

Future<void> deleteUploadedLocalFiles(String filenames) async {
  if (filenames.isNotEmpty) {
    final storageRef = FirebaseStorage.instance.ref();
    List<String> fileNames = filenames.trim().split(',');
    final path = await pathtoCloudUploadedPicture();
    for (var element in fileNames) {
      File('$path/$element').delete();
      storageRef.child("files/cloudWorkdocs/$element").delete();
    }
  }
}

DateTime dateTimeWithoutSeconds(DateTime date) {
  return DateTime(date.year, date.month, date.day, date.hour, date.minute);
}
