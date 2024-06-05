import 'package:flutter/material.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/createtodo/description.dart';
import 'package:two_a/components/createtodo/upload.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/database/cloud/cloud_storage_exceptions.dart';
import 'package:two_a/database/cloud/cloud_work.dart';
import 'package:two_a/database/cloud/firebase_cloud_storage.dart';
import 'package:two_a/database/local/database_service.dart';
import 'package:two_a/database/local/database_tables/cloud_work_status.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/firebase/bloc/auth_bloc.dart';
import 'package:two_a/helpers/loading/loading_screen.dart';
import 'package:two_a/views/home/components.dart';
import 'package:two_a/views/personal/Assign/assign.dart';

class CloudWorkAccounting extends StatefulWidget {
  final bool isAssigner;
  final String path;
  final LocalDatabaseService localDatabaseService;
  final CloudWork cloudWork;
  final FirebaseCloudStorage cloudService;

  const CloudWorkAccounting(
      {super.key,
      required this.path,
      required this.isAssigner,
      required this.cloudWork,
      required this.localDatabaseService,
      required this.cloudService});

  @override
  State<CloudWorkAccounting> createState() => _CloudWorkAccountingState();
}

class _CloudWorkAccountingState extends State<CloudWorkAccounting> {
  late final TextEditingController accountController;
  late final TextEditingController uploadController;
  late CloudWorkStatus cloudworkstatus;
  late Future<CloudWorkStatus> cloudWorkStatus;
  String? stateText;
  bool isPending = true;

  @override
  void initState() {
    accountController = TextEditingController();
    uploadController = TextEditingController();
    cloudWorkStatus =
        getorCreateCloudWorkStatus(localService, widget.cloudWork.documentId);
    super.initState();
  }

