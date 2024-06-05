// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/components/uploading/upload_exeptions.dart';
import 'package:two_a/database/cloud/cloud_user.dart';
import 'package:two_a/database/cloud/firebase_cloud_storage.dart';
import 'package:two_a/database/local/database_tables/online_userTable.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/helpers/loading/loading_screen.dart';
import 'package:two_a/main.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';
import 'package:two_a/views/homepage_view.dart';
import 'package:two_a/views/profile/user_profile.dart';

class ViewEditProfile extends StatefulWidget {
  final OnlineUser onlineUser;
  final String? path;
  const ViewEditProfile(
      {super.key, required this.onlineUser, required this.path});

  @override
  State<ViewEditProfile> createState() => _ViewEditProfileState();
}

class _ViewEditProfileState extends State<ViewEditProfile> {
  List<PlatformFile>? _paths;
  final storageRef = FirebaseStorage.instance.ref();
  final FirebaseCloudStorage cloudService = FirebaseCloudStorage();
  String? _fileName;
  String? profilePath;
  bool disableuploadbutton = false;

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _fileName = null;
      _paths = null;
    });
  }

  Future<File?> _pickFiles() async {
    _resetState();
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
      ))
          ?.files;
    } on PlatformException {
      throw UnsupportedPlatform();
    } catch (e) {
      throw LocalUploadException();
    }
    if (!mounted) return null;
    final file = File(_paths![0].path!);

    String? fileName = _paths?.map((e) => e.name).toString();
    if (fileName != null) {
      _fileName = fileName.replaceAll('(', '').replaceAll(')', '');

      var path = file.path;

      final croppedImage = await ImageCropper().cropImage(
          sourcePath: path,
          maxHeight: 320,
          maxWidth: 320,
          compressQuality: 100,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          cropStyle: CropStyle.circle,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: const Colour().primary,
              toolbarWidgetColor: const Colour().white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
          ]);
      if (croppedImage != null) {
        LoadingScreen()
            .show(context: context, text: context.loc.pleasewaitamoment);
        await File(path).delete();
        final metadata = SettableMetadata(contentType: "image/jpeg");
        await storageRef
            .child(
                "images/profilepictures/${widget.onlineUser.onlineUserId}.jpg")
            .putFile(File(croppedImage.path), metadata);
        final url = await storageRef
            .child(
                "images/profilepictures/${widget.onlineUser.onlineUserId}.jpg")
            .getDownloadURL();

        CloudUser cloudUser = await cloudService.getcloudUserwithEmail(
            cloudUserEmail: widget.onlineUser.accountEmail) as CloudUser;
        await cloudService.updatedCloudUser(
          documentId: cloudUser.documentId,
          workContacts: null,
          homeContacts: null,
          profilePicture: url,
        );
        String profilepicpath =
            await pathtoProfilePicture(widget.onlineUser.onlineUserId);
        File profpic = await moveFile(File(croppedImage.path), profilepicpath);
        LoadingScreen().hide();
        return profpic;
      } else {
        await File(path).delete();
        return null;
      }
    }
    return null;
  }

  @override
  void initState() {
    profilePath = widget.path;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      appBar: appBa,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: isLandScape ? 6 * hsf : 6 * hsf,
                //left: 0.085 * width - MediaQuery.of(context).viewPadding.left,
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  width: 150 * hsf,
                  height: 150 * hsf,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 0.6, color: const Colour().lHint),
                  ),
                  child: profilePath == null
                      ? Icon(
                          Icons.person_rounded,
                          size: 132 * hsf,
                        )
                      : Image.file(
                          File(profilePath!),
                          height: 150 * hsf,
                          width: 150 * hsf,
                          fit: BoxFit.fill,
                        ),
                )),
            Positioned(
                top: isLandScape ? 120 * hsf : 120 * hsf,
                left: 0.603 * width - MediaQuery.of(context).viewPadding.left,
                child: Container(
                  width: 36 * hsf,
                  height: 36 * hsf,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: disableuploadbutton
                        ? const Colour().lHint
                        : const Colour().primary,
                    shape: BoxShape.circle,
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        disabledIconColor: const Colour().red),
                    onPressed: disableuploadbutton
                        ? null
                        : () async {
                            if (await hasNetwork()) {
                              final image = await _pickFiles();

                              setState(() {
                                profilePath = null;
                                disableuploadbutton = true;
                              });
                              await Future.delayed(const Duration(seconds: 1));
                              setState(() {
                                profilePath = image?.path;
                                disableuploadbutton = false;
                              });
                            } else {
                              await showErrorDialog(
                                  context, context.loc.failedrequestinternet);
                            }
                          },
                    child: Icon(
                      Icons.edit,
                      size: 24 * hsf,
                      color: disableuploadbutton
                          ? const Colour().black
                          : const Colour().white,
                    ),
                  ),
                )),
            Positioned(
              top: isLandScape ? 177 * hsf : 177 * hsf,
              left: 0.109 * width + MediaQuery.of(context).viewPadding.left,
              child: Container(
                  height: 46 * hsf,
                  //color: const Colour().bhbtw,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 24 * hsf,
                        color: const Colour().black,
                      ),
                      Padding(padding: EdgeInsets.only(right: 0.064 * width)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.loc.accountname,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: CustomTextStyle(
                                context: context,
                                fontSz: 15,
                                fontWght: Fontweight.w400,
                                colour: FontColour.hintblack,
                                normalSpacing: true),
                          ),
                          SizedBox(
                            width: 0.653 * width,
                            child: Text(
                              nameGeneratedFromEmail(
                                  widget.onlineUser.accountEmail),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: CustomTextStyle(
                                  context: context,
                                  fontSz: 17,
                                  fontWght: Fontweight.w600,
                                  colour: FontColour.black,
                                  normalSpacing: true),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
            Positioned(
              top: isLandScape ? 258 * hsf : 258 * hsf,
              left: 0.109 * width + MediaQuery.of(context).viewPadding.left,
              child: Container(
                  height: 46 * hsf,
                  //color: const Colour().bhbtw,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Icon(
                        Icons.markunread_outlined,
                        size: 24 * hsf,
                        color: const Colour().black,
                      ),
                      Padding(padding: EdgeInsets.only(right: 0.064 * width)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            overflow: TextOverflow.ellipsis,
                            context.loc.accountemail,
                            style: CustomTextStyle(
                                context: context,
                                fontSz: 15,
                                fontWght: Fontweight.w400,
                                colour: FontColour.hintblack,
                                normalSpacing: true),
                          ),
                          SizedBox(
                            width: width * 0.653,
                            child: Text(
                              widget.onlineUser.accountEmail,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: CustomTextStyle(
                                  context: context,
                                  fontSz: 17,
                                  fontWght: Fontweight.w600,
                                  colour: FontColour.black,
                                  normalSpacing: true),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
            Center(
              child: SizedBox(
                height: !isLandScape
                    ? height - appBa.preferredSize.height
                    : width - appBa.preferredSize.height,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<({File compressedFile, String fileName})> compressFile(File file) async {
  var filePath = file.absolute.path;
  var result = file;
  int quality;
  final fileSize = file.lengthSync();
  XFile? compressed;
  // Create output file path
  // eg:- "Volume/VM/abcd_out.jpeg"
  switch (fileSize) {
    case <= 500000:
      quality = 95;
      break;
    case <= 1000000:
      quality = 90;
      break;
    case <= 1500000:
      quality = 85;
      break;
    case <= 2000000:
      quality = 75;
      break;
    case <= 3000000:
      quality = 65;
      break;
    default:
      quality = 55;
  }
  final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
  final splitted = filePath.substring(0, (lastIndex));
  final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
  int index = outPath.lastIndexOf(Platform.pathSeparator) + 1;
  final filename = outPath.substring(index);
  compressed = await FlutterImageCompress.compressAndGetFile(
    file.path,
    outPath,
    //quality: quality,
    minHeight: 600,
    minWidth: 600,
  );

  result = File(compressed!.path);
  return (compressedFile: File(result.path), fileName: filename);
}

Future<File> moveFile(File sourceFile, String newPath) async {
  try {
    // prefer using rename as it is probably faster
    return await sourceFile.rename(newPath);
  } on FileSystemException {
    // if rename fails, copy the source file and then delete it
    final newFile = await sourceFile.copy(newPath);
    await sourceFile.delete();
    return newFile;
  }
}
