import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

class AttachedFiles extends StatelessWidget {
  final List<String> list;
  const AttachedFiles({required this.list, super.key});

  @override
  Widget build(BuildContext context) {
    final height = context.scaleFactor.height;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scrollbar(
        scrollbarOrientation: ScrollbarOrientation.bottom,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: isPortrait ? height * 0.071 : height * 0.128,
              width: isPortrait ? height * 0.071 : height * 0.128,
              child: Material(
                color: const Color.fromARGB(0, 255, 255, 255),
                child: InkWell(
                  splashColor: const Colour().primary,
                  onTap: () {
                    OpenFile.open(
                        '/data/data/com.mahanaim.android.two_a/cache/file_picker/${list[index]}');
                  },
                  onLongPress: () async {
                    final image = File(
                        '/data/data/com.mahanaim.android.two_a/cache/file_picker/${list[index]}');
                    await image.delete();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isPicture(list[index])
                          ? const Icon(Icons.image_outlined)
                          : const Icon(Icons.file_present),
                      Text(
                        list[index],
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
          separatorBuilder: (BuildContext context, int index) => Padding(
              padding: EdgeInsets.only(
                  left: isPortrait ? 0.026 * height : 0.048 * height)),
        ));
  }
}

bool isPicture(String name) {
  if (name.contains('png') || name.contains('jpeg')) {
    return true;
  }
  if (name.contains('jpg')) {
    return true;
  } else {
    return false;
  }
}
