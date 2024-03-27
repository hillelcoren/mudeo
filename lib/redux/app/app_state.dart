import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/foundation.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/entities.dart';
import 'package:mudeo/redux/auth/auth_state.dart';
import 'package:mudeo/redux/ui/ui_state.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  factory AppState(
      {String? appVersion,
      bool? enableDarkMode,
      bool? requireAuthentication,
      bool? isDance = false}) {
    return _$AppState._(
      isLoading: false,
      isSaving: false,
      isDance: isDance,
      authState: AuthState(),
      dataState: DataState(),
      uiState: UIState(),
    );
  }

  AppState._();

  bool? get isLoading;

  bool? get isSaving;

  bool? get isDance;

  AuthState? get authState;

  DataState? get dataState;

  UIState? get uiState;

  ArtistEntity? get artist => authState!.artist;

  static Serializer<AppState> get serializer => _$appStateSerializer;

  String get appName => isDance! ? 'Dance Like Me' : 'mudeo';

  String get appUrl => isDance! ? kDanceURL : kMudeoURL;

  String get apiUrl => '$appUrl/api';

  String get termsUrl => '$appUrl/terms';

  String get privacyUrl => '$appUrl/privacy';

  String get twitterUrl => isDance! ? kDanceTwitterURL : kMudeoTwitterURL;

  String get twitterHandle => '${twitterUrl.split('/').last}';

  String get youtubeUrl => isDance! ? kDanceYouTubeURL : kMudeoYouTubeURL;

  String get contactEmail => isDance! ? kDanceContactEmail : kMudeoContactEmail;

  String? get helpVideoId => isDance! ? null : 'mV5rFN-gGRM';

  @override
  String toString() {
    //return 'Delays: ${uiState.song.tracks.map((track) => '${track.delay}').join(',')}';
    //return 'Duration: ${uiState.song?.duration}';
    //return 'Expired: ${artist.orderExpires}';
    //return '${authState.artist.token}';

    /*
    String str = '## Song: ${uiState.song.title}';
    uiState.song.tracks.forEach((track) {
      str +=
          '\nTrack:(${track.isIncluded ? 'yes' : 'no'} ${track.delay})  ${track.id} ${track.video.id}';
    });

    return str;
     */

    return 'App: $appName';
  }
}
