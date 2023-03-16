// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entities.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EntityAction _$like = const EntityAction._('like');

EntityAction _$valueOf(String name) {
  switch (name) {
    case 'like':
      return _$like;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<EntityAction> _$values =
    new BuiltSet<EntityAction>(const <EntityAction>[
  _$like,
]);

const EntityType _$song = const EntityType._('song');

EntityType _$typeValueOf(String name) {
  switch (name) {
    case 'song':
      return _$song;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<EntityType> _$typeValues =
    new BuiltSet<EntityType>(const <EntityType>[
  _$song,
]);

Serializer<ErrorMessage> _$errorMessageSerializer =
    new _$ErrorMessageSerializer();
Serializer<LoginResponse> _$loginResponseSerializer =
    new _$LoginResponseSerializer();
Serializer<LoginResponseData> _$loginResponseDataSerializer =
    new _$LoginResponseDataSerializer();
Serializer<DataState> _$dataStateSerializer = new _$DataStateSerializer();
Serializer<EntityAction> _$entityActionSerializer =
    new _$EntityActionSerializer();
Serializer<EntityType> _$entityTypeSerializer = new _$EntityTypeSerializer();

class _$ErrorMessageSerializer implements StructuredSerializer<ErrorMessage> {
  @override
  final Iterable<Type> types = const [ErrorMessage, _$ErrorMessage];
  @override
  final String wireName = 'ErrorMessage';

  @override
  Iterable<Object> serialize(Serializers serializers, ErrorMessage object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ErrorMessage deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ErrorMessageBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$LoginResponseSerializer implements StructuredSerializer<LoginResponse> {
  @override
  final Iterable<Type> types = const [LoginResponse, _$LoginResponse];
  @override
  final String wireName = 'LoginResponse';

  @override
  Iterable<Object> serialize(Serializers serializers, LoginResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(LoginResponseData)),
    ];
    Object value;
    value = object.error;
    if (value != null) {
      result
        ..add('error')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(ErrorMessage)));
    }
    return result;
  }

  @override
  LoginResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LoginResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(LoginResponseData))
              as LoginResponseData);
          break;
        case 'error':
          result.error.replace(serializers.deserialize(value,
              specifiedType: const FullType(ErrorMessage)) as ErrorMessage);
          break;
      }
    }

    return result.build();
  }
}

class _$LoginResponseDataSerializer
    implements StructuredSerializer<LoginResponseData> {
  @override
  final Iterable<Type> types = const [LoginResponseData, _$LoginResponseData];
  @override
  final String wireName = 'LoginResponseData';

  @override
  Iterable<Object> serialize(Serializers serializers, LoginResponseData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'version',
      serializers.serialize(object.version,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  LoginResponseData deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LoginResponseDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'version':
          result.version = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$DataStateSerializer implements StructuredSerializer<DataState> {
  @override
  final Iterable<Type> types = const [DataState, _$DataState];
  @override
  final String wireName = 'DataState';

  @override
  Iterable<Object> serialize(Serializers serializers, DataState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'songsFailedAt',
      serializers.serialize(object.songsFailedAt,
          specifiedType: const FullType(int)),
      'songsUpdateAt',
      serializers.serialize(object.songsUpdateAt,
          specifiedType: const FullType(int)),
      'songMap',
      serializers.serialize(object.songMap,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(int), const FullType(SongEntity)])),
      'artistMap',
      serializers.serialize(object.artistMap,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(int), const FullType(ArtistEntity)])),
    ];

    return result;
  }

  @override
  DataState deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DataStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'songsFailedAt':
          result.songsFailedAt = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'songsUpdateAt':
          result.songsUpdateAt = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'songMap':
          result.songMap.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(int), const FullType(SongEntity)])));
          break;
        case 'artistMap':
          result.artistMap.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(int), const FullType(ArtistEntity)])));
          break;
      }
    }

    return result.build();
  }
}

class _$EntityActionSerializer implements PrimitiveSerializer<EntityAction> {
  @override
  final Iterable<Type> types = const <Type>[EntityAction];
  @override
  final String wireName = 'EntityAction';

