import 'package:flutter/material.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/database/local/database_tables/personal_diary.dart';
import 'package:two_a/database/local/database_tables/personal_task_table.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/views/home/components.dart';
import 'package:two_a/views/personal/Account/diary.dart';
import 'package:two_a/views/personal/Account/todo_on_press.dart';

class AccountTaskTiles extends StatelessWidget {
  final List<PersonalTodo> todos;
  final bool isWeek;
  final List<PersonalDiary>? diaries;
  final String userEmail;
  final String userId;
  final bool forDiary;
  const AccountTaskTiles(
      {super.key,
      required this.todos,
      required this.forDiary,
      this.diaries,
      required this.userEmail,
      required this.userId,
      required this.isWeek});

  @override
  Widget build(BuildContext context) {
    final wsf = context.scaleFactor.wsf;
    final width = context.scaleFactor.width;
    final hsf = context.scaleFactor.hsf;
    return SingleChildScrollView(
      child: Column(
          children: List<Widget>.generate(
        forDiary ? diaries?.length ?? 0 : todos.length,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: 16.0 * hsf),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (context) => forDiary
                          ? AccountPersonalDiary(
                              date: diaries![index].dateOfCreation,
                              note: diaries?[index],
                              email: userEmail,
                              id: userId,
                            )
                          : AccountPersonalTask(
                              todo: todos[index],
                              date: completeDate(
                                  DateTime.parse(todos[index].dateOfCreation),
                                  context),
                            )));
            },
            child: Container(
              width: 0.853 * width,
              decoration: BoxDecoration(
                  color: const Colour().lHint2,
                  borderRadius: BorderRadius.circular(8 * hsf)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 8.0 * hsf, horizontal: 12 * hsf),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      forDiary
                          ? completeDate(
                              DateTime.parse(diaries![index].dateOfCreation),
                              context)
                          : todos[index].title,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 15 * wsf,
                          fontWeight: FontWeight.w500,
                          color: const Colour().black,
                          decoration: forDiary
                              ? null
                              : todos[index].done
                                  ? TextDecoration.lineThrough
                                  : null),
                    ),
                    forDiary
                        ? Container()
                        : Text(
                            isWeek
                                ? '${todos[index].startTime ?? ''} - ${todos[index].endTime ?? ''}   (${DateTime.parse(todos[index].dateOfCreation).day}/${DateTime.parse(todos[index].dateOfCreation).month}/${DateTime.parse(todos[index].dateOfCreation).year})'
                                : '${todos[index].startTime ?? ''} - ${todos[index].endTime ?? ''}',
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 10 * wsf,
                                fontWeight: FontWeight.w400,
                                color: const Colour().bhbtw,
                                decoration: todos[index].done
                                    ? TextDecoration.lineThrough
                                    : null),
                          ),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: forDiary ? 8 * hsf : 16 * hsf)),
                    forDiary
                        ? Text(diaries?[index].diaryEntry ?? '',
                            maxLines: 6,
                            style: TextStyle(
                              fontSize: 15 * wsf,
                              fontWeight: FontWeight.w400,
                              color: const Colour().bhbtw,
                            ))
                        : Text(todos[index].accountMessage ?? '',
                            maxLines: 4,
                            style: TextStyle(
                              fontSize: 15 * wsf,
                              fontWeight: FontWeight.w400,
                              color: const Colour().bhbtw,
                            ))
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
