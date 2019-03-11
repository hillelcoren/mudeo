import 'dart:async';
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
import 'package:mudeo/utils/localization.dart';
import 'package:redux/redux.dart';

class SongEditScreen extends StatelessWidget {
  const SongEditScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SongEditVM>(
      converter: SongEditVM.fromStore,
      builder: (context, vm) {
        return SongEdit(
          viewModel: vm,
          key: ValueKey(vm.song.id),
        );
      },
    );
  }
}

class SongEditVM {
  SongEditVM({
    @required this.state,
    @required this.isLoading,
    @required this.isLoaded,
    @required this.song,
    @required this.onTrackAdded,
    @required this.onChangedSong,
    @required this.onSavePressed,
    @required this.onClearPressed,
    @required this.onBackPressed,
  });

  final AppState state;
  final bool isLoading;
  final bool isLoaded;
  final SongEntity song;
  final Function(VideoEntity, int) onTrackAdded;
  final Function(SongEntity) onChangedSong;
  final Function() onSavePressed;
  final Function(BuildContext) onClearPressed;
  final Function() onBackPressed;

  static SongEditVM fromStore(Store<AppState> store) {
    final state = store.state;

    return SongEditVM(
        song: state.uiState.song,
        //clientMap: state.clientState.map,
        state: state,
        isLoading: state.isLoading,
        //isLoaded: state.clientState.isLoaded,
        isLoaded: state.dataState.areSongsLoaded,
        onClearPressed: (context) {
          store.dispatch(UpdateSong(SongEntity()));
        },
        onTrackAdded: (video, duration) {
          final song = state.uiState.song;
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
        onSavePressed: () {
          final song = state.uiState.song;
          final completer = Completer<Null>();
          store.dispatch(SaveSongRequest(song: song, completer: completer));
        });
  }
}
