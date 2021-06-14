import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/artist/artist_actions.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/ui/artist/artist_profile.dart';
import 'package:mudeo/ui/song/song_list.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SongPage extends StatelessWidget {
  const SongPage({
    Key key,
    @required this.song,
  }) : super(key: key);

  final SongEntity song;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    String description = song.description ?? '';
    if (song.genreId > 0) {
      description += ' #' +
          (state.isDance ? kStyles[song.genreId] : kGenres[song.genreId]);
    }

    return Container(
      padding: EdgeInsets.only(
        left: 15,
        top: 15,
        right: 15,
        //bottom: 15 + MediaQuery.of(context).padding.bottom,
        bottom: 15,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '@${song.artist.handle}',
                  style: textTheme.headline6,
                ),
                SizedBox(height: 14),
                if (description.trim().isNotEmpty) ...[
                  Text(description.trim()),
                  SizedBox(height: 12),
                ],
                Text(
                  '🎵  ${song.title}',
                  style: textTheme.bodyText1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          _SongActions(
            song: song,
          ),
        ],
      ),
    );
  }
}

class _SongActions extends StatelessWidget {
  const _SongActions({@required this.song});

  final SongEntity song;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final artist = state.authState.artist;

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

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ArtistProfile(
          artist: song.artist,
          onTap: () => kIsWeb
              ? null
              : store.dispatch(
                  ViewArtist(
                    context: context,
                    artist: song.artist,
                  ),
                ),
        ),
        SizedBox(height: 2),
        if (!kIsWeb)
          _LargeIconButton(
            iconData: Icons.video_call,
            onPressed: () {
              final uiSong = state.uiState.song;
              SongEntity newSong = song;

              if (!artist.belongsToSong(song)) {
                newSong = song.fork;

                if (state.isDance) {
                  newSong = newSong.justKeepFirstTrack;
                }
              }

              if (uiSong.hasNewVideos && uiSong.id != newSong.id) {
                showDialog<AlertDialog>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    semanticLabel: localization.areYouSure,
                    title: Text(localization.loseChanges),
                    content: Text(localization.areYouSure),
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
        if (state.authState.hasValidToken)
          _LargeIconButton(
            iconData: Icons.favorite,
            count: song.countLike + 1,
            color: artist.likedSong(song.id) ? Colors.red : null,
            onPressed: () {
              store.dispatch(LikeSongRequest(song: song));
            },
          ),
        if (!kIsWeb)
          _LargeIconButton(
            iconData: Icons.comment,
            tooltip: localization.comment,
            count: song.comments.length,
            onPressed: () {
              showDialog<SongComments>(
                  context: context,
                  builder: (BuildContext context) {
                    return SongComments(
                      song: song,
                      onClosePressed: () {
                        Navigator.of(context).pop();
                      },
                    );
                  });
            },
          ),
        _LargeIconButton(
          iconData: Icons.share,
          tooltip: localization.share,
          showCount: false,
          onPressed: () {
            Share.share(song.url);
          },
        ),
      ],
    );
  }
}

class _LargeIconButton extends StatelessWidget {
  const _LargeIconButton({
    this.iconData,
    this.tooltip,
    this.onPressed,
    this.color,
    this.count,
    this.showCount = true,
    this.requireLoggedIn = false,
  });

  final IconData iconData;
  final String tooltip;
  final Function onPressed;
  final bool requireLoggedIn;
  final Color color;
  final int count;
  final bool showCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            iconSize: 38,
            icon: Icon(
              iconData,
              size: 38,
              color: color,
            ),
            tooltip: tooltip,
            onPressed: onPressed,
          ),
          /*
          if (showCount)
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text(
                (count ?? 0) == 0 ? ' ' : '$count',
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
           */
        ],
      ),
    );
  }
}
