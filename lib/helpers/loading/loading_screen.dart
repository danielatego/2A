import 'dart:async';

import 'package:flutter/material.dart';
import 'package:two_a/extensions/buildcontext/loc.dart';
import 'package:two_a/helpers/loading/loading_screen_controller.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen() => _shared;

  LoadingScreenController? controller;

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final textToDisplay = StreamController<String>();
    textToDisplay.add(text);
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(150),
        child: Center(
            child: Container(
          constraints: BoxConstraints(
              maxHeight: context.scaleFactor.height * 0.8,
              maxWidth: size.width * 0.8,
              minWidth: size.width * 0.5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  StreamBuilder(
                    stream: textToDisplay.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data as String,
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return Container();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        )),
      );
    });
    state.insert(overlay);

    return LoadingScreenController(close: () {
      textToDisplay.close();
      overlay.remove();
      return true;
    }, update: (text) {
      textToDisplay.add(text);
      return true;
    });
  }
}
