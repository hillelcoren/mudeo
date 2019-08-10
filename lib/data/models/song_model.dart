import 'dart:async';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/entities.dart';
import 'package:path_provider/path_provider.dart';

part 'song_model.g.dart';

abstract class SongEntity extends Object
    with BaseEntity
    implements SelectableEntity, Built<SongEntity, SongEntityBuilder> {
  factory SongEntity({int id, int genreId}) {
    return _$SongEntity._(
      id: id ?? DateTime.now().millisecondsSinceEpoch * -1,
      layout: kVideoLayoutRow,
      artistId: 0,
      parentId: 0,
      title: '',
      description: '',
      url: '',
      videoUrl: '',
      thumbnailUrl: '',
      genreId: genreId ?? 0,
      duration: 0,
      countPlay: 0,
      countLike: 0,
      isFlagged: false,
      isPublic: false,
      tracks: BuiltList<TrackEntity>(),
      comments: BuiltList<CommentEntity>(),
    );
  }

  SongEntity._();

  String get title;

  String get description;

  String get url;

  @nullable
  @BuiltValueField(wireName: 'user_id')
  int get artistId;

  @nullable
  @BuiltValueField(wireName: 'user')
  ArtistEntity get artist;

  @nullable
  @BuiltValueField(wireName: 'genre_id')
  int get genreId;

  @nullable
  @BuiltValueField(wireName: 'parent_id')
  int get parentId;

  int get duration;

  @nullable
  @BuiltValueField(wireName: 'count_play')
  int get countPlay;

  @nullable
  @BuiltValueField(wireName: 'count_like')
  int get countLike;

  @BuiltValueField(wireName: 'is_flagged')
  bool get isFlagged;

  @BuiltValueField(wireName: 'is_public')
  bool get isPublic;

  @BuiltValueField(wireName: 'video_url')
  String get videoUrl;

  @BuiltValueField(wireName: 'thumbnail_url')
  String get thumbnailUrl;

  @BuiltValueField(wireName: 'song_videos')
  BuiltList<TrackEntity> get tracks;

  BuiltList<CommentEntity> get comments;

  String get layout;

  @override
  String get listDisplayName {
    return title;
  }

  CommentEntity newComment(int artistId, String comment) =>
      CommentEntity(description: comment).rebuild((b) => b
        ..songId = id
        ..artistId = artistId);

  TrackEntity newTrack(VideoEntity video) =>
      TrackEntity(video: video, orderId: tracks.length);

  VideoEntity get newVideo => trackWithNewVideo?.video;

  bool get hasNewVideos => newVideo != null;

  bool get hasParent => parentId != null && parentId > 0;

  TrackEntity get trackWithNewVideo =>
      tracks.firstWhere((track) => track.video.isNew, orElse: () => null);

  SongEntity setTrackVolume(TrackEntity track, int volume) {
    final index = tracks.indexOf(track);
    final updatedTrack = track.rebuild((b) => b..volume = volume);
    return rebuild((b) => b..tracks[index] = updatedTrack);
  }

  SongEntity setTrackDelay(TrackEntity track, int delay) {
    final index = tracks.indexOf(track);
    final updatedTrack = track.rebuild((b) => b..delay = delay);
    return rebuild((b) => b..tracks[index] = updatedTrack);
  }

  List<String> get videoURLs =>
      tracks.map((track) => track.video.url).toList()..add(videoUrl);

  bool get canAddTrack =>
      tracks.where((track) => track.isIncluded ?? true).length < kMaxTracks;

  SongEntity get fork => rebuild((b) => b
    ..parentId = id
    ..id = DateTime.now().millisecondsSinceEpoch * -1);

  SongEntity get updateOrderByIds {
    int counter = 0;
    final sortedTracks = List<TrackEntity>();

    tracks.forEach((track) {
      final updatedTrack = track.rebuild((b) => b..orderId = counter);
      sortedTracks.insert(counter++, updatedTrack);
    });

    return rebuild((b) => b..tracks.replace(sortedTracks));
  }

  static Serializer<SongEntity> get serializer => _$songEntitySerializer;
}

