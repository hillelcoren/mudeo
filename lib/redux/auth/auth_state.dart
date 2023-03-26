import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/foundation.dart';
import 'package:mudeo/data/models/artist_model.dart';

part 'auth_state.g.dart';

abstract class AuthState implements Built<AuthState, AuthStateBuilder> {
  factory AuthState() {
    return _$AuthState._(
      artist: ArtistEntity(),
      isAuthenticated: false,
      hideAppReview: false,
      installedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  AuthState._();

  ArtistEntity get artist;

  bool get isAuthenticated;

  bool get hideAppReview;

  int get installedAt;

  AuthState get reset => rebuild((b) => b
    ..artist.replace(ArtistEntity())
    ..isAuthenticated = false);

  bool get hasValidToken => artist.token != null && artist.token.isNotEmpty;

  bool get showAppReview {
    if (!kReleaseMode) {
      //return true;
    }

    if (hideAppReview) {
      return false;
    }

    final dateInstalled = DateTime.fromMillisecondsSinceEpoch(installedAt);
    final dateNow = DateTime.now();
    final difference = dateNow.difference(dateInstalled);

    return difference.inDays >= 7;
  }

  // ignore: unused_element
  static void _initializeBuilder(AuthStateBuilder builder) => builder
    ..hideAppReview = false
    ..installedAt = DateTime.now().millisecondsSinceEpoch;

  static Serializer<AuthState> get serializer => _$authStateSerializer;
}
