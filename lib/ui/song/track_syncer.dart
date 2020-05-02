import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/utils/localization.dart';

class TrackSyncer extends StatefulWidget {
  const TrackSyncer({
    @required this.song,
    @required this.track,
    @required this.onDelayChanged,
  });

  final SongEntity song;
  final TrackEntity track;
  final Function(int) onDelayChanged;

  @override
  _TrackSyncerState createState() => _TrackSyncerState();
}

class _TrackSyncerState extends State<TrackSyncer> {
  double _zoomLevel = 3;
  double _timeSpan = 7;
  int _timeStart = 0;
  bool _isSyncing = false;
  int _delay;
  TextEditingController _delayController;

  @override
  void initState() {
    super.initState();
    _delayController = TextEditingController();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    _delay = widget.track.delay;
    _delayController.text = '$_delay';
  }

  @override
  void dispose() {
    _delayController.dispose();
    super.dispose();
  }

  void _syncVideos() async {
    setState(() {
      _isSyncing = true;
    });

    final track = widget.track;

    if (track.video.volumeData != null) {
      final start = _timeStart * -1;
      final end = start + (_timeSpan.floor() * 1000);

      int delay = await compute(getMinDelay, [
        track.video.getVolumeMap(start, end),
        track.video.getVolumeMap(start, end),
      ]);
      setState(() {
        _delay = delay;
        _delayController.text = '$delay';
        _isSyncing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    final song = widget.song;
    final tracks = [song.tracks.first, widget.track];

    return AlertDialog(
      title: Text(AppLocalization.of(context).trackAdjustment),
      actions: <Widget>[
        if (!_isSyncing && widget.track.video.hasVolumeData)
          FlatButton(
            child: Text(localization.sync.toUpperCase()),
            onPressed: () => _syncVideos(),
          ),
        if (!_isSyncing)
          FlatButton(
            child: Text(localization.done.toUpperCase()),
            onPressed: () {
              widget.onDelayChanged(_delay);
              Navigator.of(context).pop();
            },
          ),
      ],
      content: ClipRect(
        child: SingleChildScrollView(
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
              for (int i = 0; i < tracks.length; i++)
                GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (i == 0) {
                      setState(() {
                        final value = _timeStart +
                            details.primaryDelta.toInt() * _timeSpan.floor();
                        _timeStart = value > 0 ? 0 : value;
                      });
                    } else {
                      var delay = _delay +
                          (details.primaryDelta.toInt() * _timeSpan.floor());
                      delay =
                          max(kMinLatencyDelay, min(kMaxLatencyDelay, delay));
                      setState(() {
                        _delay = delay;
                        _delayController.text = '$delay';
                      });
                    }
                  },
                  child: TrackVolume(
                    track: tracks[i],
                    timeSpan: _timeSpan * 1000,
                    timeStart: _timeStart,
                    isSyncing: _isSyncing,
                    delay: i == 0 ? 0 : _delay,
                    isFirst: i == 0,
                  ),
                ),
              SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Slider(
                      min: kMinLatencyDelay.toDouble(),
                      max: kMaxLatencyDelay.toDouble(),
                      value: _delay.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          _delay = value.toInt();
                          _delayController.text = '${value.toInt()}';
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _delayController,
                      decoration: InputDecoration(
                        labelText: localization.milliseconds,
                      ),
                      onChanged: (String value) {
                        setState(() {
                          int delay = int.parse(value);
                          if (delay > kMaxLatencyDelay) {
                            delay = kMaxLatencyDelay;
                          } else if (delay < kMinLatencyDelay) {
                            delay = kMinLatencyDelay;
                          }
                          _delay = delay;
                        });
                      },
                    ),
                  ),
                ],
              ),
              if (_isSyncing)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: LinearProgressIndicator(),
                )
            ],
          ),
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
    @required this.delay,
    @required this.isFirst,
  });

  final TrackEntity track;
  final double timeSpan;
  final bool isSyncing;
  final int timeStart;
  final int delay;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    if (track.video.volumeData == null) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalization.of(context).saveVideoToProcessAudio,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        alignment: Alignment.centerLeft,
        color: Colors.black38,
        height: 40,
      );
    }

    return FittedBox(
      fit: BoxFit.cover,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 2000),
        child: SizedBox(
          height: 2000,
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
                  color: isSyncing && !isFirst
                      ? Colors.yellowAccent
                      : Colors.white,
                  delay: delay,
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
    @required this.delay,
  });

  final TrackEntity track;
  final double timeSpan;
  final Color color;
  final int timeStart;
  final int delay;

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
      var time = (i - delay).toString();

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

        if (i > 10000) {
          return;
        }

        final width = 20 * (11 - seconds);
        final height = 1780.0;
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