abstract class TrackEntity extends Object
    with BaseEntity
    implements Built<TrackEntity, TrackEntityBuilder> {
  factory TrackEntity({int id, int orderId, VideoEntity video}) {
    return _$TrackEntity._(
      id: id ?? DateTime.now().millisecondsSinceEpoch * -1,
      volume: kDefaultTrackVolume,
      orderId: orderId ?? 0,
      isIncluded: true,
      video: video ?? VideoEntity(),
      delay: 0,
    );
  }

  TrackEntity._();

  TrackEntity get clone => rebuild(
        (b) => b..id = DateTime.now().millisecondsSinceEpoch * -1,
      );

  @nullable
  @BuiltValueField(wireName: 'is_included')
  bool get isIncluded;

  @nullable
  int get delay;

  @nullable
  int get volume;

  @nullable
  @BuiltValueField(wireName: 'order_id')
  int get orderId;

  VideoEntity get video;

  @override
  String get listDisplayName {
    return orderId.toString();
  }

  static Serializer<TrackEntity> get serializer => _$trackEntitySerializer;
}

abstract class CommentEntity extends Object
    with BaseEntity
    implements Built<CommentEntity, CommentEntityBuilder> {
  factory CommentEntity({int id, String description}) {
    return _$CommentEntity._(
      id: id ?? DateTime.now().millisecondsSinceEpoch * -1,
      artist: ArtistEntity(),
      artistId: 0,
      songId: 0,
      description: description ?? '',
    );
  }

  CommentEntity._();

  @BuiltValueField(wireName: 'user')
  ArtistEntity get artist;

  @BuiltValueField(wireName: 'user_id')
  int get artistId;

  @BuiltValueField(wireName: 'song_id')
  int get songId;

  String get description;

  @override
  String get listDisplayName {
    return description;
  }

  static Serializer<CommentEntity> get serializer => _$commentEntitySerializer;
}

abstract class SongLikeEntity extends Object
    with BaseEntity
    implements Built<SongLikeEntity, SongLikeEntityBuilder> {
  factory SongLikeEntity() {
    return _$SongLikeEntity._(
      id: 0,
      userId: 0,
      songId: 0,
    );
  }

  SongLikeEntity._();

  int get id;

  @BuiltValueField(wireName: 'user_id')
  int get userId;

  @BuiltValueField(wireName: 'song_id')
  int get songId;

  @override
  String get listDisplayName {
    return 'Like $songId';
  }

  static Serializer<SongLikeEntity> get serializer =>
      _$songLikeEntitySerializer;
}

abstract class SongFlagEntity extends Object
    with BaseEntity
    implements Built<SongFlagEntity, SongFlagEntityBuilder> {
  factory SongFlagEntity() {
    return _$SongFlagEntity._(
      id: 0,
      userId: 0,
      songId: 0,
    );
  }

  SongFlagEntity._();

  int get id;

  @BuiltValueField(wireName: 'user_id')
  int get userId;

  @BuiltValueField(wireName: 'song_id')
  int get songId;

  @override
  String get listDisplayName {
    return 'Flag $songId';
  }

  static Serializer<SongFlagEntity> get serializer =>
      _$songFlagEntitySerializer;
}

abstract class ArtistFlagEntity extends Object
    with BaseEntity
    implements Built<ArtistFlagEntity, ArtistFlagEntityBuilder> {
  factory ArtistFlagEntity({int artistId}) {
    return _$ArtistFlagEntity._(
      id: 0,
      artistId: artistId ?? 0,
    );
  }

  ArtistFlagEntity._();

  int get id;

  @BuiltValueField(wireName: 'user_id')
  int get artistId;

  @override
  String get listDisplayName {
    return 'Flag $artistId';
  }

  static Serializer<ArtistFlagEntity> get serializer =>
      _$artistFlagEntitySerializer;
}

