import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mudeo/data/repositories/artist_repository.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/artist/artist_actions.dart';
import 'package:mudeo/ui/artist/artist_page.dart';
import 'package:mudeo/ui/artist/artist_settings_vm.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreArtistsMiddleware([
  ArtistRepository repository = const ArtistRepository(),
]) {
  //final viewArtistList = _viewArtistList();
  //final loadArtists = _loadArtists(repository);
  final viewArtist = _viewArtist();
  final editArtist = _editArtist();
  final loadArtist = _loadArtist(repository);
  final saveArtist = _saveArtist(repository);
  final saveArtistImage = _saveArtistImage(repository);

  return [
    //TypedMiddleware<AppState, ViewArtistList>(viewArtistList),
    //TypedMiddleware<AppState, LoadArtists>(loadArtists),
    TypedMiddleware<AppState, ViewArtist>(viewArtist),
    TypedMiddleware<AppState, EditArtist>(editArtist),
    TypedMiddleware<AppState, LoadArtist>(loadArtist),
    TypedMiddleware<AppState, SaveArtistRequest>(saveArtist),
    TypedMiddleware<AppState, SaveArtistImage>(saveArtistImage),
  ];
}

Middleware<AppState> _editArtist() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);

    await Navigator.of(action.context).push(
      CupertinoPageRoute<void>(
        builder: (BuildContext context) {
          return ArtistSettingsScreen();
        },
      ),
    );

    /*
    if (action.completer != null && artist != null) {
      action.completer.complete(artist);
    }
    */
  };
}

Middleware<AppState> _viewArtist() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);

    Navigator.of(action.context).push(
      CupertinoPageRoute<void>(
        builder: (BuildContext context) {
          return ArtistPage(artist: action.artist);
        },
      ),
    );
  };
}

/*
Middleware<AppState> _viewArtistList() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    store.dispatch(UpdateCurrentRoute(ArtistScreen.route));

    //Navigator.of(action.context).pushNamedAndRemoveUntil(
    //    ArtistScreen.route, ModalRoute.withName(DashboardScreen.route));

    Navigator.of(action.context).pushNamedAndRemoveUntil(
        ArtistScreen.route, (Route<dynamic> route) => false);
  };
}
*/

Middleware<AppState> _saveArtist(ArtistRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository.saveData(store.state.authState, action.artist).then((artist) {
      store.dispatch(SaveArtistSuccess(artist));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(SaveArtistFailure(error));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _saveArtistImage(ArtistRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository
        .saveImage(
            store.state.authState, action.path, action.type)
        .then((artist) {
      store.dispatch(SaveArtistSuccess(artist));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(SaveArtistFailure(error));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _loadArtist(ArtistRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    final AppState state = store.state;

    if (state.isLoading) {
      next(action);
      return;
    }

    store.dispatch(LoadArtistRequest());
    repository.loadItem(state.authState, action.artistId).then((artist) {
      store.dispatch(LoadArtistSuccess(artist));

      if (action.completer != null) {
        action.completer.complete(null);
      }
    }).catchError((Object error) {
      print(error);
      store.dispatch(LoadArtistFailure(error));
      if (action.completer != null) {
        action.completer.completeError(error);
      }
    });

    next(action);
  };
}

/*
Middleware<AppState> _loadArtists(ArtistRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    final AppState state = store.state;

    if (!state.artistState.isStale && !action.force) {
      next(action);
      return;
    }

    if (state.isLoading) {
      next(action);
      return;
    }

    final int updatedAt = (state.artistState.lastUpdated / 1000).round();

    store.dispatch(LoadArtistsRequest());
    repository
        .loadList(state.selectedCompany, state.authState, updatedAt)
        .then((data) {
      store.dispatch(LoadArtistsSuccess(data));

      if (action.completer != null) {
        action.completer.complete(null);
      }
      if (state.productState.isStale) {
        store.dispatch(LoadProducts());
      }
    }).catchError((Object error) {
      print(error);
      store.dispatch(LoadArtistsFailure(error));
      if (action.completer != null) {
        action.completer.completeError(error);
      }
    });

    next(action);
  };
}

 */
