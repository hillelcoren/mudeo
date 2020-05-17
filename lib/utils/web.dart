import 'dart:async';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Future<String> webFilePicker() {
  final completer = new Completer<String>();
  final InputElement input = document.createElement('input');
  input
    ..type = 'file'
    ..accept = 'image/*';
  input.onChange.listen((e) async {
    final List<File> files = input.files;
    final reader = new FileReader();
    reader.readAsDataUrl(files[0]);
    reader.onError.listen((error) => completer.completeError(error));
    await reader.onLoad.first;
    completer.complete(reader.result as String);
  });
  input.click();
  return completer.future;
}

void webReload() => window.location.reload();

void registerWebView(String html) {
  /*
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
      html,
      (int viewId) => IFrameElement()
        ..src = html
        ..style.border = 'none');

   */
}

// TODO remove this once supported by Flutter
class HandCursor extends StatelessWidget {
  const HandCursor({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (PointerHoverEvent evt) {
        window.document.documentElement.style.cursor = 'pointer';
      },
      onExit: (PointerExitEvent evt) {
        window.document.documentElement.style.cursor = 'auto';
      },
      child: child,
    );
  }
}