abstract class VideoEntity extends Object
    with BaseEntity
    implements Built<VideoEntity, VideoEntityBuilder> {
  factory VideoEntity({int id}) {
    return _$VideoEntity._(
      id: id ?? DateTime.now().millisecondsSinceEpoch * -1,
      userId: 0,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      url: '',
      thumbnailUrl: '',
      description: '',
      duration: 0,
    );
  }

  VideoEntity._();

  @BuiltValueField(wireName: 'user_id')
  int get userId;

  @nullable
  int get timestamp;

  @nullable
  String get url;

  @nullable
  @BuiltValueField(wireName: 'thumbnail_url')
  String get thumbnailUrl;

  @nullable
  @BuiltValueField(wireName: 'remote_video_id')
  String get remoteVideoId;

  @override
  String get listDisplayName {
    return timestamp.toString();
  }

  @nullable
  String get description;

  @nullable
  int get duration;

  bool get hasThumbnail => thumbnailUrl != null && thumbnailUrl.isNotEmpty;

  bool get isRemoteVideo => remoteVideoId != null && remoteVideoId.isNotEmpty;

  String get remoteVideoUrl => 'https://www.youtube.com/watch?v=$remoteVideoId';

  static Future<String> getPath(int timestamp) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String folder = '${directory.path}/videos';
    await Directory(folder).create(recursive: true);
    return '$folder/$timestamp.mp4';
  }

  static Serializer<VideoEntity> get serializer => _$videoEntitySerializer;
}

abstract class SongListResponse
    implements Built<SongListResponse, SongListResponseBuilder> {
  factory SongListResponse([void updates(SongListResponseBuilder b)]) =
      _$SongListResponse;

  SongListResponse._();

  BuiltList<SongEntity> get data;

  static Serializer<SongListResponse> get serializer =>
      _$songListResponseSerializer;
}

abstract class SongItemResponse
    implements Built<SongItemResponse, SongItemResponseBuilder> {
  factory SongItemResponse([void updates(SongItemResponseBuilder b)]) =
      _$SongItemResponse;

  SongItemResponse._();

  SongEntity get data;

  static Serializer<SongItemResponse> get serializer =>
      _$songItemResponseSerializer;
}

abstract class CommentItemResponse
    implements Built<CommentItemResponse, CommentItemResponseBuilder> {
  factory CommentItemResponse([void updates(CommentItemResponseBuilder b)]) =
      _$CommentItemResponse;

  CommentItemResponse._();

  CommentEntity get data;

  static Serializer<CommentItemResponse> get serializer =>
      _$commentItemResponseSerializer;
}

abstract class LikeSongResponse
    implements Built<LikeSongResponse, LikeSongResponseBuilder> {
  factory LikeSongResponse([void updates(LikeSongResponseBuilder b)]) =
      _$LikeSongResponse;

  LikeSongResponse._();

  SongLikeEntity get data;

  static Serializer<LikeSongResponse> get serializer =>
      _$likeSongResponseSerializer;
}

abstract class FlagSongResponse
    implements Built<FlagSongResponse, FlagSongResponseBuilder> {
  factory FlagSongResponse([void updates(FlagSongResponseBuilder b)]) =
      _$FlagSongResponse;

  FlagSongResponse._();

  SongFlagEntity get data;

  static Serializer<FlagSongResponse> get serializer =>
      _$flagSongResponseSerializer;
}

abstract class VideoItemResponse
    implements Built<VideoItemResponse, VideoItemResponseBuilder> {
  factory VideoItemResponse([void updates(VideoItemResponseBuilder b)]) =
      _$VideoItemResponse;

  VideoItemResponse._();

  VideoEntity get data;

  static Serializer<VideoItemResponse> get serializer =>
      _$videoItemResponseSerializer;
}
