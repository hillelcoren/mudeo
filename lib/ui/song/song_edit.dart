import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/ui/song/song_edit_vm.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class SongEdit extends StatelessWidget {
  const SongEdit({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final SongEditVM viewModel;

  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<VideoPlayerController> videos = [];
  CameraController camera;
  bool isPlaying = false;
  DateTime start, end;
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

  void record() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String folder = '${directory.path}/videos';
    await Directory(folder).create(recursive: true);
    path = '$folder/${DateTime.now().millisecondsSinceEpoch}.mp4';
    start ??= DateTime.now();
    if (end != null) Timer(end.difference(start), stopRecording);
    await camera.startVideoRecording(path);
    play();
  }

  void stopRecording() async {
    end ??= DateTime.now();
    await camera.stopVideoRecording();
    VideoPlayerController player = VideoPlayerController.file(File(path));
    await player.initialize();
    setState(() => videos.add(player));
  }

  void play() {
    if (videos.isEmpty) return;
    videos.forEach((video) => video
      ..seekTo(Duration())
      ..play());
    setState(() => isPlaying = true);
    timer =
        Timer(end.difference(start), () => setState(() => isPlaying = false));
  }

  void stopPlaying() {
    videos.forEach((video) => video.pause());
    timer?.cancel();
    setState(() => isPlaying = false);
  }

  void delete() {
    setState(() {
      videos.removeLast();
      if (videos.isEmpty) start = end = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (camera == null) return SizedBox();
    final value = camera.value;
    if (!value.isInitialized) return SizedBox();
    final isRecording = value.isRecordingVideo;
    final isEmpty = videos.isEmpty;
    final cards = videos
        .map((video) => Card(
            elevation: 50,
            margin: EdgeInsets.symmetric(horizontal: 6),
            child: AspectRatio(
                aspectRatio: value.aspectRatio, child: VideoPlayer(video))))
        .toList();

    return Scaffold(
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
              icon: isPlaying && !isRecording ? Icons.stop : Icons.play_arrow,
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
              icon: Icons.delete,
              onPressed: isEmpty || isPlaying ? null : delete),
        ]),
        isEmpty
            ? SizedBox()
            : Flexible(
                child: ListView(
                scrollDirection: Axis.horizontal,
                children: cards,
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
    return Expanded(
      child: Tooltip(
        message: icon == Icons.play_arrow
            ? 'Play'
            : icon == Icons.stop
                ? 'Stop'
                : icon == Icons.delete ? 'Delete' : 'Record',
        child: MaterialButton(
          height: 75,
          onPressed: onPressed,
          child: Icon(icon, size: 36, color: color),
        ),
      ),
    );
  }
}
