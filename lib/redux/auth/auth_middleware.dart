import 'package:flutter/material.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/repositories/auth_repository.dart';
import 'package:mudeo/redux/app/app_actions.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/ui/main_screen.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Middleware<AppState>> createStoreAuthMiddleware([
  AuthRepository repository = const AuthRepository(),
]) {
  final appInit = _createAppInit();
  final loginRequest = _createLoginRequest(repository);
  final signUpRequest = _createSignUpRequest(repository);
  final googleSignUpRequest = _createGoogleSignUpRequest(repository);
  final oauthRequest = _createOAuthRequest(repository);
  final refreshRequest = _createRefreshRequest(repository);
  final deleteRequest = _createDeleteRequest(repository);

  return [
    TypedMiddleware<AppState, LoadUserLogin>(appInit),
    TypedMiddleware<AppState, UserLoginRequest>(loginRequest),
    TypedMiddleware<AppState, UserSignUpRequest>(signUpRequest),
    TypedMiddleware<AppState, GoogleSignUpRequest>(googleSignUpRequest),
    TypedMiddleware<AppState, GoogleLoginRequest>(oauthRequest),
    TypedMiddleware<AppState, RefreshData>(refreshRequest),
    TypedMiddleware<AppState, DeleteAccount>(deleteRequest),
  ];
}

Middleware<AppState> _createAppInit() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    Navigator.of(action.context).pushReplacementNamed(MainScreen.route);

    next(action);
  };
}

void _saveAuthLocal(ArtistEntity artist) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(kSharedPrefToken, artist.token ?? '');
}

Middleware<AppState> _createLoginRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository
        .login(store.state,
            email: action.email,
            password: action.password,
            oneTimePassword: action.oneTimePassword)
        .then((ArtistEntity artist) {
      if (artist.token == null) {
        // TODO enable this code
        //throw 'Error: token is blank';
      }
      _saveAuthLocal(artist);
      store.dispatch(UserLoginSuccess(artist));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      if (error.toString().contains('No host specified in URI')) {
        store.dispatch(UserLoginFailure('Please check the URL is correct'));
      } else {
        store.dispatch(UserLoginFailure(error.toString()));
      }
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _createGoogleSignUpRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository
        .googleSignUp(
      store.state,
      handle: action.handle,
      email: action.email,
      oauthId: action.oauthId,
      oauthToken: action.oauthToken,
      name: action.name,
      photoUrl: action.photoUrl,
    )
        .then((ArtistEntity artist) {
      _saveAuthLocal(artist);
      store.dispatch(UserLoginSuccess(artist));

      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(UserLoginFailure(error.toString()));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _createSignUpRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository
        .signUp(store.state,
            handle: action.handle,
            email: action.email,
            password: action.password,
            platform: action.platform)
        .then((ArtistEntity artist) {
      _saveAuthLocal(artist);
      store.dispatch(UserLoginSuccess(artist));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(UserLoginFailure(error.toString()));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _createOAuthRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository.oauthLogin(store.state, token: action.oauthToken).then((artist) {
      _saveAuthLocal(artist);
      store.dispatch(UserLoginSuccess(artist));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(UserLoginFailure(error.toString()));
      action.completer.completeError(error);
    });

    next(action);
  };
}

Middleware<AppState> _createRefreshRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(kSharedPrefToken);

    repository
        .refresh(
      store.state,
      artistId: store.state.authState.artist.id,
      token: token,
    )
        .then((artist) {
      store.dispatch(UserLoginSuccess(artist));
      action.completer.complete(null);
    }).catchError((Object error) {
      print(error);
      store.dispatch(UserLoginFailure(error.toString()));
      if (action.completer != null) {
        action.completer.completeError(error);
      }
    });
  };
}

Middleware<AppState> _createDeleteRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(kSharedPrefToken);

    repository
        .deleteAccount(
      store.state,
      artistId: store.state.authState.artist.id,
      token: token,
    )
        .then((response) {
      store.dispatch(UserLogout());
    }).catchError((Object error) {
      print(error);
      store.dispatch(DeleteAccountFailure(error.toString()));
      /*
      if (action.completer != null) {
        action.completer.completeError(error);
      }      
       */
    });
  };
}
