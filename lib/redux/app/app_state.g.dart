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
  Iterable<Object> serialize(Serializers serializers, AppState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'isLoading',
      serializers.serialize(object.isLoading,
          specifiedType: const FullType(bool)),
      'isSaving',
      serializers.serialize(object.isSaving,
          specifiedType: const FullType(bool)),
      'isDance',
      serializers.serialize(object.isDance,
          specifiedType: const FullType(bool)),
      'authState',
      serializers.serialize(object.authState,
          specifiedType: const FullType(AuthState)),
      'dataState',
      serializers.serialize(object.dataState,
          specifiedType: const FullType(DataState)),
      'uiState',
      serializers.serialize(object.uiState,
          specifiedType: const FullType(UIState)),
    ];

    return result;
  }

  @override
  AppState deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AppStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'isLoading':
          result.isLoading = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'isSaving':
          result.isSaving = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'isDance':
          result.isDance = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'authState':
          result.authState.replace(serializers.deserialize(value,
              specifiedType: const FullType(AuthState)) as AuthState);
          break;
        case 'dataState':
          result.dataState.replace(serializers.deserialize(value,
              specifiedType: const FullType(DataState)) as DataState);
          break;
        case 'uiState':
          result.uiState.replace(serializers.deserialize(value,
              specifiedType: const FullType(UIState)) as UIState);
          break;
      }
    }

    return result.build();
  }
}

class _$AppState extends AppState {
  @override
  final bool isLoading;
  @override
  final bool isSaving;
  @override
  final bool isDance;
  @override
  final AuthState authState;
  @override
  final DataState dataState;
  @override
  final UIState uiState;

  factory _$AppState([void Function(AppStateBuilder) updates]) =>
      (new AppStateBuilder()..update(updates))._build();

  _$AppState._(
      {this.isLoading,
      this.isSaving,
      this.isDance,
      this.authState,
      this.dataState,
      this.uiState})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(isLoading, r'AppState', 'isLoading');
    BuiltValueNullFieldError.checkNotNull(isSaving, r'AppState', 'isSaving');
    BuiltValueNullFieldError.checkNotNull(isDance, r'AppState', 'isDance');
    BuiltValueNullFieldError.checkNotNull(authState, r'AppState', 'authState');
    BuiltValueNullFieldError.checkNotNull(dataState, r'AppState', 'dataState');
    BuiltValueNullFieldError.checkNotNull(uiState, r'AppState', 'uiState');
  }

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
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, isLoading.hashCode), isSaving.hashCode),
                    isDance.hashCode),
                authState.hashCode),
            dataState.hashCode),
        uiState.hashCode));
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState _$v;

  bool _isLoading;
  bool get isLoading => _$this._isLoading;
  set isLoading(bool isLoading) => _$this._isLoading = isLoading;

  bool _isSaving;
  bool get isSaving => _$this._isSaving;
  set isSaving(bool isSaving) => _$this._isSaving = isSaving;

  bool _isDance;
  bool get isDance => _$this._isDance;
  set isDance(bool isDance) => _$this._isDance = isDance;

  AuthStateBuilder _authState;
  AuthStateBuilder get authState =>
      _$this._authState ??= new AuthStateBuilder();
  set authState(AuthStateBuilder authState) => _$this._authState = authState;

  DataStateBuilder _dataState;
  DataStateBuilder get dataState =>
      _$this._dataState ??= new DataStateBuilder();
  set dataState(DataStateBuilder dataState) => _$this._dataState = dataState;

  UIStateBuilder _uiState;
  UIStateBuilder get uiState => _$this._uiState ??= new UIStateBuilder();
  set uiState(UIStateBuilder uiState) => _$this._uiState = uiState;

  AppStateBuilder();

  AppStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _isSaving = $v.isSaving;
      _isDance = $v.isDance;
      _authState = $v.authState.toBuilder();
      _dataState = $v.dataState.toBuilder();
      _uiState = $v.uiState.toBuilder();
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
  void update(void Function(AppStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  AppState build() => _build();

  _$AppState _build() {
    _$AppState _$result;
    try {
      _$result = _$v ??
          new _$AppState._(
              isLoading: BuiltValueNullFieldError.checkNotNull(
                  isLoading, r'AppState', 'isLoading'),
              isSaving: BuiltValueNullFieldError.checkNotNull(
                  isSaving, r'AppState', 'isSaving'),
              isDance: BuiltValueNullFieldError.checkNotNull(
                  isDance, r'AppState', 'isDance'),
              authState: authState.build(),
              dataState: dataState.build(),
              uiState: uiState.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'authState';
        authState.build();
        _$failedField = 'dataState';
        dataState.build();
        _$failedField = 'uiState';
        uiState.build();
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

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
