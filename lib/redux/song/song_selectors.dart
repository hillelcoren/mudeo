import 'package:memoize/memoize.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/song_model.dart';

var memoizedSongIds = memo3(
    (BuiltMap<int, SongEntity> songMap, ArtistEntity artist,
            [int filterArtistId]) =>
        songIdsSelector(songMap, artist, filterArtistId));

List<int> songIdsSelector(
    BuiltMap<int, SongEntity> songMap, ArtistEntity artist,
    [int filterArtistId]) {
  final songIds = songMap.keys.where((songId) {
    final song = songMap[songId];

    if (filterArtistId != null && song.artistId != filterArtistId) {
      return false;
    }

    if (song.isDeleted) {
      return false;
    }

    return !artist.flaggedSong(songId) && !artist.flaggedArtist(song.artistId);
  }).toList();

  songIds.sort((songIda, songIdb) => songMap[songIdb].id - songMap[songIda].id);

  return songIds;
}

var memoizedChildSongIds = memo2(
    (BuiltMap<int, SongEntity> songMap, SongEntity song) =>
        childSongIdsSelector(songMap, song));

List<int> childSongIdsSelector(
    BuiltMap<int, SongEntity> songMap, SongEntity song) {
  List<int> songIds = [];

  songMap.forEach((key, value) {
    if (value.hasParent && value.parentId == song.parentId && value.isActive) {
      songIds.add(song.id);
    }
  });

  return songIds;
}
