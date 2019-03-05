import 'package:mudeo/data/repositories/auth_repository.dart';
import 'package:mudeo/redux/app/app_actions.dart';
import 'package:mudeo/redux/app/app_state.dart';
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
  prefs.setString(kKeychainEmail, action.email ?? '');

  if (formatApiUrlReadable(action.url) != kAppUrl) {
    prefs.setString(kKeychainUrl, formatApiUrlMachine(action.url));
    prefs.setString(kKeychainSecret, action.secret);
  }
}

void _loadAuthLocal(Store<AppState> store, dynamic action) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String email = prefs.getString(kSharedPrefEmail) ?? '';
  final String url =
  formatApiUrlMachine(prefs.getString(kSharedPrefUrl) ?? '');
  final String secret =
      prefs.getString(kSharedPrefSecret) ?? '';
  store.dispatch(UserLoginLoaded(email, url, secret));

  final bool enableDarkMode = prefs.getBool(kSharedPrefEnableDarkMode) ?? false;
  final bool emailPayment = prefs.getBool(kSharedPrefEmailPayment) ?? false;
  final bool autoStartTasks = prefs.getBool(kSharedPrefAutoStartTasks) ?? false;
  final bool requireAuthentication =
      prefs.getBool(kSharedPrefRequireAuthentication) ?? false;

  store.dispatch(UserSettingsChanged(
      enableDarkMode: enableDarkMode,
      emailPayment: emailPayment,
      requireAuthentication: requireAuthentication,
      autoStartTasks: autoStartTasks));
}

Middleware<AppState> _createLoginInit() {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    _loadAuthLocal(store, action);

    Navigator.of(action.context).pushReplacementNamed(LoginScreen.route);

    next(action);
  };
}

Middleware<AppState> _createLoginRequest(AuthRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    repository
        .login(
        email: action.email,
        password: action.password,
        url: action.url,
        secret: action.secret,
        platform: action.platform,
        oneTimePassword: action.oneTimePassword)
        .then((data) {
      _saveAuthLocal(action);

      if (_isVersionSupported(data.version)) {
        store.dispatch(
            LoadDataSuccess(completer: action.completer, loginResponse: data));
      } else {
        store.dispatch(UserLoginFailure(
            'The minimum version is v$kMinMajorAppVersion.$kMinMinorAppVersion.$kMinPatchAppVersion'));
      }
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
        url: action.url,
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
    final String token = prefs.getString(getKeychainTokenKey());

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