import 'package:mudeo/data/models/entities.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:redux/redux.dart';

Reducer<DataState> dataReducer = combineReducers([
  TypedReducer<DataState, LoadSongsSuccess>(loadSongsSuccessReducer),
  TypedReducer<DataState, LoadSongsFailure>(loadSongsFailureReducer),
  TypedReducer<DataState, AddSongSuccess>(addSongReducer),
  TypedReducer<DataState, SaveSongSuccess>(saveSongReducer),
  TypedReducer<DataState, LikeSongSuccess>(likeSongReducer),
  TypedReducer<DataState, SaveCommentSuccess>(saveCommentReducer),
  TypedReducer<DataState, DeleteCommentSuccess>(deleteCommentReducer),
  TypedReducer<DataState, DeleteSongSuccess>(deleteSongReducer),
  TypedReducer<DataState, JoinSongSuccess>(joinSongReducer),
  TypedReducer<DataState, LeaveSongSuccess>(leaveSongReducer),
]);

DataState loadSongsSuccessReducer(
    DataState dataState, LoadSongsSuccess action) {
  return dataState.rebuild((b) => b
    ..songsUpdateAt = DateTime.now().millisecondsSinceEpoch
    ..songsFailedAt = 0
    ..songMap.addAll(Map.fromIterable(
      action.songs,
      key: (dynamic item) => item.id,
      value: (dynamic item) => item,
    )));
}

DataState loadSongsFailureReducer(
    DataState dataState, LoadSongsFailure action) {
  return dataState
      .rebuild((b) => b..songsFailedAt = DateTime.now().millisecondsSinceEpoch);
}

DataState addSongReducer(DataState dataState, AddSongSuccess action) {
  return dataState.rebuild((b) => b..songMap[action.song.id] = action.song);
}

DataState saveSongReducer(DataState dataState, SaveSongSuccess action) {
  return dataState.rebuild((b) => b..songMap[action.song.id] = action.song);
}

DataState deleteSongReducer(DataState dataState, DeleteSongSuccess action) {
  return dataState.rebuild((b) => b..songMap[action.song.id] = action.song);
}

DataState joinSongReducer(DataState dataState, JoinSongSuccess action) {
  return dataState.rebuild((b) => b..songMap[action.song.id] = action.song);
}

DataState leaveSongReducer(DataState dataState, LeaveSongSuccess action) {
  return dataState.rebuild((b) => b..songMap.remove(action.songId));
}

DataState likeSongReducer(DataState dataState, LikeSongSuccess action) {
  final song = dataState.songMap[action.songLike.songId];
  return dataState.rebuild((b) => b
    ..songMap[action.songLike.songId] = song.rebuild(
        (b) => b..countLike = song.countLike + (action.unlike ? -1 : 1)));
}

DataState saveCommentReducer(DataState dataState, SaveCommentSuccess action) {
  final song = dataState.songMap[action.comment.songId];
  return dataState.rebuild((b) => b
    ..songMap[song.id] = song.rebuild((b) => b..comments.add(action.comment)));
}

DataState deleteCommentReducer(
    DataState dataState, DeleteCommentSuccess action) {
  final song = dataState.songMap[action.comment.songId];
  return dataState.rebuild((b) => b
    ..songMap[song.id] = song.rebuild((b) =>
        b..comments.removeWhere((comment) => comment.id == action.comment.id)));
}
