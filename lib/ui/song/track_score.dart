import 'dart:convert';
import 'dart:io';

import 'package:document_analysis/document_analysis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class TrackScore extends StatefulWidget {
  TrackScore({this.song, this.track});

  final SongEntity song;
  final TrackEntity track;

  @override
  _TrackScoreState createState() => _TrackScoreState();
}

class _TrackScoreState extends State<TrackScore> {
  bool _isProcessing = false;
  double _distance;
  List<int> _frameTimes;
  List<double> _frameScores;
  List<String> _origPaths;
  List<String> _copyPaths;

  @override
  void initState() {
    super.initState();

    _calculateScore();
  }

  void _calculateScore() {
    final song = widget.song;
    final origTrack = song.tracks.first;
    final origData = jsonDecode(origTrack.video.recognitions);
    final copyData = jsonDecode(widget.track.video.recognitions);

    _distance = 0;
    int countParts = 0;

    if (origData == null) {
      print('## ERROR: orig is null');
      return;
    } else if (copyData == null) {
      print('## ERROR: copy is null');
      return;
    }

    _frameScores = [];
    int count = 0;
    for (int i = 0; i < song.duration; i += kRecognitionFrameSpeed) {
      final value = _calculateFrameScore(count);
      if (value != null) {
        _distance += value;
        countParts++;
        _frameScores.add(value);
      } else {
        _frameScores.add(0);
      }
      count++;
    }

    setState(() {
      _distance = countParts > 0 ? (_distance / countParts) : 1;
    });
  }

  double _calculateFrameScore(int index) {
    final song = widget.song;
    final origTrack = song.tracks.first;
    final origData = jsonDecode(origTrack.video.recognitions);
    final copyData = jsonDecode(widget.track.video.recognitions);

    final orig = origData[index];
    final copy = copyData[index];

    int countParts = 0;

    kRecognitionParts.forEach((part) {
      final origPart = orig['$part'];
      final copyPart = copy['$part'];

      List<double> vector1 = [];
      List<double> vector2 = [];

      if (origPart != null && copyPart != null) {
        vector1.add(origPart[0]);
        vector1.add(origPart[1]);
        vector2.add(copyPart[0]);
        vector2.add(copyPart[1]);
      }

      if (vector1.isNotEmpty && vector2.isNotEmpty) {
        _distance += cosineDistance(vector1, vector2);
        countParts++;
      }
    });

    if (countParts == 0) {
      return null;
    }
    return _distance / countParts;
  }

