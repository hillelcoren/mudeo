import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/artist/artist_actions.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/redux/auth/auth_state.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:redux/redux.dart';

Reducer<AuthState> authReducer = combineReducers([
  TypedReducer<AuthState, UserLoginRequest>(userLoginRequestReducer),
  TypedReducer<AuthState, GoogleLoginRequest>(oauthLoginRequestReducer),
  TypedReducer<AuthState, UserLoginSuccess>(userLoginSuccessReducer),
  TypedReducer<AuthState, UserLoginFailure>(userLoginFailureReducer),
  TypedReducer<AuthState, ClearAuthError>(clearAuthErrorReducer),
  TypedReducer<AuthState, SaveArtistSuccess>(saveArtistReducer),
  TypedReducer<AuthState, LikeSongSuccess>(likeSongReducer),
  TypedReducer<AuthState, FlagSongSuccess>(flagSongReducer),
  TypedReducer<AuthState, FollowArtistSuccess>(followArtistReducer),
  TypedReducer<AuthState, FlagArtist>(flagArtistReducer),
  TypedReducer<AuthState, EnablePrivateStorage>(enablePrivateStorageReducer),
]);

AuthState enablePrivateStorageReducer(
    AuthState authState, EnablePrivateStorage action) {
  return authState.rebuild((b) => b..artist.orderExpires = action.expires);
}

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
    ..isAuthenticated = true);
}

AuthState userLoginFailureReducer(
    AuthState authState, UserLoginFailure action) {
  return authState.rebuild((b) => b..error = action.error);
}

AuthState saveArtistReducer(AuthState authState, SaveArtistSuccess action) {
  final artist = authState.artist;
  return authState.rebuild((b) => b
    ..artist.replace(action.artist.rebuild((b) => b
          //..artistFlags.replace(artist.artistFlags)
          ..songFlags.replace(artist.songFlags)
          ..songLikes.replace(artist.songLikes)
          ..following.replace(artist.following)
          ..token = artist.token
          ..email = artist.email // TODO remove this
        )));
}

AuthState likeSongReducer(AuthState authState, LikeSongSuccess action) {
  if (action.unlike) {
    return authState
        .rebuild((b) => b..artist.songLikes.remove(action.songLike));
  } else {
    return authState.rebuild((b) => b..artist.songLikes.add(action.songLike));
  }
}

AuthState flagSongReducer(AuthState authState, FlagSongSuccess action) {
  return authState.rebuild((b) => b..artist.songFlags.add(action.songFlag));
}

AuthState flagArtistReducer(AuthState authState, FlagArtist action) {
  return authState.rebuild((b) =>
      b..artist.artistFlags.add(ArtistFlagEntity(artistId: action.artist.id)));
}

AuthState followArtistReducer(AuthState authState, FollowArtistSuccess action) {
  if (action.unfollow) {
    return authState
        .rebuild((b) => b..artist.following.remove(action.artistFollowing));
  } else {
    return authState
        .rebuild((b) => b..artist.following.add(action.artistFollowing));
  }
}
