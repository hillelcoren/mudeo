import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/file_storage.dart';
import 'package:mudeo/data/models/entities.dart';
import 'package:mudeo/data/repositories/persistence_repository.dart';
import 'package:mudeo/redux/app/app_actions.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/redux/auth/auth_state.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/redux/ui/ui_state.dart';
import 'package:mudeo/ui/app/app_builder.dart';
import 'package:mudeo/ui/main_screen.dart';
import 'package:mudeo/utils/platforms.dart';
import 'package:redux/redux.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Middleware<AppState>> createStorePersistenceMiddleware([
  PersistenceRepository authRepository = const PersistenceRepository(
    fileStorage: const FileStorage(
      'auth_state',
      getApplicationDocumentsDirectory,
    ),
  ),
  PersistenceRepository uiRepository = const PersistenceRepository(
    fileStorage: const FileStorage(
      'ui_state',
      getApplicationDocumentsDirectory,
    ),
  ),
  PersistenceRepository dataRepository = const PersistenceRepository(
    fileStorage: const FileStorage(
      'data_state',
      getApplicationDocumentsDirectory,
    ),
  ),
]) {
  final loadState =
      _createLoadState(authRepository, uiRepository, dataRepository);

  final persistData = _createPersistData(dataRepository);

  final userLoginSuccess =
      _createUserLoggedIn(authRepository, uiRepository, dataRepository);

  final persistUI = _createPersistUI(uiRepository);

  final persistAuth = _createPersistAuth(authRepository);

  final updateTabIndex = _updateTabIndex();

  return [
    TypedMiddleware<AppState, LoadStateRequest>(loadState),
    TypedMiddleware<AppState, UserLoginSuccess>(userLoginSuccess),
    TypedMiddleware<AppState, PersistData>(persistData),
    TypedMiddleware<AppState, PersistUI>(persistUI),
    TypedMiddleware<AppState, PersistAuth>(persistAuth),
    TypedMiddleware<AppState, UpdateTabIndex>(updateTabIndex),
  ];
}

Middleware<AppState> _createLoadState(
  PersistenceRepository authRepository,
  PersistenceRepository uiRepository,
  PersistenceRepository dataRepository,
) {
  AuthState authState;
  UIState uiState;
  DataState dataState;

  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final appVersion = prefs.getString(kSharedPrefAppVersion);
      prefs.setString(kSharedPrefAppVersion, kAppVersion);

      if (appVersion != kAppVersion) {
        throw 'Clearing state for a new version';
      }

      authState = await authRepository.loadAuthState();

      if ((authState.artist.token ?? '') == '') {
        store.dispatch(UserLogout());
        store.dispatch(LoadUserLogin(action.context));
        return;
      }

      uiState = await uiRepository.loadUIState();
      dataState = await dataRepository.loadDataState();

      final AppState appState = AppState().rebuild((b) => b
        ..authState.replace(authState)
        ..uiState.replace(uiState)
        ..dataState.replace(dataState));

      AppBuilder.of(action.context).rebuild();
      store.dispatch(LoadStateSuccess(appState));

      final NavigatorState navigator = Navigator.of(action.context);
      navigator.pushReplacementNamed(MainScreen.route);
    } catch (error) {
      print(error);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(kSharedPrefToken) ?? '';

      if (token.isNotEmpty) {
        final completer = Completer<Null>();
        store.dispatch(RefreshData(
          completer: completer,
        ));
        completer.future.then((_) {
          final NavigatorState navigator = Navigator.of(action.context);
          navigator.pushReplacementNamed(MainScreen.route);
        }).catchError((Object error) {
          store.dispatch(UserLogout());
          store.dispatch(LoadUserLogin(action.context));
        });
        return;
      } else {
        store.dispatch(UserLogout());
        store.dispatch(LoadUserLogin(action.context));
      }
    }

    next(action);
  };
}

Middleware<AppState> _createUserLoggedIn(
  PersistenceRepository authRepository,
  PersistenceRepository uiRepository,
  PersistenceRepository dataRepository,
) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    final state = store.state;

    authRepository.saveAuthState(state.authState);
    uiRepository.saveUIState(state.uiState);
    dataRepository.saveDataState(state.dataState);
  };
}

Middleware<AppState> _createPersistUI(PersistenceRepository uiRepository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    uiRepository.saveUIState(store.state.uiState);
  };
}

Middleware<AppState> _createPersistAuth(PersistenceRepository authRepository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    authRepository.saveAuthState(store.state.authState);
  };
}

Middleware<AppState> _createPersistData(PersistenceRepository dataRepository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    // first process the action so the data is in the state
    next(action);

    final AppState state = store.state;
    dataRepository.saveDataState(state.dataState);
  };
}

Middleware<AppState> _updateTabIndex() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    // first process the action so the data is in the state
    next(action);

    final dataState = store.state.dataState;
    if (dataState.areSongsStale && !dataState.loadFailedRecently) {
      store.dispatch(LoadSongs());
    }
  };
}
