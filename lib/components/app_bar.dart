import 'package:flutter/material.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/routes.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/views/profile/user_profile.dart';
import 'package:two_a/views/profile/why_twoa.dart';

// ignore: must_be_immutable
class CustomAppbar extends AppBar {
  final bool? refresh;
  final bool? deleteaccount;
  final VoidCallback? onTap;
  final bool? main;
  final BuildContext context;
  final String? locTitle;
  final bool tab;
  bool? appBarRequired = true;
  final bool back;
  final toolHeight = 36.0;

  bool get locnul => locTitle == null;

  @override
  Size get preferredSize => tab
      ? Size(context.scaleFactor.width, 91 * context.scaleFactor.hsf)
      : locnul
          ? Size(context.scaleFactor.width, 48 * context.scaleFactor.hsf)
          : Size(
              context.scaleFactor.width, toolHeight * context.scaleFactor.hsf);

  @override
  PreferredSizeWidget? get bottom => tab
      ? TabBar(
          //isScrollable: true,
          dividerColor: const Colour().black,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: const Colour().black,
          indicatorWeight: 2.0,
          labelColor: const Colour().black,
          labelStyle: CustomTextStyle(
              context: context,
              fontSz: 16,
              fontWght: Fontweight.w700,
              colour: FontColour.black,
              normalSpacing: true),
          unselectedLabelColor: const Colour().lHint,
          tabs: <Widget>[
            Container(
              height: 48,
              width: 0.3 * context.scaleFactor.width,
              alignment: Alignment.bottomCenter,
              child: Tab(
                height: 26 * context.scaleFactor.hsf,
                text: context.loc.home,
              ),
            ),
            Container(
              height: 48,
              width: 0.4 * context.scaleFactor.width,
              alignment: Alignment.bottomCenter,
              child: Tab(
                height: 26 * context.scaleFactor.hsf,
                text: context.loc.personal,
              ),
            ),
            Container(
              height: 48,
              width: 0.3 * context.scaleFactor.width,
              alignment: Alignment.bottomCenter,
              child: Tab(
                height: 26 * context.scaleFactor.hsf,
                text: context.loc.work,
              ),
            ),
          ],
        )
      : super.bottom;
  @override
  double? get elevation => tab ? 3 : 0;

  @override
  Color? get backgroundColor => locnul
      ? const Colour().lbg
      : deleteaccount ?? false
          ? const Colour().red
          : const Colour().primary;

  @override
  List<Widget>? get actions => locnul
      ? [
          Material(
            color: const Colour().lbg,
            borderRadius: BorderRadius.circular(48 * context.scaleFactor.hsf),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: appBarRequired ?? false
                  ? null
                  : refresh ?? false
                      ? () {
                          onTap!();
                        }
                      : () {
                          onTap!();
                          //Navigator.of(context).pop();
                          //Navigator.push();
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (contex) => UserProfile(
                                  contexti: context,
                                ),
                              ));
                        },
              child: refresh ?? false
                  ? Semantics(
                      label: context.loc.refresh,
                      child: Padding(
                        padding: EdgeInsets.all(6 * context.scaleFactor.hsf),
                        child: Image.asset(
                          'images/logo/logo1.png',
                          height: 48 * context.scaleFactor.hsf,
                          width: 48 * context.scaleFactor.hsf,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : Semantics(
                      label: context.loc.menu,
                      child: Padding(
                        padding: EdgeInsets.all(6 * context.scaleFactor.hsf),
                        child: Container(
                          width: 42 * context.scaleFactor.hsf,
                          height: 42 * context.scaleFactor.hsf,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: .6,
                              color: appBarRequired ?? false
                                  ? const Colour().lHint
                                  : const Colour().lHint,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            size: 22 * context.scaleFactor.hsf,
                            color: appBarRequired ?? false
                                ? const Colour().lHint
                                : const Colour().black,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ]
      : super.actions;
  @override
  Widget? get leading {
    if (locnul && back) {
      return (IconButton(
        icon: Semantics(
          label: context.loc.back,
          child: Image.asset(
            'images/leftchevron/leftchevron.png',
            height: 16 * context.scaleFactor.hsf,
            width: 9.16 * context.scaleFactor.hsf,
            fit: BoxFit.fill,
          ),
        ),
        onPressed: () {
          Navigator.pop(context, false);
        },
        splashRadius: 15 * context.scaleFactor.hsf,
      ));
    } else if (locnul && !back) {
      return (Material(
        color: const Colour().lbg,
        child: InkWell(
          onTap: main ?? false
              ? () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const StaticTextWidget()))
              : () {
                  Navigator.of(context).popAndPushNamed(homePage);
                },
          child: Padding(
            padding: EdgeInsets.all(6.0 * context.scaleFactor.hsf),
            child: Image.asset(
              'images/logo/logo1.png',
              height: 48 * context.scaleFactor.hsf,
              width: 48 * context.scaleFactor.hsf,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ));
    } else {
      return super.leading;
    }
  }

  @override
  Widget? get title => locnul
      ? super.title
      : Text(
          locTitle!,
          overflow: TextOverflow.ellipsis,
          style: CustomTextStyle(
              context: context,
              fontSz: 16,
              fontWght: Fontweight.w500,
              colour: FontColour.backgroundColor,
              normalSpacing: true),
          textScaler: TextScaler.linear(context.scaleFactor.wsf),
        );

  // @override
  // Size get preferredSize => tab
  //     ? super.preferredSize
  //     : Size.fromHeight(toolHeight * context.scaleFactor.hsf);

  CustomAppbar({
    super.key,
    this.deleteaccount,
    required this.back,
    required this.tab,
    required this.context,
    required this.locTitle,
    this.main,
    this.refresh,
    this.onTap,
    this.appBarRequired,
  });

  get tabindex => null;
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final AppBar appBar;
  const CustomAppBar({super.key, required this.onTap, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: appBar,
    );
  }

  @override
  Size get preferredSize => appBar.preferredSize;
}
