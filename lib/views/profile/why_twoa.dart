import 'package:flutter/material.dart';
import 'package:two_a/components/color.dart';
import 'package:two_a/components/text_style.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';

class StaticTextWidget extends StatefulWidget {
  const StaticTextWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<StaticTextWidget> createState() => _StaticTextWidgetState();
}

class _StaticTextWidgetState extends State<StaticTextWidget> {
  final String title = 'Why 2A';

  final String text =
      'Our lives are a collection of experiences and moments, try to imagine how many you have had yourself. How about the many daily lessons we have.\n\nSadly, most are lost. Our memory can only hold so many, after which, most fade to oblivion.its like a glass filled to the brim and still being filled.\n\n2A can be that friend who absorbs everything, whom you\'d rather go on a journey than yourself: because, he\'ll tell you everything with great detail, the story, of how it was.\n\nThis journey is life. Its not ours.\n\nBut...\n\nWhile we can.\n\n\t\t\t\tDaniel Atego.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Colour().primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(6.0 * context.scaleFactor.hsf),
                    child: Image.asset(
                      'images/logo/logo1.png',
                      height: 48 * context.scaleFactor.hsf,
                      width: 48 * context.scaleFactor.hsf,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 10),
                  const Text(
                    'Our lives are a collection of experiences and moments. Try to imagine how many you have had yourself. How about the daily lessons and ideas we pick.\n\nSadly, most are lost. Our memory can only hold so much, after which, most fade to oblivion. It\'s like a glass filled to the brim and still being filled.\n\n2A can be that assistant who absorbs everything, whom you\'d rather go on a journey with than by yourself: because, he\'ll tell you everything with great detail, the story, of how it was.\n\nThis journey, is life. It\'s not ours.\n\nBut...\n\nWhile we can.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Daniel Atego.',
                      style: CustomTextStyle(
                        //fontSize: 16,
                        //color: Colors.black87,
                        context: context,
                        fontSz: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
