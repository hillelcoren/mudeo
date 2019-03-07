import 'package:invoiceninja_flutter/data/models/song_model.dart';
import 'package:invoiceninja_flutter/redux/company/company_actions.dart';
import 'package:invoiceninja_flutter/redux/ui/entity_ui_state.dart';
import 'package:invoiceninja_flutter/redux/ui/list_ui_state.dart';
import 'package:redux/redux.dart';
import 'package:invoiceninja_flutter/redux/song/song_actions.dart';
import 'package:invoiceninja_flutter/redux/song/song_state.dart';

EntityUIState songUIReducer(SongUIState state, dynamic action) {
  return state.rebuild((b) => b
    ..listUIState.replace(songListReducer(state.listUIState, action))
    ..editing.replace(editingReducer(state.editing, action)));
}

Reducer<String> dropdownFilterReducer = combineReducers([
  TypedReducer<String, FilterSongDropdown>(filterClientDropdownReducer),
]);

String filterClientDropdownReducer(
    String dropdownFilter, FilterSongDropdown action) {
  return action.filter;
}

final editingReducer = combineReducers<SongEntity>([
  TypedReducer<SongEntity, SaveSongSuccess>(_updateEditing),
  TypedReducer<SongEntity, AddSongSuccess>(_updateEditing),
  TypedReducer<SongEntity, EditSong>(_updateEditing),
  TypedReducer<SongEntity, UpdateSong>(_updateEditing),
  TypedReducer<SongEntity, RestoreSongSuccess>(_updateEditing),
  TypedReducer<SongEntity, ArchiveSongSuccess>(_updateEditing),
  TypedReducer<SongEntity, DeleteSongSuccess>(_updateEditing),
  TypedReducer<SongEntity, SelectCompany>(_clearEditing),
]);

SongEntity _clearEditing(SongEntity client, dynamic action) {
  return SongEntity();
}

SongEntity _updateEditing(SongEntity client, dynamic action) {
  return action.song;
}

final songListReducer = combineReducers<ListUIState>([
  TypedReducer<ListUIState, SortSongs>(_sortSongs),
  TypedReducer<ListUIState, FilterSongs>(_filterSongs),
  TypedReducer<ListUIState, FilterSongsByState>(_filterSongsByState),
  TypedReducer<ListUIState, FilterSongsByCustom1>(_filterSongsByCustom1),
  TypedReducer<ListUIState, FilterSongsByCustom2>(_filterSongsByCustom2),
]);

ListUIState _filterSongsByState(
    ListUIState songListState, FilterSongsByState action) {
  if (songListState.stateFilters.contains(action.state)) {
    return songListState
        .rebuild((b) => b..stateFilters.remove(action.state));
  } else {
    return songListState.rebuild((b) => b..stateFilters.add(action.state));
  }
}

ListUIState _filterSongsByCustom1(
    ListUIState songListState, FilterSongsByCustom1 action) {
  if (songListState.custom1Filters.contains(action.value)) {
    return songListState
        .rebuild((b) => b..custom1Filters.remove(action.value));
  } else {
    return songListState.rebuild((b) => b..custom1Filters.add(action.value));
  }
}

ListUIState _filterSongsByCustom2(
    ListUIState songListState, FilterSongsByCustom2 action) {
  if (songListState.custom2Filters.contains(action.value)) {
    return songListState
        .rebuild((b) => b..custom2Filters.remove(action.value));
  } else {
    return songListState.rebuild((b) => b..custom2Filters.add(action.value));
  }
}

ListUIState _filterSongs(
    ListUIState songListState, FilterSongs action) {
  return songListState.rebuild((b) => b..filter = action.filter);
}

ListUIState _sortSongs(ListUIState songListState, SortSongs action) {
  return songListState.rebuild((b) => b
    ..sortAscending = b.sortField != action.field || !b.sortAscending
    ..sortField = action.field);
}

final songsReducer = combineReducers<SongState>([
  TypedReducer<SongState, SaveSongSuccess>(_updateSong),
  TypedReducer<SongState, AddSongSuccess>(_addSong),
  TypedReducer<SongState, LoadSongsSuccess>(_setLoadedSongs),
  TypedReducer<SongState, ArchiveSongRequest>(_archiveSongRequest),
  TypedReducer<SongState, ArchiveSongSuccess>(_archiveSongSuccess),
  TypedReducer<SongState, ArchiveSongFailure>(_archiveSongFailure),
  TypedReducer<SongState, DeleteSongRequest>(_deleteSongRequest),
  TypedReducer<SongState, DeleteSongSuccess>(_deleteSongSuccess),
  TypedReducer<SongState, DeleteSongFailure>(_deleteSongFailure),
  TypedReducer<SongState, RestoreSongRequest>(_restoreSongRequest),
  TypedReducer<SongState, RestoreSongSuccess>(_restoreSongSuccess),
  TypedReducer<SongState, RestoreSongFailure>(_restoreSongFailure),
]);

SongState _archiveSongRequest(
    SongState songState, ArchiveSongRequest action) {
  final song = songState.map[action.songId]
      .rebuild((b) => b..archivedAt = DateTime.now().millisecondsSinceEpoch);

  return songState.rebuild((b) => b..map[action.songId] = song);
}

SongState _archiveSongSuccess(
    SongState songState, ArchiveSongSuccess action) {
  return songState
      .rebuild((b) => b..map[action.song.id] = action.song);
}

SongState _archiveSongFailure(
    SongState songState, ArchiveSongFailure action) {
  return songState
      .rebuild((b) => b..map[action.song.id] = action.song);
}

SongState _deleteSongRequest(
    SongState songState, DeleteSongRequest action) {
  final song = songState.map[action.songId].rebuild((b) => b
    ..archivedAt = DateTime.now().millisecondsSinceEpoch
    ..isDeleted = true);

  return songState.rebuild((b) => b..map[action.songId] = song);
}

SongState _deleteSongSuccess(
    SongState songState, DeleteSongSuccess action) {
  return songState
      .rebuild((b) => b..map[action.song.id] = action.song);
}

SongState _deleteSongFailure(
    SongState songState, DeleteSongFailure action) {
  return songState
      .rebuild((b) => b..map[action.song.id] = action.song);
}

SongState _restoreSongRequest(
    SongState songState, RestoreSongRequest action) {
  final song = songState.map[action.songId].rebuild((b) => b
    ..archivedAt = null
    ..isDeleted = false);
  return songState.rebuild((b) => b..map[action.songId] = song);
}

SongState _restoreSongSuccess(
    SongState songState, RestoreSongSuccess action) {
  return songState
      .rebuild((b) => b..map[action.song.id] = action.song);
}

SongState _restoreSongFailure(
    SongState songState, RestoreSongFailure action) {
  return songState
      .rebuild((b) => b..map[action.song.id] = action.song);
}

SongState _addSong(SongState songState, AddSongSuccess action) {
  return songState.rebuild((b) => b
    ..map[action.song.id] = action.song
    ..list.add(action.song.id));
}

SongState _updateSong(
    SongState songState, SaveSongSuccess action) {
  return songState
      .rebuild((b) => b..map[action.song.id] = action.song);
}

SongState _setLoadedSongs(
    SongState songState, LoadSongsSuccess action) {
  final state = songState.rebuild((b) => b
    ..lastUpdated = DateTime.now().millisecondsSinceEpoch
    ..map.addAll(Map.fromIterable(
      action.songs,
      key: (dynamic item) => item.id,
      value: (dynamic item) => item,
    )));

  return state.rebuild((b) => b..list.replace(state.map.keys));
}
