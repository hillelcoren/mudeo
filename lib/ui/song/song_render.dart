import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:built_collection/built_collection.dart';
import 'package:chewie/chewie.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/ui/app/dialogs/error_dialog.dart';
import 'package:mudeo/ui/auth/upgrade_dialog.dart';
import 'package:mudeo/utils/dialogs.dart';
import 'package:mudeo/utils/ffmpeg.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class SongRender extends StatefulWidget {
  const SongRender({required this.song});
  final SongEntity song;

  @override
  _SongRenderState createState() => _SongRenderState();
}

class _SongRenderState extends State<SongRender> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoPlayerController;
  String? _layout = kVideoLayoutRow;
  bool _hasError = false;
  int? _videoTimestamp;

  Future<String?> get videoPath async => await VideoEntity.getPath(
      VideoEntity().rebuild((b) => b..timestamp = _videoTimestamp));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final song = widget.song;
    if (song.layout == kVideoLayoutGrid && song.includedTracks.length != 4) {
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(
          UpdateSong(widget.song.rebuild((b) => b..layout = kVideoLayoutRow)));

      _layout = kVideoLayoutRow;
    } else {
      _layout = song.layout;
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _setLayout(String? value) {
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
    FfmpegUtils.renderSong(store.state.uiState!.song!)
        .then((videoTimestamp) async {
      _videoTimestamp = videoTimestamp;
      final videoPath = await this.videoPath;

      setState(() {
        if (videoPath == null) {
          _hasError = true;
        } else {
          _videoPlayerController = VideoPlayerController.file(File(videoPath));
          _videoPlayerController!.initialize().then((_) {
            setState(() {
              _chewieController = ChewieController(
                videoPlayerController: _videoPlayerController!,
                aspectRatio: _videoPlayerController!.value.aspectRatio,
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
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    final localization = AppLocalization.of(context);
    final song = widget.song;

    return AlertDialog(
      title: _videoPlayerController == null
          ? Text(_videoTimestamp == null
              ? localization!.createVideo!
              : localization!.creatingVideo!)
          : null,
      actions: [
        if (_videoTimestamp != null && _videoTimestamp! > 0)
          TextButton(
              onPressed: () async {
                final path = await videoPath;
                var title = song.title!.trim();
                if (title.isNotEmpty) {
                  title = 'mudeo';
                }
                if (Platform.isAndroid) {
                  final Size size = MediaQuery.of(context).size;
                  Share.shareXFiles(
                    [XFile(path!)],
                    text: song.url,
                    sharePositionOrigin:
                        Rect.fromLTWH(0, 0, size.width, size.height / 2),
                  );
                } else {
                  final Directory directory = (await getDownloadsDirectory())!;
                  final date = DateTime.now()
                      .toIso8601String()
                      .split('.')[0]
                      .replaceFirst('T', ' ')
                      .replaceAll(':', '-');
                  var downloadPath =
                      p.join(directory.path, '${song.displayTitle} $date.mp4');
                  await File(path!).copy(downloadPath);
                  showToast(localization!.downloadedSong);
                }

                /*
                if (state.artist.isPaid) {
                } else {
                  showDialog<UpgradeDialog>(
                      context: context,
                      builder: (BuildContext context) {
                        return UpgradeDialog();
                      });
                }
                */
              },
              child: Text(localization!.download!.toUpperCase())),
        if (_videoTimestamp != null && _videoTimestamp! > 0 && song.canAddTrack)
          TextButton(
              onPressed: () async {
                final store = StoreProvider.of<AppState>(context);
                var video = VideoEntity()
                    .rebuild((b) => b..timestamp = _videoTimestamp);

                late BuiltMap<String, double> volumeData;
                final path = (await video.path)!;
                try {
                  volumeData = await FfmpegUtils.calculateVolumeData(path);
                } catch (error) {
                  // do nothing
                }

                final thumbnailPath = path.replaceFirst('.mp4', '-thumb.jpg');
                await FfmpegUtils.createThumbnail(path, thumbnailPath);

                video = video.rebuild((b) => b
                  ..volumeData.replace(volumeData)
                  ..thumbnailUrl = thumbnailPath);

                final track = TrackEntity(video: video);
                var song = store.state.uiState!.song!;

                song = song.rebuild((b) => b
                  ..updatedAt = DateTime.now().millisecondsSinceEpoch.toString()
                  ..tracks.add(track));

                store.dispatch(UpdateSong(song));

                Navigator.of(context).pop();
              },
              child: Text(localization!.add!.toUpperCase())),
        if (_videoTimestamp != null && _videoTimestamp! > 0)
          TextButton(
              onPressed: () {
                confirmCallback(
                    context: context,
                    callback: () async {
                      final store = StoreProvider.of<AppState>(context);
                      var video = VideoEntity()
                          .rebuild((b) => b..timestamp = _videoTimestamp);

                      late BuiltMap<String, double> volumeData;
                      final path = (await video.path)!;
                      try {
                        volumeData =
                            await FfmpegUtils.calculateVolumeData(path);
                      } catch (error) {
                        // do nothing
                      }

                      final thumbnailPath =
                          path.replaceFirst('.mp4', '-thumb.jpg');
                      await FfmpegUtils.createThumbnail(path, thumbnailPath);

                      video = video.rebuild((b) => b
                        ..volumeData.replace(volumeData)
                        ..thumbnailUrl = thumbnailPath);

                      final track = TrackEntity(video: video);
                      var song = store.state.uiState!.song!;

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
                        ..updatedAt =
                            DateTime.now().millisecondsSinceEpoch.toString()
                        ..tracks.replace([track]));

                      store.dispatch(UpdateSong(song));

                      Navigator.of(context).pop();
                    });
              },
              child: Text(localization!.replace!.toUpperCase())),
        TextButton(
            onPressed: () {
              FFmpegKit.cancel();
              Navigator.of(context).pop();
            },
            child: Text(((_videoTimestamp ?? 0) == 0
                    ? localization!.cancel
                    : localization!.close)!
                .toUpperCase())),
        if (_videoTimestamp == null)
          TextButton(
              onPressed: () => createVideo(),
              child: Text(localization.start!.toUpperCase())),
      ],
      content: _videoTimestamp == null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 12,
                  ),
                  child: Text(
                    localization.layout!,
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
                InkWell(
                  onTap: () => _setLayout(kVideoLayoutRow),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
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
                        Text(localization.row!),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _setLayout(kVideoLayoutColumn),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
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
                        Text(localization.column!),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: song.includedTracks.length == 4
                      ? () => _setLayout(kVideoLayoutGrid)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
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
                          localization.grid!,
                          style: TextStyle(
                              color: song.includedTracks.length == 4
                                  ? Colors.white
                                  : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : _hasError
              ? _ErrorWidget()
              : _videoPlayerController == null
                  ? _LoadingWidget()
                  : _videoPlayerController!.value.hasError
                      ? _ErrorWidget(
                          error: _videoPlayerController!.value.errorDescription,
                        )
                      : ColoredBox(
                          color: Colors.black,
                          child: _chewieController == null
                              ? SizedBox()
                              : SizedBox.expand(
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: SizedBox(
                                      width: _videoPlayerController!
                                          .value.size.width,
                                      height: _videoPlayerController!
                                          .value.size.height,
                                      child: Chewie(
                                        controller: _chewieController!,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({this.error});
  final String? error;

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
        Text(error ?? localization!.failedToRender!),
      ],
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalization.of(context)!.thisMayTakeAFewMinutes!),
        SizedBox(height: 32),
        LinearProgressIndicator(),
      ],
    );
  }
}
