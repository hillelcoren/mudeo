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
  Iterable<Object?> serialize(Serializers serializers, AuthState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.artist;
    if (value != null) {
      result
        ..add('artist')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(ArtistEntity)));
    }
    value = object.isAuthenticated;
    if (value != null) {
      result
        ..add('isAuthenticated')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.hideReviewApp;
    if (value != null) {
      result
        ..add('hideReviewApp')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.installedAt;
    if (value != null) {
      result
        ..add('installedAt')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  AuthState deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AuthStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'artist':
          result.artist.replace(serializers.deserialize(value,
              specifiedType: const FullType(ArtistEntity))! as ArtistEntity);
          break;
        case 'isAuthenticated':
          result.isAuthenticated = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'hideReviewApp':
          result.hideReviewApp = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'installedAt':
          result.installedAt = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
      }
    }

    return result.build();
  }
}

class _$AuthState extends AuthState {
  @override
  final ArtistEntity? artist;
  @override
  final bool? isAuthenticated;
  @override
  final bool? hideReviewApp;
  @override
  final int? installedAt;

  factory _$AuthState([void Function(AuthStateBuilder)? updates]) =>
      (new AuthStateBuilder()..update(updates))._build();

  _$AuthState._(
      {this.artist, this.isAuthenticated, this.hideReviewApp, this.installedAt})
      : super._();

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
        hideReviewApp == other.hideReviewApp &&
        installedAt == other.installedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, artist.hashCode);
    _$hash = $jc(_$hash, isAuthenticated.hashCode);
    _$hash = $jc(_$hash, hideReviewApp.hashCode);
    _$hash = $jc(_$hash, installedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthState')
          ..add('artist', artist)
          ..add('isAuthenticated', isAuthenticated)
          ..add('hideReviewApp', hideReviewApp)
          ..add('installedAt', installedAt))
        .toString();
  }
}

class AuthStateBuilder implements Builder<AuthState, AuthStateBuilder> {
  _$AuthState? _$v;

  ArtistEntityBuilder? _artist;
  ArtistEntityBuilder get artist =>
      _$this._artist ??= new ArtistEntityBuilder();
  set artist(ArtistEntityBuilder? artist) => _$this._artist = artist;

  bool? _isAuthenticated;
  bool? get isAuthenticated => _$this._isAuthenticated;
  set isAuthenticated(bool? isAuthenticated) =>
      _$this._isAuthenticated = isAuthenticated;

  bool? _hideReviewApp;
  bool? get hideReviewApp => _$this._hideReviewApp;
  set hideReviewApp(bool? hideReviewApp) =>
      _$this._hideReviewApp = hideReviewApp;

  int? _installedAt;
  int? get installedAt => _$this._installedAt;
  set installedAt(int? installedAt) => _$this._installedAt = installedAt;

  AuthStateBuilder() {
    AuthState._initializeBuilder(this);
  }

  AuthStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _artist = $v.artist?.toBuilder();
      _isAuthenticated = $v.isAuthenticated;
      _hideReviewApp = $v.hideReviewApp;
      _installedAt = $v.installedAt;
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
  void update(void Function(AuthStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthState build() => _build();

  _$AuthState _build() {
    _$AuthState _$result;
    try {
      _$result = _$v ??
          new _$AuthState._(
              artist: _artist?.build(),
              isAuthenticated: isAuthenticated,
              hideReviewApp: hideReviewApp,
              installedAt: installedAt);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'artist';
        _artist?.build();
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

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
