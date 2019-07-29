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
              onSelected: () => setState(() => song == selectedSong
                  ? selectedSong = null
                  : selectedSong = song),
            );
          }),
    );
  }
}

class SongItem extends StatelessWidget {
  SongItem(
      {this.song,
      this.isSelected = false,
      this.enableShowArtist = true,
      this.onSelected});

  final SongEntity song;
  final bool isSelected;
  final bool enableShowArtist;
  final Function() onSelected;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: isSelected ? 500 : 350,
      child: Stack(children: <Widget>[
        CachedNetworkImage(
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          imageUrl: song.tracks.last.video.thumbnailUrl,
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            //onTap: onSelected,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.transparent),
                    color: Colors.black12.withOpacity(0.3),
                  ),
                  child: SongHeader(
                    song: song,
                    enableShowArtist: enableShowArtist,
                  ),
                ),
                Opacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  child: FormCard(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: localization.addAPublicComment,
                          //icon: Icon(Icons.comment),
                        ),
                        autofocus: false,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.transparent),
                    color: Colors.black12.withOpacity(0.3),
                  ),
                  child: SongFooter(song),
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
          IconButton(
            icon: Icon(Icons.share),
            tooltip: localization.share,
            onPressed: () => Share.share(song.url),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.keyboard_arrow_down, size: 30),
            itemBuilder: (BuildContext context) {
              final actions = [
                localization.openInBrowser,
                localization.copyLinkToSong,
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
