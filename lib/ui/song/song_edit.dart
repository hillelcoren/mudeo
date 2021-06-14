import 'dart:io';
import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:http/http.dart' as http;
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/ui/app/dialogs/error_dialog.dart';
import 'package:mudeo/ui/app/icon_text.dart';
import 'package:mudeo/ui/app/live_text.dart';
import 'package:mudeo/ui/song/add_video.dart';
import 'package:mudeo/ui/song/song_edit_vm.dart';
import 'package:mudeo/ui/song/song_render.dart';
import 'package:mudeo/ui/song/song_save_dialog.dart';
import 'package:mudeo/ui/song/track_syncer.dart';
import 'package:mudeo/utils/camera.dart';
import 'package:mudeo/utils/dialogs.dart';
import 'package:mudeo/utils/ffmpeg.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:mudeo/utils/posenet.dart';
import 'package:mudeo/utils/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class SongScaffold extends StatelessWidget {
  const SongScaffold({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final SongEditVM viewModel;

  void onSavePressed(BuildContext context, SongEditVM viewModel) {
    if (!viewModel.state.authState.hasValidToken) {
      showDialog<AlertDialog>(
          context: context,
          builder: (BuildContext context) {
            final localization = AppLocalization.of(context);
            return AlertDialog(
              content: Text(localization.requireAccountToUpload),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(localization.close.toUpperCase()))
              ],
            );
          });
    } else {
      showDialog<SongSaveDialog>(
          context: context,
          barrierDismissible: false,
          useRootNavigator: true,
          builder: (BuildContext context) {
            return SongSaveDialog(viewModel: viewModel);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final state = viewModel.state;
    final uiState = state.uiState;
    final song = viewModel.song;
    final authArtist = viewModel.state.authState.artist;
    final isMissingRecognitions = false;
    /*
    final isMissingRecognitions = song.tracks
        .where((track) =>
            track.video.isNew && (track.video.recognitions ?? '').isEmpty)
        .isNotEmpty;
    */

    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) {
            final actions = [
              state.isDance ? localization.newDance : localization.newSong
            ];
            if (song.isOld) {
              actions.add(localization.download);
            }
            if (song.canAddTrack) {
              actions.add(localization.addVideo);
            }
            if (song.isOld) {
              actions.add(
                (kIsWeb)
                    ? localization.openInNewTab
                    : localization.openInBrowser,
              );
            }
            if (song.isOld && authArtist.ownsSong(song)) {
              actions.add(state.isDance
                  ? localization.cloneDance
                  : localization.cloneSong);
            }
            if (song.isOld || song.parentId > 0) {
              actions.add(state.isDance
                  ? localization.resetDance
                  : localization.resetSong);
            }
            if (song.isOld &&
                (authArtist.ownsSong(song) || authArtist.isAdmin)) {
              actions.add(state.isDance
                  ? localization.deleteDance
                  : localization.deleteSong);
            }
            return actions
                .map((action) => PopupMenuItem(
                      child: Text(action),
                      value: action,
                    ))
                .toList();
          },
          onSelected: (String action) async {
            if (action == localization.openInBrowser ||
                action == localization.openInNewTab) {
              launch(song.url);
              return;
            } else if (action == localization.download) {
              final Directory directory =
                  await getApplicationDocumentsDirectory();
              final String folder = '${directory.path}/videos';
              await Directory(folder).create(recursive: true);
              final path = '$folder/${song.title}.mp4';
              if (!await File(path).exists()) {
                final http.Response copyResponse =
                    await http.Client().get(song.videoUrl);
                await File(path).writeAsBytes(copyResponse.bodyBytes);
              }
              Share.shareFiles([path]);
              return;
            } else if (action == localization.addVideo) {
              showDialog<AddVideo>(
                  context: context,
                  builder: (BuildContext childContext) {
                    return AddVideo(
                      song: song,
                      onRemoteVideoSelected: (videoId) =>
                          viewModel.onAddRemoteVideo(context, videoId),
                      onTrackSelected: (track) =>
                          viewModel.addVideoFromTrack(context, track),
                      onSongSelected: (song) =>
                          viewModel.addVideoFromSong(context, song),
                    );
                  });
            } else {
              showDialog<AlertDialog>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      semanticLabel: localization.areYouSure,
                      title: Text(localization.loseChanges),
                      content: Text(localization.areYouSure),
                      actions: <Widget>[
                        FlatButton(
                            child: Text(localization.cancel.toUpperCase()),
                            onPressed: () => Navigator.pop(context)),
                        FlatButton(
                            child: Text(localization.ok.toUpperCase()),
                            onPressed: () {
                              Navigator.pop(context);
                              if (action == localization.newSong ||
                                  action == localization.newDance) {
                                viewModel.onNewSongPressed(context);
                              } else if (action == localization.resetSong ||
                                  action == localization.resetDance) {
                                viewModel.onResetSongPressed(context);
                              } else if (action == localization.deleteSong ||
                                  action == localization.deleteDance) {
                                viewModel.onDeleteSongPressed(song);
                              } else if (action == localization.cloneSong ||
                                  action == localization.cloneDance) {
                                viewModel.onForkSongPressed(song);
                              }
                            })
                      ],
                    );
                  });
            }
          },
        ),
        title: Center(
          child: LiveText(
            () {
              if (uiState.recordingTimestamp > 0) {
                int seconds;
                if (viewModel.song.tracks.isNotEmpty) {
                  seconds = (viewModel.song.duration ~/ 1000) -
                      uiState.recordingDuration.inSeconds;
                } else {
                  seconds = uiState.recordingDuration.inSeconds;
                }

                return seconds < 10 ? '00:0$seconds' : '00:$seconds';
              } else {
                return song.isNew && song.parentId == 0
                    ? (state.isDance
                        ? localization.newDance
                        : localization.newSong)
                    : song.title;
              }
            },
            style: () => TextStyle(
                color: viewModel.song.tracks.isNotEmpty &&
                        uiState.recordingDuration.inMilliseconds >=
                            kMaxSongDuration - kFirstWarningOffset
                    ? (uiState.recordingDuration.inMilliseconds >=
                            kMaxSongDuration - kSecondWarningOffset
                        ? Colors.redAccent
                        : Colors.orangeAccent)
                    : null),
          ),
        ),
        actions: <Widget>[
          viewModel.state.isSaving || isMissingRecognitions
              ? Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Center(
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator()),
                  ),
                )
              : FlatButton(
                  child: Text(localization.publish),
                  onPressed:
                      !uiState.isRecording && song.includedTracks.isNotEmpty
                          ? () => onSavePressed(context, viewModel)
                          : null,
                ),
        ],
      ),
      body: SongEdit(
        viewModel: viewModel,
        key: ValueKey('${viewModel.song.updatedAt}'),
      ),
    );
  }
}

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
  Map<int, VideoPlayerController> videoPlayers = {};
  Map<int, VideoPlayerController> allVideoPlayers = {};
  CameraController camera;
  bool isPlaying = false, isRecording = false;
  bool isPastThreeSeconds = false;
  int countdownTimer = 0;
  String path;
  Timer recordTimer;
  Timer cancelTimer;
  Timer playTimer;
  Completer _readyCompleter;
  int _activeTrack = 0;

  CameraLensDirection cameraDirection = CameraLensDirection.front;
  Map<CameraLensDirection, bool> availableCameraDirections = {
    CameraLensDirection.front: false,
    CameraLensDirection.back: false,
    CameraLensDirection.external: false,
  };

  bool get disableButtons => isPlaying || isRecording || countdownTimer > 0;

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
          ResolutionPreset.low)
        /*
        ..addListener(() {
          if (mounted) setState(() {});
        })
       */
        ..initialize().then((value) async {
          if (mounted) setState(() {});
          /*
          final sharedPrefs = await SharedPreferences.getInstance();
          if (sharedPrefs.getBool(kSharedPrefCalibrated) != true) {
            sharedPrefs.setBool(kSharedPrefCalibrated, true);
            showDialog<CalibrationDialog>(
                context: context,
                builder: (BuildContext context) {
                  return CalibrationDialog();
                });
          }
           */
        });
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    bool isFirst = true;
    final futures = List<Future>();
    final viewModel = widget.viewModel;
    for (final track in viewModel.song.includedTracks) {
      futures.add(() async {
        final video = track.video;
        VideoPlayerController player;
        String path = await VideoEntity.getPath(video);
        if (!await File(path).exists()) {
          final http.Response copyResponse = await http.Client().get(video.url);
          await File(path).writeAsBytes(copyResponse.bodyBytes);
        }
        player = VideoPlayerController.file(
          File(path),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
        allVideoPlayers[track.id] = videoPlayers[track.id] = player;
        if (viewModel.state.isDance && !isFirst) {
          player.setVolume(0);
        } else {
          player.setVolume(track.volume.toDouble());
        }
        await player.initialize();
        isFirst = false;
      }());
    }
    final completer = Completer();
    Future.wait(futures)
        .then(completer.complete)
        .catchError(completer.completeError);
    _readyCompleter = completer;
    _readyCompleter.future.then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    allVideoPlayers.forEach((int, videoPlayer) => videoPlayer?.dispose());
    camera?.dispose();
    super.dispose();
  }

  void record() async {
    if (countdownTimer > 0) {
      return;
    }

    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;
    final state = viewModel.state;
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(kSharedPrefHeadphoneWarning) != true &&
        (!state.isDance || viewModel.song.tracks.isEmpty)) {
      showDialog<AlertDialog>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(localization.note),
              content: Text(
                widget.viewModel.state.isDance
                    ? localization.backgroundMusicHelp
                    : localization.headphoneWarning,
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FlatButton(
                    child: Text(AppLocalization.of(context).dismiss),
                    onPressed: () async {
                      await prefs.setBool(kSharedPrefHeadphoneWarning, true);
                      Navigator.of(context).pop();
                      record();
                    },
                  ),
                )
              ],
            );
          });
      return;
    }

    // TODO remove this, it's needed to prevent the app from crashing
    if (Platform.isIOS) {
      initCamera();
    }

    setState(() {
      countdownTimer = 3;
      Timer(Duration(seconds: 1), () {
        setState(() {
          countdownTimer = 2;
        });
        Timer(Duration(seconds: 1), () {
          camera.prepareForVideoRecording();
          setState(() {
            countdownTimer = 1;
          });
          Timer(Duration(seconds: 1), () {
            countdownTimer = 0;
            _record();
          });
        });
      });
    });
  }

  void _record() async {
    setState(() => isRecording = true);

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    widget.viewModel.onStartRecording(timestamp);

    final song = widget.viewModel.song;
    path = await VideoEntity.getPath(
        VideoEntity().rebuild((b) => b..timestamp = timestamp));
    cancelTimer = Timer(Duration(seconds: 3), () {
      setState(() => isPastThreeSeconds = true);
    });
    recordTimer = Timer(
      Duration(
          milliseconds: song.duration > 0 ? song.duration : kMaxSongDuration),
      () => saveRecording(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      play(isRecording: true);
      camera.startVideoRecording();
    });
  }

  Future stopRecording() async {
    setState(() => isRecording = false);
    stopPlaying();

    recordTimer?.cancel();
    cancelTimer?.cancel();

    setState(() {
      isPastThreeSeconds = false;
    });

    widget.viewModel.onStopRecording();

    try {
      final video = await camera.stopVideoRecording();
      final videoFile = File(video.path);
      try {
        await videoFile.rename(path);
      } on FileSystemException catch (_) {
        await videoFile.copy(path);
        await videoFile.delete();
      }
    } catch (error) {
      showDialog<ErrorDialog>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(error);
          });
    }
  }

  void saveRecording() async {
    final timestamp = widget.viewModel.state.uiState.recordingTimestamp;
    final endTimestamp = DateTime.now().millisecondsSinceEpoch;
    await stopRecording();
    VideoPlayerController videoPlayer = VideoPlayerController.file(File(path));
    await videoPlayer.initialize();

    // TODO remove this: https://github.com/flutter/flutter/issues/30689
    if (Platform.isIOS) {
      await camera.initialize();
    }

    BuiltMap<String, double> volumeData;
    try {
      volumeData = await FfmpegUtils.calculateVolumeData(path);
    } catch (error) {
      // do nothing
    }

    final video = VideoEntity().rebuild((b) => b
      ..timestamp = timestamp
      ..volumeData.replace(volumeData));

    final duration = endTimestamp - timestamp;

    final trackId = await widget.viewModel.onVideoAdded(video, duration);

    setState(() {
      isPastThreeSeconds = false;
      allVideoPlayers[trackId] = videoPlayers[trackId] = videoPlayer;
    });

    /*
    if (widget.viewModel.state.isDance) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final recognitions = await updateRecognitions(
          delay: 0,
          duration: duration,
          video: video,
        );

        if (widget.viewModel.song.tracks.length > 1) {
          showDialog<TrackScore>(
              context: context,
              builder: (BuildContext context) {
                final song = widget.viewModel.song;
                return TrackScore(
                    song: song,
                    video:
                        video.rebuild((b) => b..recognitions = recognitions));
              });
        }
      });
    }
     */
  }

  Future<String> updateRecognitions(
      {@required VideoEntity video,
      @required int duration,
      @required int delay}) async {
    if (!widget.viewModel.state.isDance) {
      return null;
    }

    showProcessingDialog(context);
    String path = await VideoEntity.getPath(video);
    if (!await File(path).exists()) {
      final http.Response response = await http.Client().get(video.url);
      await File(path).writeAsBytes(response.bodyBytes);
    }
    final data = await convertVideoToRecognitions(
        path: path, duration: duration, delay: delay);
    widget.viewModel.onVideoRecognitionsUpdated(video, data);
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    return data;
  }

  Future play({bool isRecording = false}) async {
    Future future;
    if (videoPlayers.isEmpty) return;

    // This is required to get the videos to start playing in sync
    // after the timed delay, not sure why?
    for (final videoPlayer in videoPlayers.values) {
      videoPlayer.pause();
    }

    int minDelay = 0;
    int maxDelay = 0;
    final tracks = widget.viewModel.song.includedTracks;
    for (final track in tracks) {
      if ((track.delay ?? 0) < minDelay) minDelay = track.delay;
      if ((track.delay ?? 0) > maxDelay) maxDelay = track.delay;
    }

    bool isFirst = true;
    int index = 0;
    for (final entry in videoPlayers.entries) {
      final track = tracks.firstWhere((track) => track.id == entry.key,
          orElse: () => null);
      if (track == null) {
        continue;
      }
      if (!isRecording || index == _activeTrack) {
        final player = entry.value;
        final delay =
            Duration(milliseconds: (minDelay * -1) + (track.delay ?? 0));
        player.seekTo(Duration.zero);
        if (delay == 0) {
          if (isFirst) {
            future = player.play();
          } else {
            player.play();
          }
        } else {
          Future.delayed(delay, () => player.play());
        }
      }
      isFirst = false;
      index++;
    }

    setState(() => isPlaying = true);
    playTimer = Timer(
      Duration(milliseconds: widget.viewModel.song.duration),
      () => setState(() => isPlaying = false),
    );

    return future;
  }

  void stopPlaying() {
    videoPlayers.forEach((int, videoPlayer) => videoPlayer.pause());
    playTimer?.cancel();
    setState(() => isPlaying = false);
  }

  void onSettingsPressed() {
    showDialog<SimpleDialog>(
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
    final viewModel = widget.viewModel;
    final state = viewModel.state;
    final song = viewModel.song;
    final isEmpty = song.includedTracks.isEmpty;

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

    void _renderSong() {
      showDialog<AlertDialog>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SongRender(song: song);
          });
    }

    final bool isFullScreen = state.isDance &&
        (isRecording || countdownTimer > 0) &&
        song.tracks.isNotEmpty;
    final firstTrack = isFullScreen ? song.tracks.first : null;
    final firstVideoPlayer = videoPlayers[firstTrack?.id];

    return Scaffold(
      body: Padding(
        // TODO use media query to determine this
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 78 : 50),
        child: Column(
          children: [
            if (!isFullScreen)
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1 / value.aspectRatio,
                      //child: CameraPreview(camera),
                      child: camera.buildPreview(),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: isRecording
                          ? Border.all(color: Colors.red, width: 3)
                          : null),
                ),
              ),
            Material(
              color: Colors.black26,
              //elevation: kDefaultElevation,
              child: Row(
                children: [
                  ExpandedButton(
                    icon: isPlaying && !isRecording
                        ? Icons.stop
                        : Icons.play_arrow,
                    onPressed: isEmpty || isRecording || countdownTimer > 0
                        ? null
                        : (isPlaying ? stopPlaying : play),
                  ),
                  availableCameraDirections.keys
                              .where((direction) =>
                                  availableCameraDirections[direction])
                              .length >
                          2
                      ? ExpandedButton(
                          icon: Icons.camera,
                          onPressed: disableButtons ? null : onSettingsPressed,
                        )
                      : ExpandedButton(
                          iconHeight: 26,
                          icon: cameraDirection == CameraLensDirection.front
                              ? Icons.camera_front
                              : Icons.camera_rear,
                          onPressed: disableButtons
                              ? null
                              : () => selectCameraDirection(
                                    cameraDirection == CameraLensDirection.front
                                        ? CameraLensDirection.back
                                        : CameraLensDirection.front,
                                  ),
                        ),
                  ExpandedButton(
                    icon: countdownTimer > 0 ? null : _getRecordIcon(),
                    label:
                        countdownTimer > 0 ? countdownTimer.toString() : null,
                    onPressed: _getRecordingFunction(),
                    color: isPlaying || isRecording ? null : Colors.redAccent,
                  ),
                  ExpandedButton(
                    icon: Icons.movie,
                    onPressed: disableButtons || song.includedTracks.length < 2
                        ? null
                        : () => _renderSong(),
                  ),
                ],
              ),
            ),
            if (isFullScreen && firstVideoPlayer != null)
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1 / firstVideoPlayer.value.aspectRatio,
                      child: VideoPlayer(firstVideoPlayer),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: isRecording
                          ? Border.all(color: Colors.red, width: 3)
                          : null),
                ),
              )
            else
              song.tracks.isEmpty
                  ? SizedBox()
                  : Flexible(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: song.includedTracks.map((track) {
                          final videoPlayer = videoPlayers[track.id];
                          final songIndex = song.includedTracks.indexOf(track);

                          if (videoPlayer == null) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(50),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          return TrackView(
                            isFirst: songIndex == 0,
                            viewModel: viewModel,
                            videoPlayer: videoPlayer,
                            aspectRatio: videoPlayer.value.aspectRatio,
                            track: track,
                            onDeletePressed: () async {
                              videoPlayers.remove(track.id);
                              allVideoPlayers.remove(track.id);
                              viewModel.onDeleteVideoPressed(song, track);
                            },
                            onFixPressed: () async {
                              final recognitions = await updateRecognitions(
                                delay: 0,
                                duration: song.duration,
                                video: track.video,
                              );
                              printWrapped('## recognitions: $recognitions');
                            },
                            onDelayChanged: (track, delay) {
                              final song =
                                  viewModel.song.setTrackDelay(track, delay);
                              viewModel.onChangedSong(song);
                              /*
                            if (delay != track.delay) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                updateRecognitions(
                                    video: track.video,
                                    duration: song.duration,
                                    delay: delay);
                              });
                            }
                             */
                            },
                            isActive: _activeTrack == songIndex,
                            onActivatePressed: () =>
                                setState(() => _activeTrack = songIndex),
                          );
                        }).toList(),
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}

