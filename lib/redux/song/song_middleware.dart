import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/data/repositories/song_repository.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/auth/auth_state.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreSongsMiddleware([
  SongRepository repository = const SongRepository(),
]) {
  final loadSongs = _loadSongs(repository);
  final saveSong = _saveSong(repository);
  final likeSong = _likeSong(repository);
  final flagSong = _flagSong(repository);
  final saveComment = _saveComment(repository);

  return [
    TypedMiddleware<AppState, LoadSongs>(loadSongs),
    TypedMiddleware<AppState, SaveSongRequest>(saveSong),
    TypedMiddleware<AppState, LikeSongRequest>(likeSong),
    TypedMiddleware<AppState, FlagSongRequest>(flagSong),
    TypedMiddleware<AppState, SaveCommentRequest>(saveComment),
  ];
}

Middleware<AppState> _saveSong(SongRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    SongEntity song = action.song;
    final authState = store.state.authState;

    if (song.hasNewVideos) {
      repository.saveVideo(authState, song.newVideo).then((video) {
        store.dispatch(SaveVideoSuccess(song: song, video: video));
        store.dispatch(SaveSongRequest(
            song: store.state.uiState.song, completer: action.completer));
      }).catchError((Object error) {
        print(error);
        store.dispatch(SaveVideoFailure(error));
        action.completer.completeError(error);
      });
    } else {
      repository.saveSong(authState, action.song.updateOrderByIds).then((song) {
        if (action.song.isNew) {
          store.dispatch(AddSongSuccess(song));
        } else {
          store.dispatch(SaveSongSuccess(song));
        }
        action.completer.complete(song);
      }).catchError((Object error) {
        print(error);
        store.dispatch(SaveSongFailure(error));
        action.completer.completeError(error);
      });
    }

    next(action);
  };
}

Middleware<AppState> _loadSongs(SongRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    final AppState state = store.state;

    if (!action.force) {
      if (!state.dataState.areSongsStale ||
          state.dataState.loadFailedRecently) {
        next(action);
        return;
      }
    }

    if (state.isLoading || !state.authState.hasValidToken) {
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

Middleware<AppState> _likeSong(SongRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    final AuthState state = store.state.authState;
    final song = action.song;
    final songLike = state.artist.getSongLike(song.id);

    repository.likeSong(state, song, songLike: songLike).then((data) {
      store.dispatch(LikeSongSuccess(songLike: data, unlike: songLike != null));
      if (action.completer != null) {
        action.completer.complete(null);
      }
    }).catchError((Object error) {
      print(error);
      store.dispatch(LikeSongFailure(error));
      if (action.completer != null) {
        action.completer.completeError(error);
      }
    });

    next(action);
  };
}

Middleware<AppState> _flagSong(SongRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    final AuthState state = store.state.authState;
    final song = action.song;

    repository.flagSong(state, song).then((data) {
      store.dispatch(FlagSongSuccess(data));
      if (action.completer != null) {
        action.completer.complete(null);
      }
    }).catchError((Object error) {
      print(error);
      store.dispatch(FlagSongFailure(error));
      if (action.completer != null) {
        action.completer.completeError(error);
      }
    });

    next(action);
  };
}


Middleware<AppState> _saveComment(SongRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    CommentEntity comment = action.comment;
    final authState = store.state.authState;

    repository.saveComment(authState, comment).then((song) {
      /*
      if (action.song.isNew) {
        store.dispatch(AddSongSuccess(song));
      } else {
        store.dispatch(SaveSongSuccess(song));
      }
      */
      store.dispatch(SaveCommentSuccess(comment));
      action.completer.complete(song);
    }).catchError((Object error) {
      print(error);
      store.dispatch(SaveSongFailure(error));
      action.completer.completeError(error);
    });

    next(action);
  };
}
