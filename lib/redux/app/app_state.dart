import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/entities.dart';
import 'package:mudeo/redux/auth/auth_state.dart';
import 'package:mudeo/redux/ui/ui_state.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  factory AppState(
      {String appVersion, bool enableDarkMode, bool requireAuthentication}) {
    return _$AppState._(
      isLoading: false,
      isSaving: false,
      authState: AuthState(),
      dataState: DataState(),
      uiState: UIState(),
    );
  }

  AppState._();

  bool get isLoading;

  bool get isSaving;

  AuthState get authState;

  DataState get dataState;

  UIState get uiState;

  ArtistEntity get artist => authState.artist;

  static Serializer<AppState> get serializer => _$appStateSerializer;

  @override
  String toString() {
    //return 'Delays: ${uiState.song.tracks.map((track) => '${track.delay}').join(',')}';
    //return 'Duration: ${uiState.song?.duration}';
    return 'Expired: ${artist.orderExpires}';
    return '';
  }
}
