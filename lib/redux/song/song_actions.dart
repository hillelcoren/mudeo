import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mudeo/data/models/song.dart';
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

class SaveSongRequest implements StartSaving {
  SaveSongRequest({this.song, this.completer});

  final Completer completer;
  final SongEntity song;
}

class SaveSongSuccess implements StopSaving, PersistData, PersistUI {
  SaveSongSuccess(this.song);

  final SongEntity song;
}

class AddSongSuccess implements StopSaving, PersistData, PersistUI {
  AddSongSuccess(this.song);

  final SongEntity song;
}

class SaveSongFailure implements StopSaving {
  SaveSongFailure(this.error);

  final Object error;
}

class FilterSongs {
  FilterSongs(this.filter);

  final String filter;
}

class SortSongs implements PersistUI {
  SortSongs(this.field);

  final String field;
}

class AddTrack {
  AddTrack(this.track);

  final TrackEntity track;
}