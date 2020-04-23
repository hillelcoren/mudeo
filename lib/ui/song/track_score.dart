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
  double _distance;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15),
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

                _distance = 0;
                int countParts = 0;

                for (int i = 0;
                    i < song.duration;
                    i += kRecognitionFrameSpeed) {
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
