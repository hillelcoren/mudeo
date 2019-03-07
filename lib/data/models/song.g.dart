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

Serializer<SongListResponse> _$songListResponseSerializer =
    new _$SongListResponseSerializer();
Serializer<SongItemResponse> _$songItemResponseSerializer =
    new _$SongItemResponseSerializer();
Serializer<SongEntity> _$songEntitySerializer = new _$SongEntitySerializer();
Serializer<TrackEntity> _$trackEntitySerializer = new _$TrackEntitySerializer();
Serializer<SongTrackEntity> _$songTrackEntitySerializer =
    new _$SongTrackEntitySerializer();

class _$SongListResponseSerializer
    implements StructuredSerializer<SongListResponse> {
  @override
  final Iterable<Type> types = const [SongListResponse, _$SongListResponse];
  @override
  final String wireName = 'SongListResponse';

  @override
  Iterable serialize(Serializers serializers, SongListResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'data',
      serializers.serialize(object.data,
          specifiedType:
              const FullType(BuiltList, const [const FullType(SongEntity)])),
    ];

    return result;
  }

  @override
  SongListResponse deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SongListResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(
                  BuiltList, const [const FullType(SongEntity)])) as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$SongItemResponseSerializer
    implements StructuredSerializer<SongItemResponse> {
  @override
  final Iterable<Type> types = const [SongItemResponse, _$SongItemResponse];
  @override
  final String wireName = 'SongItemResponse';

  @override
  Iterable serialize(Serializers serializers, SongItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(SongEntity)),
    ];

    return result;
  }

  @override
  SongItemResponse deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SongItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(SongEntity)) as SongEntity);
          break;
      }
    }

    return result.build();
  }
}

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
      serializers.serialize(object.genreId, specifiedType: const FullType(int)),
      'duration',
      serializers.serialize(object.duration,
          specifiedType: const FullType(int)),
      'likes',
      serializers.serialize(object.likes, specifiedType: const FullType(int)),
      'play_count',
      serializers.serialize(object.playCount,
          specifiedType: const FullType(int)),
      'like_count',
      serializers.serialize(object.likeCount,
          specifiedType: const FullType(int)),
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
    if (object.deletedAt != null) {
      result
        ..add('deleted_at')
        ..add(serializers.serialize(object.deletedAt,
            specifiedType: const FullType(int)));
    }
    if (object.updatedAt != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(object.updatedAt,
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
          result.genreId = serializers.deserialize(value,
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
        case 'play_count':
          result.playCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'like_count':
          result.likeCount = serializers.deserialize(value,
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
        case 'deleted_at':
          result.deletedAt = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
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

class _$SongListResponse extends SongListResponse {
  @override
  final BuiltList<SongEntity> data;

  factory _$SongListResponse([void updates(SongListResponseBuilder b)]) =>
      (new SongListResponseBuilder()..update(updates)).build();

  _$SongListResponse._({this.data}) : super._() {
    if (data == null) {
      throw new BuiltValueNullFieldError('SongListResponse', 'data');
    }
  }

  @override
  SongListResponse rebuild(void updates(SongListResponseBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  SongListResponseBuilder toBuilder() =>
      new SongListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SongListResponse && data == other.data;
  }

  @override
  int get hashCode {
    return $jf($jc(0, data.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SongListResponse')..add('data', data))
        .toString();
  }
}

class SongListResponseBuilder
    implements Builder<SongListResponse, SongListResponseBuilder> {
  _$SongListResponse _$v;

  ListBuilder<SongEntity> _data;
  ListBuilder<SongEntity> get data =>
      _$this._data ??= new ListBuilder<SongEntity>();
  set data(ListBuilder<SongEntity> data) => _$this._data = data;

  SongListResponseBuilder();

  SongListResponseBuilder get _$this {
    if (_$v != null) {
      _data = _$v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SongListResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SongListResponse;
  }

  @override
  void update(void updates(SongListResponseBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$SongListResponse build() {
    _$SongListResponse _$result;
    try {
      _$result = _$v ?? new _$SongListResponse._(data: data.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'SongListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SongItemResponse extends SongItemResponse {
  @override
  final SongEntity data;

  factory _$SongItemResponse([void updates(SongItemResponseBuilder b)]) =>
      (new SongItemResponseBuilder()..update(updates)).build();

  _$SongItemResponse._({this.data}) : super._() {
    if (data == null) {
      throw new BuiltValueNullFieldError('SongItemResponse', 'data');
    }
  }

  @override
  SongItemResponse rebuild(void updates(SongItemResponseBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  SongItemResponseBuilder toBuilder() =>
      new SongItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SongItemResponse && data == other.data;
  }

  @override
  int get hashCode {
    return $jf($jc(0, data.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SongItemResponse')..add('data', data))
        .toString();
  }
}

class SongItemResponseBuilder
    implements Builder<SongItemResponse, SongItemResponseBuilder> {
  _$SongItemResponse _$v;

  SongEntityBuilder _data;
  SongEntityBuilder get data => _$this._data ??= new SongEntityBuilder();
  set data(SongEntityBuilder data) => _$this._data = data;

  SongItemResponseBuilder();

  SongItemResponseBuilder get _$this {
    if (_$v != null) {
      _data = _$v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SongItemResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SongItemResponse;
  }

  @override
  void update(void updates(SongItemResponseBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$SongItemResponse build() {
    _$SongItemResponse _$result;
    try {
      _$result = _$v ?? new _$SongItemResponse._(data: data.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'SongItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
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
  final int genreId;
  @override
  final int duration;
  @override
  final int likes;
  @override
  final int playCount;
  @override
  final int likeCount;
  @override
  final bool isFlagged;
  @override
  final bool isPublic;
  @override
  final BuiltList<TrackEntity> tracks;
  @override
  final int id;
  @override
  final int deletedAt;
  @override
  final int updatedAt;

  factory _$SongEntity([void updates(SongEntityBuilder b)]) =>
      (new SongEntityBuilder()..update(updates)).build();

  _$SongEntity._(
      {this.title,
      this.description,
      this.url,
      this.artistId,
      this.genreId,
      this.duration,
      this.likes,
      this.playCount,
      this.likeCount,
      this.isFlagged,
      this.isPublic,
      this.tracks,
      this.id,
      this.deletedAt,
      this.updatedAt})
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
    if (genreId == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'genreId');
    }
    if (duration == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'duration');
    }
    if (likes == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'likes');
    }
    if (playCount == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'playCount');
    }
    if (likeCount == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'likeCount');
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
        genreId == other.genreId &&
        duration == other.duration &&
        likes == other.likes &&
        playCount == other.playCount &&
        likeCount == other.likeCount &&
        isFlagged == other.isFlagged &&
        isPublic == other.isPublic &&
        tracks == other.tracks &&
        id == other.id &&
        deletedAt == other.deletedAt &&
        updatedAt == other.updatedAt;
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
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(0,
                                                                title.hashCode),
                                                            description
                                                                .hashCode),
                                                        url.hashCode),
                                                    artistId.hashCode),
                                                genreId.hashCode),
                                            duration.hashCode),
                                        likes.hashCode),
                                    playCount.hashCode),
                                likeCount.hashCode),
                            isFlagged.hashCode),
                        isPublic.hashCode),
                    tracks.hashCode),
                id.hashCode),
            deletedAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SongEntity')
          ..add('title', title)
          ..add('description', description)
          ..add('url', url)
          ..add('artistId', artistId)
          ..add('genreId', genreId)
          ..add('duration', duration)
          ..add('likes', likes)
          ..add('playCount', playCount)
          ..add('likeCount', likeCount)
          ..add('isFlagged', isFlagged)
          ..add('isPublic', isPublic)
          ..add('tracks', tracks)
          ..add('id', id)
          ..add('deletedAt', deletedAt)
          ..add('updatedAt', updatedAt))
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

  int _genreId;
  int get genreId => _$this._genreId;
  set genreId(int genreId) => _$this._genreId = genreId;

  int _duration;
  int get duration => _$this._duration;
  set duration(int duration) => _$this._duration = duration;

  int _likes;
  int get likes => _$this._likes;
  set likes(int likes) => _$this._likes = likes;

  int _playCount;
  int get playCount => _$this._playCount;
  set playCount(int playCount) => _$this._playCount = playCount;

  int _likeCount;
  int get likeCount => _$this._likeCount;
  set likeCount(int likeCount) => _$this._likeCount = likeCount;

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

  int _deletedAt;
  int get deletedAt => _$this._deletedAt;
  set deletedAt(int deletedAt) => _$this._deletedAt = deletedAt;

  int _updatedAt;
  int get updatedAt => _$this._updatedAt;
  set updatedAt(int updatedAt) => _$this._updatedAt = updatedAt;

  SongEntityBuilder();

  SongEntityBuilder get _$this {
    if (_$v != null) {
      _title = _$v.title;
      _description = _$v.description;
      _url = _$v.url;
      _artistId = _$v.artistId;
      _genreId = _$v.genreId;
      _duration = _$v.duration;
      _likes = _$v.likes;
      _playCount = _$v.playCount;
      _likeCount = _$v.likeCount;
      _isFlagged = _$v.isFlagged;
      _isPublic = _$v.isPublic;
      _tracks = _$v.tracks?.toBuilder();
      _id = _$v.id;
      _deletedAt = _$v.deletedAt;
      _updatedAt = _$v.updatedAt;
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
              genreId: genreId,
              duration: duration,
              likes: likes,
              playCount: playCount,
              likeCount: likeCount,
              isFlagged: isFlagged,
              isPublic: isPublic,
              tracks: tracks.build(),
              id: id,
              deletedAt: deletedAt,
              updatedAt: updatedAt);
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
