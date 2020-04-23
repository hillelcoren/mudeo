import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:document_analysis/document_analysis.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class TrackScore extends StatefulWidget {
  TrackScore({this.song, this.track});

  final SongEntity song;
  final TrackEntity track;

  @override
  _TrackScoreState createState() => _TrackScoreState();
}

class _TrackScoreState extends State<TrackScore> {
  double _distance;
  List<int> _frameTimes;
  List<String> _origPaths;
  List<String> _copyPaths;

  void _calculateScore() {
    final song = widget.song;
    final origTrack = song.tracks.first;
    final origData = jsonDecode(origTrack.video.recognitions);
    final copyData = jsonDecode(widget.track.video.recognitions);

    int counter = 0;

    if (origData == null) {
      print('## ERROR: orig is null');
      return;
    } else if (copyData == null) {
      print('## ERROR: copy is null');
      return;
    }

    _distance = 0;
    int countParts = 0;

    for (int i = 0; i < song.duration; i += kRecognitionFrameSpeed) {
      final orig = origData[counter];
      final copy = copyData[counter];

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
          countParts++;
          _distance += cosineDistance(vector1, vector2);
        }
      });
    }

    setState(() {
      _distance = countParts > 0 ? (_distance / countParts) : 1;
    });

    counter++;
  }

  void _calculateDetails() async {
    print('## _calculateDetails');
    int frameLength = kRecognitionFrameSpeed;
    _frameTimes = [];
    _origPaths = [];
    _copyPaths = [];
    final song = widget.song;
    final http.Response response =
        await http.Client().get(widget.track.video.url);

    final origVideoPath =
        await VideoEntity.getPath(DateTime.now().millisecondsSinceEpoch);
    await File(origVideoPath).writeAsBytes(response.bodyBytes);

    for (int i = 0; i < song.duration; i += frameLength) {
      _frameTimes.add(i);
      final path = origVideoPath.replaceFirst('.mp4', '-$i.jpg');
      print('## $origVideoPath => $path');
      await VideoThumbnail.thumbnailFile(
        video: origVideoPath,
        imageFormat: ImageFormat.JPEG,
        timeMs: i,
        thumbnailPath: path,
      );
      _origPaths.add(path);
    }

    setState(() {

    });

    final copyVideoPath =
        await VideoEntity.getPath(DateTime.now().millisecondsSinceEpoch);
    await File(copyVideoPath).writeAsBytes(response.bodyBytes);

    for (int i = 0; i < song.duration; i += frameLength) {
      final copyPath =
          widget.track.video.url.replaceFirst('.mp4', '-$i-copy.jpg');
      print('## ${widget.track.video.url} => $copyPath');
      await VideoThumbnail.thumbnailFile(
        video: widget.track.video.url,
        imageFormat: ImageFormat.JPEG,
        timeMs: i,
        thumbnailPath: copyPath,
      );
      _copyPaths.add(copyPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (_distance != null) ...[
                Text('Your score is:'),
                SizedBox(height: 20),
                Text(
                  '${(100 - (_distance * 100)).round()}%',
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(height: 20),
              ],
              RaisedButton(
                child: Text('Calculate'),
                onPressed: () => _calculateScore(),
              ),
              SizedBox(height: 20),
              RaisedButton(
                child: Text('Details'),
                onPressed: () => _calculateDetails(),
              ),
              if (_frameTimes != null)
                for (int time in _frameTimes)
                  Row(
                    children: <Widget>[
                      Text('$time'),
                      Expanded(
                        child: Image.file(
                            File(_origPaths[_frameTimes.indexOf(time)])),
                      ),
                      Expanded(
                        child: Image.file(
                            File(_copyPaths[_frameTimes.indexOf(time)])),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
