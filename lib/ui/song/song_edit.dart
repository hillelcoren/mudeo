import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/ui/app/elevated_button.dart';
import 'package:mudeo/ui/song/song_edit_vm.dart';
import 'package:mudeo/ui/song/song_save_dialog.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:path_provider/path_provider.dart';
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
  int timestamp;
  String path;
  Timer timer;

  @override
  void initState() {
    super.initState();

    availableCameras().then((cameras) {
      camera = CameraController(
          cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front),
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
      String path = await getVideoPath(track.video.timestamp);
      if (await File(path).exists()) {
        VideoPlayerController player = VideoPlayerController.file(File(path));
        await player.initialize();
        setState(() {
          videos.add(player);
        });
      }
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    videos.forEach((video) => video.dispose());
    camera.dispose();
    super.dispose();
  }

  Future<String> getVideoPath(int timestamp) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String folder = '${directory.path}/videos';
    await Directory(folder).create(recursive: true);
    return '$folder/$timestamp.mp4';
  }

  void record() async {
    final song = widget.viewModel.song;
    timestamp = DateTime.now().millisecondsSinceEpoch;
    path = await getVideoPath(timestamp);
    if (song.duration > 0)
      Timer(Duration(milliseconds: song.duration), stopRecording);
    await camera.startVideoRecording(path);
    play();
  }

  void stopRecording() async {
    await camera.stopVideoRecording();
    VideoPlayerController player = VideoPlayerController.file(File(path));
    await player.initialize();
    setState(() => videos.add(player));
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
    timer = Timer(Duration(milliseconds: widget.viewModel.song.duration),
        () => setState(() => isPlaying = false));
  }

  void stopPlaying() {
    videos.forEach((video) => video.pause());
    timer?.cancel();
    setState(() => isPlaying = false);
  }

  void onSavePressed() {
    showDialog<SongSaveDialog>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SongSaveDialog(viewModel: widget.viewModel);
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

    /*
    final cards = videos
        .map((video) => Card(
            elevation: 50,
            margin: EdgeInsets.symmetric(horizontal: 6),
            child: AspectRatio(
                aspectRatio: value.aspectRatio, child: VideoPlayer(video))))
        .toList();
    */

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => viewModel.onBackPressed()),
          title: Text(viewModel.song.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              tooltip: localization.delete,
              //onPressed: isEmpty || isPlaying ? null : viewModel.onClearPressed,
              onPressed: () => viewModel.onClearPressed(context),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 50),
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
                  icon:
                      isPlaying && !isRecording ? Icons.stop : Icons.play_arrow,
                  onPressed: isRecording || isEmpty
                      ? null
                      : (isPlaying ? stopPlaying : play)),
              ExpandedButton(
                  icon: isRecording && isEmpty
                      ? Icons.stop
                      : Icons.fiber_manual_record,
                  onPressed: isRecording
                      ? (isEmpty ? stopRecording : null)
                      : (isPlaying ? null : record),
                  color: isPlaying || isRecording ? null : Colors.redAccent),
              ExpandedButton(
                  icon: Icons.cloud_upload,
                  onPressed: isEmpty || isPlaying ? null : onSavePressed),
            ]),
            isEmpty
                ? SizedBox()
                : Flexible(
                    child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: videos
                        .map((video) => TrackView(
                              video: video,
                              aspectRatio: value.aspectRatio,
                            ))
                        .toList(),
                  ))
          ]),
        ));
  }
}

class ExpandedButton extends StatelessWidget {
  ExpandedButton({this.icon, this.onPressed, this.color});

  final IconData icon;
  final Function onPressed;
  final Color color;

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
          height: 75,
          onPressed: onPressed,
          child: Icon(icon, size: 36, color: color),
        ),
      ),
    );
  }
}

class TrackView extends StatelessWidget {
  TrackView({this.video, this.aspectRatio});

  final VideoPlayerController video;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog<TrackEditDialog>(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return TrackEditDialog();
            });
      },
      child: Card(
          elevation: 50,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child:
              AspectRatio(aspectRatio: aspectRatio, child: VideoPlayer(video))),
    );
  }
}

class TrackEditDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Material(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Form(
                //key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    ElevatedButton(
                      label: localization.solo,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      height: 200,
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
                        values: [50],
                        max: 100,
                        min: 0,
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          //setState(() {});
                        },
                      ),
                    ),
                    ElevatedButton(
                      label: localization.delete,
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
