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

Serializer<SongEntity> _$songEntitySerializer = new _$SongEntitySerializer();
Serializer<TrackEntity> _$trackEntitySerializer = new _$TrackEntitySerializer();
Serializer<SongTrackEntity> _$songTrackEntitySerializer =
    new _$SongTrackEntitySerializer();

class _$SongEntitySerializer implements StructuredSerializer<SongEntity> {
  @override
  final Iterable<Type> types = const [SongEntity, _$SongEntity];
  @override
  final String wireName = 'SongEntity';

  @override
  Iterable serialize(Serializers serializers, SongEntity object,
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
      'artist_id',
      serializers.serialize(object.artistId,
          specifiedType: const FullType(int)),
      'category_id',
      serializers.serialize(object.categoryId,
          specifiedType: const FullType(int)),
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
      'tracks',
      serializers.serialize(object.tracks,
          specifiedType:
              const FullType(BuiltList, const [const FullType(TrackEntity)])),
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
  SongEntity deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SongEntityBuilder();

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
        case 'artist_id':
          result.artistId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'category_id':
          result.categoryId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
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
        case 'tracks':
          result.tracks.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(TrackEntity)]))
              as BuiltList);
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

class _$TrackEntitySerializer implements StructuredSerializer<TrackEntity> {
  @override
  final Iterable<Type> types = const [TrackEntity, _$TrackEntity];
  @override
  final String wireName = 'TrackEntity';

  @override
  Iterable serialize(Serializers serializers, TrackEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  TrackEntity deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TrackEntityBuilder();

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

class _$SongTrackEntitySerializer
    implements StructuredSerializer<SongTrackEntity> {
  @override
  final Iterable<Type> types = const [SongTrackEntity, _$SongTrackEntity];
  @override
  final String wireName = 'SongTrackEntity';

  @override
  Iterable serialize(Serializers serializers, SongTrackEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  SongTrackEntity deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SongTrackEntityBuilder();

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

class _$SongEntity extends SongEntity {
  @override
  final String title;
  @override
  final String description;
  @override
  final String url;
  @override
  final int artistId;
  @override
  final int categoryId;
  @override
  final int duration;
  @override
  final int likes;
  @override
  final bool isFlagged;
  @override
  final bool isPublic;
  @override
  final BuiltList<TrackEntity> tracks;
  @override
  final int id;

  factory _$SongEntity([void updates(SongEntityBuilder b)]) =>
      (new SongEntityBuilder()..update(updates)).build();

  _$SongEntity._(
      {this.title,
      this.description,
      this.url,
      this.artistId,
      this.categoryId,
      this.duration,
      this.likes,
      this.isFlagged,
      this.isPublic,
      this.tracks,
      this.id})
      : super._() {
    if (title == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'title');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'description');
    }
    if (url == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'url');
    }
    if (artistId == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'artistId');
    }
    if (categoryId == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'categoryId');
    }
    if (duration == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'duration');
    }
    if (likes == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'likes');
    }
    if (isFlagged == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'isFlagged');
    }
    if (isPublic == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'isPublic');
    }
    if (tracks == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'tracks');
    }
  }

  @override
  SongEntity rebuild(void updates(SongEntityBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  SongEntityBuilder toBuilder() => new SongEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SongEntity &&
        title == other.title &&
        description == other.description &&
        url == other.url &&
        artistId == other.artistId &&
        categoryId == other.categoryId &&
        duration == other.duration &&
        likes == other.likes &&
        isFlagged == other.isFlagged &&
        isPublic == other.isPublic &&
        tracks == other.tracks &&
        id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc($jc(0, title.hashCode),
                                            description.hashCode),
                                        url.hashCode),
                                    artistId.hashCode),
                                categoryId.hashCode),
                            duration.hashCode),
                        likes.hashCode),
                    isFlagged.hashCode),
                isPublic.hashCode),
            tracks.hashCode),
        id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SongEntity')
          ..add('title', title)
          ..add('description', description)
          ..add('url', url)
          ..add('artistId', artistId)
          ..add('categoryId', categoryId)
          ..add('duration', duration)
          ..add('likes', likes)
          ..add('isFlagged', isFlagged)
          ..add('isPublic', isPublic)
          ..add('tracks', tracks)
          ..add('id', id))
        .toString();
  }
}