  @override
  Object serialize(Serializers serializers, EntityAction object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  EntityAction deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EntityAction.valueOf(serialized as String);
}

class _$EntityTypeSerializer implements PrimitiveSerializer<EntityType> {
  @override
  final Iterable<Type> types = const <Type>[EntityType];
  @override
  final String wireName = 'EntityType';

  @override
  Object serialize(Serializers serializers, EntityType object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  EntityType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EntityType.valueOf(serialized as String);
}

class _$ErrorMessage extends ErrorMessage {
  @override
  final String message;

  factory _$ErrorMessage([void Function(ErrorMessageBuilder) updates]) =>
      (new ErrorMessageBuilder()..update(updates))._build();

  _$ErrorMessage._({this.message}) : super._() {
    BuiltValueNullFieldError.checkNotNull(message, r'ErrorMessage', 'message');
  }

  @override
  ErrorMessage rebuild(void Function(ErrorMessageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ErrorMessageBuilder toBuilder() => new ErrorMessageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ErrorMessage && message == other.message;
  }

  @override
  int get hashCode {
    return $jf($jc(0, message.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ErrorMessage')
          ..add('message', message))
        .toString();
  }
}

class ErrorMessageBuilder
    implements Builder<ErrorMessage, ErrorMessageBuilder> {
  _$ErrorMessage _$v;

  String _message;
  String get message => _$this._message;
  set message(String message) => _$this._message = message;

  ErrorMessageBuilder();

  ErrorMessageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ErrorMessage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ErrorMessage;
  }

  @override
  void update(void Function(ErrorMessageBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  ErrorMessage build() => _build();

  _$ErrorMessage _build() {
    final _$result = _$v ??
        new _$ErrorMessage._(
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'ErrorMessage', 'message'));
    replace(_$result);
    return _$result;
  }
}

class _$LoginResponse extends LoginResponse {
  @override
  final LoginResponseData data;
  @override
  final ErrorMessage error;

  factory _$LoginResponse([void Function(LoginResponseBuilder) updates]) =>
      (new LoginResponseBuilder()..update(updates))._build();

  _$LoginResponse._({this.data, this.error}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'LoginResponse', 'data');
  }

  @override
  LoginResponse rebuild(void Function(LoginResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginResponseBuilder toBuilder() => new LoginResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginResponse && data == other.data && error == other.error;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, data.hashCode), error.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoginResponse')
          ..add('data', data)
          ..add('error', error))
        .toString();
  }
}

class LoginResponseBuilder
    implements Builder<LoginResponse, LoginResponseBuilder> {
  _$LoginResponse _$v;

  LoginResponseDataBuilder _data;
  LoginResponseDataBuilder get data =>
      _$this._data ??= new LoginResponseDataBuilder();
  set data(LoginResponseDataBuilder data) => _$this._data = data;

  ErrorMessageBuilder _error;
  ErrorMessageBuilder get error => _$this._error ??= new ErrorMessageBuilder();
  set error(ErrorMessageBuilder error) => _$this._error = error;

  LoginResponseBuilder();

  LoginResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _error = $v.error?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$LoginResponse;
  }

