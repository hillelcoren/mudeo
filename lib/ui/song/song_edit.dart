import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/ui/app/elevated_button.dart';
import 'package:mudeo/ui/app/icon_text.dart';
import 'package:mudeo/ui/song/song_edit_vm.dart';
import 'package:mudeo/utils/camera.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class SongEdit extends StatefulWidget {
  const SongEdit({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final SongEditVM viewModel;

  @override
  _SongEditState createState() => _SongEditState();
}

class _SongEditState extends State<SongEdit> {
  List<VideoPlayerController> videos = [];
  CameraController camera;
  bool isPlaying = false;
  bool isPastThreeSeconds = false;
  int timestamp;
  String path;
  Timer recordTimer;
  Timer cancelTimer;
  Timer playTimer;

  CameraLensDirection cameraDirection = CameraLensDirection.front;
  Map<CameraLensDirection, bool> availableCameraDirections = {
    CameraLensDirection.front: false,
    CameraLensDirection.back: false,
    CameraLensDirection.external: false,
  };

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((sharedPrefs) {
      cameraDirection = convertCameraDirectionFromString(
          sharedPrefs.getString(kSharedPrefCameraDirection));
      initCamera();
    });
  }

  void initCamera() {
    availableCameras().then((cameras) {
      cameras.forEach((camera) {
        availableCameraDirections[camera.lensDirection] = true;
      });

      camera = CameraController(
          cameras
              .firstWhere((camera) => camera.lensDirection == cameraDirection),
          ResolutionPreset.high)
        ..addListener(() {
          if (mounted) setState(() {});
        })
        ..initialize();
    });
  }

  @override
  void didChangeDependencies() async {
    widget.viewModel.song.tracks.forEach((track) async {
      String path = await VideoEntity.getPath(track.video.timestamp);
      VideoPlayerController player;
      if (await File(path).exists()) {
        player = VideoPlayerController.file(File(path));
        await player.initialize();
      } else {
        player = VideoPlayerController.asset(null);
      }
      setState(() {
        videos.add(player);
      });
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    videos.forEach((video) => video.dispose());
    camera.dispose();
    super.dispose();
  }

  void record() async {
    widget.viewModel.onStartRecording();

    final song = widget.viewModel.song;
    timestamp = DateTime.now().millisecondsSinceEpoch;
    path = await VideoEntity.getPath(timestamp);

    cancelTimer = Timer(Duration(seconds: 3), () {
      setState(() => isPastThreeSeconds = true);
    });
    recordTimer = Timer(
        Duration(
            milliseconds: song.duration > 0 ? song.duration : kMaxSongDuration),
        () => saveRecording());

    await camera.startVideoRecording(path);
    play();
  }

  void stopRecording() async {
    stopPlaying();
    recordTimer?.cancel();
    cancelTimer?.cancel();
    await camera.stopVideoRecording();
    setState(() {
      isPastThreeSeconds = false;
    });
    widget.viewModel.onStopRecording();
  }

  void saveRecording() async {
    stopRecording();
    VideoPlayerController player = VideoPlayerController.file(File(path));
    await player.initialize();
    setState(() {
      isPastThreeSeconds = false;
      videos.add(player);
    });
    final track = VideoEntity().rebuild((b) => b..timestamp = timestamp);
    widget.viewModel
        .onTrackAdded(track, DateTime.now().millisecondsSinceEpoch - timestamp);
  }

  void play() {
    if (videos.isEmpty) return;
    videos.forEach((video) => video
      ..seekTo(Duration())
      ..play());
    setState(() => isPlaying = true);
    playTimer = Timer(Duration(milliseconds: widget.viewModel.song.duration),
        () => setState(() => isPlaying = false));
  }

  void stopPlaying() {
    videos.forEach((video) => video.pause());
    playTimer?.cancel();
    setState(() => isPlaying = false);
  }

  void onSettingsPressed() {
    showDialog<SimpleDialog>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          final localization = AppLocalization.of(context);
          return SimpleDialog(
            title: Text(localization.selectCamera),
            children: <Widget>[
              availableCameraDirections[CameraLensDirection.front]
                  ? SimpleDialogOption(
                      onPressed: () {
                        selectCameraDirection(CameraLensDirection.front);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconText(
                          icon: Icons.camera_front,
                          text: localization.front,
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  : SizedBox(),
              availableCameraDirections[CameraLensDirection.back]
                  ? SimpleDialogOption(
                      onPressed: () {
                        selectCameraDirection(CameraLensDirection.back);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconText(
                          icon: Icons.camera_rear,
                          text: localization.back,
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  : SizedBox(),
              availableCameraDirections[CameraLensDirection.external]
                  ? SimpleDialogOption(
                      onPressed: () {
                        selectCameraDirection(CameraLensDirection.external);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconText(
                          icon: Icons.camera_alt,
                          text: localization.external,
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          );
        });
  }

  void selectCameraDirection(CameraLensDirection direction) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        kSharedPrefCameraDirection, convertCameraDirectionToString(direction));
    setState(() {
      cameraDirection = direction;
      initCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (camera == null) return SizedBox();
    final value = camera.value;
    if (!value.isInitialized) return SizedBox();
    final isRecording = value.isRecordingVideo;
    final isEmpty = videos.isEmpty;

    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;
    final song = viewModel.song;

    IconData _getRecordIcon() {
      if (isRecording && isEmpty) {
        if (!isPastThreeSeconds) {
          return Icons.close;
        } else {
          return Icons.stop;
        }
      } else if (song.canAddTrack) {
        if (isRecording && (!isPastThreeSeconds || !isEmpty)) {
          return Icons.close;
        } else {
          return Icons.fiber_manual_record;
        }
      } else {
        return Icons.not_interested;
      }
    }

    Function _getRecordingFunction() {
      if (isRecording) {
        if (!isPastThreeSeconds || (isRecording && !isEmpty)) {
          return stopRecording;
        } else {
          return isEmpty ? saveRecording : null;
        }
      } else {
        return isPlaying ? null : (song.canAddTrack ? record : null);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: Column(children: [
        Expanded(
            child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                child: Center(
                  child: AspectRatio(
                      aspectRatio: value.aspectRatio,
                      child: CameraPreview(camera)),
                ),
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: isRecording
                        ? Border.all(color: Colors.red, width: 3)
                        : null))),
        Row(children: [
          ExpandedButton(
              icon: isPlaying && !isRecording ? Icons.stop : Icons.play_arrow,
              onPressed: isRecording || isEmpty
                  ? null
                  : (isPlaying ? stopPlaying : play)),
          ExpandedButton(
              icon: _getRecordIcon(),
              onPressed: _getRecordingFunction(),
              color: isPlaying || isRecording ? null : Colors.redAccent),
          availableCameraDirections.keys
                      .where(
                          (direction) => availableCameraDirections[direction])
                      .length >
                  2
              ? ExpandedButton(
                  icon: Icons.camera,
                  onPressed: isPlaying ? null : onSettingsPressed,
                )
              : ExpandedButton(
                  iconHeight: 26,
                  icon: cameraDirection == CameraLensDirection.front
                      ? Icons.camera_front
                      : Icons.camera_rear,
                  onPressed: isPlaying ? null : () => selectCameraDirection(
                      cameraDirection == CameraLensDirection.front
                          ? CameraLensDirection.back
                          : CameraLensDirection.front),
                ),
        ]),
        isEmpty
            ? SizedBox()
            : Flexible(
                child: ListView(
                scrollDirection: Axis.horizontal,
                children: videos
                    .map((videoPlayer) => TrackView(
                          viewModel: viewModel,
                          video: videoPlayer,
                          aspectRatio: value.aspectRatio,
                          index: videos.indexOf(videoPlayer),
                          onDeletePressed: () async {
                            Navigator.of(context).pop();
                            final index = videos.indexOf(videoPlayer);
                            final song = viewModel.song
                                .rebuild((b) => b..tracks.removeAt(index));
                            final video = viewModel.song.tracks[index].video;
                            viewModel.onDeleteVideoPressed(song, video);
                            setState(() {
                              videos.remove(videoPlayer);
                              if (videos.isEmpty) {
                                timestamp = null;
                              }
                            });
                          },
                        ))
                    .toList(),
              ))
      ]),
    );
  }
}

class TrackView extends StatelessWidget {
  TrackView(
      {this.video,
      this.aspectRatio,
      this.viewModel,
      this.index,
      this.onDeletePressed});

  final int index;
  final SongEditVM viewModel;
  final VideoPlayerController video;
  final double aspectRatio;
  final Function onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog<TrackEditDialog>(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return TrackEditDialog(
                video: video,
                viewModel: viewModel,
                index: index,
                onDeletePressed: onDeletePressed,
              );
            });
      },
      child: Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child:
              AspectRatio(aspectRatio: aspectRatio, child: VideoPlayer(video))),
    );
  }
}

class TrackEditDialog extends StatelessWidget {
  TrackEditDialog(
      {this.video, this.viewModel, this.index, this.onDeletePressed});

  final SongEditVM viewModel;
  final VideoPlayerController video;
  final int index;
  final Function onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final song = viewModel.song;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Material(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 30),
                          height: 250,
                          child: FlutterSlider(
                            handlerAnimation: FlutterSliderHandlerAnimation(
                                curve: Curves.elasticOut,
                                reverseCurve: Curves.bounceIn,
                                duration: Duration(milliseconds: 500),
                                scale: 1.25),
                            trackBar: FlutterSliderTrackBar(
                              activeTrackBarColor: Colors.greenAccent,
                              activeTrackBarHeight: 5,
                              leftInactiveTrackBarColor:
                                  Colors.grey.withOpacity(0.5),
                            ),
                            tooltip: FlutterSliderTooltip(
                              rightSuffix: Icon(
                                Icons.volume_up,
                                size: 19,
                                color: Colors.black26,
                              ),
                            ),
                            axis: Axis.vertical,
                            rtl: true,
                            //values: [0, 25, 50, 75, 100],
                            values: [song.tracks[index].volume.toDouble()],
                            max: 100,
                            min: 0,
                            onDragging: (handlerIndex, lowerValue, upperValue) {
                              video.setVolume(lowerValue / 100);
                              final song = viewModel.song
                                  .setTrackVolume(index, lowerValue.toInt());
                              viewModel.onChangedSong(song);
                            },
                          ),
                        ),
                        ElevatedButton(
                          label: localization.delete,
                          color: Colors.redAccent,
                          onPressed: onDeletePressed,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandedButton extends StatelessWidget {
  ExpandedButton(
      {this.icon, this.onPressed, this.color, this.viewModel, this.iconHeight});

  final IconData icon;
  final Function onPressed;
  final Color color;
  final SongEditVM viewModel;
  final double iconHeight;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return Expanded(
      child: Tooltip(
        message: icon == Icons.play_arrow
            ? localization.play
            : icon == Icons.stop
                ? localization.stop
                : icon == Icons.delete
                    ? localization.delete
                    : localization.record,
        child: MaterialButton(
          height: 60,
          onPressed: onPressed,
          child: Icon(icon, size: iconHeight ?? 32, color: color),
          //color: Colors.grey,
        ),
      ),
    );
  }
}
