import 'package:mudeo/redux/artist/artist_actions.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/redux/auth/auth_state.dart';
import 'package:redux/redux.dart';

Reducer<AuthState> authReducer = combineReducers([
  TypedReducer<AuthState, UserLoginRequest>(userLoginRequestReducer),
  TypedReducer<AuthState, GoogleLoginRequest>(oauthLoginRequestReducer),
  TypedReducer<AuthState, UserLoginSuccess>(userLoginSuccessReducer),
  TypedReducer<AuthState, UserLoginFailure>(userLoginFailureReducer),
  TypedReducer<AuthState, ClearAuthError>(clearAuthErrorReducer),
  TypedReducer<AuthState, SaveArtistSuccess>(saveArtistReducer),
]);

AuthState clearAuthErrorReducer(AuthState authState, ClearAuthError action) {
  return authState.rebuild((b) => b..error = null);
}

AuthState userLoginRequestReducer(
    AuthState authState, UserLoginRequest action) {
  return authState.rebuild((b) => b..error = null);
}

AuthState oauthLoginRequestReducer(
    AuthState authState, GoogleLoginRequest action) {
  return authState.rebuild((b) => b..error = null);
}

AuthState userLoginSuccessReducer(
    AuthState authState, UserLoginSuccess action) {
  return authState.rebuild((b) => b
    ..artist.replace(action.artist)
    ..error = null
    ..isAuthenticated = true
    ..wasAuthenticated = true);
}

AuthState userLoginFailureReducer(
    AuthState authState, UserLoginFailure action) {
  return authState.rebuild((b) => b..error = action.error);
}

AuthState saveArtistReducer(AuthState authState, SaveArtistSuccess action) {
  return authState.rebuild((b) => b..artist.replace(action.artist));
}