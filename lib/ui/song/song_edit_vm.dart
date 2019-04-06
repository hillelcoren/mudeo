import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/app/app_actions.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/ui/song/song_edit.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongEditScreen extends StatelessWidget {
  const SongEditScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SongEditVM>(
      converter: SongEditVM.fromStore,
      builder: (context, viewModel) {
        return SongScaffold(
          viewModel: viewModel,
        );
      },
    );
  }
}

class SongEditVM {
  SongEditVM({
    @required this.state,
    @required this.song,
    @required this.onStartRecording,
    @required this.onStopRecording,
    @required this.onTrackAdded,
    @required this.onChangedSong,
    @required this.onSavePressed,
    @required this.onNewSongPressed,
    @required this.onResetSongPressed,
    @required this.onBackPressed,
    @required this.onDeleteVideoPressed,
  });

  final AppState state;
  final SongEntity song;
  final Function(int) onStartRecording;
  final Function onStopRecording;
  final Function(VideoEntity, int) onTrackAdded;
  final Function(SongEntity) onChangedSong;
  final Function(Completer) onSavePressed;
  final Function(BuildContext) onNewSongPressed;
  final Function(BuildContext) onResetSongPressed;
  final Function(SongEntity, TrackEntity) onDeleteVideoPressed;
  final Function() onBackPressed;

  static SongEditVM fromStore(Store<AppState> store) {
    return SongEditVM(
      song: store.state.uiState.song,
      state: store.state,
      onNewSongPressed: (context) async {
        final sharedPrefs = await SharedPreferences.getInstance();
        final genreId = sharedPrefs.getInt(kSharedPrefGenreId);
        store.dispatch(UpdateSong(SongEntity(genreId: genreId)));
      },
      onResetSongPressed: (context) {
        final state = store.state;
        final uiState = state.uiState;
        SongEntity song;
        if (state.uiState.song.isNew) {
          final songId = uiState.song.parentId;
          song = state.dataState.songMap[songId].fork;
        } else {
          final songId = uiState.song.id;
          song = state.dataState.songMap[songId];
        }
        store.dispatch(UpdateSong(SongEntity()));
        WidgetsBinding.instance
            .addPostFrameCallback((_) => store.dispatch(UpdateSong(song)));
      },
      onStartRecording: (timestamp) {
        store.dispatch(StartRecording(timestamp));
      },
      onStopRecording: () {
        store.dispatch(StopRecording());
      },
      onTrackAdded: (video, duration) {
        store.dispatch(StopRecording());
        final song = store.state.uiState.song;
        final track = song.newTrack(video);
        store.dispatch(AddTrack(
          track: track,
          duration: duration,
        ));
      },
      onChangedSong: (song) {
        store.dispatch(UpdateSong(song));
      },
      onBackPressed: () {
        store.dispatch(UpdateTabIndex(kTabExplore));
      },
      onSavePressed: (completer) {
        final song = store.state.uiState.song;
        store.dispatch(SaveSongRequest(song: song, completer: completer));
      },
      onDeleteVideoPressed: (song, track) async {
        final int index = song.tracks.indexOf(track);
        song = song.rebuild((b) => b..tracks.removeAt(index));
        if (song.tracks.isEmpty) {
          song = song.rebuild((b) => b..duration = 0);
        }
        store.dispatch(UpdateSong(song));
        String path = await VideoEntity.getPath(track.video.timestamp);
        if (File(path).existsSync()) {
          File(path).deleteSync();
        }
      },
    );
  }
}
