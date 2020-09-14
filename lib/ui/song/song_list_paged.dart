import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
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
import 'package:mudeo/utils/platforms.dart';
import 'package:mudeo/ui/app/first_interaction.dart';
import 'package:mudeo/ui/app/loading_indicator.dart';
import 'package:mudeo/ui/song/paged/cached_view_pager.dart';
import 'package:mudeo/ui/song/paged/page_animation.dart';
import 'package:mudeo/ui/song/paged/song_page.dart';
import 'package:mudeo/ui/song/song_list_paged_vm.dart';
import 'package:mudeo/ui/song/song_prefs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:mudeo/utils/web_stub.dart'
    if (dart.library.html) 'package:mudeo/utils/web.dart';

class SongListPaged extends StatefulWidget {
  const SongListPaged({
    Key key,
    @required this.viewModel,
    @required this.pageController,
    @required this.isFeatured,
  }) : super(key: key);

  final SongListPagedVM viewModel;
  final bool isFeatured;
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

    final allSongIds = memoizedSongIds(state.dataState.songMap,
        state.authState.artist, widget.isFeatured, null, null)
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
                      isLastSong: index >= allSongIds.length - 1,
                      onNextPressed: () {
                        widget.pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInCubic);
                      },
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
            Duration(milliseconds: track.delay),
            () => controller.play(),
          );
        } else {
          controller.play();
        }
      }
    }
  }

  void pause() {
    for (final controller in _controllers.values) {
      if (controller.value?.isPlaying == true) {
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
    @required this.onNextPressed,
    @required this.isLastSong,
  }) : super(key: key);

  final Animation<double> fade;
  final SongEntity entity;
  final Function onNextPressed;
  final bool isLastSong;

  @override
  _SongListItemState createState() => _SongListItemState();
}

