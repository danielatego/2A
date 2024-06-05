import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/createtodo/attached_files.dart';
import 'package:two_a/components/createtodo/upload.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';

class DescriptionAttachToggle extends StatefulWidget {
  final String? description;
  final bool isAssigner;
  final String? attachedFiles;
  final String path;
  const DescriptionAttachToggle(
      {required this.description,
      required this.attachedFiles,
      required this.path,
      super.key,
      required this.isAssigner});

  @override
  State<DescriptionAttachToggle> createState() {
    return _DescriptionAttachToggleState();
  }
}

class _DescriptionAttachToggleState extends State<DescriptionAttachToggle> {
  bool isDescription = true;

  Future<String> attachedpath() async {
    final clouduploadPath = '${await pathtoCloudUploadedPicture()}/';
    return clouduploadPath;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController descriptioncontroller = TextEditingController();
    descriptioncontroller.text = widget.description ?? '';
    final width = context.scaleFactor.width;
    final height = context.scaleFactor.height;
    final hsf = context.scaleFactor.hsf;
    List<String> attachedList =
        generateImageListFromString(widget.attachedFiles);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 9.0 * hsf),
          child: Row(
            children: [
              InkWell(
                child: Icon(
                  Icons.circle,
                  color: isDescription
                      ? const Colour().primary
                      : const Colour().lHint,
                  size: 6 * hsf,
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 8 * hsf)),
              InkWell(
                child: Icon(
                  Icons.circle,
                  color: isDescription
                      ? const Colour().lHint
                      : const Colour().green,
                  size: 6 * hsf,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 0.142 * height,
          width: 0.85 * width,
          child: RotatedBox(
            quarterTurns: -1,
            child: ListWheelScrollView.useDelegate(
                itemExtent: 0.749 * width,
                onSelectedItemChanged: (index) {
                  setState(() {
                    isDescription = !isDescription;
                  });
                },
                physics: const FixedExtentScrollPhysics(),
                childDelegate: ListWheelChildLoopingListDelegate(children: [
                  RotatedBox(
                    quarterTurns: 1,
                    child: Container(
                      height: 0.096 * height,
                      width: 0.749 * width,
                      decoration: BoxDecoration(
                        color: const Colour().lHint2,
                        borderRadius:
                            BorderRadius.all(Radius.circular(8.0 * hsf)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: 8 * hsf, top: 8 * hsf),
                            child: Container(
                              height: 20 * hsf,
                              width: 20 * hsf,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Colour().primary),
                              child: Icon(
                                Icons.description,
                                size: 14 * hsf,
                                color: const Colour().white,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 16 * hsf)),
                          SizedBox(
                            width: 0.602 * width,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(0),
                              child: TextField(
                                readOnly: true,
                                onTapOutside: (event) => {
                                  FocusManager.instance.primaryFocus?.unfocus()
                                },
                                controller: descriptioncontroller,
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
                                    hintText: context.loc.description,
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.only(top: 10 * hsf)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 1,
                    child: Container(
                      height: 0.096 * height,
                      width: 0.749 * width,
                      decoration: BoxDecoration(
                        color: const Colour().lHint2,
                        borderRadius:
                            BorderRadius.all(Radius.circular(8.0 * hsf)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(top: 8 * hsf, left: 8 * hsf),
                            child: Container(
                              height: 20 * hsf,
                              width: 20 * hsf,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Colour().green),
                              child: Icon(
                                Icons.attach_file_rounded,
                                size: 14 * hsf,
                                color: const Colour().white,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 8 * hsf)),
                          SizedBox(
                            height: 0.096 * height,
                            width: 0.602 * width,
                            child: Scrollbar(
                                trackVisibility: true,
                                scrollbarOrientation:
                                    ScrollbarOrientation.bottom,
                                child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: attachedList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: height * 0.071,
                                        width: height * 0.071,
                                        child: Material(
                                          color: const Color.fromARGB(
                                              0, 255, 255, 255),
                                          child: InkWell(
                                            splashColor: const Colour().primary,
                                            onTap: () async {
                                              if (widget.isAssigner) {
                                                try {
                                                  File(widget.path +
                                                          attachedList[index])
                                                      .lengthSync();
                                                  OpenFile.open(widget.path +
                                                      attachedList[index]);
                                                } on FileSystemException catch (e) {
                                                  if (e.message ==
                                                      'Cannot retrieve length of file') {
                                                    await showErrorDialog(
                                                        context,
                                                        context.loc
                                                            .filedoesnotexist);
                                                  }
                                                }
                                              } else {
                                                bool isImageAvailable =
                                                    await getorDownloadCloudWorkDoc(
                                                        widget.path,
                                                        attachedList[index]);
                                                if (isImageAvailable) {
                                                  OpenFile.open(widget.path +
                                                      attachedList[index]);
                                                } else {
                                                  // ignore: use_build_context_synchronously
                                                  await showErrorDialog(
                                                      context,
                                                      // ignore: use_build_context_synchronously
                                                      context.loc
                                                          .filedoesnotexist);
                                                }
                                              }

                                              //
                                              // OpenFile.open(widget.path +
                                              //     attachedList[index]);
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                isPicture(attachedList[index])
                                                    ? const Icon(
                                                        Icons.image_outlined)
                                                    : const Icon(
                                                        Icons.file_present),
                                                Text(
                                                  attachedList[index],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: CustomTextStyle(
                                                      context: context,
                                                      fontSz: 10,
                                                      fontWght: Fontweight.w400,
                                                      colour: FontColour.black,
                                                      normalSpacing: true),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 0.026 * height),
                                            ))),
                          ),
                        ],
                      ),
                    ),
                  )
                ])),
          ),
        ),
      ],
    );
  }
}

List<String> generateImageListFromString(String? imagesString) {
  List<String> imagesList = [];
  if (imagesString != null && imagesString.isNotEmpty) {
    if (imagesString.contains(',')) {
      imagesString.trim();
      imagesList = imagesString.split(',');
      return imagesList;
    }
    imagesList.add(imagesString);
    return imagesList;
  } else {
    return imagesList;
  }
}

Future<bool> getorDownloadCloudWorkDoc(String path, String nameOfFile) async {
  try {
    File(path + nameOfFile).lengthSync();
    return true;
  } on FileSystemException catch (e) {
    if (e.message == 'Cannot retrieve length of file') {
      await Directory(path).create(recursive: true);

      final file = File(path + nameOfFile);
      final storageRef = FirebaseStorage.instance.ref();
      final onlineprofpic = storageRef.child("files/cloudWorkdocs/$nameOfFile");
      try {
        await onlineprofpic.getMetadata();
        onlineprofpic.writeToFile(file).snapshotEvents.listen((event) async {
          switch (event.state) {
            case TaskState.success:
              await onlineprofpic.delete();
              break;
            default:
          }
        });
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}
