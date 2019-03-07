import 'package:flutter/material.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreSongsMiddleware([
  SongRepository repository = const SongRepository(),
]) {
  final viewSongList = _viewSongList();
  final editSong = _editSong();
  final loadSongs = _loadSongs(repository);
  final saveSong = _saveSong(repository);
  final archiveSong = _archiveSong(repository);
  final deleteSong = _deleteSong(repository);
  final restoreSong = _restoreSong(repository);

  return [
    TypedMiddleware<AppState, ViewSongList>(viewSongList),
    TypedMiddleware<AppState, EditSong>(editSong),
    TypedMiddleware<AppState, LoadSongs>(loadSongs),
    TypedMiddleware<AppState, SaveSongRequest>(saveSong),
    TypedMiddleware<AppState, ArchiveSongRequest>(archiveSong),
    TypedMiddleware<AppState, DeleteSongRequest>(deleteSong),
    TypedMiddleware<AppState, RestoreSongRequest>(restoreSong),
  ];
}

Middleware<AppState> _editSong() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);

    store.dispatch(UpdateCurrentRoute(SongEditScreen.route));
    Navigator.of(action.context).pushNamed(SongEditScreen.route);
  };
}

Middleware<AppState> _viewSongList() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    store.dispatch(UpdateCurrentRoute(SongScreen.route));
    Navigator.of(action.context).pushNamedAndRemoveUntil(
        SongScreen.route, (Route<dynamic> route) => false);
  };
}

Middleware<AppState> _archiveSong(SongRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    final origSong = store.state.songState.map[action.songId];
    repository
        .saveData(store.state.selectedCompany, store.state.authState,
        origSong, EntityAction.archive)
        .then((SongEntity song) {
      store.dispatch(ArchiveSongSuccess(song));
      if (action.completer != null) {
        action.completer.complete(null);
      }
    }).catchError((dynamic error) {
      print(error);
      store.dispatch(ArchiveSongFailure(origSong));
      if (action.completer != null) {
        action.completer.completeError(error);
      }
    });

    next(action);
  };
}

Middleware<AppState> _deleteSong(SongRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    final origSong = store.state.songState.map[action.songId];
    repository
        .saveData(store.state.selectedCompany, store.state.authState,
        origSong, EntityAction.delete)
        .then((SongEntity song) {
      store.dispatch(DeleteSongSuccess(song));
      if (action.completer != null) {
        action.completer.complete(null);
      }
    }).catchError((Object error) {
      print(error);
      store.dispatch(DeleteSongFailure(origSong));
      if (action.completer != null) {
        action.completer.completeError(error);
      }
    });

    next(action);
  };
}

Middleware<AppState> _restoreSong(SongRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    final origSong = store.state.songState.map[action.songId];
    repository
        .saveData(store.state.selectedCompany, store.state.authState,
        origSong, EntityAction.restore)
        .then((SongEntity song) {
      store.dispatch(RestoreSongSuccess(song));
      if (action.completer != null) {
        action.completer.complete(null);
      }
    }).catchError((Object error) {
      print(error);
      store.dispatch(RestoreSongFailure(origSong));
      if (action.completer != null) {
        action.completer.completeError(error);
      }
    });

    next(action);
  };
}

Middleware<AppState> _saveSong(SongRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository
        .saveData(
        store.state.selectedCompany, store.state.authState, action.song)
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

    if (!state.songState.isStale && !action.force) {
      next(action);
      return;
    }

    if (state.isLoading) {
      next(action);
      return;
    }

    final int updatedAt = (state.songState.lastUpdated / 1000).round();

    store.dispatch(LoadSongsRequest());
    repository.loadList(state.selectedCompany, state.authState, updatedAt).then((data) {
      store.dispatch(LoadSongsSuccess(data));
      if (action.completer != null) {
        action.completer.complete(null);
      }
      if (state.invoiceState.isStale) {
        store.dispatch(LoadInvoices());
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
