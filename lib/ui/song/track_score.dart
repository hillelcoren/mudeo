import 'dart:convert';

import 'package:document_analysis/document_analysis.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';

class TrackScore extends StatefulWidget {
  TrackScore({this.song, this.track});

  final SongEntity song;
  final TrackEntity track;

  @override
  _TrackScoreState createState() => _TrackScoreState();
}

class _TrackScoreState extends State<TrackScore> {
  double _jaccardScore;
  double _cosineScore;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (_cosineScore != null) ...[
              Text('Your score is:'),
              SizedBox(height: 20),
              Text('Jaccard: ${(_jaccardScore * 100).round()}%'),
              SizedBox(height: 10),
              Text('Cosine: ${(_cosineScore * 100).round()}%'),
              SizedBox(height: 20),
            ],
            RaisedButton(
              child: Text('Calculate'),
              onPressed: () {
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

                for (int i = 0;
                    i < song.duration;
                    i += kRecognitionFrameSpeed) {
                  final orig = origData[counter];
                  final copy = copyData[counter];

                  List<double> vector1 = [];
                  List<double> vector2 = [];

                  kRecognitionParts.forEach((part) {
                    final origPart = orig['$part'];
                    final copyPart = copy['$part'];
                    if (origPart != null && copyPart != null) {
                      vector1.add(origPart[0]);
                      vector1.add(origPart[1]);
                      vector2.add(copyPart[0]);
                      vector2.add(copyPart[1]);
                    }
                  });

                  setState(() {
                    print('## vector1: $vector1');
                    print('## vector2: $vector2');
                    _jaccardScore = jaccardDistance(vector1, vector2);
                    _cosineScore = cosineDistance(vector1, vector2);
                  });

                  counter++;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
