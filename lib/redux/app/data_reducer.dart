import 'package:mudeo/data/models/entities.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:redux/redux.dart';

Reducer<DataState> dataReducer = combineReducers([
  TypedReducer<DataState, LoadSongsSuccess>(loadSongsSuccessReducer),
  TypedReducer<DataState, LoadSongsFailure>(loadSongsFailureReducer),
]);

DataState loadSongsSuccessReducer(DataState dataState, LoadSongsSuccess action) {
  return dataState.rebuild((b) => b
    ..songsUpdateAt = DateTime.now().millisecondsSinceEpoch
    ..songMap.addAll(Map.fromIterable(
      action.songs,
      key: (dynamic item) => item.id,
      value: (dynamic item) => item,
    )));
}

DataState loadSongsFailureReducer(DataState dataState, LoadSongsFailure action) {
  return dataState.rebuild((b) => b
    ..songsTriedAt = DateTime.now().millisecondsSinceEpoch);
}

