import 'package:flutter/material.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/createtodo/upload.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/database/local/database_service.dart';
import 'package:two_a/database/local/database_tables/personal_task_table.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

class AccountPersonalTask extends StatefulWidget {
  final PersonalTodo todo;
  final String date;
  const AccountPersonalTask(
      {super.key, required this.todo, required this.date});

  @override
  State<AccountPersonalTask> createState() => _AccountPersonalTaskState();
}

class _AccountPersonalTaskState extends State<AccountPersonalTask> {
  late Future<PersonalTodo> _todofuture;
  late PersonalTodo _todo;

  late final LocalDatabaseService _todoService;
  late TextEditingController accountText, accountImages;
  late bool done;
  @override
  void initState() {
    _todoService = LocalDatabaseService();
    accountText = TextEditingController();
    accountImages = TextEditingController();
    _todofuture = gettodo();
    accountText.text = widget.todo.accountMessage ?? '';
    //done = widget.todo.done;
    super.initState();
  }

  @override
  void dispose() {
    updatetodo();
    accountImages.dispose();
    accountText.dispose();
    super.dispose();
  }

  Future<PersonalTodo> gettodo() async {
    final todo = await _todoService.getTodo(id: widget.todo.taskId);
    if (todo.accountMessage != null) {
      accountText.text = todo.accountMessage ?? '';
    }
    done = todo.done;
    return todo;
  }

  void updatetodo() {
    _todoService.updateTodo(
        todo: widget.todo,
        title: null,
        done: done,
        isAllDay: null,
        archived: null,
        startTime: null,
        endTime: null,
        dateOfCreation: null,
        alertTime: null,
        alertFrequency: null,
        fileAttachment: null,
        description: null,
        accountAttachment: accountImages.text,
        accountMessage: accountText.text);
  }

  @override
  Widget build(BuildContext context) {
    accountImages.addListener(updatetodo);
    accountText.addListener(updatetodo);
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
    return Scaffold(
      appBar: appBa,
      body: FutureBuilder(
          future: _todofuture,
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _todo = snapshot.data as PersonalTodo;
                accountImages.addListener(updatetodo);
                accountText.addListener(updatetodo);
                return SingleChildScrollView(
                  child: Stack(
                    children: [
                      Positioned(
                        top: isLandScape ? 6 * hsf : 6 * hsf,
                        left: (0.083 * width) +
                            MediaQuery.of(context).viewPadding.left,
                        child: Text(
                          context.loc.task(1),
                          style: CustomTextStyle(
                              context: context,
                              fontSz: 27.41,
                              fontWght: Fontweight.w400,
                              colour: FontColour.black,
                              normalSpacing: false),
                        ),
                      ),
                      Positioned(
                        top: isLandScape ? 38 * hsf : 38 * hsf,
                        left: (0.083 * width) +
                            MediaQuery.of(context).viewPadding.left,
                        child: Text(
                          widget.date,
                          style: CustomTextStyle(
                              context: context,
                              fontSz: 12,
                              fontWght: Fontweight.w500,
                              colour: FontColour.hintblack,
                              normalSpacing: true),
                        ),
                      ),
                      Positioned(
                          top: 84 * hsf,
                          child: SizedBox(
                            width: width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.todo.title,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 15 * wsf,
                                      fontWeight: FontWeight.w400,
                                      color: const Colour().black,
                                      decoration: done
                                          ? TextDecoration.lineThrough
                                          : null),
                                ),
                                Text(
                                  '${widget.todo.startTime ?? ''} - ${widget.todo.endTime ?? ''}',
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 10 * wsf,
                                      fontWeight: FontWeight.w400,
                                      color: const Colour().bhbtw,
                                      decoration: done
                                          ? TextDecoration.lineThrough
                                          : null),
                                ),
                              ],
                            ),
                          )),
                      Positioned(
                        top: isLandScape ? 149 * hsf : 149 * hsf,
                        left: (0.051 * width) +
                            MediaQuery.of(context).viewPadding.left,
                        child: Container(
                          height: isLandScape ? 0.405 * width : 0.405 * height,
                          width: isLandScape ? 0.899 * width : 0.899 * width,
                          decoration: BoxDecoration(
                            color: const Colour().lHint2,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0 * hsf)),
                          ),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 16 * wsf),
                            child: TextField(
                              controller: accountText,
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
                                hintText: context.loc.accountforthistask,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: isLandScape ? 451 * hsf : 451 * hsf,
                          left: (0.051 * width) +
                              MediaQuery.of(context).viewPadding.left,
                          child: Upload(
                              controller: accountImages,
                              images: _todo.accountAttachment ?? '')),
                      Positioned(
                          top: 556 * hsf,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  done = !done;
                                  updatetodo();
                                });
                              },
                              child: Container(
                                width: width,
                                alignment: Alignment.center,
                                child: Text(
                                  done
                                      ? context.loc.stillneedswork
                                      : context.loc.markascompleted,
                                  style: CustomTextStyle(
                                      context: context,
                                      fontSz: 17,
                                      fontWght: Fontweight.w600,
                                      colour: done
                                          ? FontColour.red
                                          : FontColour.black,
                                      normalSpacing: true),
                                ),
                              ))),
                      Center(
                        child: SizedBox(
                          height: isLandScape
                              ? width - appBa.preferredSize.height
                              : height - appBa.preferredSize.height,
                        ),
                      )
                    ],
                  ),
                );
              default:
                return Container();
            }
          })),
    );
  }
}
