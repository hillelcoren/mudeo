import 'package:flutter/material.dart';
import 'package:mudeo/data/models/song.dart';
import 'package:mudeo/data/repositories/song_repository.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreSongsMiddleware([
  SongRepository repository = const SongRepository(),
]) {
  final viewSongList = _viewSongList();
  final editSong = _editSong();
  final loadSongs = _loadSongs(repository);
  final saveSong = _saveSong(repository);

  return [
    TypedMiddleware<AppState, EditSong>(editSong),
    TypedMiddleware<AppState, LoadSongs>(loadSongs),
    TypedMiddleware<AppState, SaveSongRequest>(saveSong),
  ];
}

Middleware<AppState> _editSong() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);

    //store.dispatch(UpdateCurrentRoute(SongEditScreen.route));
    //Navigator.of(action.context).pushNamed(SongEditScreen.route);
  };
}

Middleware<AppState> _viewSongList() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    /*
    store.dispatch(UpdateCurrentRoute(SongScreen.route));
    Navigator.of(action.context).pushNamedAndRemoveUntil(
        SongScreen.route, (Route<dynamic> route) => false);
       */
  };
}

Middleware<AppState> _saveSong(SongRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository
        .saveData(
        store.state.authState, action.song)
        .then((SongEntity song) {
      if (action.song.isNew) {
        store.dispatch(AddSongSuccess(song));
      } else {
        store.dispatch(SaveSongSuccess(song));
      }
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(SaveSongFailure(error));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadSongs(SongRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    final AppState state = store.state;

    if (!state.dataState.areSongsStale && !action.force) {
      next(action);
      return;
    }

    if (state.isLoading) {
      next(action);
      return;
    }

    final int updatedAt = (state.dataState.songsUpdateAt / 1000).round();

    store.dispatch(LoadSongsRequest());
    repository.loadList(state.authState, updatedAt).then((data) {
      store.dispatch(LoadSongsSuccess(data));
      if (action.completer != null) {
        action.completer.complete(null);
      }
    }).catchError((Object error) {
      print(error);
      store.dispatch(LoadSongsFailure(error));
      if (action.completer != null) {
        action.completer.completeError(error);
      }
    });

    next(action);
  };
}
