import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/ui/song/song_list.dart';
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
    @required this.onSongTap,
    @required this.onSongEdit,
    @required this.onRefreshed,
    @required this.songIds,
  });

  final AppState state;
  final bool isLoading;
  final bool isLoaded;
  final List<int> songIds;
  final Function(BuildContext, SongEntity) onSongTap;
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
      onSongTap: (context, client) {
        //store.dispatch(ViewSong(clientId: client.id, context: context));
      },
      onSongEdit: (context, song) {
        if (state.uiState.song) {

        }
        store.dispatch(EditSong(song: song, context: context));
      },
      onRefreshed: (context) => _handleRefresh(context),
    );
  }
}
