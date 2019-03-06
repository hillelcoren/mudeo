import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:mudeo/data/models/entities.dart';

part 'song.g.dart';

abstract class SongState
    implements SelectableEntity, Built<SongState, SongStateBuilder> {
  factory SongState() {
    return _$SongState._(
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

  SongState._();

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

  static Serializer<SongState> get serializer => _$songStateSerializer;
}

abstract class TrackState
    implements Built<TrackState, TrackStateBuilder> {
  factory TrackState() {
    return _$TrackState._();
  }

  TrackState._();

  int get id;

  static Serializer<TrackState> get serializer => _$trackStateSerializer;
}


abstract class SongTrackState
    implements Built<SongTrackState, SongTrackStateBuilder> {
  factory SongTrackState() {
    return _$SongTrackState._(
    );
  }

  SongTrackState._();

  int get id;

  static Serializer<SongTrackState> get serializer => _$songTrackStateSerializer;
}