class TrackView extends StatelessWidget {
  TrackView({
    @required this.videoPlayer,
    @required this.aspectRatio,
    @required this.viewModel,
    @required this.track,
    @required this.onDeletePressed,
    @required this.onDelayChanged,
    @required this.isFirst,
    @required this.onFixPressed,
    @required this.isActive,
    @required this.onActivatePressed,
  });

  final SongEditVM viewModel;
  final VideoPlayerController videoPlayer;
  final TrackEntity track;
  final double aspectRatio;
  final Function onFixPressed;
  final Function onDeletePressed;
  final Function(TrackEntity, int) onDelayChanged;
  final bool isFirst;
  final bool isActive;
  final Function onActivatePressed;

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    final localization = AppLocalization.of(context);

    return InkWell(
      onTap: state.isDance
          ? null
          : () {
              showDialog<TrackEditDialog>(
                context: context,
                builder: (BuildContext context) {
                  return TrackEditDialog(
                    videoPlayer: videoPlayer,
                    viewModel: viewModel,
                    onDeletePressed: onDeletePressed,
                    onDelayChanged: (delay) => onDelayChanged(track, delay),
                    track: track,
                    isFirst: isFirst,
                    isActive: isActive,
                    onActivatePressed: onActivatePressed,
                    onFixPressed: onFixPressed,
                  );
                },
              );
            },
      child: Stack(
        children: <Widget>[
          Card(
            elevation: kDefaultElevation,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: videoPlayer == null
                ? SizedBox(width: 139)
                : track.video.isRemoteVideo
                    ? Stack(
                        children: <Widget>[
                          AspectRatio(
                              aspectRatio: aspectRatio,
                              child: VideoPlayer(videoPlayer)),
                          Container(
                            // TODO FIX if video download failed size will be null
                            width: videoPlayer.value.size.width,
                            color: Colors.black,
                            child: Center(
                              child: Text(
                                AppLocalization.of(context).backingTrack,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(
                        child: AspectRatio(
                            aspectRatio: aspectRatio,
                            child: VideoPlayer(videoPlayer)),
                      ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                  stops: [0.0, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 4),
                  if (!isFirst)
                    IconButton(
                      icon: Icon(Icons.swap_horizontal_circle, size: 28),
                      onPressed: () {
                        showDialog<TrackSyncer>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return TrackSyncer(
                              song: viewModel.song,
                              track: track,
                              onDelayChanged: (delay) =>
                                  onDelayChanged(track, delay),
                            );
                          },
                        );
                      },
                    )
                  else
                    SizedBox(),
                  Spacer(),
                  if (!isFirst || !state.isDance)
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 28,
                      ),
                      onPressed: () {
                        showDialog<AlertDialog>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            semanticLabel: localization.areYouSure,
                            title: Text(localization.removeVideo),
                            content: Text(localization.areYouSure),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(localization.cancel.toUpperCase()),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text(localization.ok.toUpperCase()),
                                onPressed: () {
                                  Navigator.pop(context);
                                  onDeletePressed();
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  SizedBox(width: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrackEditDialog extends StatelessWidget {
  TrackEditDialog({
    @required this.videoPlayer,
    @required this.track,
    @required this.viewModel,
    @required this.onDeletePressed,
    @required this.onFixPressed,
    @required this.onDelayChanged,
    @required this.isFirst,
    @required this.isActive,
    @required this.onActivatePressed,
  });

  final SongEditVM viewModel;
  final VideoPlayerController videoPlayer;
  final TrackEntity track;
  final Function onDeletePressed;
  final Function onFixPressed;
  final Function(int) onDelayChanged;
  final bool isFirst;
  final bool isActive;
  final Function onActivatePressed;

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    /*
   final localization = AppLocalization.of(context);
    final buttonWidth = 160.0;
    final buttonHeight = 55.0;
    final bottomPadding = 16.0;
     */

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Material(
          elevation: kDefaultElevation,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (!state.isDance)
                    Container(
                      height: 300,
                      width: 100,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: FlutterSlider(
                        handlerWidth: 36,
                        handler: FlutterSliderHandler(
                          decoration: BoxDecoration(),
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.rectangle,
                              border:
                                  Border.all(width: 2, color: Colors.black54),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        handlerAnimation: FlutterSliderHandlerAnimation(
                            curve: Curves.elasticOut,
                            reverseCurve: Curves.bounceIn,
                            duration: Duration(milliseconds: 500),
                            scale: 1.25),
                        trackBar: FlutterSliderTrackBar(
                          activeTrackBar: BoxDecoration(
                            color: Colors.greenAccent,
                          ),
                          activeTrackBarHeight: 5,
                          inactiveTrackBar: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                          ),
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
                        max: 100,
                        min: 0,
                        onDragCompleted:
                            (handlerIndex, lowerValue, upperValue) {
                          videoPlayer.setVolume(lowerValue / 100);
                          final song = viewModel.song
                              .setTrackVolume(track, lowerValue.toInt());
                          viewModel.onChangedSong(song);
                        },
                        values: [track.volume.toDouble()],
                      ),
                    ),
                  if (isActive)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('Active'),
                    )
                  else
                    IconButton(
                      onPressed: () {
                        onActivatePressed();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.volume_up),
                    ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text(AppLocalization.of(context).download),
                    onPressed: () async {
                      Share.shareFiles([await track.video.path]);
                    },
                  )
                  /*
                  if (state.isDance && state.authState.artist.isAdmin)
                    Padding(
                      padding: EdgeInsets.only(bottom: bottomPadding),
                      child: ElevatedButton(
                        width: buttonWidth,
                        height: buttonHeight,
                        color: Colors.orange,
                        icon: Icons.warning,
                        label: localization.fix,
                        textStyle: Theme.of(context).textTheme.headline6,
                        onPressed: () => onFixPressed(),
                      ),
                    ),
                  if (state.isDance)
                    Padding(
                      padding: EdgeInsets.only(bottom: bottomPadding),
                      child: ElevatedButton(
                        width: buttonWidth,
                        height: buttonHeight,
                        color: Colors.green,
                        icon: Icons.check_circle_outline,
                        label: localization.score,
                        textStyle: Theme.of(context).textTheme.headline6,
                        onPressed: () async {
                          Navigator.of(context).pop();
                          showDialog<TrackScore>(
                              context: context,
                              builder: (BuildContext context) {
                                return TrackScore(
                                  song: viewModel.song,
                                  video: track.video,
                                );
                              });
                        },
                      ),
                    ),
                  isFirst
                      ? SizedBox()
                      : Padding(
                          padding: EdgeInsets.only(bottom: bottomPadding),
                          child: ElevatedButton(
                            width: buttonWidth,
                            height: buttonHeight,
                            label: localization.adjust,
                            icon: Icons.swap_horizontal_circle,
                            textStyle: Theme.of(context).textTheme.headline6,
                            onPressed: () {
                              Navigator.of(context).pop();
                              showDialog<TrackLatency>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return TrackSyncer(
                                      song: viewModel.song,
                                      track: track,
                                      onDelayChanged: (delay) =>
                                          onDelayChanged(delay),
                                    );
                                  });
                            },
                          ),
                        ),
                  track.video.isRemoteVideo
                      ? Padding(
                          padding: EdgeInsets.only(bottom: bottomPadding),
                          child: ElevatedButton(
                            width: buttonWidth,
                            height: buttonHeight,
                            label: localization.source,
                            textStyle: Theme.of(context).textTheme.headline6,
                            onPressed: () {
                              Navigator.of(context).pop();
                              launch(track.video.remoteVideoUrl,
                                  forceSafariVC: false);
                            },
                          ),
                        )
                      : SizedBox(),
                  ElevatedButton(
                    width: buttonWidth,
                    height: buttonHeight,
                    textStyle: Theme.of(context).textTheme.headline6,
                    icon: Icons.delete_outline,
                    label: track.video.isOld
                        ? localization.remove
                        : localization.delete,
                    color: Colors.redAccent,
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDialog<AlertDialog>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          semanticLabel: localization.areYouSure,
                          title: Text(localization.removeVideo),
                          content: Text(localization.areYouSure),
                          actions: <Widget>[
                            new FlatButton(
                                child: Text(localization.cancel.toUpperCase()),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            new FlatButton(
                                child: Text(localization.ok.toUpperCase()),
                                onPressed: () {
                                  Navigator.pop(context);
                                  onDeletePressed();
                                })
                          ],
                        ),
                      );
                    },
                  ),
                   */
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ExpandedButton extends StatelessWidget {
  ExpandedButton({
    this.icon,
    this.onPressed,
    this.color,
    this.viewModel,
    this.iconHeight,
    this.label,
  });

  final IconData icon;
  final Function onPressed;
  final Color color;
  final SongEditVM viewModel;
  final double iconHeight;
  final String label;

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
          color: Colors.black38,
          height: 60,
          onPressed: onPressed,
          child: label != null
              ? Text(label,
                  style: TextStyle(
                      color: color, fontSize: 24, fontWeight: FontWeight.bold))
              : Icon(icon, size: iconHeight ?? 32, color: color),
          //color: Colors.grey,
        ),
      ),
    );
  }
}
