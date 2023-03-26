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
      'hideAppReview',
      serializers.serialize(object.hideAppReview,
          specifiedType: const FullType(bool)),
      'installedAt',
      serializers.serialize(object.installedAt,
          specifiedType: const FullType(int)),
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
      final dynamic value = iterator.current;
      switch (key) {
        case 'artist':
          result.artist.replace(serializers.deserialize(value,
              specifiedType: const FullType(ArtistEntity)) as ArtistEntity);
          break;
        case 'isAuthenticated':
          result.isAuthenticated = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'hideAppReview':
          result.hideAppReview = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'installedAt':
          result.installedAt = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
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
  @override
  final bool hideAppReview;
  @override
  final int installedAt;

  factory _$AuthState([void Function(AuthStateBuilder) updates]) =>
      (new AuthStateBuilder()..update(updates)).build();

  _$AuthState._(
      {this.artist, this.isAuthenticated, this.hideAppReview, this.installedAt})
      : super._() {
    if (artist == null) {
      throw new BuiltValueNullFieldError('AuthState', 'artist');
    }
    if (isAuthenticated == null) {
      throw new BuiltValueNullFieldError('AuthState', 'isAuthenticated');
    }
    if (hideAppReview == null) {
      throw new BuiltValueNullFieldError('AuthState', 'hideAppReview');
    }
    if (installedAt == null) {
      throw new BuiltValueNullFieldError('AuthState', 'installedAt');
    }
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
        isAuthenticated == other.isAuthenticated &&
        hideAppReview == other.hideAppReview &&
        installedAt == other.installedAt;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, artist.hashCode), isAuthenticated.hashCode),
            hideAppReview.hashCode),
        installedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AuthState')
          ..add('artist', artist)
          ..add('isAuthenticated', isAuthenticated)
          ..add('hideAppReview', hideAppReview)
          ..add('installedAt', installedAt))
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

  bool _hideAppReview;
  bool get hideAppReview => _$this._hideAppReview;
  set hideAppReview(bool hideAppReview) =>
      _$this._hideAppReview = hideAppReview;

  int _installedAt;
  int get installedAt => _$this._installedAt;
  set installedAt(int installedAt) => _$this._installedAt = installedAt;

  AuthStateBuilder() {
    AuthState._initializeBuilder(this);
  }

  AuthStateBuilder get _$this {
    if (_$v != null) {
      _artist = _$v.artist?.toBuilder();
      _isAuthenticated = _$v.isAuthenticated;
      _hideAppReview = _$v.hideAppReview;
      _installedAt = _$v.installedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AuthState;
  }

  @override
  void update(void Function(AuthStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AuthState build() {
    _$AuthState _$result;
    try {
      _$result = _$v ??
          new _$AuthState._(
              artist: artist.build(),
              isAuthenticated: isAuthenticated,
              hideAppReview: hideAppReview,
              installedAt: installedAt);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'artist';
        artist.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'AuthState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
