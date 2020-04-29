import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/redux/song/song_selectors.dart';
import 'package:mudeo/ui/song/paged/cached_view_pager.dart';
import 'package:mudeo/ui/song/paged/song_page.dart';
import 'package:mudeo/ui/song/song_list_paged_vm.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SongListPaged extends StatefulWidget {
  const SongListPaged({
    Key key,
    @required this.viewModel,
    @required this.pageController,
  }) : super(key: key);

  final SongListPagedVM viewModel;

  final PageController pageController;

  @override
  _SongListPagedState createState() => _SongListPagedState();
}

class _SongListPagedState extends State<SongListPaged> {
  SongListPagedVM get viewModel => widget.viewModel;

  AppState get state => viewModel.state;

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
                controller: widget.pageController,
                cachedPages: kCountCachedPages,
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

class VideoControllerCache
    extends DelegatingMap<TrackEntity, VideoPlayerController> {
  factory VideoControllerCache() {
    final cache = <TrackEntity, VideoPlayerController>{};
    return VideoControllerCache._(cache);
  }

  VideoControllerCache._(this._cache) : super(_cache);

  final Map<TrackEntity, VideoPlayerController> _cache;

  void dispose() {
    for (final controller in _cache.values) {
      controller.dispose();
    }
  }
}

class VideoControllerScope extends InheritedWidget {
  const VideoControllerScope({
    Key key,
    @required this.cache,
    @required Widget child,
  })  : assert(cache != null),
        assert(child != null),
        super(key: key, child: child);

  final VideoControllerCache cache;

  static VideoControllerCache of(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<VideoControllerScope>()
        .widget as VideoControllerScope;
    return widget.cache;
  }

  @override
  bool updateShouldNotify(VideoControllerScope old) => cache != old.cache;
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
  final _controllerCache = VideoControllerCache();

  SongEntity get song => widget.entity;

  TrackEntity get firstTrack => song.tracks.first;

  TrackEntity get secondTrack => song.tracks.length > 1 ? song.tracks[1] : null;

  bool _isFullScreen = false;
  bool _areVideosSwapped = false;

  @override
  void initState() {
    super.initState();
    print('init ${song.id}: ${song.title}');
  }

  @override
  void dispose() {
    print('dispose ${song.id}: ${song.title}');
    _controllerCache.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);

    return VideoControllerScope(
      cache: _controllerCache,
      child: Material(
        child: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            _TrackVideoPlayer(
              blurHash: song.blurhash,
              track: _areVideosSwapped ? secondTrack : firstTrack,
              isFullScreen: _isFullScreen,
            ),
            if (secondTrack != null)
              Positioned(
                width: 150.0,
                height: 200.0,
                right: 16.0,
                top: 16.0,
                child: _TrackVideoPlayer(
                  blurHash: song.blurhash,
                  track: _areVideosSwapped ? firstTrack : secondTrack,
                  isFullScreen: _isFullScreen,
                ),
              ),
            GestureDetector(
              /*
              onTap: () => _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play(),
               */
              onDoubleTap: store.state.artist.likedSong(song.id)
                  ? null
                  : () => store.dispatch(LikeSongRequest(song: song)),
              child: SongPage(
                song: song,
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        _isFullScreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                      ),
                      onPressed: () {
                        setState(() => _isFullScreen = !_isFullScreen);
                      },
                    ),
                    if (secondTrack != null)
                      IconButton(
                        icon: Icon(
                          Icons.swap_vertical_circle,
                        ),
                        onPressed: () {
                          setState(
                              () => _areVideosSwapped = !_areVideosSwapped);
                        },
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackVideoPlayer extends StatefulWidget {
  const _TrackVideoPlayer({
    Key key,
    @required this.blurHash,
    @required this.track,
    @required this.isFullScreen,
  }) : super(key: key);

  final String blurHash;
  final TrackEntity track;
  final bool isFullScreen;

  @override
  _TrackVideoPlayerState createState() => _TrackVideoPlayerState();
}

class _TrackVideoPlayerState extends State<_TrackVideoPlayer> {
  VideoPlayerController _controller;
  Future _future;
  ui.Image _thumbnail;

  VideoEntity get video => widget.track.video;

  VideoControllerCache get controllers => VideoControllerScope.of(context);

  @override
  void initState() {
    super.initState();
    print('init ${widget.track}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _update();
  }

  @override
  void didUpdateWidget(_TrackVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.track != oldWidget.track) {
      _update();
    }
  }

  void _update() {
    _controller = controllers[widget.track];
    if (_controller == null) {
      _future ??= _initialize();
    } else {
      _future = Future.value(null);
    }
  }

  Future<void> _initialize() async {
    // Fetch thumbnail and precache
    await precacheImage(NetworkImage(video.thumbnailUrl), context);
    if (mounted) {
      setState(() {});
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
      controllers[widget.track] = _controller;
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
    // _controller is disposed by VideoControllerCache
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Image(
            image: NetworkImage(video.thumbnailUrl),
            fit: widget.isFullScreen ? BoxFit.cover : BoxFit.fitWidth,
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
                  child: FittedBox(
                    fit: widget.isFullScreen ? BoxFit.cover : BoxFit.fitWidth,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                );
              }
            } else {
              return Align(
                alignment: Alignment.topLeft,
                child: LinearProgressIndicator(),
              );
            }
          },
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
  Future _future;

  @override
  void initState() {
    super.initState();
    _future = decode();
  }

  @override
  void didUpdateWidget(_BlurHashBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.blurHash != oldWidget.blurHash) {
      setState(() => _future = decode());
    }
  }

  Future<ui.Image> decode() {
    return blurHashDecodeImage(
      blurHash: widget.blurHash,
      width: 128,
      height: 128,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: _future,
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
