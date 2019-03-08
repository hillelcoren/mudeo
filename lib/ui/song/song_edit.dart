import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/data/models/song.dart';
import 'package:mudeo/ui/app/elevated_button.dart';
import 'package:mudeo/ui/song/song_edit_vm.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

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
  DateTime start, end;
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

  void record() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String folder = '${directory.path}/videos';
    await Directory(folder).create(recursive: true);
    timestamp = DateTime.now().millisecondsSinceEpoch;
    path = '$folder/$timestamp.mp4';
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

    final track = VideoEntity().rebuild((b) => b..timestamp = timestamp);
    widget.viewModel.onTrackAdded(track);
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

  void onSavePressed() {
    showDialog<SaveSongDialog>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SaveSongDialog(viewModel: widget.viewModel);
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
              icon: Icons.cloud_upload,
              onPressed: isEmpty || isPlaying ? null : onSavePressed),
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

class SaveSongDialog extends StatefulWidget {
  const SaveSongDialog({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final SongEditVM viewModel;

  @override
  _SaveSongDialogState createState() => _SaveSongDialogState();
}

class _SaveSongDialogState extends State<SaveSongDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<TextEditingController> _controllers = [];

  @override
  void didChangeDependencies() {
    if (_controllers.isNotEmpty) {
      return;
    }

    _controllers = [
      _titleController,
      _descriptionController,
    ];

    _controllers
        .forEach((dynamic controller) => controller.removeListener(_onChanged));

    final song = widget.viewModel.song;
    _titleController.text = song.title;
    _descriptionController.text = song.description;

    _controllers
        .forEach((dynamic controller) => controller.addListener(_onChanged));

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllers.forEach((dynamic controller) {
      controller.removeListener(_onChanged);
      controller.dispose();
    });

    super.dispose();
  }

  void _onChanged() {
    final song = widget.viewModel.song
        .rebuild((b) => b..title = _titleController.text.trim());

    if (song != widget.viewModel.song) {
      print('save song');
      widget.viewModel.onSongChanged(song);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final song = widget.viewModel.song;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Material(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    autocorrect: false,
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: localization.title,
                    ),
                    validator: (value) => value.isNotEmpty && value.length < 8
                        ? localization.fieldIsRequired
                        : null,
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: _descriptionController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: localization.description,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.public,
                          color: Colors.white70,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          localization.public,
                          style: TextStyle(color: Colors.white70),
                        ),
                        Spacer(),
                        FlatButton(
                          child: Text(localization.cancel),
                          //color: Colors.grey,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          label: song.isNew
                              ? localization.upload
                              : localization.save,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