class _SongListItemState extends State<_SongListItem>
    with SingleTickerProviderStateMixin {
  final _controllerCollection = VideoControllerCollection();

  SongEntity get song => widget.entity;

  TrackEntity get firstTrack => song.includedTracks.first;

  TrackEntity get secondTrack =>
      song.includedTracks.length > 1 ? song.includedTracks.last : null;

  bool _hasPlayedVideos = false;
  bool _isWaitingToPlay = false;
  bool _isReadyToPlay = false;
  bool _areVideosSwapped = false;
  int _countVideosReady = 0;

  ValueListenable<bool> _hasInteracted;
  SongPreferences _songPrefs;

  @override
  void initState() {
    super.initState();
    print('init ${song.id}: ${song.title}');
    _hasInteracted = FirstInteractionTracker.of(context);
    _songPrefs = SongPreferencesWidget.of(context);
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.5) {
      if (!kIsWeb || _hasInteracted.value) {
        _playVideos();
      }
    } else {
      _pauseVideos();
    }
  }

  bool get areVideosReady =>
      _countVideosReady == min(2, song.includedTracks.length);

  void _playVideos() {
    if (!areVideosReady) {
      _isWaitingToPlay = true;
      return;
    } else {
      _isWaitingToPlay = false;
    }

    _hasPlayedVideos = true;
    _controllerCollection.play(playFromStart: true);
  }

  void _pauseVideos() {
    _isWaitingToPlay = false;
    _controllerCollection.pause();
  }

  void _togglePlayback() {
    if (_hasPlayedVideos) {
      _controllerCollection.toggle();
    } else {
      _controllerCollection.play(playFromStart: true);
    }

    _hasPlayedVideos = true;
  }

  void _toggleFullscreen() {
    _songPrefs.fullscreen.value = !_songPrefs.fullscreen.value;
  }

  void _toggleMute() {
    _songPrefs.mute.value = !_songPrefs.mute.value;
  }

  void _toggleSwapVideos() {
    setState(() {
      _areVideosSwapped = !_areVideosSwapped;
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
    final state = store.state;
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
              SizedBox.expand(
                child: _TrackVideoPlayer(
                  blurHash: song.blurhash,
                  track: _areVideosSwapped ? secondTrack : firstTrack,
                  videoUrl: (_areVideosSwapped || !isMixDown)
                      ? null
                      : song.trackVideoUrl,
                  isAudioMuted:
                      _areVideosSwapped && (store.state.isDance || isMixDown),
                  onVideoInitialized: () {
                    setState(() {
                      _countVideosReady++;
                    });
                    if (_isWaitingToPlay) {
                      _playVideos();
                    }
                  },
                ),
              ),
              // Top Scrim
              ValueListenableBuilder<bool>(
                valueListenable: _hasInteracted,
                builder: (BuildContext context, bool value, Widget child) {
                  if (value || !kIsWeb) {
                    return SizedBox();
                  }

                  if (!areVideosReady) {
                    return SizedBox();
                  }

                  return Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 100,
                      color: Colors.white.withOpacity(.6),
                    ),
                  );
                },
              ),
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
                  right: 16.0,
                  top: 16.0 + MediaQuery.of(context).viewPadding.top,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 136.0,
                      maxWidth: 136.0,
                    ),
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
                          isAudioMuted: !_areVideosSwapped &&
                              (store.state.isDance || isMixDown),
                          onVideoInitialized: () {
                            setState(() {
                              _countVideosReady++;
                            });
                            if (_isWaitingToPlay) {
                              _playVideos();
                            }
                          },
                        ),
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
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: SongPage(
                              song: song,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    kIsWeb ? 0 : (Platform.isIOS ? 90 : 60)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                if (!isDesktop(context) && kIsWeb)
                                  FlatButton(
                                    child:
                                        Text('Apple App Store'.toUpperCase()),
                                    onPressed: () {
                                      launch(
                                          state.isDance
                                              ? kDanceAppleStoreUrl
                                              : kMudeoAppleStoreUrl,
                                          forceSafariVC: false);
                                    },
                                  ),
                                if (!widget.isLastSong)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 45,
                                        ),
                                        onPressed: widget.onNextPressed,
                                      ),
                                    ),
                                  )
                                else
                                  Expanded(child: SizedBox()),
                                if (!isDesktop(context) && kIsWeb)
                                  FlatButton(
                                    child:
                                        Text('Google Play Store'.toUpperCase()),
                                    onPressed: () {
                                      launch(
                                          state.isDance
                                              ? kDanceGoogleStoreUrl
                                              : kMudeoGoogleStoreUrl,
                                          forceSafariVC: false);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ],
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
                      padding: const EdgeInsets.only(top: 8, bottom: 24.0),
                      child: Row(
                        children: <Widget>[
                          ValueListenableBuilder<bool>(
                            valueListenable: _songPrefs.fullscreen,
                            builder: (BuildContext context, bool isFullscreen,
                                Widget child) {
                              return IconButton(
                                onPressed: _toggleFullscreen,
                                icon: Icon(
                                  isFullscreen
                                      ? Icons.fullscreen_exit
                                      : Icons.fullscreen,
                                ),
                              );
                            },
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: _songPrefs.mute,
                            builder: (BuildContext context, bool isMuted,
                                Widget child) {
                              return IconButton(
                                onPressed: _toggleMute,
                                icon: Icon(
                                  isMuted ? Icons.volume_off : Icons.volume_up,
                                ),
                              );
                            },
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
    @required this.onVideoInitialized,
    this.isAudioMuted = false,
  }) : super(key: key);

  final String videoUrl;
  final String blurHash;
  final TrackEntity track;
  final bool isAudioMuted;
  final Function onVideoInitialized;

  @override
  _TrackVideoPlayerState createState() => _TrackVideoPlayerState();
}

class _TrackVideoPlayerState extends State<_TrackVideoPlayer> {
  VideoPlayerController _controller;
  Future _future;
  Size _thumbnailSize;
  bool _hadError = false;

  SongPreferences _songPrefs;
  double _volume;

  VideoEntity get video => widget.track.video;

  VideoControllerCollection get controllers => VideoControllerScope.of(context);

  String get videoUrl {
    final isMixDown = (widget.videoUrl ?? '').isNotEmpty;
    return isMixDown ? widget.videoUrl : video.url;
  }

  @override
  void initState() {
    super.initState();
    _songPrefs = SongPreferencesWidget.of(context);
    _songPrefs.mute.addListener(_onMuteChanged);
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

  void _onMuteChanged() {
    if (_songPrefs.mute.value) {
      _controller.setVolume(0.0);
    } else {
      _controller.setVolume(_volume);
    }
  }

  void _update() {
    _controller?.removeListener(_onValueChanged);
    _controller = controllers[widget.track];
    if (_controller == null) {
      _future ??= _initialize();
    } else {
      _controller.addListener(_onValueChanged);
      _future = Future.value(null);
    }
  }

  void _onValueChanged() {
    final hasError = _controller.value.hasError;
    if (hasError != _hadError) {
      setState(() => _hadError = hasError);
    }
  }

  Future<void> _initialize() async {
    final client = http.Client();

    // Fetch thumbnail and precache
    await precacheImage(NetworkImage(video.thumbnailUrl), context);

    try {
      final http.Response thumbnailResponse =
          await client.get(video.thumbnailUrl + '?clear_cache=0');
      ui.Image thumbnail =
          await decodeImageFromList(thumbnailResponse.bodyBytes);
      if (mounted) {
        setState(() {
          _thumbnailSize = Size(
            thumbnail.width.toDouble(),
            thumbnail.height.toDouble(),
          );
        });
      }
    } catch (e) {
      _thumbnailSize = Size(720, 1280);
    }

    // fetch video
    final isMixDown = (widget.videoUrl ?? '').isNotEmpty;
    final videoUrl = isMixDown ? widget.videoUrl : video.url;

    String path = '';

    if (!kIsWeb) {
      path = await VideoEntity.getPath(
        isMixDown
            ? video.rebuild((b) => b
              ..url = videoUrl
              ..timestamp = 1)
            : video,
      );

      if (!await File(path).exists()) {
        // FIXME Warning.. it can take some time to download the video.
        final http.Response copyResponse =
            await client.get(isMixDown ? widget.videoUrl : video.url);
        await File(path).writeAsBytes(copyResponse.bodyBytes);
      }
    }

    _volume = widget.track.volume.toDouble();
    if (widget.isAudioMuted) {
      _volume = 0.0;
    } else if (isMixDown) {
      _volume = 1.0;
    }

    if (mounted) {
      if (kIsWeb) {
        _controller = VideoPlayerController.network(videoUrl);
      } else {
        _controller = VideoPlayerController.file(File(path));
      }
      controllers[widget.track] = _controller;
      await _controller.initialize().then((value) {
        _controller.setLooping(true);
        _controller.setVolume(_volume);
        widget.onVideoInitialized();
        setState(() {});
      }).catchError((e, st) {
        print('VIDEO ERROR: $e\n$st');
      });
      if (mounted) {
        _controller.addListener(_onValueChanged);
      }
    }
  }

  @override
  void dispose() {
    // _controller is disposed by [VideoControllerCollection]
    _songPrefs.mute.removeListener(_onMuteChanged);
    _controller?.removeListener(_onValueChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Widget child = ValueListenableBuilder<bool>(
            valueListenable: SongPreferencesWidget.of(context).fullscreen,
            builder: (BuildContext context, bool isFullScreen, Widget child) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  if (!kIsWeb && (widget.blurHash?.length ?? 0) != 0)
                    _BlurHashBackground(
                      blurHash: widget.blurHash,
                    )
                  else
                    ColoredBox(color: Colors.black),
                  if (video.thumbnailUrl != null)
                    Image(
                      image: NetworkImage(video.thumbnailUrl),
                      fit: isFullScreen ? BoxFit.cover : BoxFit.fitWidth,
                    ),
                  FutureBuilder(
                    future: _future,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return ErrorWidget(snapshot.error);
                        } else {
                          return FittedBox(
                            fit: isFullScreen ? BoxFit.cover : BoxFit.fitWidth,
                            child: SizedBox(
                              width: _controller?.value?.size?.width ?? 0,
                              height: _controller?.value?.size?.height ?? 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: VideoPlayer(_controller),
                                /*
                                child: kIsWeb && false
                                    ? WebVideoPlayer(
                                        src: videoUrl,
                                        showControls: false,
                                        autoplay: true,
                                        width:
                                            _controller?.value?.size?.width ??
                                                0,
                                        height:
                                            _controller?.value?.size?.height ??
                                                0,
                                      )
                                    : VideoPlayer(_controller),
                                    
                                 */
                              ),
                            ),
                          );
                        }
                      } else {
                        return LoadingIndicator();
                      }
                    },
                  ),
                  if (_controller != null && _controller.value.hasError)
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'ERROR: ${_controller.value.errorDescription}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                ],
              );
            });
        if (!constraints.isTight) {
          child = AspectRatio(
            aspectRatio: _thumbnailSize?.aspectRatio ?? 1.33,
            child: child,
          );
        }
        return child;
      },
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
