import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:mudeo/data/models/song.dart';
import 'package:mudeo/redux/app/app_actions.dart';

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
