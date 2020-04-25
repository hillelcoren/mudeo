import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/app/app_actions.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/ui/app/dialogs/error_dialog.dart';
import 'package:mudeo/ui/song/song_edit.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:redux/redux.dart';
import 'package:share/share.dart';
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
    @required this.onVideoAdded,
    @required this.onVideoUpdated,
    @required this.onChangedSong,
    @required this.onSavePressed,
    @required this.onNewSongPressed,
    @required this.onResetSongPressed,
    @required this.onBackPressed,
    @required this.onDeleteVideoPressed,
    @required this.onSharePressed,
    @required this.onAddRemoteVideo,
    @required this.onDeleteSongPressed,
    @required this.onForkSongPressed,
    @required this.addVideoFromTrack,
    @required this.addVideoFromSong,
  });

  final AppState state;
  final SongEntity song;
  final Function(int) onStartRecording;
  final Function onStopRecording;
  final Function(VideoEntity, int) onVideoAdded;
  final Function(VideoEntity, String) onVideoUpdated;
  final Function(SongEntity) onChangedSong;
  final Function(Completer) onSavePressed;
  final Function(BuildContext) onNewSongPressed;
  final Function(BuildContext) onResetSongPressed;
  final Function(BuildContext, String) onAddRemoteVideo;
  final Function(BuildContext, TrackEntity) addVideoFromTrack;
  final Function(BuildContext, SongEntity) addVideoFromSong;
  final Function(SongEntity, TrackEntity) onDeleteVideoPressed;
  final Function(SongEntity) onDeleteSongPressed;
  final Function(SongEntity) onForkSongPressed;
  final Function() onBackPressed;
  final Function() onSharePressed;

  static const MUDEO_TAB_LIST = 0;
  static const MUDEO_TAB_EDIT = 1;
  static const MUDEO_TAB_PROFILE = 2;

  static const DANCE_TAB_EDIT = 0;
  static const DANCE_TAB_PROFILE = 1;

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
          store.dispatch(UpdateSong(SongEntity(id: 0)));
          WidgetsBinding.instance
              .addPostFrameCallback((_) => store.dispatch(UpdateSong(song)));
        },
        onSharePressed: () {
          final uiState = store.state.uiState;
          Share.share(uiState.song.url);
        },
        onStartRecording: (timestamp) {
          store.dispatch(StartRecording(timestamp));
        },
        onStopRecording: () {
          store.dispatch(StopRecording());
        },
        onVideoUpdated: (video, recognitions) {
          store.dispatch(UpdateVideo(
            video: video,
            recognitions: recognitions,
          ));
        },
        onVideoAdded: (video, duration) async {
          store.dispatch(StopRecording());
          final song = store.state.uiState.song;
          final track = song.newTrack(video);
          store.dispatch(AddTrack(
            track: track,
            duration: duration,
          ));

          return track.id;
        },
        onChangedSong: (song) {
          store.dispatch(UpdateSong(song));
        },
        onBackPressed: () {
          store.dispatch(
              UpdateTabIndex(MUDEO_TAB_LIST));
        },
        onSavePressed: (completer) {
          final song = store.state.uiState.song;
          store.dispatch(SaveSongRequest(song: song, completer: completer));
        },
        onDeleteVideoPressed: (song, track) async {
          final int index = song.tracks.indexOf(track);
          if (track.video.isNew) {
            song = song.rebuild((b) => b..tracks.removeAt(index));
          } else {
            song = song.rebuild((b) =>
            b..tracks[index] = track.rebuild((b) => b..isIncluded = false));
          }
          if (!song.hasParent && song.tracks.isEmpty) {
            song = song.rebuild((b) => b..duration = 0);
          }
          store.dispatch(UpdateSong(song));
          String path = await VideoEntity.getPath(
              track.video);
          if (File(path).existsSync()) {
            File(path).deleteSync();
          }
        },
        onAddRemoteVideo: (context, videoId) {
          final song = store.state.uiState.song;
          final video =
          VideoEntity().rebuild((b) => b..remoteVideoId = videoId);

          final track = song.newTrack(video);
          store.dispatch(AddTrack(
            track: track,
            duration: 0,
          ));

          final completer = Completer<Null>();
          store.dispatch(SaveVideoRequest(
            completer: completer,
            song: song.rebuild((b) => b..tracks.add(track)),
            video: video,
          ));
        },
        addVideoFromTrack: (context, track) {
          bool hasVideo = false;
          store.state.uiState.song.tracks
              .where((track) => track.isIncluded)
              .forEach((songTrack) {
            if (songTrack.video.id == track.video.id) {
              hasVideo = true;
            }
          });

          store.dispatch(AddTrack(
            track: track.clone.rebuild((b) => b..volume = hasVideo ? 0 : 100),
            duration: 0,
            refreshUI: true,
          ));
        },
        addVideoFromSong: (context, sourceSong) async {
          final song = store.state.uiState.song;
          final video =
          VideoEntity().rebuild((b) => b..url = sourceSong.videoUrl);
          final track = song.newTrack(video);

          // store stacked video locally so it can be re-uploaded when saved
          final response =
          await http.Client().get(Uri.parse(sourceSong.videoUrl));

          if (response.statusCode >= 300) {
            showDialog<ErrorDialog>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                      AppLocalization
                          .of(context)
                          .errorVideoNotReady);
                });
          } else {
            String path = await VideoEntity.getPath(
                track.video);
            File file = new File(path);
            file.writeAsBytes(response.bodyBytes);

            store.dispatch(AddTrack(
              track: track,
              duration: 0,
              refreshUI: true,
            ));
          }
        },
        onDeleteSongPressed: (song) {
          store.dispatch(DeleteSongRequest(
            song: song,
            completer: Completer<Null>(),
          ));
        },
        onForkSongPressed: (song) {
          WidgetsBinding.instance.addPostFrameCallback(
                  (_) => store.dispatch(UpdateSong(song.fork)));
        });
  }
}
