import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:video_player/video_player.dart';

class CalibrationDialog extends StatefulWidget {
  @override
  _CalibrationDialogState createState() => _CalibrationDialogState();
}

class _CalibrationDialogState extends State<CalibrationDialog> {
  static const STATE_PROMPT = 0;
  static const STATE_CALIBRATE = 1;
  static const STATE_UPLOAD = 2;
  static const STATE_RESULTS = 3;

  int _currentState = STATE_PROMPT;
  
  VideoPlayerController _videoController;
  CameraController _cameraController;

  void _calibrate() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);

    _cameraController =
        CameraController(frontCamera ?? cameras.first, ResolutionPreset.low)
          ..addListener(() {
            if (mounted) setState(() {});
          })
          ..initialize().then((value) async {
            //
          });

    _videoController = VideoPlayerController.asset('assets/tone.mp4')
      ..initialize().then((value) {
        _videoController.play();
      });

    setState(() {
      _currentState = STATE_CALIBRATE;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    Widget content;

    if (_currentState == STATE_PROMPT) {
      content = Text(localization.calibrationMessage);
    } else if (_currentState == STATE_CALIBRATE) {
      content = Column(
        children: [
          AspectRatio(
            aspectRatio: _videoController?.value?.aspectRatio ?? 1,
            child: VideoPlayer(_videoController),
          ),
          AspectRatio(
            aspectRatio: _cameraController?.value?.aspectRatio ?? 1,
            child: CameraPreview(_cameraController),
          ),
        ],
      );
    } else {
      content = SizedBox();
    }

    return AlertDialog(
      title: Text(localization.calibrate),
      content: content,
      actions: [
        FlatButton(
          child: Text(localization.noThanks),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(localization.ok),
          onPressed: () {
            if (_currentState == STATE_PROMPT) {
              _calibrate();
            }
          },
        )
      ],
    );
  }
}
