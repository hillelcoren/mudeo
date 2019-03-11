import 'package:mudeo/constants.dart';
import 'package:mudeo/redux/app/app_actions.dart';
import 'package:mudeo/redux/artist/artist_actions.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/redux/ui/ui_state.dart';
import 'package:redux/redux.dart';

Reducer<UIState> uiReducer = combineReducers([
  TypedReducer<UIState, AddTrack>(addTrackReducer),
  TypedReducer<UIState, UpdateSong>(updateSongReducer),
  TypedReducer<UIState, EditSong>(editSongReducer),
  TypedReducer<UIState, UpdateTabIndex>(mainTabChangedReducer),
  TypedReducer<UIState, SaveVideoSuccess>(saveVideoReducer),
]);

UIState saveVideoReducer(UIState uiState, SaveVideoSuccess action) {
  final video = action.video;
  final song = action.song;

  final oldTrack = song.trackWithNewVideo;

  if (oldTrack == null) {
    print('>> Old track not found');
    return uiState;
  }

  final index = song.tracks.indexOf(oldTrack);
  final newTrack = oldTrack.rebuild((b) => b..video.replace(video));

  return uiState.rebuild((b) => b..song.tracks[index] = newTrack);
}

UIState addTrackReducer(UIState uiState, AddTrack action) {
  final song = uiState.song;
  final track = action.track;
  return uiState.rebuild((b) => b
    ..song.duration = song.duration == 0 ? action.duration : song.duration
    ..song.isChanged = true
    ..song.tracks.add(track));
}

UIState updateSongReducer(UIState uiState, UpdateSong action) {
  return uiState.rebuild((b) => b
    ..song.replace(action.song)
    ..song.isChanged = true);
}

UIState updateArtistReducer(UIState uiState, UpdateArtist action) {
  return uiState.rebuild((b) => b
    ..artist.replace(action.artist));
}

UIState editSongReducer(UIState uiState, EditSong action) {
  return uiState.rebuild((b) => b
    ..selectedTabIndex = kTabCreate
    ..song.replace(action.song));
}

UIState mainTabChangedReducer(UIState uiState, UpdateTabIndex action) {
  return uiState.rebuild((b) => b..selectedTabIndex = action.index);
}
