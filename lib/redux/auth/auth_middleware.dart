import 'package:flutter/material.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/repositories/auth_repository.dart';
import 'package:mudeo/redux/app/app_actions.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/ui/auth/login_vm.dart';
import 'package:mudeo/ui/main_screen_vm.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Middleware<AppState>> createStoreAuthMiddleware([
  AuthRepository repository = const AuthRepository(),
]) {
  final loginInit = _createLoginInit();
  final loginRequest = _createLoginRequest(repository);
  final oauthRequest = _createOAuthRequest(repository);
  final refreshRequest = _createRefreshRequest(repository);

  return [
    TypedMiddleware<AppState, LoadUserLogin>(loginInit),
    TypedMiddleware<AppState, UserLoginRequest>(loginRequest),
    TypedMiddleware<AppState, OAuthLoginRequest>(oauthRequest),
    TypedMiddleware<AppState, RefreshData>(refreshRequest),
  ];
}

void _saveAuthLocal(dynamic action) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(kSharedPrefAppVersion, action.email ?? '');
}

void _loadAuthLocal(Store<AppState> store, dynamic action) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String email = prefs.getString(kSharedPrefEmail) ?? '';
  store.dispatch(UserLoginLoaded(email));

  store.dispatch(UserSettingsChanged());
}

Middleware<AppState> _createLoginInit() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    _loadAuthLocal(store, action);

    Navigator.of(action.context).pushReplacementNamed(LoginScreen.route);
    //Navigator.of(action.context).pushReplacementNamed(MainScreen.route);

    next(action);
  };
}

Middleware<AppState> _createLoginRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository
        .login(
        email: action.email,
        password: action.password,
        platform: action.platform,
        oneTimePassword: action.oneTimePassword)
        .then((data) {
      _saveAuthLocal(action);

    }).catchError((Object error) {
      print(error);
      if (error.toString().contains('No host specified in URI')) {
        store.dispatch(UserLoginFailure('Please check the URL is correct'));
      } else {
        store.dispatch(UserLoginFailure(error.toString()));
      }
    });

    next(action);
  };
}

Middleware<AppState> _createOAuthRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository
        .oauthLogin(
        token: action.token,
        secret: action.secret,
        platform: action.platform)
        .then((data) {
      _saveAuthLocal(action);

    }).catchError((Object error) {
      print(error);
      store.dispatch(UserLoginFailure(error.toString()));
    });

    next(action);
  };
}

Middleware<AppState> _createRefreshRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);

    _loadAuthLocal(store, action);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(kSharedPrefToken);

    repository
        .refresh(token: token, platform: action.platform)
        .then((data) {
      store.dispatch(
          LoadDataSuccess(completer: action.completer, loginResponse: data));
    }).catchError((Object error) {
      print(error);
      store.dispatch(UserLoginFailure(error.toString()));
      if (action.completer != null) {
        action.completer.completeError(error);
      }
    });
  };
}