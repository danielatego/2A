import 'package:flutter/material.dart';
import 'package:two_a/components/DateOnPress/filter_row.dart';
import 'package:two_a/components/DateOnPress/switch_bar2do.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/utilities/dialogs/error_dialog.dart';

class HintsWidget extends StatelessWidget {
  final int v;
  final bool hintsEnabled;
  const HintsWidget({super.key, required this.v, required this.hintsEnabled});

  @override
  Widget build(BuildContext context) {
    double height = context.scaleFactor.height;
    double width = context.scaleFactor.width;
    double hsf = context.scaleFactor.hsf;
    double wsf = context.scaleFactor.wsf;
    List<String> actions = [
      context.loc.tassign,
      context.loc.tdo,
      context.loc.toaccount
    ];
    return hintsEnabled
        ? Material(
            color: const Colour().lbg,
            child: InkWell(
              onTap: () async {
                await infoDialog(
                    context, context.loc.info, context.loc.disableInfo);
              },
              child: Container(
                alignment: Alignment.center,
                height: 0.072 * height,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info,
                      size: 14 * hsf,
                      color: const Colour().purple,
                    ),
                    Padding(padding: EdgeInsets.only(left: 6 * wsf)),
                    Text(
                      v == 0
                          ? context.loc.personalinfoassign
                          : v == 1
                              ? context.loc.personalinfotodo
                              : context.loc.personalinfoaccount,
                      style: CustomTextStyle(
                          context: context,
                          fontSz: 11.6,
                          colour: FontColour.purple),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
          )
        : Container();
  }
}

class AssignDoAccountToggle extends StatefulWidget {
  final VoidCallback right;
  final VoidCallback left;
  final int v;
  final DateTime date;
  final bool? isWeek;
  final String? month;
  final String? year;
  final List<DateTime>? week;
  const AssignDoAccountToggle({
    super.key,
    required this.right,
    required this.left,
    required this.v,
    required this.date,
    required this.isWeek,
    this.month,
    this.year,
    this.week,
  });

  @override
  State<AssignDoAccountToggle> createState() => _AssignDoAccountToggleState();
}

class _AssignDoAccountToggleState extends State<AssignDoAccountToggle> {
  late int position;

  @override
  void initState() {
    position = widget.v;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = context.scaleFactor.height;
    double width = context.scaleFactor.width;
    double hsf = context.scaleFactor.hsf;
    double wsf = context.scaleFactor.wsf;
    List<String> actions = [
      context.loc.tassign,
      context.loc.tdo,
      context.loc.toaccount
    ];
    return SizedBox(
      height: 48 * context.scaleFactor.hsf,
      width: 348 * context.scaleFactor.wsf,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(48 * hsf),
            color: const Colour().lHint2,
            child: InkWell(
              splashColor: const Colour().primary,
              onTap: (position == 0)
                  ? null
                  : () {
                      widget.right();
                      setState(() {
                        if (position >= 1) {
                          position--;
                        }
                      });
                    },
              child: SizedBox(
                  width: 48 * hsf,
                  height: 48 * hsf,
                  child: Semantics(
                    label: context.loc.navigateleft,
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: (position == 0)
                          ? const Colour().lHint
                          : const Colour().black,
                    ),
                  )),
            ),
          ),
          UpgradedSwitchColumn(
            isWeek: widget.isWeek,
            month: widget.month,
            year: widget.year,
            week: widget.week,
            text1: actions[position],
            date: widget.date,
          ),
          Material(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(48 * hsf),
            color: const Colour().lHint2,
            child: InkWell(
              splashColor: const Colour().primary,
              onTap: (position == 2)
                  ? null
                  : () {
                      widget.left();
                      setState(() {
                        if (position < 2) position++;
                      });
                    },
              child: SizedBox(
                  width: 48 * hsf,
                  height: 48 * hsf,
                  child: Semantics(
                    label: context.loc.navigateright,
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: (position == 2)
                          ? const Colour().lHint
                          : const Colour().black,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class Personal2DoStatusTab extends StatefulWidget {
  final VoidCallback all;
  final VoidCallback open;
  final VoidCallback done;
  final VoidCallback archived;
  final int openCount;
  final int closedCount;
  final int archivedCount;
  final int allCount;
  const Personal2DoStatusTab({
    super.key,
    required this.all,
    required this.open,
    required this.done,
    required this.archived,
    required this.openCount,
    required this.closedCount,
    required this.archivedCount,
    required this.allCount,
  });

  @override
  State<Personal2DoStatusTab> createState() => _Personal2DoStatusTabState();
}

class _Personal2DoStatusTabState extends State<Personal2DoStatusTab> {
  bool archived = false;
  bool closed = false;
  bool open = false;
  bool all = true;
  @override
  Widget build(BuildContext context) {
    double hsf = context.scaleFactor.hsf;
    double wsf = context.scaleFactor.wsf;
    List<String> actions = [
      context.loc.tassign,
      context.loc.tdo,
      context.loc.toaccount
    ];
    return Container(
      alignment: Alignment.topCenter,
      height: 48 * hsf,
      width: 322 * wsf,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                archived = false;
                closed = false;
                open = false;
                all = true;
              });
            },
            style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0),
                minimumSize: Size.fromWidth(40 * wsf),
                foregroundColor: const Colour().black),
            child: FilterRow(
                text: context.loc.all, active: all, count: widget.allCount),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                archived = false;
                closed = false;
                open = true;
                all = false;
              });
            },
            style: TextButton.styleFrom(
                foregroundColor: const Colour().black,
                padding: const EdgeInsets.all(0)),
            child: FilterRow(
                text: context.loc.open, active: open, count: widget.openCount),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                archived = false;
                closed = true;
                open = false;
                all = false;
              });
            },
            style: TextButton.styleFrom(
                foregroundColor: const Colour().black,
                padding: const EdgeInsets.all(0)),
            child: FilterRow(
                text: context.loc.closed,
                active: closed,
                count: widget.closedCount),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                archived = true;
                closed = false;
                open = false;
                all = false;
              });
            },
            style: TextButton.styleFrom(
                foregroundColor: const Colour().black,
                padding: const EdgeInsets.all(0)),
            child: FilterRow(
                text: context.loc.archived,
                active: archived,
                count: widget.archivedCount),
          ),
        ],
      ),
    );
  }
}

class ShowcaseButtons extends StatelessWidget {
  final String text;
  const ShowcaseButtons({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    double height = context.scaleFactor.height;
    double width = context.scaleFactor.width;
    double hsf = context.scaleFactor.hsf;

    return Container(
      alignment: Alignment.center,
      height: 0.0719 * height,
      width: 0.232 * width,
      decoration: BoxDecoration(
          color: const Colour().purple,
          borderRadius: BorderRadius.circular(8 * hsf)),
      child: Text(
        text,
        style: CustomTextStyle(
          context: context,
          fontSz: 12,
          colour: FontColour.white,
        ),
      ),
    );
  }
}
