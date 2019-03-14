import 'package:built_collection/built_collection.dart';
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
import 'package:mudeo/ui/app/form_card.dart';
import 'package:mudeo/ui/app/loading_indicator.dart';
import 'package:mudeo/ui/artist/artist_page.dart';
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
      return LoadingIndicator();
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
                print('tapped');
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
    final localization = AppLocalization.of(context);
    final state = StoreProvider.of<AppState>(context).state;
    final artist = song.artist ?? ArtistEntity();
    //final artist = state.dataState.artistMap[song.artistId] ?? ArtistEntity();

    final ThemeData themeData = Theme.of(context);
    final TextStyle linkStyle = themeData.textTheme.body2
        .copyWith(color: themeData.accentColor, fontSize: 15);

    return Material(
      child: FormCard(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child:
                    Text(song.title, style: Theme.of(context).textTheme.title),
              ),
              IconButton(
                icon: Icon(Icons.play_circle_filled, size: 35),
                tooltip: localization.play,
                onPressed: onEdit,
              ),
              /*
              IconButton(
                icon: Icon(Icons.play_circle_filled, size: 35),
                //onPressed: onPlay,
                tooltip: localization.play,
              ),
              */
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: <Widget>[
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => onArtistTap(artist),
                        style: linkStyle,
                        text: '@${artist.handle}',
                      ),
                      /*
                      TextSpan(
                        text: ' • ${song.countPlay ?? 0} ${localization.views}',
                      ),
                      */
                    ],
                  ),
                ),
              ),
              song.genreId == null || song.genreId == 0
                  ? SizedBox()
                  : Text(
                      localization.lookup(kGenres[song.genreId]),
                      style: TextStyle(
                          color: kGenreColors[song.genreId], fontSize: 15),
                    ),
            ],
          ),
          SizedBox(height: song.description.isEmpty ? 0 : 12),
          Text(song.description),
          SizedBox(height: song.description.isEmpty ? 0 : 12),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
              height: 100,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: (song.tracks)
                    .map(
                      (track) => Placeholder(
                            fallbackHeight: 140,
                            fallbackWidth: 100,
                          ),
                      /*
                          CachedNetworkImage(
                            imageUrl:
                            '',
                            height: 140.0,
                          ),
                          */
                    )
                    .toList(),
              ),
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
    );
  }
}

class SongView extends StatelessWidget {
  SongView(this.song);

  final SongEntity song;

  @override
  Widget build(BuildContext context) {
    return Text(song.title);
  }
}
