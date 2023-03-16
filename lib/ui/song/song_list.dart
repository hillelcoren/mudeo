import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/main_common.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/artist/artist_actions.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/redux/song/song_selectors.dart';
import 'package:mudeo/ui/app/form_card.dart';
import 'package:mudeo/ui/app/loading_indicator.dart';
import 'package:mudeo/ui/artist/artist_profile.dart';
import 'package:mudeo/ui/song/song_list_vm.dart';
import 'package:mudeo/ui/song/song_share.dart';
import 'package:mudeo/utils/dialogs.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:chewie/chewie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

//import 'package:mudeo/utils/web_stub.dart'
//    if (dart.library.html) 'package:mudeo/utils/web.dart';

class SongList extends StatefulWidget {
  const SongList({
    Key key,
    @required this.viewModel,
    @required this.scrollController,
  }) : super(key: key);

  final SongListVM viewModel;
  final ScrollController scrollController;

  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.viewModel.isLoaded) {
      return LoadingIndicator();
    }

    final localization = AppLocalization.of(context);
    final state = widget.viewModel.state;

    final allSongIds = memoizedSongIds(
        state.dataState.songMap, state.authState.artist, null, null, null);
    final featureSongIds = memoizedSongIds(state.dataState.songMap,
        state.authState.artist, null, null, kSongFilterFeatured);
    final newestSongIds = memoizedSongIds(state.dataState.songMap,
        state.authState.artist, null, null, kSongFilterNewest);

    return Scaffold(
      appBar: state.isDance
          ? null
          : AppBar(
              title: null,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(0), // here the desired height
                child: TabBar(
                  controller: _controller,
                  tabs: <Widget>[
                    Tab(
                      text: localization.featured,
                    ),
                    Tab(
                      text: localization.newest,
                    ),
                  ],
                ),
              ),
            ),
      body: state.isDance
          ? RefreshIndicator(
              onRefresh: () => widget.viewModel.onRefreshed(context),
              child: DraggableScrollbar.arrows(
                controller: widget.scrollController,
                alwaysVisibleScrollThumb: true,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 130),
                  shrinkWrap: true,
                  controller: widget.scrollController,
                  itemCount: allSongIds.length,
                  itemBuilder: (BuildContext context, index) {
                    final data = widget.viewModel.state.dataState;
                    final songId = allSongIds[index];
                    final song = data.songMap[songId];
                    return SongItem(
                      song: song,
                      enableShowArtist: !kIsWeb,
                    );
                  },
                ),
              ),
            )
          : TabBarView(
              controller: _controller,
              children: <Widget>[
                RefreshIndicator(
                  onRefresh: () => widget.viewModel.onRefreshed(context),
                  child: DraggableScrollbar.arrows(
                    controller: widget.scrollController,
                    alwaysVisibleScrollThumb: true,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 130),
                      shrinkWrap: true,
                      controller: widget.scrollController,
                      itemCount: featureSongIds.length,
                      itemBuilder: (BuildContext context, index) {
                        final data = widget.viewModel.state.dataState;
                        final songId = featureSongIds[index];
                        final song = data.songMap[songId];
                        return SongItem(
                          song: song,
                          enableShowArtist: !kIsWeb,
                        );
                      },
                    ),
                  ),
                ),
                RefreshIndicator(
                  onRefresh: () => widget.viewModel.onRefreshed(context),
                  child: DraggableScrollbar.arrows(
                    controller: widget.scrollController,
                    alwaysVisibleScrollThumb: true,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 130),
                      shrinkWrap: true,
                      controller: widget.scrollController,
                      itemCount: newestSongIds.length,
                      itemBuilder: (BuildContext context, index) {
                        final data = widget.viewModel.state.dataState;
                        final songId = newestSongIds[index];
                        final song = data.songMap[songId];
                        return SongItem(
                          song: song,
                          enableShowArtist: !kIsWeb,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class SongItem extends StatefulWidget {
  SongItem({
    this.song,
    this.enableShowArtist = true,
  });

  final SongEntity song;
  final bool enableShowArtist;

  @override
  _SongItemState createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {
  void onMessageTap() {
    showDialog<SongComments>(
        context: context,
        builder: (BuildContext context) {
          return SongComments(
            songId: widget.song.id,
            onClosePressed: () {
              Navigator.of(context).pop();
            },
          );
        });

    Scrollable.ensureVisible(context,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final song = widget.song;
    final tracks = song.tracks;
    final lastTrack = tracks.isNotEmpty ? tracks.last : null;
    final lastVideo = lastTrack?.video ?? VideoEntity();
    final gradientColor = Colors.black12.withOpacity(.75);

    return GestureDetector(
      onTap: () {
        showDialog<VideoPlayer>(
            context: context,
            builder: (BuildContext context) {
              return VideoPlayer(
                  '${song.videoUrl}?updated_at=${song.updatedAt}');
            });
        /*
              if ((song.youTubeId ?? '').isEmpty) {
                showDialog<VideoPlayer>(
                    context: context,
                    builder: (BuildContext context) {
                      return VideoPlayer(
                          '${song.videoUrl}?updated_at=${song.updatedAt}');
                    });
              } else {
                if (kIsWeb) {
                  registerWebView(song.youTubeEmbedUrl);
                  showDialog<Scaffold>(
                      context: context,
                      builder: (BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(
                            title: Text('mudeo'),
                            leading: IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          body: HtmlElementView(viewType: song.youTubeEmbedUrl),
                        );
                      });
                } else {
                  FlutterYoutube.playYoutubeVideoById(
                    apiKey: Config.YOU_TUBE_API_KEY,
                    videoId: song.youTubeId,
                    autoPlay: true,
                    fullScreen: true,
                    appBarColor: Colors.black12,
                    backgroundColor: Colors.black,
                  );
                }
              }
               */
      },
      child: Container(
        color: Colors.black,
        height: kSongHeight,
        child: Stack(children: <Widget>[
          !song.hasThumbnail && lastVideo.isRemoteVideo
              ? Center(
                  child: Text(
                    localization.backingTrack,
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                )
              : (song.isRendered && song.hasThumbnail) || lastVideo.hasThumbnail
                  ? SongImage(song: song)
                  : SizedBox(),
          Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [gradientColor, Colors.transparent],
                      stops: [0, 1],
                      begin: Alignment(0, -1),
                      end: Alignment(0, 1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SongHeader(
                      song: widget.song,
                      enableShowArtist: widget.enableShowArtist,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        gradientColor,
                        Colors.transparent,
                      ],
                      stops: [0, 1],
                      begin: Alignment(0, 1),
                      end: Alignment(0, -1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SongFooter(widget.song, onMessageTap),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class SongFooter extends StatelessWidget {
  SongFooter(this.song, this.onMessagePressed);

  final SongEntity song;
  final Function onMessagePressed;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final artist = state.authState.artist;
    final likedSong = artist.likedSong(song.id);

    _editSong({SongEntity song, BuildContext context}) {
      // TODO remove this workaround for selecting selected song in list view
      if (state.uiState.song.id == song.id) {
        store.dispatch(EditSong(song: SongEntity(), context: context));
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => store.dispatch(EditSong(song: song, context: context)));
      } else {
        store.dispatch(EditSong(song: song, context: context));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.videocam),
            tooltip: localization.cloneSong,
            onPressed: () {
              if (!state.authState.hasValidToken) {
                showDialog<AlertDialog>(
                    context: context,
                    builder: (BuildContext context) {
                      final localization = AppLocalization.of(context);
                      return AlertDialog(
                        content: Text(kIsWeb
                            ? localization.requireMobileToCollaborate
                            : localization.requireAccountToCollaborate),
                      );
                    });
                return;
              }

              final uiSong = state.uiState.song;
              SongEntity newSong = song;

              if (!artist.belongsToSong(song)) {
                newSong = song.fork;
              }
              if (state.isDance && !state.artist.belongsToSong(newSong)) {
                newSong = newSong.justKeepFirstTrack;
              }

              if (uiSong.hasNewVideos && uiSong.id != newSong.id) {
                showDialog<AlertDialog>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    semanticLabel: localization.areYouSure,
                    title: Text(localization.loseChanges),
                    content: Text(localization.areYouSure),
                    actions: <Widget>[
                      new TextButton(
                          child: Text(localization.cancel.toUpperCase()),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      new TextButton(
                          child: Text(localization.ok.toUpperCase()),
                          onPressed: () {
                            Navigator.pop(context);
                            _editSong(song: newSong, context: context);
                          })
                    ],
                  ),
                );
              } else {
                _editSong(song: newSong, context: context);
              }
            },
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                  child: state.isSaving || artist.likedSong(song.id)
                      ? Icon(
                    Icons.favorite,
                    key: const ValueKey('favorite'),
                    color: Colors.red,
                  )
                      : Icon(
                    Icons.favorite,
                    key: const ValueKey('favorite_red'),
                    color: artist.likedSong(song.id) ? Colors.red : null,
                  ),
                ),
                tooltip: localization.like,
                onPressed: () {
                  if (state.isSaving) {
                    return;
                  }
                  if (!state.authState.hasValidToken) {
                    showDialog<AlertDialog>(
                        context: context,
                        builder: (BuildContext context) {
                          final localization = AppLocalization.of(context);
                          return AlertDialog(
                            content: Text(kIsWeb
                                ? localization.requireMobileToLike
                                : localization.requireAccountToLike),
                          );
                        });
                    return;
                  }

                  store.dispatch(LikeSongRequest(song: song));
                },
              ),
              Text('${song.countLike + 1}'),
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.message),
                tooltip: localization.comments,
                onPressed: onMessagePressed,
              ),
              song.comments.length > 0
                  ? Text('${song.comments.length}')
                  : SizedBox(),
            ],
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: 30),
            itemBuilder: (BuildContext context) {
              final actions = [
                if (!kIsWeb)
                  ((song.sharingKey ?? '').isNotEmpty
                      ? localization.addFriends
                      : state.isDance
                          ? localization.shareDance
                          : localization.shareSong),
                if (!kIsWeb) localization.download,
                if (song.isPublic) ...[
                  if (kIsWeb)
                    localization.openInNewTab
                  else
                    localization.copyLinkToSong
                ],
                if ((song.twitterId ?? '').isNotEmpty)
                  localization.viewOnTwitter,
                if ((song.youTubeId ?? '').isNotEmpty)
                  localization.viewOnYouTube,
                if (song.parentId > 0) localization.viewOriginal,
                if (song.artistId == state.authState.artist.id)
                  state.isDance
                      ? localization.deleteDance
                      : localization.deleteSong
                else if (song.joinedArtists != null &&
                    song.joinedArtists.any(
                        (artist) => artist.id == state.authState.artist.id))
                  state.isDance
                      ? localization.leaveDance
                      : localization.leaveSong,
                if (!kIsWeb && song.artistId != state.artist.id)
                  localization.reportSong,
              ];
              return actions
                  .map((action) => PopupMenuItem(
                        child: Text(action),
                        value: action,
                      ))
                  .toList();
            },
            onSelected: (String action) async {
              if (action == localization.openInBrowser ||
                  action == localization.openInNewTab) {
                launch(song.url);
                return;
              } else if (action == localization.viewOnTwitter) {
                launch(song.twitterUrl(state.twitterHandle));
                return;
              } else if (action == localization.viewOnYouTube) {
                launch(song.youTubeUrl);
                return;
              } else if (action == localization.download) {
                final Directory directory =
                    await getApplicationDocumentsDirectory();
                final String folder = '${directory.path}/videos';
                await Directory(folder).create(recursive: true);
                final path = '$folder/${song.title}.mp4';
                if (!await File(path).exists()) {
                  final http.Response copyResponse =
                      await http.Client().get(song.videoUrl);
                  await File(path).writeAsBytes(copyResponse.bodyBytes);
                }

                await FileSaver.instance.saveFile(
                    '${song.title} ${DateTime.now().toIso8601String().split('.')[0].replaceFirst('T', ' ')}',
                    File(path).readAsBytesSync(),
                    'mp4',
                    mimeType: MimeType.MPEG);

                showToast(localization.downloadedSong);

                return;
              } else if (action == localization.copyLinkToSong ||
                  action == localization.copyLinkToDance) {
                Clipboard.setData(new ClipboardData(text: song.url));
                showToast(localization.copiedToClipboard);
                return;
              } else if (action == localization.copyLinkToVideo) {
                Clipboard.setData(new ClipboardData(text: song.videoUrl));
                showToast(localization.copiedToClipboard);
                return;
              } else if (action == localization.viewOriginal) {
                final originalSong = state.dataState.songMap[song.parentId] ??
                    SongEntity(id: song.parentId);
                final originalArtist =
                    state.dataState.artistMap[originalSong.artistId] ??
                        ArtistEntity(id: originalSong.artistId);
                store.dispatch(
                    ViewArtist(context: context, artist: originalArtist));
                return;
              } else if (action == localization.shareSong ||
                  action == localization.shareDance ||
                  action == localization.addFriends) {
                showDialog<SongShareDialog>(
                    context: context,
                    builder: (BuildContext context) {
                      return SongShareDialog(song: song);
                    });
                return;
              } else if (action == localization.leaveDance ||
                  action == localization.leaveSong) {
                confirmCallback(
                    message: state.isDance
                        ? localization.leaveDance
                        : localization.leaveSong,
                    context: context,
                    callback: () {
                      final Completer<Null> completer = Completer<Null>();
                      completer.future.then((value) {
                        store
                            .dispatch(LoadSongs(clearCache: true, force: true));
                      });
                      store.dispatch(LeaveSongRequest(
                        songId: song.id,
                        completer: completer,
                      ));
                    });
                return;
              } else if (action == localization.deleteSong ||
                  action == localization.deleteDance) {
                showDialog<AlertDialog>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        semanticLabel: localization.areYouSure,
                        title: Text(localization.deleteSong),
                        content: Text(localization.areYouSure),
                        actions: <Widget>[
                          TextButton(
                              child: Text(localization.cancel.toUpperCase()),
                              onPressed: () => Navigator.pop(context)),
                          TextButton(
                              child: Text(localization.ok.toUpperCase()),
                              onPressed: () {
                                Navigator.pop(context);
                                store.dispatch(DeleteSongRequest(
                                  song: song,
                                  completer: Completer<Null>(),
                                ));
                              })
                        ],
                      );
                    });
                return;
              }

              if (!state.authState.hasValidToken) {
                showDialog<AlertDialog>(
                    context: context,
                    builder: (BuildContext context) {
                      final localization = AppLocalization.of(context);
                      return AlertDialog(
                        content: Text(kIsWeb
                            ? localization.requireMobileToReport
                            : localization.requireAccountToReport),
                      );
                    });
                return;
              }

              showDialog<AlertDialog>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      semanticLabel: localization.areYouSure,
                      title: Text(state.isDance
                          ? localization.reportDance
                          : localization.reportSong),
                      content: Text(localization.areYouSure),
                      actions: <Widget>[
                        TextButton(
                            child: Text(localization.cancel.toUpperCase()),
                            onPressed: () => Navigator.pop(context)),
                        TextButton(
                            child: Text(localization.ok.toUpperCase()),
                            onPressed: () {
                              store.dispatch(FlagSongRequest(song: song));
                              Navigator.pop(context);
                            })
                      ],
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}

class SongHeader extends StatelessWidget {
  SongHeader({@required this.song, @required this.enableShowArtist});

  final SongEntity song;
  final bool enableShowArtist;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final localization = AppLocalization.of(context);
    final artist = song.artist ?? ArtistEntity();
    final ThemeData themeData = Theme.of(context);
    final TextStyle artistStyle = themeData.textTheme.bodyText1
        .copyWith(color: themeData.accentColor, fontSize: 16);
    final TextStyle genreStyle =
        artistStyle.copyWith(color: kGenreColors[song.genreId]);
    final TextStyle dotStyle = artistStyle.copyWith(color: Colors.white);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ArtistProfile(
            artist: song.artist,
            onTap: () => enableShowArtist
                ? store.dispatch(ViewArtist(context: context, artist: artist))
                : null,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  song.title,
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => enableShowArtist
                              ? store.dispatch(
                                  ViewArtist(context: context, artist: artist))
                              : null,
                        style: artistStyle,
                        text: '@${artist.handle}',
                      ),
                      song.genreId == null || song.genreId == 0
                          ? TextSpan()
                          : TextSpan(text: ' • ', style: dotStyle),
                      song.genreId == null || song.genreId == 0
                          ? TextSpan()
                          : TextSpan(
                              text: localization.lookup(store.state.isDance
                                  ? kStyles[song.genreId]
                                  : kGenres[song.genreId]),
                              style: genreStyle,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          /*
          IconButton(
            padding: EdgeInsets.only(top: 0),
            icon: Icon(Icons.play_circle_filled, size: 50),
            tooltip: localization.play,
            onPressed: () {
              showDialog<VideoPlayer>(
                  context: context,
                  builder: (BuildContext context) {
                    return VideoPlayer(song.videoUrl);
                  });
            },
          ),
           */
        ],
      ),
    );
  }
}

class VideoPlayer extends StatefulWidget {
  VideoPlayer(this.videoUrl);

  final String videoUrl;

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  void initVideo() async {
    videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    videoPlayerController.initialize().then((_) {
      setState(() {
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          aspectRatio: videoPlayerController.value.aspectRatio,
          autoPlay: true,
          looping: false,
          showControls: true,
        );
      });
    });
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (chewieController == null) {
      return LoadingIndicator();
    }

    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.contain,
            child: Chewie(
              controller: chewieController,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class CommentRow extends StatefulWidget {
  CommentRow({Key key, this.comment, this.song}) : super(key: key);

  final SongEntity song;
  final CommentEntity comment;

  @override
  _CommentRowState createState() => _CommentRowState();
}

class _CommentRowState extends State<CommentRow> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final authArtistId = state.authState.artist.id;
    final localization = AppLocalization.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() => isSelected = !isSelected);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          style: TextStyle(color: Colors.grey, fontSize: 17),
                          text: widget.comment.artist.displayName),
                      TextSpan(
                        style: TextStyle(fontSize: 17, color: Colors.white),
                        text: '   ${widget.comment.description}',
                      ),
                    ],
                  ),
                ),
              ),
              if (isSelected && !state.isSaving) SizedBox(width: 10),
              if (isSelected && !state.isSaving)
                if (widget.comment.artistId == authArtistId ||
                    widget.song.artistId == authArtistId)
                  ElevatedButton(
                    //color: Colors.redAccent,
                    child:
                        Text(AppLocalization.of(context).delete.toUpperCase()),
                    onPressed: () {
                      showDialog<AlertDialog>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              semanticLabel: localization.areYouSure,
                              title: Text(localization.deleteComment),
                              content: Text(localization.areYouSure),
                              actions: <Widget>[
                                TextButton(
                                    child:
                                        Text(localization.cancel.toUpperCase()),
                                    onPressed: () => Navigator.pop(context)),
                                TextButton(
                                    child: Text(localization.ok.toUpperCase()),
                                    onPressed: () {
                                      final completer = Completer<Null>()
                                        ..future.then((value) {
                                          if (Navigator.of(context).canPop()) {
                                            Navigator.of(context).pop();
                                          }
                                        });
                                      store.dispatch(DeleteCommentRequest(
                                          comment: widget.comment,
                                          completer: completer));
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.of(context).pop();
                                      }
                                    })
                              ],
                            );
                          });
                    },
                  )
                else
                  ElevatedButton(
                    //color: Colors.redAccent,
                    child:
                        Text(AppLocalization.of(context).report.toUpperCase()),
                    onPressed: () {
                      showDialog<AlertDialog>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              semanticLabel: localization.areYouSure,
                              title: Text(localization.report),
                              content: Text(localization.areYouSure),
                              actions: <Widget>[
                                TextButton(
                                    child:
                                        Text(localization.cancel.toUpperCase()),
                                    onPressed: () => Navigator.pop(context)),
                                TextButton(
                                    child: Text(localization.ok.toUpperCase()),
                                    onPressed: () {
                                      final completer = Completer<Null>()
                                        ..future.then((value) {
                                          showToast(
                                              localization.reportedComment);
                                          if (Navigator.of(context).canPop()) {
                                            Navigator.of(context).pop();
                                          }
                                        });
                                      store.dispatch(FlagSongRequest(
                                          song: widget.song,
                                          commentId: widget.comment.id,
                                          completer: completer));
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.of(context).pop();
                                      }
                                    })
                              ],
                            );
                          });
                    },
                  )
            ],
          ),
        ),
      ),
    );
  }
}

