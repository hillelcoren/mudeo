import 'dart:math';

import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
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
  TypedReducer<UIState, DeleteSongSuccess>(deleteSongReducer),
  TypedReducer<UIState, SaveSongSuccess>(saveSongReducer),
  TypedReducer<UIState, AddSongSuccess>(addSongReducer),
  TypedReducer<UIState, EditArtist>(editArtistReducer),
  TypedReducer<UIState, UpdateArtist>(updateArtistReducer),
  TypedReducer<UIState, StartRecording>(startRecordingReducer),
  TypedReducer<UIState, StopRecording>(stopRecordingReducer),
]);

UIState startRecordingReducer(UIState uiState, StartRecording action) {
  return uiState.rebuild((b) => b..recordingTimestamp = action.timestamp);
}

UIState stopRecordingReducer(UIState uiState, StopRecording action) {
  return uiState.rebuild((b) => b..recordingTimestamp = 0);
}

UIState mainTabChangedReducer(UIState uiState, UpdateTabIndex action) {
  return uiState.rebuild((b) => b..selectedTabIndex = action.index);
}

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

  var state = uiState.rebuild((b) => b
    ..song.tracks[index] = newTrack
  // TODO remove this workaround
    ..song.updatedAt = DateTime.now().millisecondsSinceEpoch.toString());

  if (video.isRemoteVideo) {
    if (song.title == null || song.title.isEmpty) {
      state = state.rebuild((b) => b..song.title = video.description);
    }

    if (song.duration == null || song.duration == 0) {
      state = state.rebuild(
          (b) => b..song.duration = min(video.duration, kMaxSongDuration));
    }
  }

  return state;
}

UIState saveSongReducer(UIState uiState, SaveSongSuccess action) {
  return uiState.rebuild((b) => b..song.replace(action.song));
}

UIState deleteSongReducer(UIState uiState, DeleteSongSuccess action) {
  return uiState.rebuild((b) => b
    ..song.replace(SongEntity())
    ..selectedTabIndex = kTabList);
}

UIState addSongReducer(UIState uiState, AddSongSuccess action) {
  return uiState.rebuild((b) => b..song.replace(action.song));
}

UIState addTrackReducer(UIState uiState, AddTrack action) {
  final song = uiState.song;
  final track = action.track;

  return uiState.rebuild((b) => b
    ..song.duration = song.duration == 0 ? action.duration : song.duration
    // TODO remove this workaround
    ..song.updatedAt = track.video.isOld
        ? DateTime.now().millisecondsSinceEpoch.toString()
        : song.updatedAt
    ..song.tracks.add(track));
}

UIState updateSongReducer(UIState uiState, UpdateSong action) {
  return uiState.rebuild((b) => b..song.replace(action.song));
}

UIState editSongReducer(UIState uiState, EditSong action) {
  UIState state = uiState.rebuild((b) => b..selectedTabIndex = kTabEdit);

  if (uiState.song.id != action.song.id) {
    state = state.rebuild((b) => b..song.replace(action.song));
  }

  return state;
}

UIState editArtistReducer(UIState uiState, EditArtist action) {
  return uiState.rebuild((b) => b..artist.replace(action.artist));
}

UIState updateArtistReducer(UIState uiState, UpdateArtist action) {
  return uiState.rebuild((b) => b..artist.replace(action.artist));
}
