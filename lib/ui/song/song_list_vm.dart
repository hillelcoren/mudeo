import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/ui/artist/artist_page.dart';
import 'package:mudeo/ui/song/song_list.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:redux/redux.dart';

class SongListScreen extends StatelessWidget {
  const SongListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SongListVM>(
      converter: SongListVM.fromStore,
      builder: (context, vm) {
        return SongList(
          viewModel: vm,
        );
      },
    );
  }
}

class SongListVM {
  SongListVM({
    @required this.state,
    @required this.isLoading,
    @required this.isLoaded,
    @required this.onArtistTap,
    @required this.onSongEdit,
    @required this.onRefreshed,
    @required this.songIds,
  });

  final AppState state;
  final bool isLoading;
  final bool isLoaded;
  final List<int> songIds;
  final Function(BuildContext, ArtistEntity) onArtistTap;
  final Function(BuildContext, SongEntity) onSongEdit;
  final Function(BuildContext) onRefreshed;

  static SongListVM fromStore(Store<AppState> store) {
    Future<Null> _handleRefresh(BuildContext context) {
      if (store.state.isLoading) {
        return Future<Null>(null);
      }
      /*
      final completer = snackBarCompleter(
          context, AppLocalization.of(context).refreshComplete);
          */
      final completer = Completer<Null>();
      store.dispatch(LoadSongs(completer: completer, force: true));
      return completer.future;
    }

    final state = store.state;

    return SongListVM(
      //clientMap: state.clientState.map,
      state: state,
      isLoading: state.isLoading,
      //isLoaded: state.clientState.isLoaded,
      songIds: state.dataState.songMap.keys.toList(),
      isLoaded: state.dataState.areSongsLoaded,
      onArtistTap: (context, artist) {
        Navigator.of(context).push(
          CupertinoPageRoute<void>(
            builder: (BuildContext context) {
              return ArtistPage(artist: artist);
            },
          ),
        );
      },
      onSongEdit: (context, song) {
        final localization = AppLocalization.of(context);
        final uiSong = store.state.uiState.song;
        if (uiSong.isChanged ?? false) {
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
                      store.dispatch(EditSong(song: song, context: context));
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
