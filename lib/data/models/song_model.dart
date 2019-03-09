import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:mudeo/data/models/entities.dart';

part 'song_model.g.dart';

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

abstract class SongEntity extends Object
    with BaseEntity
    implements SelectableEntity, Built<SongEntity, SongEntityBuilder> {
  factory SongEntity({int id}) {
    return _$SongEntity._(
      id: id ?? --SongEntity.counter,
      artistId: 0,
      title: '',
      description: '',
      url: '',
      genreId: 0,
      duration: 0,
      playCount: 0,
      likeCount: 0,
      isFlagged: false,
      isPublic: false,
      tracks: BuiltList<TrackEntity>(),
      isChanged: false,
    );
  }

  SongEntity._();

  static int counter = 0;

  String get title;

  String get description;

  String get url;

  @nullable
  @BuiltValueField(wireName: 'artist_id')
  int get artistId;

  @nullable
  @BuiltValueField(wireName: 'category_id')
  int get genreId;

  int get duration;

  @nullable
  @BuiltValueField(wireName: 'play_count')
  int get playCount;

  @nullable
  @BuiltValueField(wireName: 'like_count')
  int get likeCount;

  @BuiltValueField(wireName: 'is_flagged')
  bool get isFlagged;

  @BuiltValueField(wireName: 'is_public')
  bool get isPublic;

  @BuiltValueField(wireName: 'song_videos')
  BuiltList<TrackEntity> get tracks;

  @override
  String get listDisplayName {
    return title;
  }

  @nullable
  bool get isChanged;

  TrackEntity newTrack(VideoEntity video) =>
      TrackEntity(video: video, orderId: tracks.length);

  static Serializer<SongEntity> get serializer => _$songEntitySerializer;
}

abstract class TrackEntity implements Built<TrackEntity, TrackEntityBuilder> {
  factory TrackEntity({int id, int orderId, VideoEntity video}) {
    return _$TrackEntity._(
      id: id ?? --TrackEntity.counter,
      volume: 0,
      orderId: orderId ?? 0,
      video: video ?? VideoEntity(),
    );
  }

  TrackEntity._();

  static int counter = 0;

  int get id;

  @nullable
  int get volume;

  @nullable
  int get orderId;

  @nullable
  VideoEntity get video;

  static Serializer<TrackEntity> get serializer => _$trackEntitySerializer;
}

abstract class VideoEntity implements Built<VideoEntity, VideoEntityBuilder> {
  factory VideoEntity({int id}) {
    return _$VideoEntity._(
      id: id ?? --VideoEntity.counter,
      userId: 0,
      timestamp: 0,
    );
  }

  VideoEntity._();

  static int counter = 0;

  int get id;

  int get userId;

  int get timestamp;

  static Serializer<VideoEntity> get serializer => _$videoEntitySerializer;
}
