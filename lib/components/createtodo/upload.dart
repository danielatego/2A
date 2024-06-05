import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:two_a/components/assign/desc_attach_toggle.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/createtodo/attached_files.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/components/uploading/upload_exeptions.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';
import 'package:two_a/views/homepage_view.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class Upload extends StatefulWidget {
  final String? path;
  final TextEditingController controller;
  final String images;
  final bool? isAssigner;
  final bool? disableupload;
  bool? cloudUpload;
  Upload(
      {super.key,
      required this.controller,
      required this.images,
      this.cloudUpload,
      this.isAssigner,
      this.disableupload,
      this.path});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  String? _fileName;
  late bool isRightSize;
  late String defaultPath;
  late List<String> attachedFiles;
  List<PlatformFile>? _paths;

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _fileName = null;
      _paths = null;
    });
  }

  Future<({String localpath, String cloudPath})> paths() async {
    final clouduploadPath = '${await pathtoCloudUploadedPicture()}/';
    final localUploadPath = "${await pathtoLocalUploadedFile()}/";
    return (localpath: localUploadPath, cloudPath: clouduploadPath);
  }

  Future<({File compressedFile, String fileName})> compressFile(
      File file) async {
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
    var filename = outPath.substring(index);
    compressed = await FlutterImageCompress.compressAndGetFile(
      file.path,
      outPath,
      quality: quality,
      minWidth: 480,
      minHeight: 270,
    );

    result = File(compressed!.path);
    return (compressedFile: result, fileName: filename);
  }

  void _pickFiles() async {
    _resetState();
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
      ))
          ?.files;
    } on PlatformException {
      throw UnsupportedPlatform();
    } catch (e) {
      throw LocalUploadException();
    }
    if (!mounted) return;

    String? fileName = _paths?.map((e) => e.name).toString();
    if (fileName != null) {
      _fileName = fileName.replaceAll('(', '').replaceAll(')', '');
      final file = File(_paths![0].path!);
      var path = file.path;
      attachedFiles.add(_fileName!);
      if (isPicture(fileName)) {
        attachedFiles.remove(_fileName);
        final compressedfile = await compressFile(file);
        final movedlocalfile = widget.cloudUpload ?? false
            ? await moveFile(compressedfile.compressedFile, true, null, false)
            : await moveFile(compressedfile.compressedFile, true, null, true);
        attachedFiles.add(movedlocalfile.cloudfilename);
        path = movedlocalfile.cloudFile.path;
        file.delete();
      } else {
        attachedFiles.remove(_fileName);
        final randomname = randomName();
        String filename =
            '$randomname${_fileName!.substring(_fileName!.lastIndexOf('.'))}';
        filename = filename.trim();
        attachedFiles.add(filename);
        if (widget.cloudUpload ?? false) {
          final cloudUploadedfile =
              await moveFile(file, false, filename, false);
          path = cloudUploadedfile.cloudFile.path;
        } else {
          final localUploadedfile = await moveFile(file, false, filename, true);
          path = localUploadedfile.cloudFile.path;
        }
      }

      final clouduploadPath = '${await pathtoCloudUploadedPicture()}/';
      final localUploadPath = '${await pathtoLocalUploadedFile()}/';
      var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
      setState(() {
        defaultPath =
            widget.cloudUpload ?? false ? clouduploadPath : localUploadPath;
      });
    }
    setState(() {
      widget.controller.text = attachedFiles
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll(' ', '');
    });
  }

  @override
  void initState() {
    if (widget.images.contains(',')) {
      attachedFiles = widget.images.split(',');
      widget.controller.text = attachedFiles
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll(' ', '');
    } else if (widget.images.isNotEmpty) {
      attachedFiles = [widget.images];
      widget.controller.text = attachedFiles
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll(' ', '');
    } else {
      attachedFiles = [];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final wsf = context.scaleFactor.wsf;
    final hsf = context.scaleFactor.hsf;
    final width = context.scaleFactor.width;
    final height = context.scaleFactor.height;
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SizedBox(
      height: isLandScape ? 0.071 * width : 0.071 * height,
      width: 0.901 * width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: isLandScape ? 0.071 * width : 0.071 * height,
            width: isLandScape ? 0.731 * width : 0.731 * width,
            decoration: BoxDecoration(
                color: const Colour().lHint2,
                borderRadius: BorderRadius.circular(8.0 * hsf)),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: wsf * 8),
                child: Scrollbar(
                    scrollbarOrientation: ScrollbarOrientation.bottom,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: attachedFiles.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: isPortrait ? height * 0.071 : height * 0.128,
                          width: isPortrait ? height * 0.071 : height * 0.128,
                          child: Material(
                            color: const Color.fromARGB(0, 255, 255, 255),
                            child: InkWell(
                              splashColor: const Colour().primary,
                              onTap: () async {
                                final path = await paths();
                                if (widget.cloudUpload ?? false) {
                                  setState(() {
                                    defaultPath = path.cloudPath;
                                  });
                                } else {
                                  setState(() {
                                    defaultPath = path.localpath;
                                  });
                                }
                                if (widget.isAssigner ?? false) {
                                  final clouduploadPath =
                                      '${await pathtoCloudUploadedPicture()}/';
                                  setState(() {
                                    defaultPath = clouduploadPath;
                                  });
                                  bool picAvailable =
                                      await getorDownloadCloudWorkDoc(
                                          clouduploadPath,
                                          attachedFiles[index]);
                                  picAvailable
                                      ? null
                                      // ignore: use_build_context_synchronously
                                      : await showErrorDialog(
                                          context,
                                          // ignore: use_build_context_synchronously
                                          context.loc.filedoesnotexist);
                                }

                                try {
                                  OpenFile.open(
                                      defaultPath + attachedFiles[index]);
                                } catch (e) {
                                  final clouduploadPath =
                                      '${await pathtoCloudUploadedPicture()}/';
                                  setState(() {
                                    defaultPath = clouduploadPath;
                                  });
                                  OpenFile.open(
                                      clouduploadPath + attachedFiles[index]);
                                }
                              },
                              onLongPress: () async {
                                final path = await paths();
                                if (widget.cloudUpload ?? false) {
                                  setState(() {
                                    defaultPath = path.cloudPath;
                                  });
                                } else {
                                  setState(() {
                                    defaultPath = path.localpath;
                                  });
                                }
                                // ignore: use_build_context_synchronously
                                bool proceed = await deleteContact(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    context.loc.deletefile);
                                if (proceed) {
                                  try {
                                    final image = File(
                                        defaultPath + attachedFiles[index]);
                                    await image.delete();

                                    setState(() {
                                      attachedFiles.removeWhere((element) =>
                                          element == attachedFiles[index]);
                                      attachedFiles = attachedFiles;
                                      widget.controller.text = attachedFiles
                                          .toString()
                                          .replaceAll('[', '')
                                          .replaceAll(']', '')
                                          .replaceAll(' ', '');
                                    });
                                  } catch (e) {
                                    // ignore: use_build_context_synchronously
                                    await showErrorDialog(context,
                                        context.loc.couldnotdeletefile);
                                  }
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  isPicture(attachedFiles[index])
                                      ? const Icon(Icons.image_outlined)
                                      : const Icon(Icons.file_present),
                                  Text(
                                    attachedFiles[index],
                                    overflow: TextOverflow.ellipsis,
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
                      separatorBuilder: (BuildContext context, int index) =>
                          Padding(
                              padding: EdgeInsets.only(
                                  left: isPortrait
                                      ? 0.026 * height
                                      : 0.048 * height)),
                    ))),
          ),
          Container(
            height: 48 * hsf,
            width: 48 * hsf,
            decoration: BoxDecoration(
                color: widget.disableupload ?? false
                    ? const Colour().lHint
                    : const Colour().primary,
                borderRadius: BorderRadius.all(Radius.circular(48.0 * hsf))),
            child: IconButton(
              splashRadius: 24 * hsf,
              color: const Colour().white,
              onPressed: widget.disableupload ?? false
                  ? null
                  : () {
                      _pickFiles();
                    },
              icon: Icon(
                semanticLabel: context.loc.attach,
                Icons.attach_file,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String> pathtoCloudUploadedPicture() async {
  final docPath = await getApplicationDocumentsDirectory();
  String path = docPath.path.substring(0, docPath.path.lastIndexOf('/'));

  return join(path, 'cache', 'cloudUploads', 'documents');
}

String randomName() {
  String randomName = const Uuid().v4();
  randomName = randomName.replaceAll(RegExp(r'-'), '').trim();
  return randomName;
}

Future<({File cloudFile, String cloudfilename})> moveFile(
    File sourceFile, bool isImageFile, String? filename, bool local) async {
  final docPath = await getApplicationDocumentsDirectory();
  String path = docPath.path.substring(0, docPath.path.lastIndexOf('/'));
  String randomname = randomName();
  String newPath = local
      ? join(path, 'cache', 'localUploads', 'documents',
          isImageFile ? '$randomname.jpg' : filename)
      : join(path, 'cache', 'cloudUploads', 'documents',
          isImageFile ? '$randomname.jpg' : filename);
  File newFile;
  try {
    newFile = await sourceFile.rename(newPath);
    // prefer using rename as it is probably faster
    return (
      cloudFile: newFile,
      cloudfilename: isImageFile ? '$randomname.jpg' : filename!
    );
  } on FileSystemException {
    local
        ? await Directory(join(path, 'cache', 'localUploads', 'documents'))
            .create(recursive: true)
        : await Directory(join(path, 'cache', 'cloudUploads', 'documents'))
            .create(recursive: true);

    // if rename fails, copy the source file and then delete it
    newFile = await sourceFile.copy(newPath);
    await sourceFile.delete();
    return (
      cloudFile: newFile,
      cloudfilename: isImageFile ? '$randomname.jpg' : filename!
    );
  }
}
