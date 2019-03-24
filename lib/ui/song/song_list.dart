import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/ui/app/loading_indicator.dart';
import 'package:mudeo/ui/artist/artist_profile.dart';
import 'package:mudeo/ui/song/song_list_vm.dart';
import 'package:mudeo/utils/localization.dart';

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
            final songId = songIds[index];
            final song = data.songMap[songId];

            return SongItem(
              ValueKey(songId),
              context,
              song: song,
              onArtistTap: (artist) => viewModel.onArtistTap(context, artist),
              onPlay: () {
                print('play tapped');
              },
              onEdit: () => viewModel.onSongEdit(context, song),
            );
          }),
    );
  }
}

class SongItem extends StatelessWidget {
  SongItem(Key key, BuildContext context,
      {this.song, this.onPlay, this.onEdit, this.onArtistTap})
      : super(key: key);

  final SongEntity song;
  final Function onPlay;
  final Function onEdit;
  final Function(ArtistEntity) onArtistTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SongHeader(
                song: song,
                //onPlay: onPlay,
                onPlay: onEdit,
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
              /*
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.videocam),
                    tooltip: localization.edit,
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite),
                    tooltip: localization.like,
                    //onPressed: () => null,
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    tooltip: localization.share,
                    //onPressed: () => null,
                  ),
                  IconButton(
                    icon: Icon(Icons.flag),
                    //onPressed: () => null,
                  ),
                ],
              ),
              */
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
    final state = StoreProvider.of<AppState>(context).state;
    final artist = song.artist ?? ArtistEntity();
    //final artist = state.dataState.artistMap[song.artistId] ?? ArtistEntity();

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
          SizedBox(width: 12),
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
            icon: Icon(Icons.play_circle_filled, size: 40),
            tooltip: localization.play,
            onPressed: onPlay,
          ),
        ],
      ),
    );
  }
}
