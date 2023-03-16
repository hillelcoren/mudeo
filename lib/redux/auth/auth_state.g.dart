// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AuthState> _$authStateSerializer = new _$AuthStateSerializer();

class _$AuthStateSerializer implements StructuredSerializer<AuthState> {
  @override
  final Iterable<Type> types = const [AuthState, _$AuthState];
  @override
  final String wireName = 'AuthState';

  @override
  Iterable<Object> serialize(Serializers serializers, AuthState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'artist',
      serializers.serialize(object.artist,
          specifiedType: const FullType(ArtistEntity)),
      'isAuthenticated',
      serializers.serialize(object.isAuthenticated,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  AuthState deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AuthStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'artist':
          result.artist.replace(serializers.deserialize(value,
              specifiedType: const FullType(ArtistEntity)) as ArtistEntity);
          break;
        case 'isAuthenticated':
          result.isAuthenticated = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$AuthState extends AuthState {
  @override
  final ArtistEntity artist;
  @override
  final bool isAuthenticated;

  factory _$AuthState([void Function(AuthStateBuilder) updates]) =>
      (new AuthStateBuilder()..update(updates))._build();

  _$AuthState._({this.artist, this.isAuthenticated}) : super._() {
    BuiltValueNullFieldError.checkNotNull(artist, r'AuthState', 'artist');
    BuiltValueNullFieldError.checkNotNull(
        isAuthenticated, r'AuthState', 'isAuthenticated');
  }

  @override
  AuthState rebuild(void Function(AuthStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthStateBuilder toBuilder() => new AuthStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthState &&
        artist == other.artist &&
        isAuthenticated == other.isAuthenticated;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, artist.hashCode), isAuthenticated.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthState')
          ..add('artist', artist)
          ..add('isAuthenticated', isAuthenticated))
        .toString();
  }
}

class AuthStateBuilder implements Builder<AuthState, AuthStateBuilder> {
  _$AuthState _$v;

  ArtistEntityBuilder _artist;
  ArtistEntityBuilder get artist =>
      _$this._artist ??= new ArtistEntityBuilder();
  set artist(ArtistEntityBuilder artist) => _$this._artist = artist;

  bool _isAuthenticated;
  bool get isAuthenticated => _$this._isAuthenticated;
  set isAuthenticated(bool isAuthenticated) =>
      _$this._isAuthenticated = isAuthenticated;

  AuthStateBuilder();

  AuthStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _artist = $v.artist.toBuilder();
      _isAuthenticated = $v.isAuthenticated;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuthState;
  }

  @override
  void update(void Function(AuthStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthState build() => _build();

  _$AuthState _build() {
    _$AuthState _$result;
    try {
      _$result = _$v ??
          new _$AuthState._(
              artist: artist.build(),
              isAuthenticated: BuiltValueNullFieldError.checkNotNull(
                  isAuthenticated, r'AuthState', 'isAuthenticated'));
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'artist';
        artist.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AuthState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
