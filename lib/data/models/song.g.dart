// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_catches_without_on_clauses
// ignore_for_file: avoid_returning_this
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first
// ignore_for_file: unnecessary_const
// ignore_for_file: unnecessary_new
// ignore_for_file: test_types_in_equals

Serializer<SongState> _$songStateSerializer = new _$SongStateSerializer();
Serializer<TrackState> _$trackStateSerializer = new _$TrackStateSerializer();
Serializer<SongTrackState> _$songTrackStateSerializer =
    new _$SongTrackStateSerializer();

class _$SongStateSerializer implements StructuredSerializer<SongState> {
  @override
  final Iterable<Type> types = const [SongState, _$SongState];
  @override
  final String wireName = 'SongState';

  @override
  Iterable serialize(Serializers serializers, SongState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(String)),
      'duration',
      serializers.serialize(object.duration,
          specifiedType: const FullType(int)),
      'likes',
      serializers.serialize(object.likes, specifiedType: const FullType(int)),
      'is_flagged',
      serializers.serialize(object.isFlagged,
          specifiedType: const FullType(bool)),
      'is_public',
      serializers.serialize(object.isPublic,
          specifiedType: const FullType(bool)),
    ];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(int)));
    }

    return result;
  }

  @override
  SongState deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SongStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'duration':
          result.duration = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'likes':
          result.likes = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'is_flagged':
          result.isFlagged = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'is_public':
          result.isPublic = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$TrackStateSerializer implements StructuredSerializer<TrackState> {
  @override
  final Iterable<Type> types = const [TrackState, _$TrackState];
  @override
  final String wireName = 'TrackState';

  @override
  Iterable serialize(Serializers serializers, TrackState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  TrackState deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TrackStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$SongTrackStateSerializer
    implements StructuredSerializer<SongTrackState> {
  @override
  final Iterable<Type> types = const [SongTrackState, _$SongTrackState];
  @override
  final String wireName = 'SongTrackState';

  @override
  Iterable serialize(Serializers serializers, SongTrackState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  SongTrackState deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SongTrackStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$SongState extends SongState {
  @override
  final String title;
  @override
  final String description;
  @override
  final String url;
  @override
  final int duration;
  @override
  final int likes;
  @override
  final bool isFlagged;
  @override
  final bool isPublic;
  @override
  final int id;

  factory _$SongState([void updates(SongStateBuilder b)]) =>
      (new SongStateBuilder()..update(updates)).build();

  _$SongState._(
      {this.title,
      this.description,
      this.url,
      this.duration,
      this.likes,
      this.isFlagged,
      this.isPublic,
      this.id})
      : super._() {
    if (title == null) {
      throw new BuiltValueNullFieldError('SongState', 'title');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('SongState', 'description');
    }
    if (url == null) {
      throw new BuiltValueNullFieldError('SongState', 'url');
    }
    if (duration == null) {
      throw new BuiltValueNullFieldError('SongState', 'duration');
    }
    if (likes == null) {
      throw new BuiltValueNullFieldError('SongState', 'likes');
    }
    if (isFlagged == null) {
      throw new BuiltValueNullFieldError('SongState', 'isFlagged');
    }
    if (isPublic == null) {
      throw new BuiltValueNullFieldError('SongState', 'isPublic');
    }
  }

  @override
  SongState rebuild(void updates(SongStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  SongStateBuilder toBuilder() => new SongStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SongState &&
        title == other.title &&
        description == other.description &&
        url == other.url &&
        duration == other.duration &&
        likes == other.likes &&
        isFlagged == other.isFlagged &&
        isPublic == other.isPublic &&
        id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, title.hashCode), description.hashCode),
                            url.hashCode),
                        duration.hashCode),
                    likes.hashCode),
                isFlagged.hashCode),
            isPublic.hashCode),
        id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SongState')
          ..add('title', title)
          ..add('description', description)
          ..add('url', url)
          ..add('duration', duration)
          ..add('likes', likes)
          ..add('isFlagged', isFlagged)
          ..add('isPublic', isPublic)
          ..add('id', id))
        .toString();
  }
}

class SongStateBuilder implements Builder<SongState, SongStateBuilder> {
  _$SongState _$v;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _url;
  String get url => _$this._url;
  set url(String url) => _$this._url = url;

  int _duration;
  int get duration => _$this._duration;
  set duration(int duration) => _$this._duration = duration;

  int _likes;
  int get likes => _$this._likes;
  set likes(int likes) => _$this._likes = likes;

  bool _isFlagged;
  bool get isFlagged => _$this._isFlagged;
  set isFlagged(bool isFlagged) => _$this._isFlagged = isFlagged;

  bool _isPublic;
  bool get isPublic => _$this._isPublic;
  set isPublic(bool isPublic) => _$this._isPublic = isPublic;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  SongStateBuilder();

  SongStateBuilder get _$this {
    if (_$v != null) {
      _title = _$v.title;
      _description = _$v.description;
      _url = _$v.url;
      _duration = _$v.duration;
      _likes = _$v.likes;
      _isFlagged = _$v.isFlagged;
      _isPublic = _$v.isPublic;
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SongState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SongState;
  }

  @override
  void update(void updates(SongStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$SongState build() {
    final _$result = _$v ??
        new _$SongState._(
            title: title,
            description: description,
            url: url,
            duration: duration,
            likes: likes,
            isFlagged: isFlagged,
            isPublic: isPublic,
            id: id);
    replace(_$result);
    return _$result;
  }
}

class _$TrackState extends TrackState {
  @override
  final int id;

  factory _$TrackState([void updates(TrackStateBuilder b)]) =>
      (new TrackStateBuilder()..update(updates)).build();

  _$TrackState._({this.id}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('TrackState', 'id');
    }
  }

  @override
  TrackState rebuild(void updates(TrackStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  TrackStateBuilder toBuilder() => new TrackStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrackState && id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(0, id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TrackState')..add('id', id))
        .toString();
  }
}

class TrackStateBuilder implements Builder<TrackState, TrackStateBuilder> {
  _$TrackState _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  TrackStateBuilder();

  TrackStateBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrackState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TrackState;
  }

  @override
  void update(void updates(TrackStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$TrackState build() {
    final _$result = _$v ?? new _$TrackState._(id: id);
    replace(_$result);
    return _$result;
  }
}

class _$SongTrackState extends SongTrackState {
  @override
  final int id;

  factory _$SongTrackState([void updates(SongTrackStateBuilder b)]) =>
      (new SongTrackStateBuilder()..update(updates)).build();

  _$SongTrackState._({this.id}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('SongTrackState', 'id');
    }
  }

  @override
  SongTrackState rebuild(void updates(SongTrackStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  SongTrackStateBuilder toBuilder() =>
      new SongTrackStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SongTrackState && id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(0, id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SongTrackState')..add('id', id))
        .toString();
  }
}

class SongTrackStateBuilder
    implements Builder<SongTrackState, SongTrackStateBuilder> {
  _$SongTrackState _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  SongTrackStateBuilder();

  SongTrackStateBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SongTrackState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SongTrackState;
  }

  @override
  void update(void updates(SongTrackStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$SongTrackState build() {
    final _$result = _$v ?? new _$SongTrackState._(id: id);
    replace(_$result);
    return _$result;
  }
}