class SongImage extends StatelessWidget {
  const SongImage({
    @required this.song,
  });

  final SongEntity song;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      song.imageUrl,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        if (!kIsWeb && (song.blurhash ?? '').isNotEmpty)
          return Container(
            height: double.infinity,
            width: double.infinity,
            child: BlurHash(hash: song.blurhash),
          );
        else
          return Container();
      },
    );

    /*
    double aspectRation = 1;
    if (song.width > 0 && song.height > 0) {
      aspectRation = (song.width / song.height);
      if (song.width > song.height) {
        aspectRation *= 1.2;
      } else {
        aspectRation *= .8;
      }
    }

    return Stack(
      children: <Widget>[
        if (kIsWeb)
          Container(
            height: double.infinity,
            width: double.infinity,
            color: convertHexStringToColor(song.color),
          )
        else if ((song.blurhash ?? '').isNotEmpty)
          Container(
            height: double.infinity,
            width: double.infinity,
            child: BlurHash(hash: song.blurhash),
          ),
        Center(
          child: AspectRatio(
            aspectRatio: aspectRation,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: song.width > song.height
                    ? BoxFit.fitWidth
                    : BoxFit.fitHeight,
                alignment: Alignment.center,
                image: NetworkImage(song.imageUrl),
              )),
            ),
          ),
        ),
      ],
    );
     */
  }
}

