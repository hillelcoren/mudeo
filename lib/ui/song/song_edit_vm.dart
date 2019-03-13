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
import 'package:mudeo/ui/app/live_text.dart';
import 'package:mudeo/ui/song/song_edit.dart';
import 'package:mudeo/ui/song/song_save_dialog.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:redux/redux.dart';

class SongEditScreen extends StatelessWidget {
  const SongEditScreen({Key key}) : super(key: key);

  void onSavePressed(BuildContext context, SongEditVM viewModel) {
    showDialog<SongSaveDialog>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SongSaveDialog(viewModel: viewModel);
        });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return StoreConnector<AppState, SongEditVM>(
      converter: SongEditVM.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.delete),
              tooltip: localization.delete,
              onPressed: () => vm.onClearPressed(context),
              // TODO enable this code
              /*
                onPressed: isEmpty || isPlaying
                    ? null
                    : () => viewModel.onClearPressed(context),
                    */
            ),
            title: LiveText(() {
              final state = vm.state.uiState;
              if (state.recordingTimestamp > 0) {
                return 'TS: ${vm.state.uiState.recordingTimestamp}';
              } else {
                return vm.song.title;
              }
            }),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.cloud_upload),
                tooltip: localization.save,
                onPressed: () => onSavePressed(context, vm),
              ),
            ],
          ),
          body: SongEdit(
            viewModel: vm,
            key: ValueKey(vm.song.id),
          ),
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
    @required this.onStartRecording,
    @required this.onTrackAdded,
    @required this.onChangedSong,
    @required this.onSavePressed,
    @required this.onClearPressed,
    @required this.onBackPressed,
    @required this.onDeleteVideoPressed,
  });

  final AppState state;
  final bool isLoading;
  final bool isLoaded;
  final SongEntity song;
  final Function onStartRecording;
  final Function(VideoEntity, int) onTrackAdded;
  final Function(SongEntity) onChangedSong;
  final Function() onSavePressed;
  final Function(BuildContext) onClearPressed;
  final Function(SongEntity, VideoEntity) onDeleteVideoPressed;
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
      onStartRecording: () {
        store.dispatch(StartRecording());
      },
      onTrackAdded: (video, duration) {
        store.dispatch(StopRecording());
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
      },
      onDeleteVideoPressed: (song, video) async {
        store.dispatch(UpdateSong(song));
        String path = await VideoEntity.getPath(video.timestamp);
        if (File(path).existsSync()) {
          File(path).deleteSync();
        }
      },
    );
  }
}
