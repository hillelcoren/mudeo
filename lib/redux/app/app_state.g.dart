// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AppState> _$appStateSerializer = new _$AppStateSerializer();

class _$AppStateSerializer implements StructuredSerializer<AppState> {
  @override
  final Iterable<Type> types = const [AppState, _$AppState];
  @override
  final String wireName = 'AppState';

  @override
  Iterable<Object?> serialize(Serializers serializers, AppState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.isLoading;
    if (value != null) {
      result
        ..add('isLoading')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.isSaving;
    if (value != null) {
      result
        ..add('isSaving')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.isDance;
    if (value != null) {
      result
        ..add('isDance')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.authState;
    if (value != null) {
      result
        ..add('authState')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(AuthState)));
    }
    value = object.dataState;
    if (value != null) {
      result
        ..add('dataState')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DataState)));
    }
    value = object.uiState;
    if (value != null) {
      result
        ..add('uiState')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(UIState)));
    }
    return result;
  }

  @override
  AppState deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AppStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'isLoading':
          result.isLoading = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'isSaving':
          result.isSaving = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'isDance':
          result.isDance = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'authState':
          result.authState.replace(serializers.deserialize(value,
              specifiedType: const FullType(AuthState))! as AuthState);
          break;
        case 'dataState':
          result.dataState.replace(serializers.deserialize(value,
              specifiedType: const FullType(DataState))! as DataState);
          break;
        case 'uiState':
          result.uiState.replace(serializers.deserialize(value,
              specifiedType: const FullType(UIState))! as UIState);
          break;
      }
    }

    return result.build();
  }
}

class _$AppState extends AppState {
  @override
  final bool? isLoading;
  @override
  final bool? isSaving;
  @override
  final bool? isDance;
  @override
  final AuthState? authState;
  @override
  final DataState? dataState;
  @override
  final UIState? uiState;

  factory _$AppState([void Function(AppStateBuilder)? updates]) =>
      (new AppStateBuilder()..update(updates))._build();

  _$AppState._(
      {this.isLoading,
      this.isSaving,
      this.isDance,
      this.authState,
      this.dataState,
      this.uiState})
      : super._();

  @override
  AppState rebuild(void Function(AppStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStateBuilder toBuilder() => new AppStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppState &&
        isLoading == other.isLoading &&
        isSaving == other.isSaving &&
        isDance == other.isDance &&
        authState == other.authState &&
        dataState == other.dataState &&
        uiState == other.uiState;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, isSaving.hashCode);
    _$hash = $jc(_$hash, isDance.hashCode);
    _$hash = $jc(_$hash, authState.hashCode);
    _$hash = $jc(_$hash, dataState.hashCode);
    _$hash = $jc(_$hash, uiState.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _isSaving;
  bool? get isSaving => _$this._isSaving;
  set isSaving(bool? isSaving) => _$this._isSaving = isSaving;

  bool? _isDance;
  bool? get isDance => _$this._isDance;
  set isDance(bool? isDance) => _$this._isDance = isDance;

  AuthStateBuilder? _authState;
  AuthStateBuilder get authState =>
      _$this._authState ??= new AuthStateBuilder();
  set authState(AuthStateBuilder? authState) => _$this._authState = authState;

  DataStateBuilder? _dataState;
  DataStateBuilder get dataState =>
      _$this._dataState ??= new DataStateBuilder();
  set dataState(DataStateBuilder? dataState) => _$this._dataState = dataState;

  UIStateBuilder? _uiState;
  UIStateBuilder get uiState => _$this._uiState ??= new UIStateBuilder();
  set uiState(UIStateBuilder? uiState) => _$this._uiState = uiState;

  AppStateBuilder();

  AppStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _isSaving = $v.isSaving;
      _isDance = $v.isDance;
      _authState = $v.authState?.toBuilder();
      _dataState = $v.dataState?.toBuilder();
      _uiState = $v.uiState?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AppState;
  }

  @override
  void update(void Function(AppStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppState build() => _build();

  _$AppState _build() {
    _$AppState _$result;
    try {
      _$result = _$v ??
          new _$AppState._(
              isLoading: isLoading,
              isSaving: isSaving,
              isDance: isDance,
              authState: _authState?.build(),
              dataState: _dataState?.build(),
              uiState: _uiState?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'authState';
        _authState?.build();
        _$failedField = 'dataState';
        _dataState?.build();
        _$failedField = 'uiState';
        _uiState?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AppState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