class SongComments extends StatefulWidget {
  const SongComments({
    @required this.songId,
    @required this.onClosePressed,
  });

  final Function onClosePressed;
  final int songId;

  @override
  _SongCommentsState createState() => _SongCommentsState();
}

class _SongCommentsState extends State<SongComments> {
  TextEditingController _textController;
  FocusNode _textFocusNode;
  bool _showSubmitButton = false;
  bool _enableSubmitButton = false;

  @override
  void initState() {
    super.initState();
    _textFocusNode = FocusNode();
    _textFocusNode.addListener(() {
      if (_showSubmitButton != _textFocusNode.hasFocus) {
        setState(() => _showSubmitButton = _textFocusNode.hasFocus);
      }
    });

    _textController = TextEditingController();
    _textController.addListener(() {
      if (_enableSubmitButton != _textController.text.isNotEmpty) {
        setState(() => _enableSubmitButton = _textController.text.isNotEmpty);
      }
    });
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final song = state.dataState.songMap[widget.songId];

    return AlertDialog(
      title: Text(song.description != null && song.description.trim().isNotEmpty
          ? song.description
          : song.title),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localization.close.toUpperCase())),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (state.authState.hasValidToken)
            TextFormField(
              autofocus: false,
              minLines: 1,
              maxLines: 3,
              inputFormatters: [
                LengthLimitingTextInputFormatter(kMaxCommentLength),
              ],
              controller: _textController,
              focusNode: _textFocusNode,
              decoration: InputDecoration(
                labelText: localization.addAPublicComment,
                //icon: Icon(Icons.comment),
              ),
            ),
          SizedBox(height: 8),
          Visibility(
            visible: _showSubmitButton,
            child: Padding(
              padding: EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (!state.isSaving)
                    TextButton(
                      child: Text(localization.cancel.toUpperCase()),
                      onPressed: () {
                        _textController.clear();
                        _textFocusNode.unfocus();
                      },
                    ),
                  SizedBox(width: 10),
                  state.isSaving
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 35, vertical: 10),
                          child: SizedBox(
                              child: CircularProgressIndicator(),
                              width: 20,
                              height: 20),
                        )
                      : ElevatedButton(
                          child: Text(localization.comment.toUpperCase()),
                          onPressed: _enableSubmitButton
                              ? () {
                                  final Completer<Null> completer =
                                      Completer<Null>();
                                  final comment = song.newComment(
                                      state.authState.artist.id,
                                      _textController.text.trim());
                                  store.dispatch(SaveCommentRequest(
                                      completer: completer, comment: comment));
                                  completer.future.then((value) {
                                    _textController.clear();
                                    _textFocusNode.unfocus();
                                  });

                                  /*
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop();
                                  }
                                  */
                                }
                              : null,
                        )
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: song.comments.isEmpty
                ? Center(
                    child: Text(
                      localization.noComments,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300),
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    children: song.comments.reversed
                        .map((comment) => CommentRow(
                              key: ValueKey(comment.id),
                              song: song,
                              comment: comment,
                            ))
                        .toList(),
                  ),
          )
        ],
      ),
    );
  }
}
