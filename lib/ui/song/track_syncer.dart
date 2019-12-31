import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/utils/localization.dart';

class TrackSyncer extends StatefulWidget {
  const TrackSyncer({
    @required this.song,
    @required this.onDelayChanged,
  });

  final SongEntity song;
  final Function(TrackEntity, int) onDelayChanged;

  @override
  _TrackSyncerState createState() => _TrackSyncerState();
}

class _TrackSyncerState extends State<TrackSyncer> {
  double _timeSpan = 10;
  int _timeStart = 0;
  double _zoomLevel = 1;
  Map<int, bool> _isSyncing = {
    1: false,
    2: false,
    3: false,
    4: false,
  };

  SongEntity _song;

  @override
  void initState() {
    super.initState();
    _song = widget.song;
  }

  void _syncVideos() async {
    if (_song.tracks.length < 2) {
      return;
    }

    for (int i = 1; i <= _song.tracks.length - 1; i++) {
      setState(() {
        _isSyncing[i] = true;
      });

      final track = _song.tracks[i];
      final start = _timeStart * -1;
      final end = start + (_timeSpan.floor() * 1000);
      int delay = await compute(getMinDelay, [
        _song.tracks[0].video.getVolumeMap(start, end),
        _song.tracks[i].video.getVolumeMap(start, end),
      ]);
      print('## SYNC: Start: $_timeStart, Span: $_timeSpan => $start - $end = $delay');
      widget.onDelayChanged(track, delay);
      setState(() {
        _song = _song.setTrackDelay(track, delay);
        _isSyncing[i] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return AlertDialog(
      title: Text(AppLocalization.of(context).trackAdjustment),
      content: ClipRect(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: <Widget>[
                Text(localization.zoom.toUpperCase()),
                Expanded(
                  child: Slider(
                    min: 1,
                    max: 10,
                    value: _zoomLevel,
                    onChanged: (value) {
                      setState(() {
                        _zoomLevel = value;
                        _timeSpan = 11 - _zoomLevel;
                      });
                    },
                  ),
                ),
                Icon(Icons.zoom_in),
              ],
            ),
            SizedBox(height: 6),
            for (int i = 0; i < _song.tracks.length; i++)
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  final track = _song.tracks[i];
                  if (i == 0) {
                    setState(() {
                      final value = _timeStart +
                          details.primaryDelta.toInt() * _timeSpan.floor();
                      _timeStart = value > 0 ? 0 : value;
                    });
                  } else {
                    var delay = track.delay +
                        (details.primaryDelta.toInt() * _timeSpan.floor());
                    delay = max(-1000, min(1000, delay));
                    widget.onDelayChanged(track, delay);
                    setState(() {
                      _song = _song.setTrackDelay(track, delay);
                    });
                  }
                },
                child: TrackVolume(
                  track: _song.tracks[i],
                  timeSpan: _timeSpan * 1000,
                  timeStart: _timeStart,
                  isSyncing: i == 0 ? false : _isSyncing[i],
                ),
              ),
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    color: Colors.grey,
                    child: Text(localization.sync.toUpperCase()),
                    onPressed: _isSyncing.values.contains(true)
                        ? null
                        : () => _syncVideos(),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: RaisedButton(
                    child: Text(localization.done.toUpperCase()),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TrackVolume extends StatelessWidget {
  const TrackVolume({
    @required this.track,
    @required this.timeSpan,
    @required this.timeStart,
    @required this.isSyncing,
  });

  final TrackEntity track;
  final double timeSpan;
  final bool isSyncing;
  final int timeStart;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 1400),
        child: SizedBox(
          height: 1400,
          width: 10000,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Container(
              color: Colors.black38,
              child: CustomPaint(
                painter: VolumePainter(
                  track: track,
                  timeSpan: timeSpan,
                  timeStart: timeStart,
                  color: isSyncing ? Colors.yellowAccent : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VolumePainter extends CustomPainter {
  const VolumePainter({
    @required this.track,
    @required this.timeSpan,
    @required this.timeStart,
    @required this.color,
  });

  final TrackEntity track;
  final double timeSpan;
  final Color color;
  final int timeStart;

  @override
  void paint(Canvas canvas, Size size) {
    final video = track.video;
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    if (video == null || video.volumeData == null) {
      return;
    }

    final volumeData = video.volumeData;

    double volume = 0;

    for (int i = timeStart; i <= timeSpan - timeStart; i++) {
      var time = (i - track.delay).toString();

      if (volumeData.containsKey(time)) {
        volume = volumeData[time];
      }

      if (volume > 120) {
        volume = 120;
      } else if (volume < 20) {
        volume = 20;
      }

      final seconds = (timeSpan / 1000).round();
      if (i % seconds == 0) {
        final x = (i + timeStart) * (11 - seconds);

        if (x > 10000) {
          return;
        }

        final width = 20 * (11 - seconds);
        final height = 1200.0;
        final rect = Rect.fromLTRB(x.toDouble(), height, x.toDouble() + width,
            height - ((volume - 20) * 10));
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

int getMinDelay(List<Map<int, double>> maps) {
  final video1Map = maps[0];
  final video2Map = maps[1];
  double minDiff = 999999999;
  int minDiffDelay = 0;
  for (int j = -1000; j <= 1000; j++) {
    double totalDiff = 0;

    for (int k = 1000; k <= 9000; k++) {
      if (video1Map.containsKey(k) && video2Map.containsKey(k + j)) {
        final oldVolume = video1Map[k];
        final newVolume = video2Map[k + j];
        final diff = oldVolume > newVolume
            ? oldVolume - newVolume
            : newVolume - oldVolume;

        totalDiff += diff;
      }
    }

    if (totalDiff < minDiff) {
      minDiff = totalDiff;
      minDiffDelay = j;
    }
  }

  return minDiffDelay * -1;
}
