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
  static const STATE_CONFIRM = 1;
  static const STATE_CALIBRATE = 2;
  static const STATE_UPLOAD = 3;
  static const STATE_RESULTS = 4;

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
            ..initialize().then((value) async {
              //
            });
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
    //_cameraController.startVideoRecording(filePath);
    _videoController.play();

    setState(() {
      _currentState = STATE_CALIBRATE;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    Widget content;

    if (_currentState == STATE_PROMPT) {
      content = Text(localization.calibrationMessage);
    } else if (_currentState == STATE_CONFIRM ||
        _currentState == STATE_CALIBRATE) {
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
                  child: AspectRatio(
                    aspectRatio: _cameraController?.value?.aspectRatio ?? 1,
                    child: CameraPreview(_cameraController),
                  ),
                ),
              ],
            ),
          ),
          Text(localization.calibrationWarning),
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
