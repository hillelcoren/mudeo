import 'dart:io';
import 'package:built_collection/built_collection.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/ui/app/dialogs/error_dialog.dart';
import 'package:mudeo/utils/dialogs.dart';
import 'package:mudeo/utils/ffmpeg.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:share/share.dart';
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
  String _layout = kVideoLayoutRow;
  bool _hasError = false;
  int _videoTimestamp;

  Future<String> get videoPath async => await VideoEntity.getPath(
      VideoEntity().rebuild((b) => b..timestamp = _videoTimestamp));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _layout = widget.song.layout;
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _setLayout(String value) {
    setState(() {
      _layout = value;
    });

    final store = StoreProvider.of<AppState>(context);
    store.dispatch(UpdateSong(widget.song.rebuild((b) => b..layout = value)));
  }

  void createVideo() {
    setState(() {
      _videoTimestamp = 0;
    });

    final store = StoreProvider.of<AppState>(context);
    FfmpegUtils.renderSong(store.state.uiState.song)
        .then((videoTimestamp) async {
      _videoTimestamp = videoTimestamp;
      final videoPath = await this.videoPath;

      setState(() {
        if (videoPath == null) {
          _hasError = true;
        } else {
          _videoPlayerController = VideoPlayerController.file(File(videoPath));
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
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final song = widget.song;

    return AlertDialog(
      title: _videoPlayerController == null
          ? Text(_videoTimestamp == null
              ? localization.createVideo
              : localization.creatingVideo)
          : null,
      actions: [
        if (_videoTimestamp == null)
          TextButton(
              onPressed: () => createVideo(),
              child: Text(localization.start.toUpperCase())),
        if (_videoTimestamp != null && _videoTimestamp > 0)
          TextButton(
              onPressed: () async => Share.shareFiles([await videoPath]),
              child: Text(localization.download.toUpperCase())),
        if (_videoTimestamp != null && _videoTimestamp > 0)
          TextButton(
              onPressed: () {
                final store = StoreProvider.of<AppState>(context);
                final video = VideoEntity()
                    .rebuild((b) => b..timestamp = _videoTimestamp);
                final track = TrackEntity(video: video);
                var song = store.state.uiState.song;

                /*
                song = song.rebuild((b) => b
                  ..updatedAt = DateTime.now().millisecondsSinceEpoch.toString()
                  ..tracks.replace(BuiltList<TrackEntity>(song.tracks
                      .map((track) =>
                          track.rebuild((b) => b..isIncluded = false))
                      .toList()
                        ..add(track))));
                        */

                song = song.rebuild((b) => b
                  ..updatedAt = DateTime.now().millisecondsSinceEpoch.toString()
                  ..tracks.replace(BuiltList<TrackEntity>([track])));

                store.dispatch(UpdateSong(song));

                Navigator.of(context).pop();
              },
              child: Text(localization.bounce.toUpperCase())),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(localization.close.toUpperCase())),
      ],
      content: _videoTimestamp == null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 22,
                    bottom: 8,
                  ),
                  child: Text(
                    localization.layout,
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
                InkWell(
                  onTap: () => _setLayout(kVideoLayoutRow),
                  child: Row(
                    children: [
                      IgnorePointer(
                        child: Radio(
                          value: kVideoLayoutRow,
                          groupValue: _layout,
                          activeColor: Colors.lightBlueAccent,
                          onChanged: _setLayout,
                        ),
                      ),
                      Text(localization.row),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _setLayout(kVideoLayoutColumn),
                  child: Row(
                    children: [
                      IgnorePointer(
                        child: Radio(
                          value: kVideoLayoutColumn,
                          groupValue: _layout,
                          activeColor: Colors.lightBlueAccent,
                          onChanged: _setLayout,
                        ),
                      ),
                      Text(localization.column),
                    ],
                  ),
                ),
                InkWell(
                  onTap: song.tracks.length == 4
                      ? () => _setLayout(kVideoLayoutGrid)
                      : null,
                  child: Row(
                    children: [
                      IgnorePointer(
                        child: Radio(
                          value: kVideoLayoutGrid,
                          groupValue: _layout,
                          activeColor: Colors.lightBlueAccent,
                          onChanged: _setLayout,
                        ),
                      ),
                      Text(
                        localization.grid,
                        style: TextStyle(
                            color: song.tracks.length == 4
                                ? Colors.white
                                : Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : _hasError
              ? _ErrorWidget()
              : _videoPlayerController == null
                  ? _LoadingWidget()
                  : _videoPlayerController.value.hasError
                      ? _ErrorWidget(
                          error: _videoPlayerController.value.errorDescription,
                        )
                      : _chewieController == null
                          ? SizedBox()
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppLocalization.of(context).thisMayTakeAFewMinutes),
        SizedBox(height: 32),
        LinearProgressIndicator(),
      ],
    );
  }
}
