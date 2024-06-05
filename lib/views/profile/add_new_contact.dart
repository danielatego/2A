// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:two_a/ads/ads_state.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/cloudOnlineprofile/contact.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/components/textfield.dart';
import 'package:two_a/database/cloud/cloud_user.dart';
import 'package:two_a/database/cloud/firebase_cloud_storage.dart';
import 'package:two_a/database/local/database_service.dart';
import 'package:two_a/database/local/database_tables/online_userTable.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/helpers/loading/loading_screen.dart';
import 'package:two_a/main.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';
import 'package:two_a/views/profile/edit_contactname.dart';
import 'package:two_a/views/profile/user_profile.dart';

class AddNewContact extends StatefulWidget {
  final String? userEmail;
  final OnlineUser onlineUser;
  final bool? onTutorial;
  const AddNewContact(
      {super.key, required this.onlineUser, this.userEmail, this.onTutorial});

  @override
  State<AddNewContact> createState() => _AddNewContactState();
}

class _AddNewContactState extends State<AddNewContact> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();
  late FirebaseCloudStorage cloudService;
  late LocalDatabaseService localDatabaseService;
  late TextEditingController emailController;
  CloudUser? searchedCloudUser;
  bool resultLoadedNowShow = false;
  late Contact _contact;
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';
  late BannerAd banner;
  BuildContext? myContext;
  @override
  void initState() {
    cloudService = FirebaseCloudStorage();
    localDatabaseService = LocalDatabaseService();
    emailController = TextEditingController();
    emailController.text = widget.userEmail ?? '';
    _contact = Contact();
    widget.onTutorial ?? false
        ? WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(const Duration(milliseconds: 200), () {
              ShowCaseWidget.of(myContext!).startShowCase([_one]);
            });
          })
        : null;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AdState adState = Provider.of<AdState>(context);
    adState.initialization.then((value) {
      setState(() {
        banner = BannerAd(
            size: AdSize.mediumRectangle,
            adUnitId: adState.bannerAdUnit,
            listener: adState.adListener,
            request: const AdRequest())
          ..load();
      });
    });
  }

  @override
  void dispose() {
    cloudService;
    localDatabaseService;
    emailController.dispose();
    _contact;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hsf = context.scaleFactor.hsf;
    final wsf = context.scaleFactor.wsf;
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
    return ShowCaseWidget(
        disableBarrierInteraction: true,
        enableShowcase: widget.onTutorial ?? false,
        builder: Builder(
          builder: (context) {
            myContext = context;
            return Scaffold(
              appBar: appBa,
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    Positioned(
                        top: isLandScape ? 6 * hsf : 6 * hsf,
                        left: MediaQuery.of(context).viewPadding.left,
                        child: Container(
                            height: 32 * hsf,
                            width: width,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  margin: EdgeInsets.only(right: 10 * wsf),
                                  padding: EdgeInsets.only(left: 3.5 * hsf),
                                  width: 32 * hsf,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 0.0,
                                        color: const Colour().black),
                                  ),
                                  child: Icon(
                                    Icons.person_add_alt_1,
                                    size: 24 * hsf,
                                  ),
                                ),
                                Text(
                                  context.loc.addnewcontact2,
                                  style: CustomTextStyle(
                                      context: context,
                                      fontSz: 17,
                                      fontWght: Fontweight.w500,
                                      colour: FontColour.black,
                                      normalSpacing: true),
                                )
                              ],
                            ))),
                    Positioned(
                      top: isLandScape ? 98 * hsf : 98 * hsf,
                      left: 0.137 * width +
                          MediaQuery.of(context).viewPadding.left,
                      child: SizedBox(
                        width: 0.725 * width,
                        child: Showcase(
                          key: _one,
                          description:
                              'Enter the email of any 2A user 😳\nI understand you are probably new and\nprobably none of you pals are on 2A yet\nHakuna matata 🐗,  \n💡even your 2A email will work\nI\'ll add you for you 🤣.\nTap me 🤓 to continue',
                          targetBorderRadius: BorderRadius.circular(8 * hsf),
                          onTargetClick: () {
                            setState(() {
                              emailController.text =
                                  widget.onlineUser.accountEmail;
                            });
                            ShowCaseWidget.of(context).startShowCase([_two]);
                          },
                          onToolTipClick: () {
                            setState(() {
                              emailController.text =
                                  widget.onlineUser.accountEmail;
                            });
                            ShowCaseWidget.of(context).startShowCase([_two]);
                          },
                          disposeOnTap: false,
                          child: CustomTextField(
                            context: context,
                            isEmail: true,
                            controllerr: emailController,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: isLandScape ? 170 * hsf : 170 * hsf,
                        left: MediaQuery.of(context).viewPadding.left,
                        child: Container(
                          height: 20 * hsf,
                          width: width,
                          alignment: Alignment.center,
                          child: Showcase(
                            key: _two,
                            description:
                                'Tap me to search the cloud ☁️\nJust make sure you have internet connection',
                            disposeOnTap: true,
                            onTargetClick: () async {
                              setState(() {
                                resultLoadedNowShow = false;
                              });
                              CloudUser? cloudUser;
                              final cloudUserEmail =
                                  emailController.text.toLowerCase().trim();
                              LoadingScreen().show(
                                  context: context,
                                  text: context.loc.pleasewaitamoment);
                              if (await hasNetwork()) {
                                try {
                                  cloudUser =
                                      await cloudService.getcloudUserwithEmail(
                                          cloudUserEmail: cloudUserEmail);
                                  if (cloudUser == null) {
                                    LoadingScreen().hide();
                                    await showErrorDialog(context,
                                        context.loc.couldnotfindContact);
                                    return;
                                  }
                                  LoadingScreen().hide();
                                  ShowCaseWidget.of(context)
                                      .startShowCase([_three]);
                                  await Future.delayed(
                                      const Duration(milliseconds: 500));
                                  setState(() {
                                    searchedCloudUser = cloudUser;
                                    resultLoadedNowShow = true;
                                  });
                                } catch (e) {
                                  LoadingScreen().hide;
                                  await showErrorDialog(
                                      context, context.loc.couldnotfindContact);
                                }
                              } else {
                                LoadingScreen().hide();
                                await showErrorDialog(
                                    context, context.loc.failedrequestinternet);
                              }
                            },
                            onToolTipClick: () async {
                              setState(() {
                                resultLoadedNowShow = false;
                              });
                              CloudUser? cloudUser;
                              final cloudUserEmail =
                                  emailController.text.toLowerCase().trim();
                              LoadingScreen().show(
                                  context: context,
                                  text: context.loc.pleasewaitamoment);
                              if (await hasNetwork()) {
                                try {
                                  cloudUser =
                                      await cloudService.getcloudUserwithEmail(
                                          cloudUserEmail: cloudUserEmail);
                                  if (cloudUser == null) {
                                    LoadingScreen().hide();
                                    await showErrorDialog(context,
                                        context.loc.couldnotfindContact);
                                    return;
                                  }
                                  LoadingScreen().hide();
                                  ShowCaseWidget.of(context)
                                      .startShowCase([_three]);
                                  await Future.delayed(
                                      const Duration(milliseconds: 500));
                                  setState(() {
                                    searchedCloudUser = cloudUser;
                                    resultLoadedNowShow = true;
                                  });
                                } catch (e) {
                                  LoadingScreen().hide;
                                  await showErrorDialog(
                                      context, context.loc.couldnotfindContact);
                                }
                              } else {
                                LoadingScreen().hide();
                                await showErrorDialog(
                                    context, context.loc.failedrequestinternet);
                              }
                            },
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(0)),
                              onPressed: () async {
                                setState(() {
                                  resultLoadedNowShow = false;
                                });
                                CloudUser? cloudUser;
                                final cloudUserEmail =
                                    emailController.text.toLowerCase().trim();
                                LoadingScreen().show(
                                    context: context,
                                    text: context.loc.pleasewaitamoment);
                                if (await hasNetwork()) {
                                  try {
                                    cloudUser = await cloudService
                                        .getcloudUserwithEmail(
                                            cloudUserEmail: cloudUserEmail);
                                    if (cloudUser == null) {
                                      LoadingScreen().hide();
                                      await showErrorDialog(context,
                                          context.loc.couldnotfindContact);
                                      return;
                                    }
                                    LoadingScreen().hide();
                                    await Future.delayed(
                                        const Duration(milliseconds: 500));
                                    setState(() {
                                      searchedCloudUser = cloudUser;
                                      resultLoadedNowShow = true;
                                    });
                                  } catch (e) {
                                    LoadingScreen().hide;
                                    await showErrorDialog(context,
                                        context.loc.couldnotfindContact);
                                  }
                                } else {
                                  LoadingScreen().hide();
                                  await showErrorDialog(context,
                                      context.loc.failedrequestinternet);
                                }
                              },
                              child: Text(
                                context.loc.search,
                                style: CustomTextStyle(
                                    context: context,
                                    fontSz: 17,
                                    fontWght: Fontweight.w500,
                                    colour: FontColour.black,
                                    normalSpacing: true),
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                        top: isLandScape ? 244 * hsf : 244 * hsf,
                        left: 0.137 * width +
                            MediaQuery.of(context).viewPadding.left,
                        child: Showcase(
                          key: _three,
                          description:
                              'Voilà! 😁 there you are\nif you haven\'t uploaded your profile picture📸\ntake a selfie🤳🏼 and add it after this tutorial,\nTap me to proceed',
                          targetBorderRadius: BorderRadius.circular(16 * hsf),
                          onTargetClick: () {
                            ShowCaseWidget.of(context).startShowCase([_four]);
                          },
                          onToolTipClick: () {
                            ShowCaseWidget.of(context).startShowCase([_four]);
                          },
                          disposeOnTap: true,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: resultLoadedNowShow ? 1.0 : 0.0,
                            child: Container(
                              height: 91 * hsf,
                              width: 0.723 * width,
                              padding: const EdgeInsets.all(0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16 * hsf),
                                color: const Colour().lHint2,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                      top: 15.5 * hsf,
                                      left: 15.5 * hsf,
                                      child: Container(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        width: 60 * hsf,
                                        height: 60 * hsf,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 0.0,
                                              color: const Colour().black),
                                        ),
                                        child: searchedCloudUser == null
                                            ? Icon(
                                                Icons.person,
                                                size: 40 * hsf,
                                              )
                                            : searchedCloudUser!
                                                        .profilePicture ==
                                                    null
                                                ? Icon(
                                                    Icons.person,
                                                    size: 40 * hsf,
                                                  )
                                                : Image.network(
                                                    searchedCloudUser!
                                                        .profilePicture!,
                                                    fit: BoxFit.fill,
                                                  ),
                                      )),
                                  Positioned(
                                      top: 15.5 * hsf,
                                      left: 0.245 * width,
                                      child: SizedBox(
                                        width: 0.260 * width,
                                        child: Text(
                                          nameGeneratedFromEmail(
                                              searchedCloudUser?.accountEmail ??
                                                  'user@gmail.com'),
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                          softWrap: false,
                                          style: CustomTextStyle(
                                              context: context,
                                              fontSz: 17,
                                              fontWght: Fontweight.w500,
                                              colour: FontColour.black,
                                              normalSpacing: true),
                                        ),
                                      )),
                                  Positioned(
                                    top: 54 * hsf,
                                    left: 0.245 * width,
                                    child: Showcase(
                                      key: _five,
                                      description:
                                          'To add the contact to home contacts\ntap on "Home" 🤐\nTap to proceed',
                                      targetBorderRadius:
                                          BorderRadius.circular(8 * hsf),
                                      onTargetClick: () {
                                        emailController.clear();
                                        setState(() {
                                          resultLoadedNowShow = false;
                                        });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                                builder: (context) =>
                                                    EditContactToSave(
                                                        onTutorial: true,
                                                        userToAdd:
                                                            searchedCloudUser!,
                                                        addtoHome: true)));
                                      },
                                      onToolTipClick: () {
                                        emailController.clear();
                                        setState(() {
                                          resultLoadedNowShow = false;
                                        });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                                builder: (context) =>
                                                    EditContactToSave(
                                                        onTutorial: true,
                                                        userToAdd:
                                                            searchedCloudUser!,
                                                        addtoHome: true)));
                                      },
                                      disposeOnTap: true,
                                      child: Container(
                                          height: 24 * hsf,
                                          alignment: Alignment.center,
                                          width: 0.171 * width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8 * hsf),
                                            color: const Colour().green,
                                          ),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(0)),
                                            onPressed: () async {
                                              emailController.clear();
                                              setState(() {
                                                resultLoadedNowShow = false;
                                              });
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                      builder: (context) =>
                                                          EditContactToSave(
                                                              userToAdd:
                                                                  searchedCloudUser!,
                                                              addtoHome:
                                                                  true)));
                                            },
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(context.loc.home,
                                                      style: CustomTextStyle(
                                                          context: context,
                                                          fontSz: 14,
                                                          fontWght:
                                                              Fontweight.w500,
                                                          colour:
                                                              FontColour.white,
                                                          normalSpacing: true))
                                                ]),
                                          )),
                                    ),
                                  ),
                                  Positioned(
                                    top: 54 * hsf,
                                    right: 0.042 * width,
                                    child: Showcase(
                                      key: _four,
                                      description:
                                          'To add to work contacts tap this\nMy advice...🤵🏻\nreserve work contacts for important contacts\nbut who am i to advise 😹\norganize your contacts as you please\ntap to continue',
                                      targetBorderRadius:
                                          BorderRadius.circular(8 * hsf),
                                      disposeOnTap: true,
                                      onTargetClick: () {
                                        ShowCaseWidget.of(context)
                                            .startShowCase([_five]);
                                      },
                                      onToolTipClick: () {
                                        ShowCaseWidget.of(context)
                                            .startShowCase([_five]);
                                      },
                                      child: Container(
                                          height: 24 * hsf,
                                          alignment: Alignment.center,
                                          width: 0.171 * width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8 * hsf),
                                            color: const Colour().primary,
                                          ),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(0)),
                                            onPressed: () async {
                                              emailController.clear();
                                              setState(() {
                                                resultLoadedNowShow = false;
                                              });
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                      builder: (context) =>
                                                          EditContactToSave(
                                                              userToAdd:
                                                                  searchedCloudUser!,
                                                              addtoHome:
                                                                  false)));
                                            },
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(context.loc.work,
                                                      style: CustomTextStyle(
                                                          context: context,
                                                          fontSz: 14,
                                                          fontWght:
                                                              Fontweight.w500,
                                                          colour:
                                                              FontColour.white,
                                                          normalSpacing: true))
                                                ]),
                                          )),
                                    ),
                                  ),
                                  Positioned(
                                    top: 2 * hsf,
                                    right: 5 * hsf,
                                    child: Container(
                                      padding: const EdgeInsets.all(0),
                                      height: 24 * hsf,
                                      width: 24 * hsf,
                                      alignment: Alignment.topRight,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                            padding: const EdgeInsets.all(0)),
                                        onPressed: () {
                                          setState(() {
                                            resultLoadedNowShow = false;
                                          });
                                        },
                                        child: Icon(
                                          Icons.shortcut_outlined,
                                          size: 17 * hsf,
                                          color: const Colour().black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: SizedBox(
                                      height: 91 * hsf,
                                      width: 0.723 * width,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                      bottom: 0,
                      child: (banner != null)
                          ? SizedBox(
                              height: 250 * hsf,
                              width: MediaQuery.of(context).size.width,
                              child: AdWidget(ad: banner))
                          : SizedBox(
                              height: 250 * hsf,
                              width: MediaQuery.of(context).size.width),
                    ),
                    Center(
                      child: SizedBox(
                        height: !isLandScape
                            ? height - appBa.preferredSize.height
                            : width - appBa.preferredSize.height,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
