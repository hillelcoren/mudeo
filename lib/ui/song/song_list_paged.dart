import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/redux/song/song_selectors.dart';
import 'package:mudeo/ui/song/paged/cached_view_pager.dart';
import 'package:mudeo/ui/song/song_list_vm.dart';
import 'package:mudeo/ui/song/paged/song_details.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SongListPaged extends StatefulWidget {
  const SongListPaged({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final SongListVM viewModel;

  @override
  _SongListPagedState createState() => _SongListPagedState();
}

class _SongListPagedState extends State<SongListPaged> {
  PageController _pageController;

  SongListVM get viewModel => widget.viewModel;

  AppState get state => viewModel.state;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allSongIds = memoizedSongIds(
        state.dataState.songMap, state.authState.artist, null, null)
      ..where((id) {
        final song = state.dataState.songMap[id];
        final hasTracks = song.tracks.isNotEmpty;
        if (!hasTracks) {
          print('Song missing tracks: ${song.id}');
        }
        return hasTracks;
      });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Material(
        child: Builder(
          builder: (BuildContext context) {
            if (!widget.viewModel.isLoaded) {
              return LinearProgressIndicator();
            } else {
              return PageViewWithCacheExtent(
                controller: _pageController,
                cachedPages: 6,
                childDelegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _SongListItem(
                      entity: state.dataState.songMap[allSongIds[index]],
                    );
                  },
                  childCount: allSongIds.length,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class _SongListItem extends StatefulWidget {
  const _SongListItem({
    Key key,
    @required this.entity,
  }) : super(key: key);

  final SongEntity entity;

  @override
  _SongListItemState createState() => _SongListItemState();
}

class _SongListItemState extends State<_SongListItem> {
  SongEntity get song => widget.entity;

  TrackEntity get firstTrack => song.tracks.first;

  @override
  void initState() {
    super.initState();
    print('init ${song.id}: ${song.title}');
  }

  @override
  void dispose() {
    print('dispose ${song.id}: ${song.title}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: _TrackVideoPlayer(
        blurHash: song.blurhash,
        track: firstTrack,
        song: song,
      ),
    );
  }
}

class _TrackVideoPlayer extends StatefulWidget {
  const _TrackVideoPlayer({
    Key key,
    @required this.blurHash,
    @required this.track,
    @required this.song,
  }) : super(key: key);

  final SongEntity song;
  final String blurHash;
  final TrackEntity track;

  @override
  _TrackVideoPlayerState createState() => _TrackVideoPlayerState();
}

class _TrackVideoPlayerState extends State<_TrackVideoPlayer> {
  VideoPlayerController _controller;
  Future _future;
  ui.Image _thumbnail;
  Size _thumbnailSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _initialize();
  }

  Future<void> _initialize() async {
    final video = widget.track.video;

    // Fetch thumbnail and precache
    final thumbnail = NetworkImage(video.thumbnailUrl);
    await precacheImage(thumbnail, context);
    final imageStream = PaintingBinding.instance.imageCache.putIfAbsent(
        thumbnail, () => throw UnimplementedError(),
        onError: (e, st) {});
    final completer = Completer<ImageInfo>();
    final listener = ImageStreamListener(
      (ImageInfo image, bool synchronousCall) {
        completer.complete(image);
      },
      onError: completer.completeError,
    );
    imageStream.addListener(listener);
    final result = await completer.future;
    imageStream.removeListener(listener);

    //_thumbnailImage = image.decodeJpg(result.image.);
    //final http.Response copyResponse = await http.Client().get(video.url);
    //  await File(path).writeAsBytes(copyResponse.bodyBytes);
    if (mounted) {
      setState(() {
        _thumbnail = result.image;
        _thumbnailSize = Size(
          result.image.width.toDouble(),
          result.image.height.toDouble(),
        );
      });
    }

    // fetch video
    final path = await VideoEntity.getPath(video);
    if (!await File(path).exists()) {
      // FIXME Warning.. it can take some time to download the video.
      final http.Response copyResponse = await http.Client().get(video.url);
      await File(path).writeAsBytes(copyResponse.bodyBytes);
    }

    if (mounted) {
      _controller = VideoPlayerController.file(File(path))..setLooping(true);
      await _controller.initialize();
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.5) {
      if (!_controller.value.isPlaying) {
        _controller.play();
      }
    } else {
      if (_controller.value.isPlaying) {
        _controller.pause();
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        if ((widget.blurHash?.length ?? 0) != 0)
          _BlurHashBackground(
            blurHash: widget.blurHash,
          )
        else
          ColoredBox(color: Colors.black),
        if (_thumbnail != null)
          RawImage(
            image: _thumbnail,
            fit: BoxFit.fitWidth,
          ),
        FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ErrorWidget(snapshot.error);
              } else {
                return VisibilityDetector(
                  key: Key('track-${widget.track.id}-preview'),
                  onVisibilityChanged: _onVisibilityChanged,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: _thumbnailSize.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                );
              }
            } else {
              return Column(
                children: <Widget>[
                  LinearProgressIndicator(),
                ],
              );
            }
          },
        ),
        GestureDetector(
          onTap: () => _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play(),
          onDoubleTap: store.state.artist.likedSong(widget.song.id)
              ? null
              : () => store.dispatch(LikeSongRequest(song: widget.song)),
          child: SongDetails(
            song: widget.song,
          ),
        ),
      ],
    );
  }
}

class _BlurHashBackground extends StatefulWidget {
  const _BlurHashBackground({
    Key key,
    @required this.blurHash,
  }) : super(key: key);

  final String blurHash;

  @override
  _BlurHashBackgroundState createState() => _BlurHashBackgroundState();
}

class _BlurHashBackgroundState extends State<_BlurHashBackground> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: blurHashDecodeImage(
        blurHash: widget.blurHash,
        width: 128,
        height: 128,
      ),
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox();
        }
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error);
        } else {
          return RawImage(
            image: snapshot.data,
            fit: BoxFit.cover,
          );
        }
      },
    );
  }
}
