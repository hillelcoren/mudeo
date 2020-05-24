import 'package:memoize/memoize.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/song_model.dart';

var memoizedSongIds = memo4(
    (BuiltMap<int, SongEntity> songMap, ArtistEntity artist,
            [int filterArtistId, String filter]) =>
        songIdsSelector(songMap, artist, filterArtistId, filter));

List<int> songIdsSelector(
    BuiltMap<int, SongEntity> songMap, ArtistEntity artist,
    [int filterArtistId, String filter]) {
  final songIds = songMap.keys.where((songId) {
    final song = songMap[songId];

    if (filterArtistId != null) {
      bool isMatch = false;

      if (song.artistId == filterArtistId) {
        isMatch = true;
      } else if (song.joinedArtists
          .any((artist) => artist.id == filterArtistId)) {
        isMatch = true;
      }

      if (!isMatch) {
        return false;
      }
    } else {
      if (!song.isApproved) {
        return false;
      }

      if (filter == kSongFilterFeatured && !song.isFeatured) {
        return false;
      } else if (filter == kSongFilterNewest && song.isFeatured) {
        return false;
      }
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

  songMap.forEach((key, child) {
    if (child.hasParent && child.parentId == song.id && child.isActive) {
      songIds.add(child.id);
    }
  });

  return songIds;
}
