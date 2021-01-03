import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/data/models/song_model.dart';
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
  bool _hasError;

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
      title: Text(localization.renderingSong),
      content: _hasError
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning,
                  size: 42,
                ),
                SizedBox(height: 16),
                Text(localization.failedToRender),
              ],
            )
          : _chewieController == null
              ? LinearProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Chewie(
                        controller: _chewieController,
                      ),
                    ),
                  ],
                ),
    );
  }
}