  void _calculateDetails() async {
    setState(() {
      _isProcessing = true;
    });

    print('## _calculateDetails');
    int frameLength = kRecognitionFrameSpeed;
    _frameTimes = [];
    _origPaths = [];
    _copyPaths = [];

    final song = widget.song;
    var video = song.tracks.first.video;
    String origVideoPath = await VideoEntity.getPath(video.timestamp);
    if (!await File(origVideoPath).exists()) {
      final http.Response response =
          await http.Client().get(widget.song.tracks.first.video.url);

      origVideoPath =
          await VideoEntity.getPath(DateTime.now().millisecondsSinceEpoch);
      await File(origVideoPath).writeAsBytes(response.bodyBytes);
    }

    for (int i = 0; i < song.duration; i += frameLength) {
      _frameTimes.add(i);
      final path = origVideoPath.replaceFirst('.mp4', '-$i.jpg');
      await VideoThumbnail.thumbnailFile(
        video: origVideoPath,
        imageFormat: ImageFormat.JPEG,
        timeMs: i,
        thumbnailPath: path,
      );
      _origPaths.add(path);
    }

    video = widget.track.video;
    String copyVideoPath = await VideoEntity.getPath(video.timestamp);
    if (!await File(origVideoPath).exists()) {
      final http.Response copyResponse = await http.Client().get(video.url);

      final copyVideoPath =
          await VideoEntity.getPath(DateTime.now().millisecondsSinceEpoch);
      await File(copyVideoPath).writeAsBytes(copyResponse.bodyBytes);
    }

    for (int i = 0; i < song.duration; i += frameLength) {
      final copyPath = copyVideoPath.replaceFirst('.mp4', '-$i.jpg');
      await VideoThumbnail.thumbnailFile(
        video: copyVideoPath,
        imageFormat: ImageFormat.JPEG,
        timeMs: i,
        thumbnailPath: copyPath,
      );
      _copyPaths.add(copyPath);
    }

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final song = widget.song;
    final origTrack = song.tracks.first;
    final origData = jsonDecode(origTrack.video.recognitions);
    final copyData = jsonDecode(widget.track.video.recognitions);
    print('## origData: $origData');

    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      actions: <Widget>[
        if (_frameTimes == null)
          FlatButton(
            child: Text(localization.showDetails.toUpperCase()),
            onPressed: () {
              _calculateDetails();
            },
          ),
        FlatButton(
          child: Text(localization.close.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
      content: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_distance != null) ...[
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text('Your score is:'),
              ),
              SizedBox(height: 10),
              Text(
                '${(100 - (_distance * 100)).round()}%',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(height: 20),
            ],
            Expanded(
              child: Stack(
                children: [
                  if (_frameTimes != null)
                    AspectRatio(
                      aspectRatio: 0.75,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: _frameTimes.length,
                        itemBuilder: (BuildContext context, int index) {
                          final i = index;
                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: _PoseDisplay(
                                  index: i,
                                  frame:
                                      origData[i].cast<String, List<dynamic>>(),
                                  color: Colors.blue,
                                  child: Image.file(
                                    File(_origPaths[
                                        _frameTimes.indexOf(_frameTimes[i])]),
                                    color: Colors.black87,
                                    colorBlendMode: BlendMode.srcOver,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: _PoseDisplay(
                                  index: i,
                                  frame:
                                      copyData[i].cast<String, List<dynamic>>(),
                                  color: Colors.red,
                                  child: Image.file(
                                    File(_copyPaths[
                                        _frameTimes.indexOf(_frameTimes[i])]),
                                    color: Colors.black87,
                                    colorBlendMode: BlendMode.srcOver,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  if (_isProcessing)
                    Center(
                      child: CircularProgressIndicator(),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PoseDisplay extends StatelessWidget {
  const _PoseDisplay({
    Key key,
    @required this.index,
    @required this.frame,
    @required this.color,
    @required this.child,
  }) : super(key: key);

  final int index;
  final Map<String, List<dynamic>> frame;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _PosePainter(
        index: index,
        frame: frame,
        color: color,
      ),
      child: child,
    );
  }
}

class _PosePainter extends CustomPainter {
  _PosePainter({
    @required this.index,
    @required this.frame,
    @required this.color,
  });

  final int index;
  final Map<String, List<dynamic>> frame;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = color;

    final Paint circlePaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 3.0
      ..color = color;

    Offset _extract(int key) {
      final List<double> point = frame[key.toString()].cast<double>();
      return Offset(point[0], point[1]);
    }

    _drawLine(canvas, size, _extract(kRecognitionPartLeftAnkle),
        _extract(kRecognitionPartLeftKnee), paint);
    _drawLine(canvas, size, _extract(kRecognitionPartLeftKnee),
        _extract(kRecognitionPartLeftHip), paint);
    _drawLine(canvas, size, _extract(kRecognitionPartLeftHip),
        _extract(kRecognitionPartLeftShoulder), paint);
    _drawLine(canvas, size, _extract(kRecognitionPartLeftShoulder),
        _extract(kRecognitionPartLeftElbow), paint);
    _drawLine(canvas, size, _extract(kRecognitionPartLeftElbow),
        _extract(kRecognitionPartLeftWrist), paint);
    _drawLine(canvas, size, _extract(kRecognitionPartRightAnkle),
        _extract(kRecognitionPartRightKnee), paint);
    _drawLine(canvas, size, _extract(kRecognitionPartRightKnee),
        _extract(kRecognitionPartRightHip), paint);
    _drawLine(canvas, size, _extract(kRecognitionPartRightHip),
        _extract(kRecognitionPartRightShoulder), paint);
    _drawLine(canvas, size, _extract(kRecognitionPartRightShoulder),
        _extract(kRecognitionPartRightElbow), paint);
    _drawLine(canvas, size, _extract(kRecognitionPartRightElbow),
        _extract(kRecognitionPartRightWrist), paint);
    _drawLine(canvas, size, _extract(kRecognitionPartLeftHip),
        _extract(kRecognitionPartRightHip), paint);
    _drawLine(canvas, size, _extract(kRecognitionPartLeftShoulder),
        _extract(kRecognitionPartRightShoulder), paint);

    for (final entry in frame.entries) {
      final point = entry.value.cast<double>();
      final dx = point[0] * size.width;
      final dy = point[1] * size.height;
      canvas.drawCircle(Offset(dx, dy), 1.0, circlePaint);
    }
  }

  void _drawLine(Canvas canvas, Size size, Offset a, Offset b, Paint paint) {
    if (a != null && b != null) {
      canvas.drawLine(
        a.scale(size.width, size.height),
        b.scale(size.width, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_PosePainter oldDelegate) {
    return index != oldDelegate.index;
  }
}
