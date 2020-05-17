import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:video_player/video_player.dart';

class CalibrationDialog extends StatefulWidget {
  @override
  _CalibrationDialogState createState() => _CalibrationDialogState();
}

class _CalibrationDialogState extends State<CalibrationDialog> {
  static const STATE_PROMPT = 0;
  static const STATE_CONFIRM = 1;
  static const STATE_CALIBRATE = 2;
  static const STATE_UPLOAD = 3;

  //static const STATE_RESULTS = 4;

  int _currentState = STATE_PROMPT;

  VideoPlayerController _videoController;
  CameraController _cameraController;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset('assets/tone.mp4')
      ..initialize();

    availableCameras().then((cameras) {
      final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);

      _cameraController =
          CameraController(frontCamera ?? cameras.first, ResolutionPreset.low)
            ..addListener(() {
              if (mounted) setState(() {});
            })
            ..initialize();
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _showCalibration() async {
    setState(() {
      _currentState = STATE_CONFIRM;
    });
  }

  void _runCalibration() async {
    final videoPath = await VideoEntity().path;
    _cameraController.startVideoRecording(videoPath);
    _videoController.play();

    setState(() {
      _currentState = STATE_CALIBRATE;
    });

    Timer(Duration(seconds: 2), () async {
      _cameraController.stopVideoRecording();

      final Directory directory = await getApplicationDocumentsDirectory();
      final String folder = '${directory.path}/calibrate';
      await Directory(folder).create(recursive: true);
      final audioPath = '$folder/data.txt';

      /*
      final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
      _flutterFFmpeg
          .execute(
              "-i $videoPath -af astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=$audioPath -f null -")
          .then((rc) async {
        print("FFmpeg process exited with rc $rc");

        final file = File(audioPath);
        String contents = await file.readAsString();

        debugPrint('## DATA: ${contents.substring(1000)}');

        setState(() {
          _currentState = STATE_UPLOAD;
        });
      });      
       */
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    Widget content;

    if (_currentState == STATE_PROMPT) {
      content = Text(localization.calibrationMessage);
    } else {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.black,
            child: Row(
              children: [
                Flexible(
                  child: AspectRatio(
                    aspectRatio: _videoController?.value?.aspectRatio ?? 1,
                    child: VideoPlayer(_videoController),
                  ),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: _currentState == STATE_CALIBRATE
                          ? Border.all(color: Colors.red, width: 2)
                          : null,
                    ),
                    child: AspectRatio(
                      aspectRatio: _cameraController?.value?.aspectRatio ?? 1,
                      child: CameraPreview(_cameraController),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 16),
              child: _currentState == STATE_CONFIRM
                  ? Text(localization.calibrationWarning)
                  : _currentState == STATE_UPLOAD
                      ? LinearProgressIndicator()
                      : SizedBox()),
        ],
      );
    }

    return AlertDialog(
      title: Text(localization.calibrate),
      // TODO remove the column
      content: Column(
        children: [
          Expanded(child: content),
          Text('State: $_currentState'),
        ],
      ),
      actions: [
        FlatButton(
          child: Text(_currentState == STATE_PROMPT
              ? localization.noThanks
              : localization.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(_currentState == STATE_CONFIRM
              ? localization.start
              : localization.ok),
          onPressed: () {
            if (_currentState == STATE_PROMPT) {
              _showCalibration();
            } else if (_currentState == STATE_CONFIRM) {
              _runCalibration();
            }
          },
        )
      ],
    );
  }
}
