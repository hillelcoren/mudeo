import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:document_analysis/document_analysis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/main_common.dart';
import 'package:mudeo/utils/ffmpeg.dart';
import 'package:mudeo/utils/localization.dart';

class TrackScore extends StatefulWidget {
  TrackScore({this.song, this.video});

  final SongEntity? song;
  final VideoEntity? video;

  @override
  _TrackScoreState createState() => _TrackScoreState();
}

class _TrackScoreState extends State<TrackScore> {
  bool _isProcessing = false;
  bool _maskBackground = true;
  double _distance = 0.0;
  List<int>? _frameTimes;
  late List<double> _frameScores;
  late List<String> _origPaths;
  late List<String> _copyPaths;

  @override
  void initState() {
    super.initState();

    _calculateScore();
  }

  void _calculateScore() {
    final song = widget.song!;
    final origTrack = song.tracks!.first!;

    if ((origTrack.video!.recognitions ?? '').isEmpty ||
        (widget.video!.recognitions ?? '').isEmpty) {
      print('## ERROR: recognitions are null');
      return;
    }

    final origData = jsonDecode(origTrack.video!.recognitions!);
    final copyData = jsonDecode(widget.video!.recognitions!);

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
    for (int i = 0; i < song.duration!; i += kRecognitionFrameSpeed) {
      final value = _calculateFrameScore(count);
      if (value != null) {
        _distance = _distance + value;
        countParts++;
        _frameScores.add(value);
      } else {
        _frameScores.add(0);
      }
      count++;
    }

    setState(() {
      _distance = countParts > 0 ? (_distance! / countParts) : 1;
    });
  }

  double? _calculateFrameScore(int index) {
    final song = widget.song!;
    final origTrack = song.tracks!.first!;
    final origData = jsonDecode(origTrack.video!.recognitions!);
    final copyData = jsonDecode(widget.video!.recognitions!);

    print('## LENGTH: ${origData.length} ${copyData.length}');
    if (index >= origData.length || index >= copyData.length) {
      return null;
    } else if (origData[index] == null || copyData[index] == null) {
      return null;
    }

    final orig = origData[index][0];
    final copy = copyData[index][0];

    int countParts = 0;

    for (var part in kRecognitionParts) {
      if (orig == null || copy == null) {
        continue;
      }

      final origPart = orig['$part'];
      final copyPart = copy['$part'];

      List<double?> vector1 = [];
      List<double?> vector2 = [];

      if (origPart != null && copyPart != null) {
        vector1.add(origPart[0]);
        vector1.add(origPart[1]);
        vector2.add(copyPart[0]);
        vector2.add(copyPart[1]);
      }

      if (vector1.isNotEmpty && vector2.isNotEmpty) {
        _distance +=
            cosineDistance(vector1 as List<double>, vector2 as List<double>);
        countParts++;
      }
    }

    if (countParts == 0) {
      return null;
    }
    return _distance! / countParts;
  }

  void _calculateDetails() async {
    setState(() {
      _isProcessing = true;
    });

    int frameLength = kRecognitionFrameSpeed;
    _frameTimes = [];
    _origPaths = [];
    _copyPaths = [];

    final song = widget.song!;
    var video = song.tracks!.first!.video;

    String path = (await VideoEntity.getPath(video))!;
    if (!await File(path).exists()) {
      final http.Response response = await http.Client()
          .get(Uri.parse(widget.song!.tracks!.first!.video!.url!));
      await File(path).writeAsBytes(response.bodyBytes);
    }

    for (int i = 0; i < song.duration!; i += frameLength) {
      _frameTimes!.add(i);
      final thumbnailPath = path.replaceFirst('.mp4', '-$i.jpg');
      await FfmpegUtils.createThumbnail(path, thumbnailPath);

      _origPaths.add(thumbnailPath);
    }

    video = widget.video;
    path = (await VideoEntity.getPath(video))!;

    if (!await File(path).exists()) {
      final http.Response copyResponse =
          await http.Client().get(Uri.parse(video!.url!));
      await File(path).writeAsBytes(copyResponse.bodyBytes);
    }

    for (int i = 0; i < song.duration!; i += frameLength) {
      final thumbnailPath = path.replaceFirst('.mp4', '-$i.jpg');
      await FfmpegUtils.createThumbnail(path, thumbnailPath);
      _copyPaths.add(thumbnailPath);
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
    final song = widget.song!;
    final origTrack = song.tracks!.first!;

    if ((origTrack.video!.recognitions ?? '').isEmpty ||
        (widget.video!.recognitions ?? '').isEmpty) {
      print('## ERROR: recognitions are null');
      return SizedBox();
    }

    final origData = jsonDecode(origTrack.video!.recognitions!);
    final copyData = jsonDecode(widget.video!.recognitions!);

    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      actions: <Widget>[
        if (_frameTimes == null)
          TextButton(
            child: Text(localization!.showDetails!.toUpperCase()),
            onPressed: () {
              _calculateDetails();
            },
          )
        else if (_frameTimes!.isNotEmpty)
          TextButton(
            child: Text((_maskBackground
                    ? localization!.showImage
                    : localization!.blurImage)!
                .toUpperCase()),
            onPressed: () {
              setState(() {
                _maskBackground = !_maskBackground;
              });
            },
          ),
        TextButton(
          child: Text(localization!.close!.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
      title: _isProcessing ? Text('${localization.processing}...') : null,
      content: _isProcessing
          ? Padding(
              padding: const EdgeInsets.only(top: 15),
              child: LinearProgressIndicator(),
            )
          : IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_distance != null) ...[
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(localization.yourScoreIs!),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${max((100 - (_distance! * 100)).round(), 0)}%',
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
                              itemCount: _frameTimes!.length,
                              itemBuilder: (BuildContext context, int index) {
                                final i = index;
                                final frameIndex =
                                    _frameTimes!.indexOf(_frameTimes![i]);

                                return Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: frameIndex >= _origPaths.length ||
                                              frameIndex >= origData.length ||
                                              origData[i][0] == null
                                          ? Container()
                                          : _PoseDisplay(
                                              index: i,
                                              frame: origData[i][0].cast<String,
                                                  List<dynamic>>(),
                                              color: Colors.blue,
                                              child: Image.file(
                                                File(_origPaths[frameIndex]),
                                                color: Colors.black87,
                                                colorBlendMode: _maskBackground
                                                    ? BlendMode.srcOver
                                                    : BlendMode.dstIn,
                                              ),
                                            ),
                                    ),
                                    Expanded(
                                      child: frameIndex >= _copyPaths.length ||
                                              frameIndex >= copyData.length ||
                                              copyData[i][0] == null
                                          ? Container()
                                          : _PoseDisplay(
                                              index: i,
                                              frame: copyData[i][0].cast<String,
                                                  List<dynamic>>(),
                                              color: Colors.red,
                                              child: Image.file(
                                                File(_copyPaths[frameIndex]),
                                                color: Colors.black87,
                                                colorBlendMode: _maskBackground
                                                    ? BlendMode.srcOver
                                                    : BlendMode.dstIn,
                                              ),
                                            ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
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
    Key? key,
    required this.index,
    required this.frame,
    required this.color,
    required this.child,
  }) : super(key: key);

  final int index;
  final Map<String, List<dynamic>>? frame;
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
    required this.index,
    required this.frame,
    required this.color,
  });

  final int index;
  final Map<String, List<dynamic>>? frame;
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
      final value = frame![key.toString()];
      if (value == null) {
        return Offset(0, 0);
      }
      final List<double> point = value.cast<double>();
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

    for (final entry in frame!.entries) {
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