class SongEntityBuilder implements Builder<SongEntity, SongEntityBuilder> {
  _$SongEntity _$v;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _url;
  String get url => _$this._url;
  set url(String url) => _$this._url = url;

  int _artistId;
  int get artistId => _$this._artistId;
  set artistId(int artistId) => _$this._artistId = artistId;

  int _categoryId;
  int get categoryId => _$this._categoryId;
  set categoryId(int categoryId) => _$this._categoryId = categoryId;

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

  ListBuilder<TrackEntity> _tracks;
  ListBuilder<TrackEntity> get tracks =>
      _$this._tracks ??= new ListBuilder<TrackEntity>();
  set tracks(ListBuilder<TrackEntity> tracks) => _$this._tracks = tracks;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  SongEntityBuilder();

  SongEntityBuilder get _$this {
    if (_$v != null) {
      _title = _$v.title;
      _description = _$v.description;
      _url = _$v.url;
      _artistId = _$v.artistId;
      _categoryId = _$v.categoryId;
      _duration = _$v.duration;
      _likes = _$v.likes;
      _isFlagged = _$v.isFlagged;
      _isPublic = _$v.isPublic;
      _tracks = _$v.tracks?.toBuilder();
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SongEntity other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SongEntity;
  }

  @override
  void update(void updates(SongEntityBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$SongEntity build() {
    _$SongEntity _$result;
    try {
      _$result = _$v ??
          new _$SongEntity._(
              title: title,
              description: description,
              url: url,
              artistId: artistId,
              categoryId: categoryId,
              duration: duration,
              likes: likes,
              isFlagged: isFlagged,
              isPublic: isPublic,
              tracks: tracks.build(),
              id: id);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'tracks';
        tracks.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'SongEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$TrackEntity extends TrackEntity {
  @override
  final int id;

  factory _$TrackEntity([void updates(TrackEntityBuilder b)]) =>
      (new TrackEntityBuilder()..update(updates)).build();

  _$TrackEntity._({this.id}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('TrackEntity', 'id');
    }
  }

  @override
  TrackEntity rebuild(void updates(TrackEntityBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  TrackEntityBuilder toBuilder() => new TrackEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrackEntity && id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(0, id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TrackEntity')..add('id', id))
        .toString();
  }
}

class TrackEntityBuilder implements Builder<TrackEntity, TrackEntityBuilder> {
  _$TrackEntity _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  TrackEntityBuilder();

  TrackEntityBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrackEntity other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TrackEntity;
  }

  @override
  void update(void updates(TrackEntityBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$TrackEntity build() {
    final _$result = _$v ?? new _$TrackEntity._(id: id);
    replace(_$result);
    return _$result;
  }
}

class _$SongTrackEntity extends SongTrackEntity {
  @override
  final int id;

  factory _$SongTrackEntity([void updates(SongTrackEntityBuilder b)]) =>
      (new SongTrackEntityBuilder()..update(updates)).build();

  _$SongTrackEntity._({this.id}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('SongTrackEntity', 'id');
    }
  }

  @override
  SongTrackEntity rebuild(void updates(SongTrackEntityBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  SongTrackEntityBuilder toBuilder() =>
      new SongTrackEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SongTrackEntity && id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(0, id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SongTrackEntity')..add('id', id))
        .toString();
  }
}

class SongTrackEntityBuilder
    implements Builder<SongTrackEntity, SongTrackEntityBuilder> {
  _$SongTrackEntity _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  SongTrackEntityBuilder();

  SongTrackEntityBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SongTrackEntity other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SongTrackEntity;
  }

  @override
  void update(void updates(SongTrackEntityBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$SongTrackEntity build() {
    final _$result = _$v ?? new _$SongTrackEntity._(id: id);
    replace(_$result);
    return _$result;
  }
}
