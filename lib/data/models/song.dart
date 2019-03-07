import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:mudeo/data/models/entities.dart';

part 'song.g.dart';

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

abstract class SongEntity extends BaseEntity
    implements SelectableEntity, Built<SongEntity, SongEntityBuilder> {
  factory SongEntity() {
    return _$SongEntity._(
      id: 0,
      artistId: 0,
      title: '',
      description: '',
      url: '',
      genreId: 0,
      duration: 0,
      likes: 0,
      playCount: 0,
      likeCount: 0,
      isFlagged: false,
      isPublic: false,
      tracks: BuiltList<TrackEntity>(),
    );
  }

  SongEntity._();

  String get title;

  String get description;

  String get url;

  @BuiltValueField(wireName: 'artist_id')
  int get artistId;

  @BuiltValueField(wireName: 'category_id')
  int get genreId;

  int get duration;

  int get likes;

  @BuiltValueField(wireName: 'play_count')
  int get playCount;

  @BuiltValueField(wireName: 'like_count')
  int get likeCount;

  @BuiltValueField(wireName: 'is_flagged')
  bool get isFlagged;

  @BuiltValueField(wireName: 'is_public')
  bool get isPublic;

  BuiltList<TrackEntity> get tracks;

  @override
  String get listDisplayName {
    return title;
  }

  static Serializer<SongEntity> get serializer => _$songEntitySerializer;
}

abstract class TrackEntity
    implements Built<TrackEntity, TrackEntityBuilder> {
  factory TrackEntity() {
    return _$TrackEntity._(
      id: 0,
    );
  }

  TrackEntity._();

  int get id;

  static Serializer<TrackEntity> get serializer => _$trackEntitySerializer;
}


abstract class SongTrackEntity
    implements Built<SongTrackEntity, SongTrackEntityBuilder> {
  factory SongTrackEntity() {
    return _$SongTrackEntity._(
    );
  }

  SongTrackEntity._();

  int get id;

  static Serializer<SongTrackEntity> get serializer => _$songTrackEntitySerializer;
}

