import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/data/models/song.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/ui/song/song_edit.dart';
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
  });

  final AppState state;
  final bool isLoading;
  final bool isLoaded;
  final SongEntity song;
  final Function(SongEntity, TrackEntity) onTrackAdded;

  static SongEditVM fromStore(Store<AppState> store) {

    final state = store.state;

    return SongEditVM(
      song: state.uiState.song,
      //clientMap: state.clientState.map,
      state: state,
      isLoading: state.isLoading,
      //isLoaded: state.clientState.isLoaded,
      isLoaded: state.dataState.areSongsLoaded,
      onTrackAdded: (song, track) {
        store.dispatch(AddTrack(
          song: song,
          track: track,
        ));
      }
    );
  }
}
