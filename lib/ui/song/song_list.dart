import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/artist/artist_actions.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/redux/song/song_selectors.dart';
import 'package:mudeo/ui/app/form_card.dart';
import 'package:mudeo/ui/app/loading_indicator.dart';
import 'package:mudeo/ui/artist/artist_profile.dart';
import 'package:mudeo/ui/song/song_list_vm.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:chewie/chewie.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

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

class _SongListState extends State<SongList> {
  SongEntity selectedSong;

  @override
  Widget build(BuildContext context) {
    if (!widget.viewModel.isLoaded) {
      return Container(child: LoadingIndicator());
    }

    final state = widget.viewModel.state;
    final songIds =
        memoizedSongIds(state.dataState.songMap, state.authState.artist, null);

    return RefreshIndicator(
      onRefresh: () => widget.viewModel.onRefreshed(context),
      child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 130),
          shrinkWrap: true,
          controller: widget.scrollController,
          itemCount: songIds.length,
          itemBuilder: (BuildContext context, index) {
            final data = widget.viewModel.state.dataState;
            final songId = songIds[index];
            final song = data.songMap[songId];

            return SongItem(
              song: song,
              isSelected: song == selectedSong,
              onSelected: (newSong) => setState(() {
                selectedSong = newSong;
                //widget.scrollController.en
                //Scrollable.ensureVisible(context);
              }),
            );
          }),
    );
  }
}

class SongItem extends StatefulWidget {
  SongItem(
      {this.song,
      this.isSelected = false,
      this.enableShowArtist = true,
      this.onSelected});

  final SongEntity song;
  final bool isSelected;
  final bool enableShowArtist;
  final Function(SongEntity) onSelected;

  @override
  _SongItemState createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {
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

    return AnimatedContainer(
      duration: Duration(milliseconds: widget.isSelected ? 300 : 500),
      height: widget.isSelected ? 560 : 380,
      child: Stack(children: <Widget>[
        CachedNetworkImage(
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          imageUrl: widget.song.tracks.last.video.thumbnailUrl,
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isSelected
                ? null
                : () {
                    widget.onSelected(widget.song);
                    Scrollable.ensureVisible(context,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.transparent),
                    color: Colors.black12.withOpacity(0.3),
                  ),
                  child: SongHeader(
                    song: widget.song,
                    enableShowArtist: widget.enableShowArtist,
                  ),
                ),
                AnimatedContainer(
                  height: widget.isSelected ? 400 : 0,
                  duration:
                      Duration(milliseconds: widget.isSelected ? 500 : 300),
                  curve: Curves.easeInOut,
                  child: SingleChildScrollView(
                    child: FormCard(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                widget.song.description,
                                style: Theme.of(context).textTheme.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                _textController.clear();
                                _textFocusNode.unfocus();
                                widget.onSelected(null);
                              },
                            ),
                          ],
                        ),
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
                        Visibility(
                          visible: _showSubmitButton,
                          child: Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FlatButton(
                                  child:
                                      Text(localization.cancel.toUpperCase()),
                                  onPressed: () {
                                    _textController.clear();
                                    _textFocusNode.unfocus();
                                  },
                                ),
                                RaisedButton(
                                  child:
                                      Text(localization.comment.toUpperCase()),
                                  onPressed:
                                      _enableSubmitButton ? () => null : null,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                              'dfasd',
                            ].map((val) => Text(val)).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.transparent),
                    color: Colors.black12.withOpacity(0.3),
                  ),
                  child: SongFooter(widget.song),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}

class SongFooter extends StatelessWidget {
  SongFooter(this.song);

  final SongEntity song;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final artist = state.authState.artist;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.videocam),
            tooltip: localization.edit,
            onPressed: () {
              final uiSong = state.uiState.song;
              SongEntity newSong = song;

              if (!artist.ownsSong(song)) {
                newSong = song.fork;
              }

              if (uiSong.hasNewVideos && uiSong.id != newSong.id) {
                showDialog<AlertDialog>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    semanticLabel: localization.areYouSure,
                    title: Text(localization.areYouSure),
                    content: Text(localization.loseChanges),
                    actions: <Widget>[
                      new FlatButton(
                          child: Text(localization.cancel.toUpperCase()),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      new FlatButton(
                          child: Text(localization.ok.toUpperCase()),
                          onPressed: () {
                            Navigator.pop(context);
                            store.dispatch(
                                EditSong(song: newSong, context: context));
                          })
                    ],
                  ),
                );
              } else {
                store.dispatch(EditSong(song: newSong, context: context));
              }
            },
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.favorite),
                tooltip: localization.like,
                onPressed: () => store.dispatch(LikeSongRequest(song: song)),
                color: artist.likedSong(song.id) ? Colors.redAccent : null,
              ),
              song.countLike > 0 ? Text('${song.countLike}') : SizedBox(),
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.message),
                tooltip: localization.comments,
                onPressed: () => null,
              ),
              //song.countLike > 0 ? Text('${song.countLike}') : SizedBox(),
            ],
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: 30),
            itemBuilder: (BuildContext context) {
              final actions = [
                localization.shareSong,
                localization.openInBrowser,
                localization.copyLinkToSong,
                if (song.parentId > 0) localization.viewOriginal,
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
              if (action == localization.openInBrowser) {
                launch(song.url);
                return;
              } else if (action == localization.copyLinkToSong) {
                Clipboard.setData(new ClipboardData(text: song.url));
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text(localization.copiedToClipboard)));
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
              } else if (action == localization.shareSong) {
                Share.share(song.url);
                return;
              }

              showDialog<AlertDialog>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      semanticLabel: localization.areYouSure,
                      title: Text(localization.areYouSure),
                      content: Text(localization.reportSong),
                      actions: <Widget>[
                        FlatButton(
                            child: Text(localization.cancel.toUpperCase()),
                            onPressed: () => Navigator.pop(context)),
                        FlatButton(
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
    final TextStyle artistStyle = themeData.textTheme.body2
        .copyWith(color: themeData.accentColor, fontSize: 16);
    final TextStyle genreStyle =
        artistStyle.copyWith(color: kGenreColors[song.genreId]);

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
                  style: Theme.of(context).textTheme.title,
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
                          : TextSpan(text: ' • '),
                      song.genreId == null || song.genreId == 0
                          ? TextSpan()
                          : TextSpan(
                              text: localization.lookup(kGenres[song.genreId]),
                              style: genreStyle,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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

    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          SingleChildScrollView(
            child: Chewie(
              controller: chewieController,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
