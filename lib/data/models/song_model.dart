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
      artistId: 0,
      parentId: 0,
      title: '',
      description: '',
      url: '',
      videoUrl: '',
      genreId: genreId ?? 0,
      duration: 0,
      countPlay: 0,
      countLink: 0,
      isFlagged: false,
      isPublic: false,
      tracks: BuiltList<TrackEntity>(),
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
  int get countLink;

  @BuiltValueField(wireName: 'is_flagged')
  bool get isFlagged;

  @BuiltValueField(wireName: 'is_public')
  bool get isPublic;

  @BuiltValueField(wireName: 'video_url')
  String get videoUrl;

  @BuiltValueField(wireName: 'song_videos')
  BuiltList<TrackEntity> get tracks;

  @override
  String get listDisplayName {
    return title;
  }

  TrackEntity newTrack(VideoEntity video) =>
      TrackEntity(video: video, orderId: tracks.length);

  VideoEntity get newVideo => trackWithNewVideo?.video;

  bool get hasNewVideos => newVideo != null;

  TrackEntity get trackWithNewVideo =>
      tracks.firstWhere((track) => track.video.isNew, orElse: () => null);

  SongEntity setTrackVolume(TrackEntity track, int volume) {
    final index = tracks.indexOf(track);
    final updatedTrack = track.rebuild((b) => b..volume = volume);
    return rebuild((b) => b..tracks[index] = updatedTrack);
  }

  bool get canAddTrack => tracks.length < kMaxTracks;

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
      video: video ?? VideoEntity(),
    );
  }

  TrackEntity._();

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
    return '$songId';
  }

  static Serializer<SongLikeEntity> get serializer =>
      _$songLikeEntitySerializer;
}

abstract class VideoEntity extends Object
    with BaseEntity
    implements Built<VideoEntity, VideoEntityBuilder> {
  factory VideoEntity({int id}) {
    return _$VideoEntity._(
      id: id ?? DateTime.now().millisecondsSinceEpoch * -1,
      userId: 0,
      timestamp: 0,
      url: '',
      thumbnailUrl: '',
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

  @override
  String get listDisplayName {
    return timestamp.toString();
  }

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

abstract class LikeSongResponse
    implements Built<LikeSongResponse, LikeSongResponseBuilder> {
  factory LikeSongResponse([void updates(LikeSongResponseBuilder b)]) =
      _$LikeSongResponse;

  LikeSongResponse._();

  SongLikeEntity get data;

  static Serializer<LikeSongResponse> get serializer =>
      _$likeSongResponseSerializer;
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