  @override
  void dispose() {
    if (!widget.isAssigner) {
      updateCloudWorkStatusOnClose(localService, accountController.text,
          uploadController.text, cloudworkstatus);
    }
    accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = context.scaleFactor.width;
    final hsf = context.scaleFactor.hsf;
    final wsf = context.scaleFactor.wsf;
    final height = context.scaleFactor.height;
    final Appba = CustomAppbar(
      back: true,
      tab: false,
      context: context,
      locTitle: null,
      appBarRequired: true,
    );
    return FutureBuilder<CloudWorkStatus>(
        future: cloudWorkStatus,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              cloudworkstatus = snapshot.data!;
              return Scaffold(
                  appBar: Appba,
                  body: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                          top: 0.009 * height,
                          child: HomeTitle(
                              title: context.loc.toaccount,
                              date: DateTime.fromMicrosecondsSinceEpoch(
                                  widget.cloudWork.beginTime))),
                      Positioned(
                          top: 0.126 * height,
                          child: TitleAndDuration(
                              beginTime: widget.cloudWork.beginTime,
                              finishTime: widget.cloudWork.finishTime,
                              title: widget.cloudWork.title)),
                      Positioned(
                          top: 0.223 * height,
                          child: Description(
                              controller: accountController,
                              text: widget.isAssigner
                                  ? widget.cloudWork.account
                                  : cloudworkstatus.accountMessage,
                              height: 0.442 * height,
                              isDescription: false,
                              readOnly: widget.isAssigner ||
                                  widget.cloudWork.pending ||
                                  stateText == context.loc.pendingapproval ||
                                  widget.cloudWork.completed ||
                                  stateText == context.loc.completed)),
                      Positioned(
                          top: 0.714 * height,
                          child: Upload(
                            path: widget.path,
                            isAssigner: widget.isAssigner,
                            controller: uploadController,
                            images: widget.isAssigner
                                ? widget.cloudWork.accountAttachedFiles
                                : cloudworkstatus.fileToUpload ?? '',
                            cloudUpload: true,
                            disableupload: widget.isAssigner ||
                                widget.cloudWork.pending ||
                                stateText == context.loc.pendingapproval ||
                                widget.cloudWork.completed ||
                                stateText == context.loc.completed,
                          )),
                      Positioned(
                          bottom: 0.048 * height,
                          child: Material(
                            color: const Colour().lbg,
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(8 * hsf),
                            child: InkWell(
                              onTap: widget.isAssigner ||
                                      widget.cloudWork.pending
                                  ? null
                                  : widget.cloudWork.completed ||
                                          stateText != null
                                      ? null
                                      : () async {
                                          LoadingScreen().show(
                                              context: context,
                                              text:
                                                  context.loc.uploadingtocloud);
                                          if (widget.isAssigner == false &&
                                              widget.cloudWork.pending ==
                                                  false) {
                                            final proceed =
                                                await storageExceeded(
                                                    uploadController.text);
                                            if (proceed.isUploadLimitExceeded) {
                                              await uploadtoCloud(
                                                  proceed.listOfFilesforUpload,
                                                  proceed.path);
                                            }
                                            try {
                                              await cloudService
                                                  .updateCloudWork(
                                                      documentId: widget
                                                          .cloudWork.documentId,
                                                      pending: true,
                                                      account: accountController
                                                          .text,
                                                      uploadedfiles:
                                                          uploadController
                                                              .text);
                                              LoadingScreen().hide();
                                              setState(() {
                                                stateText =
                                                    context.loc.pendingapproval;
                                              });
                                            } catch (e) {
                                              LoadingScreen().hide();
                                              throw CouldNotUpdateCloudWorkException();
                                            }
                                          }
                                        },
                              child: Center(
                                child: Text(
                                  stateText ??
                                      (widget.isAssigner
                                          ? widget.cloudWork.pending
                                              ? ""
                                              : widget.cloudWork.completed
                                                  ? context.loc.completed
                                                  : context.loc.underway
                                          : widget.cloudWork.pending
                                              ? context.loc.pendingapproval
                                              : widget.cloudWork.completed
                                                  ? context.loc.completed
                                                  : context.loc.submit),
                                  style: CustomTextStyle(
                                      context: context,
                                      fontSz: 17,
                                      fontWght: Fontweight.w600,
                                      colour: (stateText != null)
                                          ? FontColour.green
                                          : null),
                                ),
                              ),
                            ),
                          )),
                      (widget.cloudWork.pending &&
                              widget.isAssigner &&
                              isPending)
                          ? Positioned(
                              bottom: 0.048 * height,
                              child: SizedBox(
                                width: 0.901 * width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Material(
                                      color: const Colour().lbg,
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius:
                                          BorderRadius.circular(8 * hsf),
                                      child: InkWell(
                                        onTap: () async {
                                          LoadingScreen().show(
                                              context: context,
                                              text:
                                                  context.loc.uploadingtocloud);
                                          try {
                                            await widget.cloudService
                                                .updateCloudWork(
                                                    documentId: widget
                                                        .cloudWork.documentId,
                                                    pending: false);
                                            setState(() {
                                              isPending = false;
                                              stateText = context.loc.needswork;
                                            });
                                            LoadingScreen().hide();
                                          } catch (e) {
                                            LoadingScreen().hide();
                                            throw CouldNotUpdateCloudWorkException();
                                          }
                                        },
                                        child: Center(
                                          child: Text(
                                            context.loc.needswork,
                                            style: CustomTextStyle(
                                                context: context,
                                                fontSz: 17,
                                                fontWght: Fontweight.w600,
                                                colour: FontColour.red),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: const Colour().lbg,
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius:
                                          BorderRadius.circular(8 * hsf),
                                      child: InkWell(
                                        onTap: () async {
                                          LoadingScreen().show(
                                              context: context,
                                              text:
                                                  context.loc.uploadingtocloud);
                                          try {
                                            await widget.cloudService
                                                .updateCloudWork(
                                                    documentId: widget
                                                        .cloudWork.documentId,
                                                    pending: false,
                                                    completed: true);
                                            setState(() {
                                              isPending = false;
                                              stateText = context.loc.completed;
                                            });
                                            LoadingScreen().hide();
                                          } catch (e) {
                                            LoadingScreen().hide();
                                            throw CouldNotUpdateCloudWorkException();
                                          }
                                        },
                                        child: Center(
                                          child: Text(
                                            context.loc.markdone,
                                            style: CustomTextStyle(
                                              context: context,
                                              fontSz: 17,
                                              fontWght: Fontweight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ))
                          : Container(),
                      Center(
                        child: SizedBox(
                          height: height - Appba.preferredSize.height,
                        ),
                      )
                    ],
                  ));

            default:
              return Container();
          }
        });
  }
}

Future<CloudWorkStatus> getorCreateCloudWorkStatus(
    LocalDatabaseService localservice, String documentId) async {
  return await localservice.getorCreateCloudWorkStatus(documentId: documentId);
}

Future<void> updateCloudWorkStatusOnClose(
    LocalDatabaseService localservice,
    String? accountMessage,
    String? uploads,
    CloudWorkStatus cloudWorkStatus) async {
  await localservice.updateCloudWorkStatus(
      cloudWorkStatus: cloudWorkStatus,
      accountMessage: accountMessage,
      fileToUpload: uploads);
}
