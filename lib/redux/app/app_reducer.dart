import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/entities.dart';
import 'package:mudeo/redux/app/app_actions.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/app/loading_reducer.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/redux/auth/auth_reducer.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/redux/ui/ui_state.dart';
import 'package:redux/redux.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is UserLogout) {
    return AppState().rebuild((b) => b..authState.replace(state.authState));
    //..uiState.enableDarkMode = state.uiState.enableDarkMode);
  } else if (action is LoadStateSuccess) {
    return action.state.rebuild((b) => b
      ..isLoading = false
      ..isSaving = false);
  }

  return state.rebuild((b) => b
    ..isLoading = loadingReducer(state.isLoading, action)
    ..isSaving = savingReducer(state.isSaving, action)
    ..authState.replace(authReducer(state.authState, action))
    ..dataState.replace(dataReducer(state.dataState, action))
    ..uiState.replace(uiReducer(state.uiState, action)));
}

Reducer<DataState> dataReducer = combineReducers([
  TypedReducer<DataState, LoadSongsSuccess>(songListReducer),
]);

DataState songListReducer(DataState dataState, LoadSongsSuccess action) {
  return dataState.rebuild((b) => b
    ..songsUpdateAt = DateTime.now().millisecondsSinceEpoch
    ..songMap.addAll(Map.fromIterable(
      action.songs,
      key: (dynamic item) => item.id,
      value: (dynamic item) => item,
    )));
}

Reducer<UIState> uiReducer = combineReducers([
  TypedReducer<UIState, AddTrack>(addTrackReducer),
  TypedReducer<UIState, UpdateSong>(updateSongReducer),
  TypedReducer<UIState, EditSong>(editSongReducer),
  TypedReducer<UIState, MainTabChanged>(mainTabChangedReducer),
]);

UIState addTrackReducer(UIState uiState, AddTrack action) {
  final song = uiState.song;
  final track = action.track;
  return uiState.rebuild((b) => b
    ..song.duration = song.duration == 0 ? action.duration : song.duration
    ..song.tracks.add(track));
}

UIState updateSongReducer(UIState uiState, UpdateSong action) {
  return uiState.rebuild((b) => b..song.replace(action.song));
}

UIState editSongReducer(UIState uiState, EditSong action) {
  return uiState.rebuild((b) => b
    ..selectedTabIndex = kTabCreate
    ..song.replace(action.song));
}

UIState mainTabChangedReducer(UIState uiState, MainTabChanged action) {
  return uiState.rebuild((b) => b
    ..selectedTabIndex = action.tabIndex);
}