  @override
  void update(void Function(LoginResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginResponse build() => _build();

  _$LoginResponse _build() {
    _$LoginResponse _$result;
    try {
      _$result = _$v ??
          new _$LoginResponse._(data: data.build(), error: _error?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'error';
        _error?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'LoginResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$LoginResponseData extends LoginResponseData {
  @override
  final String version;

  factory _$LoginResponseData(
          [void Function(LoginResponseDataBuilder) updates]) =>
      (new LoginResponseDataBuilder()..update(updates))._build();

  _$LoginResponseData._({this.version}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        version, r'LoginResponseData', 'version');
  }

  @override
  LoginResponseData rebuild(void Function(LoginResponseDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginResponseDataBuilder toBuilder() =>
      new LoginResponseDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginResponseData && version == other.version;
  }

  @override
  int get hashCode {
    return $jf($jc(0, version.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoginResponseData')
          ..add('version', version))
        .toString();
  }
}

class LoginResponseDataBuilder
    implements Builder<LoginResponseData, LoginResponseDataBuilder> {
  _$LoginResponseData _$v;

  String _version;
  String get version => _$this._version;
  set version(String version) => _$this._version = version;

  LoginResponseDataBuilder();

  LoginResponseDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginResponseData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$LoginResponseData;
  }

  @override
  void update(void Function(LoginResponseDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginResponseData build() => _build();

  _$LoginResponseData _build() {
    final _$result = _$v ??
        new _$LoginResponseData._(
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'LoginResponseData', 'version'));
    replace(_$result);
    return _$result;
  }
}

class _$DataState extends DataState {
  @override
  final int songsFailedAt;
  @override
  final int songsUpdateAt;
  @override
  final BuiltMap<int, SongEntity> songMap;
  @override
  final BuiltMap<int, ArtistEntity> artistMap;

  factory _$DataState([void Function(DataStateBuilder) updates]) =>
      (new DataStateBuilder()..update(updates))._build();

  _$DataState._(
      {this.songsFailedAt, this.songsUpdateAt, this.songMap, this.artistMap})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        songsFailedAt, r'DataState', 'songsFailedAt');
    BuiltValueNullFieldError.checkNotNull(
        songsUpdateAt, r'DataState', 'songsUpdateAt');
    BuiltValueNullFieldError.checkNotNull(songMap, r'DataState', 'songMap');
    BuiltValueNullFieldError.checkNotNull(artistMap, r'DataState', 'artistMap');
  }

  @override
  DataState rebuild(void Function(DataStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DataStateBuilder toBuilder() => new DataStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DataState &&
        songsFailedAt == other.songsFailedAt &&
        songsUpdateAt == other.songsUpdateAt &&
        songMap == other.songMap &&
        artistMap == other.artistMap;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, songsFailedAt.hashCode), songsUpdateAt.hashCode),
            songMap.hashCode),
        artistMap.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DataState')
          ..add('songsFailedAt', songsFailedAt)
          ..add('songsUpdateAt', songsUpdateAt)
          ..add('songMap', songMap)
          ..add('artistMap', artistMap))
        .toString();
  }
}

class DataStateBuilder implements Builder<DataState, DataStateBuilder> {
  _$DataState _$v;

  int _songsFailedAt;
  int get songsFailedAt => _$this._songsFailedAt;
  set songsFailedAt(int songsFailedAt) => _$this._songsFailedAt = songsFailedAt;

  int _songsUpdateAt;
  int get songsUpdateAt => _$this._songsUpdateAt;
  set songsUpdateAt(int songsUpdateAt) => _$this._songsUpdateAt = songsUpdateAt;

  MapBuilder<int, SongEntity> _songMap;
  MapBuilder<int, SongEntity> get songMap =>
      _$this._songMap ??= new MapBuilder<int, SongEntity>();
  set songMap(MapBuilder<int, SongEntity> songMap) => _$this._songMap = songMap;

  MapBuilder<int, ArtistEntity> _artistMap;
  MapBuilder<int, ArtistEntity> get artistMap =>
      _$this._artistMap ??= new MapBuilder<int, ArtistEntity>();
  set artistMap(MapBuilder<int, ArtistEntity> artistMap) =>
      _$this._artistMap = artistMap;

  DataStateBuilder();

  DataStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _songsFailedAt = $v.songsFailedAt;
      _songsUpdateAt = $v.songsUpdateAt;
      _songMap = $v.songMap.toBuilder();
      _artistMap = $v.artistMap.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DataState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DataState;
  }

  @override
  void update(void Function(DataStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  DataState build() => _build();

  _$DataState _build() {
    _$DataState _$result;
    try {
      _$result = _$v ??
          new _$DataState._(
              songsFailedAt: BuiltValueNullFieldError.checkNotNull(
                  songsFailedAt, r'DataState', 'songsFailedAt'),
              songsUpdateAt: BuiltValueNullFieldError.checkNotNull(
                  songsUpdateAt, r'DataState', 'songsUpdateAt'),
              songMap: songMap.build(),
              artistMap: artistMap.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'songMap';
        songMap.build();
        _$failedField = 'artistMap';
        artistMap.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'DataState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
