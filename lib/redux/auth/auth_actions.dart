import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/redux/app/app_actions.dart';
import 'package:mudeo/redux/app/app_state.dart';

class LoadStateRequest {
  LoadStateRequest(this.context);

  final BuildContext context;
}

class LoadStateSuccess {
  LoadStateSuccess(this.state);

  final AppState state;
}

class LoadUserLogin {
  LoadUserLogin(this.context);

  final BuildContext context;
}

class GoogleLoginRequest implements StartLoading {
  GoogleLoginRequest(
      {this.completer,
      this.email,
      this.oauthToken,});

  final Completer completer;
  final String email; // TODO remove this property, break up _saveAuthLocal
  final String oauthToken;
}

class GoogleSignUpRequest implements StartLoading {
  GoogleSignUpRequest({
    this.completer,
    this.handle,
    this.email,
    this.oauthId,
    this.name,
    this.photoUrl,
    this.oauthToken,
    this.platform,
  });

  final Completer completer;
  final String handle;
  final String email;
  final String name;
  final String oauthId;
  final String photoUrl;
  final String oauthToken;
  final String platform;
}

class UserSignUpRequest implements StartLoading {
  UserSignUpRequest({
    this.completer,
    this.handle,
    this.email,
    this.password,
    this.platform,
  });

  final Completer completer;
  final String handle;
  final String email;
  final String password;
  final String platform;
}

class UserLoginRequest implements StartLoading {
  UserLoginRequest(
      {this.completer,
      this.email,
      this.password,
      this.platform,
      this.oneTimePassword});

  final Completer completer;
  final String email;
  final String password;
  final String platform;
  final String oneTimePassword;
}

class UserLoginSuccess implements StopLoading, PersistAuth {
  UserLoginSuccess(this.artist);
  final ArtistEntity artist;
}

class UserLoginFailure implements StopLoading {
  UserLoginFailure(this.error);

  final Object error;
}

class UserLogout implements PersistData, PersistAuth, PersistUI {}

class ClearAuthError {}
