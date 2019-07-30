import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/redux/app/app_actions.dart';

class ViewSongList implements PersistUI {
  ViewSongList(this.context);

  final BuildContext context;
}

class EditSong implements PersistUI {
  EditSong({this.song, this.context});

  final SongEntity song;
  final BuildContext context;
}

class UpdateSong implements PersistUI {
  UpdateSong(this.song);

  final SongEntity song;
}

class LoadSongs {
  LoadSongs({this.completer, this.force = false});

  final Completer completer;
  final bool force;
}

class LoadSongsRequest implements StartLoading {}

class LoadSongsFailure implements StopLoading {
  LoadSongsFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadSongsFailure{error: $error}';
  }
}

class LoadSongsSuccess implements PersistData, StopLoading {
  LoadSongsSuccess(this.songs);

  final BuiltList<SongEntity> songs;

  @override
  String toString() {
    return 'LoadSongsSuccess{songs: $songs}';
  }
}

class SaveCommentRequest implements StartSaving {
  SaveCommentRequest({this.comment, this.completer});

  final Completer completer;
  final CommentEntity comment;
}

class SaveCommentSuccess implements StopSaving, PersistData, PersistUI {
  SaveCommentSuccess(this.comment);

  final CommentEntity comment;
}

class SaveCommentFailure implements StopSaving {
  SaveCommentFailure(this.error);

  final Object error;
}

class DeleteCommentRequest implements StartSaving {
  DeleteCommentRequest({this.comment, this.completer});

  final Completer completer;
  final CommentEntity comment;
}

class DeleteCommentSuccess implements StopSaving, PersistData, PersistUI {
  DeleteCommentSuccess(this.comment);

  final CommentEntity comment;
}

class DeleteCommentFailure implements StopSaving {
  DeleteCommentFailure(this.error);

  final Object error;
}


class SaveSongRequest implements StartSaving {
  SaveSongRequest({this.song, this.completer});

  final Completer completer;
  final SongEntity song;
}

class SaveSongSuccess implements StopSaving, PersistData, PersistUI {
  SaveSongSuccess(this.song);

  final SongEntity song;
}

class SaveSongFailure implements StopSaving {
  SaveSongFailure(this.error);

  final Object error;
}

class LikeSongRequest implements StartSaving {
  LikeSongRequest({this.song, this.completer});

  final Completer completer;
  final SongEntity song;
}

class LikeSongSuccess implements StopSaving, PersistAuth {
  LikeSongSuccess({this.songLike, this.unlike});

  final SongLikeEntity songLike;
  final bool unlike;
}

class LikeSongFailure implements StopSaving {
  LikeSongFailure(this.error);

  final Object error;
}

class FlagSongRequest implements StartSaving {
  FlagSongRequest({this.song, this.completer});

  final Completer completer;
  final SongEntity song;
}

class FlagSongSuccess implements StopSaving, PersistAuth {
  FlagSongSuccess(this.songFlag);

  final SongFlagEntity songFlag;
}

class FlagSongFailure implements StopSaving {
  FlagSongFailure(this.error);

  final Object error;
}


class SaveVideoSuccess implements StopSaving, PersistData, PersistUI {
  SaveVideoSuccess({this.song, this.video});

  final SongEntity song;
  final VideoEntity video;
}

class SaveVideoFailure implements StopSaving, PersistData, PersistUI {
  SaveVideoFailure(this.error);

  final Object error;
}

class AddSongSuccess implements StopSaving, PersistData, PersistUI {
  AddSongSuccess(this.song);

  final SongEntity song;
}


class FilterSongs {
  FilterSongs(this.filter);

  final String filter;
}

class SortSongs implements PersistUI {
  SortSongs(this.field);

  final String field;
}

class AddTrack implements PersistUI {
  AddTrack({this.track, this.duration});

  final TrackEntity track;
  final int duration;
}

class StartRecording {
  StartRecording(this.timestamp);
  final int timestamp;
}
class StopRecording {}