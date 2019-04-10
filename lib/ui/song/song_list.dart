import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/ui/app/loading_indicator.dart';
import 'package:mudeo/ui/artist/artist_profile.dart';
import 'package:mudeo/ui/song/song_list_vm.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class SongList extends StatelessWidget {
  const SongList({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final SongListVM viewModel;

  @override
  Widget build(BuildContext context) {
    if (!viewModel.isLoaded) {
      return Container(child: LoadingIndicator());
    }

    final dataState = viewModel.state.dataState;
    final songIds = dataState.songMap.keys.toList();
    songIds.sort((songIda, songIdb) =>
        dataState.songMap[songIdb].id - dataState.songMap[songIda].id);

    return RefreshIndicator(
      onRefresh: () => viewModel.onRefreshed(context),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: songIds.length,
          itemBuilder: (BuildContext context, index) {
            final data = viewModel.state.dataState;
            final auth = viewModel.state.authState;
            final songId = songIds[index];
            final song = data.songMap[songId];

            return SongItem(
              ValueKey(songId),
              context,
              song: song,
              isLiked: auth.artist.likedSong(song.id),
              onArtistTap: (artist) => viewModel.onArtistTap(context, artist),
              onPlayPressed: () {
                showDialog<VideoPlayer>(
                    context: context,
                    builder: (BuildContext context) {
                      return VideoPlayer(song.videoUrl);
                    });
              },
              onLikePressed: () => viewModel.onLikePressed(song),
              onSharePressed: () => viewModel.onSharePressed(song),
              onEditPressed: () => viewModel.onSongEdit(context, song),
            );
          }),
    );
  }
}

class SongItem extends StatelessWidget {
  SongItem(Key key, BuildContext context,
      {this.song,
      this.isLiked = false,
      this.onPlayPressed,
      this.onLikePressed,
      this.onEditPressed,
      this.onSharePressed,
      this.onArtistTap})
      : super(key: key);

  final SongEntity song;
  final bool isLiked;
  final Function onPlayPressed;
  final Function onLikePressed;
  final Function onEditPressed;
  final Function onSharePressed;
  final Function(ArtistEntity) onArtistTap;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        elevation: 8,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SongHeader(
                song: song,
                onPlay: onPlayPressed,
                onArtistTap: onArtistTap,
              ),
              song.description.isEmpty
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(
                          left: 10, bottom: 14, right: 10),
                      child: Text(song.description),
                    ),
              Container(
                height: 330,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: (song.tracks)
                      .map(
                        (track) => track.video.thumbnailUrl.isEmpty
                            ? SizedBox(
                                height: 330,
                              )
                            : CachedNetworkImage(
                                imageUrl: track.video.thumbnailUrl,
                                height: 330,
                              ),
                      )
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.videocam),
                      tooltip: localization.edit,
                      onPressed: onEditPressed,
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite),
                      tooltip: localization.like,
                      onPressed: onLikePressed,
                      color: isLiked ? Colors.redAccent : null,
                    ),
                    IconButton(
                      icon: Icon(Icons.share),
                      tooltip: localization.share,
                      onPressed: onSharePressed,
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) {
                        final actions = [
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
                        if (action == localization.copyLinkToSong) {
                          Clipboard.setData(new ClipboardData(text: song.url));
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(localization.copiedToClipboard)));
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
                                      child: Text(
                                          localization.cancel.toUpperCase()),
                                      onPressed: () => Navigator.pop(context)),
                                  FlatButton(
                                      child:
                                          Text(localization.ok.toUpperCase()),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })
                                ],
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SongHeader extends StatelessWidget {
  SongHeader({this.song, this.onPlay, this.onArtistTap});

  final SongEntity song;
  final Function onPlay;
  final Function onArtistTap;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final artist = song.artist ?? ArtistEntity();

    final ThemeData themeData = Theme.of(context);
    final TextStyle artistStyle = themeData.textTheme.body2
        .copyWith(color: themeData.accentColor, fontSize: 16);
    final TextStyle genreStyle =
        artistStyle.copyWith(color: kGenreColors[song.genreId]);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ArtistProfile(
            artist: song.artist,
            onTap: () => onArtistTap(artist),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(song.title, style: Theme.of(context).textTheme.title),
                SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => onArtistTap(artist),
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
                      /*
                          TextSpan(
                            text: ' • ${song.countPlay ?? 0} ${localization.views}',
                          ),
                          */
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            padding: EdgeInsets.only(top: 0),
            icon: Icon(Icons.play_circle_filled, size: 42),
            tooltip: localization.play,
            onPressed: onPlay,
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
    videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: false,
      showControls: true,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Chewie(
            controller: chewieController,
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
