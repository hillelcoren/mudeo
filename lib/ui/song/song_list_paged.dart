import 'dart:async';
import 'dart:io';
import 'dart:math';
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
import 'package:mudeo/ui/app/loading_indicator.dart';
import 'package:mudeo/ui/song/paged/cached_view_pager.dart';
import 'package:mudeo/ui/song/paged/page_animation.dart';
import 'package:mudeo/ui/song/paged/song_page.dart';
import 'package:mudeo/ui/song/song_list_paged_vm.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    if (state.dataState.areSongsStale) {
      return LoadingIndicator();
    }

    final allSongIds = memoizedSongIds(
        state.dataState.songMap, state.authState.artist, null, null)
      ..where((id) {
        final song = state.dataState.songMap[id];
        final hasTracks = song.includedTracks.isNotEmpty;
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
        key: ValueKey('__first_song_${allSongIds.first}__'),
        child: Builder(
          builder: (BuildContext context) {
            if (!widget.viewModel.isLoaded) {
              return LoadingIndicator();
            } else {
              return PageViewWithCacheExtent(
                controller: widget.pageController,
                cachedPages: kCountCachedPages,
                childDelegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    ProxyAnimation();
                    return _SongListItem(
                      fade: PageAnimation(
                        index: index,
                        controller: widget.pageController,
                        curve: Curves.easeInCubic,
                      ),
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

class VideoControllerCollection
    extends DelegatingMap<TrackEntity, VideoPlayerController> {
  factory VideoControllerCollection() {
    final controllers = <TrackEntity, VideoPlayerController>{};
    return VideoControllerCollection._(controllers);
  }

  VideoControllerCollection._(this._controllers) : super(_controllers);

  final Map<TrackEntity, VideoPlayerController> _controllers;

  void play({@required bool playFromStart}) {
    for (final track in _controllers.keys) {
      final controller = _controllers[track];
      if (!controller.value.isPlaying) {
        if (playFromStart) {
          controller.pause();
          controller.seekTo(Duration.zero);
          Future.delayed(
              Duration(milliseconds: track.delay), () => controller.play());
        } else {
          controller.play();
        }
      }
    }
  }

  void pause() {
    for (final controller in _controllers.values) {
      if (controller.value.isPlaying) {
        controller.pause();
      }
    }
  }

  bool toggle() {
    if (_controllers.isEmpty) {
      return false;
    }
    final masterIsPlaying = _controllers.values.first.value.isPlaying;
    if (masterIsPlaying) {
      pause();
    } else {
      play(playFromStart: false);
    }
    return !masterIsPlaying;
  }

  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
  }
}

class VideoControllerScope extends InheritedWidget {
  const VideoControllerScope({
    Key key,
    @required this.collection,
    @required Widget child,
  })  : assert(collection != null),
        assert(child != null),
        super(key: key, child: child);

  final VideoControllerCollection collection;

  static VideoControllerCollection of(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<VideoControllerScope>()
        .widget as VideoControllerScope;
    return widget.collection;
  }

  @override
  bool updateShouldNotify(VideoControllerScope old) {
    return collection != old.collection;
  }
}

class _SongListItem extends StatefulWidget {
  const _SongListItem({
    Key key,
    @required this.fade,
    @required this.entity,
  }) : super(key: key);

  final Animation<double> fade;
  final SongEntity entity;

  @override
  _SongListItemState createState() => _SongListItemState();
}

class _SongListItemState extends State<_SongListItem>
    with SingleTickerProviderStateMixin {
  final _controllerCollection = VideoControllerCollection();

  SongEntity get song => widget.entity;

  TrackEntity get firstTrack => song.includedTracks.first;

  TrackEntity get secondTrack =>
      song.includedTracks.length > 1 ? song.includedTracks[1] : null;

  bool _isWaitingToPlay = false;
  bool _isFullScreen = false;
  bool _areVideosSwapped = false;

  static const double PIP_WIDTH = 136;
  double _pipHeight = PIP_WIDTH * 1.33;
  int _countVideosReady = 0;

  @override
  void initState() {
    super.initState();
    print('init ${song.id}: ${song.title}');

    SharedPreferences.getInstance().then((prefs) {
      _isFullScreen = prefs.getBool(kSharedPrefFullScreen) ?? false;
    });
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    SharedPreferences.getInstance().then(
      (prefs) {
        final isFullScreen = prefs.getBool(kSharedPrefFullScreen);
        if (_isFullScreen != isFullScreen) {
          _toggleFullscreen();
        }
      },
    );

    if (info.visibleFraction > 0.5) {
      _playVideos();
    } else {
      _pauseVides();
    }
  }

  void _playVideos() {
    if (_countVideosReady < min(2, song.includedTracks.length)) {
      _isWaitingToPlay = true;
      return;
    } else {
      _isWaitingToPlay = false;
    }

    _controllerCollection.play(playFromStart: true);
  }

  void _pauseVides() {
    _isWaitingToPlay = false;
    _controllerCollection.pause();
  }

  void _togglePlayback() {
    _controllerCollection.toggle();
  }

  void _toggleFullscreen() async {
    final isFullScreen = !_isFullScreen;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(kSharedPrefFullScreen, isFullScreen);
    setState(() => _isFullScreen = isFullScreen);
  }

  void _toggleSwapVideos() {
    setState(() => _areVideosSwapped = !_areVideosSwapped);
  }

  void _caculatePipHeight() {
    final track = _areVideosSwapped ? secondTrack : firstTrack;
    final size = _controllerCollection[track]?.value?.size ?? Size(320, 240);
    setState(() {
      _pipHeight = (size.height / size.width) * PIP_WIDTH;
    });
  }

  @override
  void dispose() {
    print('dispose ${song.id}: ${song.title}');
    _controllerCollection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final bool isMixDown = (song.trackVideoUrl ?? '').isNotEmpty;

    return VideoControllerScope(
      collection: _controllerCollection,
      child: VisibilityDetector(
        key: Key('song-${song.id}-preview'),
        onVisibilityChanged: _onVisibilityChanged,
        child: Material(
          child: Stack(
            children: <Widget>[
              // Large Player
              _TrackVideoPlayer(
                blurHash: song.blurhash,
                track: _areVideosSwapped ? secondTrack : firstTrack,
                videoUrl: (_areVideosSwapped || !isMixDown)
                    ? null
                    : song.trackVideoUrl,
                isFullScreen: _isFullScreen,
                isAudioMuted:
                    _areVideosSwapped && (store.state.isDance || isMixDown),
                onVideoInitialized: () {
                  _caculatePipHeight();
                  _countVideosReady++;
                  if (_isWaitingToPlay) {
                    _playVideos();
                  }
                },
              ),
              // Top Scrim
              SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                      ],
                      stops: [0.0, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment(0.0, -0.7),
                    ),
                  ),
                ),
              ),
              // Small PIP Player
              if (secondTrack != null)
                Positioned(
                  width: PIP_WIDTH,
                  height: _pipHeight,
                  right: 16.0,
                  top: 16.0 + MediaQuery.of(context).viewPadding.top,
                  child: FadeTransition(
                    opacity: widget.fade,
                    child: Material(
                      elevation: 6.0,
                      shape: Border.all(color: Colors.black26, width: 1.0),
                      child: _TrackVideoPlayer(
                        blurHash: song.blurhash,
                        track: _areVideosSwapped ? firstTrack : secondTrack,
                        videoUrl: (_areVideosSwapped && isMixDown)
                            ? song.trackVideoUrl
                            : null,
                        isFullScreen: _isFullScreen,
                        isAudioMuted: !_areVideosSwapped &&
                            (store.state.isDance || isMixDown),
                        onVideoInitialized: () {
                          _countVideosReady++;
                          if (_isWaitingToPlay) {
                            _playVideos();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              // Overlayed Icons and Controls
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: _togglePlayback,
                  onDoubleTap: store.state.artist.likedSong(song.id)
                      ? null
                      : () => store.dispatch(LikeSongRequest(song: song)),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.transparent,
                        ],
                        stops: [0.0, 1.0],
                        begin: Alignment.bottomCenter,
                        end: Alignment(0.0, 0.0),
                      ),
                    ),
                    child: FadeTransition(
                      opacity: widget.fade,
                      child: SongPage(
                        song: song,
                      ),
                    ),
                  ),
                ),
              ),
              // Top Left player controls
              FadeTransition(
                opacity: widget.fade,
                child: Material(
                  type: MaterialType.transparency,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: _toggleFullscreen,
                            icon: Icon(
                              _isFullScreen
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen,
                            ),
                          ),
                          if (secondTrack != null)
                            IconButton(
                              onPressed: _toggleSwapVideos,
                              icon: Icon(
                                Icons.swap_vertical_circle,
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
    @required this.videoUrl,
    @required this.isFullScreen,
    @required this.onVideoInitialized,
    this.isAudioMuted = false,
  }) : super(key: key);

  final String videoUrl;
  final String blurHash;
  final TrackEntity track;
  final bool isFullScreen;
  final bool isAudioMuted;
  final Function onVideoInitialized;

  @override
  _TrackVideoPlayerState createState() => _TrackVideoPlayerState();
}

class _TrackVideoPlayerState extends State<_TrackVideoPlayer> {
  VideoPlayerController _controller;
  Future _future;
  ui.Image _thumbnail;

  VideoEntity get video => widget.track.video;

  VideoControllerCollection get controllers => VideoControllerScope.of(context);

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
    final isMixDown = (widget.videoUrl ?? '').isNotEmpty;
    final path = await VideoEntity.getPath(
      isMixDown
          ? video.rebuild((b) => b
            ..url = widget.videoUrl
            ..timestamp = 1)
          : video,
    );

    if (!await File(path).exists()) {
      // FIXME Warning.. it can take some time to download the video.
      final http.Response copyResponse =
          await http.Client().get(isMixDown ? widget.videoUrl : video.url);
      await File(path).writeAsBytes(copyResponse.bodyBytes);
    }

    double volume = widget.track.volume.toDouble();
    if (widget.isAudioMuted) {
      volume = 0;
    } else if (isMixDown) {
      volume = 100;
    }

    if (mounted) {
      _controller = VideoPlayerController.file(File(path))..setLooping(true);
      _controller.setVolume(volume);
      controllers[widget.track] = _controller;
      await _controller
          .initialize()
          .then((value) => widget.onVideoInitialized());
    }
  }

  @override
  void dispose() {
    // _controller is disposed by [VideoControllerCollection]
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
                return FittedBox(
                  fit: widget.isFullScreen ? BoxFit.cover : BoxFit.fitWidth,
                  child: SizedBox(
                    width: _controller?.value?.size?.width ?? 0,
                    height: _controller?.value?.size?.height ?? 0,
                    child: VideoPlayer(_controller),
                  ),
                );
              }
            } else {
              return LoadingIndicator();
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
