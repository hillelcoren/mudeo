import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:video_editor/video_editor.dart';

class SongTrim extends StatefulWidget {
  const SongTrim({Key key, @required this.file}) : super(key: key);

  final File file;

  @override
  State<SongTrim> createState() => _SongTrimState();
}

class _SongTrimState extends State<SongTrim> {
  VideoEditorController _controller;
  bool _isTrimming = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoEditorController.file(
      widget.file,
      minDuration: const Duration(seconds: 3),
      maxDuration: const Duration(seconds: 300),
    );

    _controller
        .initialize()
        //.initialize(aspectRatio: 9 / 16)
        .then((_) => setState(() {}))
        .catchError((error) {
      // handle minumum duration bigger than video duration error
      //Navigator.pop(context);
    }, test: (e) => e is VideoMinDurationError);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return AlertDialog(
      content: _isTrimming
          ? Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: LinearProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CropGridViewer.preview(controller: _controller),
                    SizedBox(height: 20),
                    TrimSlider(
                      controller: _controller,
                      height: 100,
                      child: TrimTimeline(
                        controller: _controller,
                        padding: const EdgeInsets.only(top: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(localization.cancel.toUpperCase()),
        ),
        TextButton(
          onPressed: () {
            setState(() => _isTrimming = true);
            _controller.exportVideo(onCompleted: (file) {
              setState(() => _isTrimming = false);
              file.copy(widget.file.path);
              Navigator.of(context)
                  .pop(_controller.trimmedDuration.inMilliseconds);
            });
          },
          child: Text(localization.trim.toUpperCase()),
        ),
      ],
    );
  }
}
