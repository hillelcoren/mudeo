import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/ui/app/dialogs/error_dialog.dart';
import 'package:mudeo/utils/ffmpeg.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:video_player/video_player.dart';

class SongRender extends StatefulWidget {
  const SongRender({@required this.song});
  final SongEntity song;

  @override
  _SongRenderState createState() => _SongRenderState();
}

class _SongRenderState extends State<SongRender> {
  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    FfmpegUtils.renderSong(widget.song).then((videoPath) {
      print('## Result: $videoPath');
      setState(() {
        if (videoPath == null) {
          _hasError = true;
        } else {
          _videoPlayerController = VideoPlayerController.network(videoPath);
          _videoPlayerController.initialize().then((_) {
            setState(() {
              _chewieController = ChewieController(
                videoPlayerController: _videoPlayerController,
                aspectRatio: _videoPlayerController.value.aspectRatio,
                autoPlay: true,
                looping: false,
                showControls: true,
              );
            });
          });
        }
      });
    }).catchError((error) {
      showDialog<ErrorDialog>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(error);
          });
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return AlertDialog(
      title: _videoPlayerController == null
          ? Text(localization.creatingVideo)
          : null,
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(localization.close.toUpperCase()))
      ],
      content: _hasError
          ? _ErrorWidget()
          : _videoPlayerController == null
              ? _LoadingWidget()
              : _videoPlayerController.value.hasError
                  ? _ErrorWidget(
                      error: _videoPlayerController.value.errorDescription,
                    )
                  : _chewieController == null
                      ? _LoadingWidget()
                      : FittedBox(
                          fit: BoxFit.contain,
                          child: Chewie(
                            controller: _chewieController,
                          ),
                        ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 25),
          child: Icon(
            Icons.error,
            size: 42,
          ),
        ),
        Text(error ?? localization.failedToRender),
      ],
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: LinearProgressIndicator(),
    );
  }
}
