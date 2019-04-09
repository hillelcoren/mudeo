import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/artist/artist_actions.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/ui/song/song_list.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:redux/redux.dart';

class SongListScreen extends StatelessWidget {
  const SongListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(builder: (BuildContext context) {
      return CupertinoPageScaffold(
        child: StoreConnector<AppState, SongListVM>(
          onInit: (store) {
            store.dispatch(LoadSongs());
          },
          converter: SongListVM.fromStore,
          builder: (context, vm) {
            return SongList(viewModel: vm);
          },
        ),
      );
    });
  }
}

class SongListVM {
  SongListVM({
    @required this.state,
    @required this.isLoaded,
    @required this.onArtistTap,
    @required this.onSongEdit,
    @required this.onRefreshed,
    @required this.onLikePressed,
  });

  final AppState state;
  final bool isLoaded;
  final Function(BuildContext, ArtistEntity) onArtistTap;
  final Function(BuildContext, SongEntity) onSongEdit;
  final Function(BuildContext) onRefreshed;
  final Function() onLikePressed;

  static SongListVM fromStore(Store<AppState> store) {
    Future<Null> _handleRefresh(BuildContext context) {
      if (store.state.isLoading) {
        return Future<Null>(null);
      }

      final completer = Completer<Null>();
      store.dispatch(LoadSongs(completer: completer, force: true));
      return completer.future;
    }

    final state = store.state;

    return SongListVM(
      state: state,
      isLoaded: state.dataState.areSongsLoaded,
      onArtistTap: (context, artist) {
        store.dispatch(ViewArtist(context: context, artist: artist));
      },
      onLikePressed: () {
        final song = store.state.uiState.song;
        print('dispatching...');
        store.dispatch(LikeSongRequest(song: song));
      },
      onSongEdit: (context, song) {
        final localization = AppLocalization.of(context);
        final state = store.state;
        final artist = state.authState.artist;
        final uiSong = state.uiState.song;

        if (!artist.ownsSong(song)) {
          song = song.fork;
        }

        if (uiSong.hasNewVideos && uiSong.id != song.id) {
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
                          store
                              .dispatch(EditSong(song: song, context: context));
                        })
                  ],
                ),
          );
        } else {
          store.dispatch(EditSong(song: song, context: context));
        }
      },
      onRefreshed: (context) => _handleRefresh(context),
    );
  }
}
