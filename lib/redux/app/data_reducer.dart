import 'package:mudeo/data/models/entities.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:redux/redux.dart';

Reducer<DataState> dataReducer = combineReducers([
  TypedReducer<DataState, LoadSongsSuccess>(songListReducer),
]);

DataState songListReducer(DataState dataState, LoadSongsSuccess action) {
  return dataState.rebuild((b) => b
    ..songsUpdateAt = DateTime.now().millisecondsSinceEpoch
    ..songMap.addAll(Map.fromIterable(
      action.songs,
      key: (dynamic item) => item.id,
      value: (dynamic item) => item,
    )));
}

