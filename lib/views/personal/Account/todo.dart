import 'package:flutter/material.dart';
import 'package:two_a/components/DateOnPress/switch_bar2do.dart';
import 'package:two_a/components/app_bar.dart';
import 'package:two_a/components/personaltoAccount/task_list_tiles.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/database/local/database_tables/personal_diary.dart';
import 'package:two_a/database/local/database_tables/personal_task_table.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

class AccountPersonalTasks extends StatefulWidget {
  final List<PersonalTodo> todos;
  final String userEmail;
  final String userId;
  final String? month;
  final String? year;
  final bool isweek;
  final bool forDiary;
  final List<DateTime>? week;
  final List<PersonalDiary>? diaries;
  final String date;
  const AccountPersonalTasks(
      {super.key,
      required this.todos,
      required this.isweek,
      required this.date,
      this.diaries,
      this.week,
      this.month,
      this.year,
      required this.forDiary,
      required this.userEmail,
      required this.userId});

  @override
  State<AccountPersonalTasks> createState() => _AccountPersonalTasksState();
}

class _AccountPersonalTasksState extends State<AccountPersonalTasks> {
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
    return Scaffold(
      appBar: appBa,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: isLandScape ? 6 * hsf : 6 * hsf,
              left: (0.083 * width) + MediaQuery.of(context).viewPadding.left,
              child: Text(
                widget.forDiary
                    ? context.loc.diary
                    : context.loc.task(widget.todos.length),
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
              left: (0.083 * width) + MediaQuery.of(context).viewPadding.left,
              child: Text(
                widget.year != null
                    ? widget.year ?? ''
                    : widget.month != null
                        ? widget.month ?? ''
                        : widget.isweek
                            ? weekdate(widget.week!)
                            : widget.date,
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
                left: (0.078 * width) + MediaQuery.of(context).viewPadding.left,
                child: SizedBox(
                  height: isLandScape
                      ? width - appBa.preferredSize.height - 100 * hsf
                      : height - appBa.preferredSize.height - 100 * hsf,
                  width: 0.856 * width,
                  child: AccountTaskTiles(
                    diaries: widget.diaries,
                    todos: widget.todos,
                    forDiary: widget.forDiary,
                    userEmail: widget.userEmail,
                    userId: widget.userId,
                    isWeek: widget.isweek,
                  ),
                )),
            Center(
              child: SizedBox(
                height: isLandScape
                    ? width - appBa.preferredSize.height
                    : height - appBa.preferredSize.height,
              ),
            )
          ],
        ),
      ),
    );
  }
}
