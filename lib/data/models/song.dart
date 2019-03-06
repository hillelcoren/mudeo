import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:mudeo/data/models/entities.dart';

part 'song.g.dart';

abstract class SongEntity
    implements SelectableEntity, Built<SongEntity, SongEntityBuilder> {
  factory SongEntity() {
    return _$SongEntity._(
      id: 0,
      title: '',
      description: '',
      url: '',
      duration: 0,
      likes: 0,
      isFlagged: false,
      isPublic: false,
    );
  }

  SongEntity._();

  String get title;

  String get description;

  String get url;

  int get duration;

  int get likes;

  @BuiltValueField(wireName: 'is_flagged')
  bool get isFlagged;

  @BuiltValueField(wireName: 'is_public')
  bool get isPublic;

  @override
  String get listDisplayName {
    return title;
  }

  static Serializer<SongEntity> get serializer => _$songEntitySerializer;
}

abstract class TrackEntity
    implements Built<TrackEntity, TrackEntityBuilder> {
  factory TrackEntity() {
    return _$TrackEntity._();
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

