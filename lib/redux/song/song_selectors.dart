import 'package:memoize/memoize.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/song_model.dart';

var memoizedSongIds = memo2(
    (BuiltMap<int, SongEntity> songMap, ArtistEntity artist) =>
        songIdsSelector(songMap, artist));

List<int> songIdsSelector(
    BuiltMap<int, SongEntity> songMap, ArtistEntity artist) {
  final songIds =
      songMap.keys.where((songId) => !artist.flaggedSong(songId)).toList();

  songIds.sort((songIda, songIdb) => songMap[songIdb].id - songMap[songIda].id);

  return songIds;
}
