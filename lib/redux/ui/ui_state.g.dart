// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UIState> _$uIStateSerializer = new _$UIStateSerializer();

class _$UIStateSerializer implements StructuredSerializer<UIState> {
  @override
  final Iterable<Type> types = const [UIState, _$UIState];
  @override
  final String wireName = 'UIState';

  @override
  Iterable<Object?> serialize(Serializers serializers, UIState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.selectedTabIndex;
    if (value != null) {
      result
        ..add('selectedTabIndex')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.recordingTimestamp;
    if (value != null) {
      result
        ..add('recordingTimestamp')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.song;
    if (value != null) {
      result
        ..add('song')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(SongEntity)));
    }
    value = object.artist;
    if (value != null) {
      result
        ..add('artist')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(ArtistEntity)));
    }
    return result;
  }

  @override
  UIState deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UIStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'selectedTabIndex':
          result.selectedTabIndex = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'recordingTimestamp':
          result.recordingTimestamp = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'song':
          result.song.replace(serializers.deserialize(value,
              specifiedType: const FullType(SongEntity))! as SongEntity);
          break;
        case 'artist':
          result.artist.replace(serializers.deserialize(value,
              specifiedType: const FullType(ArtistEntity))! as ArtistEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$UIState extends UIState {
  @override
  final int? selectedTabIndex;
  @override
  final int? recordingTimestamp;
  @override
  final SongEntity? song;
  @override
  final ArtistEntity? artist;

  factory _$UIState([void Function(UIStateBuilder)? updates]) =>
      (new UIStateBuilder()..update(updates))._build();

  _$UIState._(
      {this.selectedTabIndex, this.recordingTimestamp, this.song, this.artist})
      : super._();

  @override
  UIState rebuild(void Function(UIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UIStateBuilder toBuilder() => new UIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UIState &&
        selectedTabIndex == other.selectedTabIndex &&
        recordingTimestamp == other.recordingTimestamp &&
        song == other.song &&
        artist == other.artist;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, selectedTabIndex.hashCode);
    _$hash = $jc(_$hash, recordingTimestamp.hashCode);
    _$hash = $jc(_$hash, song.hashCode);
    _$hash = $jc(_$hash, artist.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UIState')
          ..add('selectedTabIndex', selectedTabIndex)
          ..add('recordingTimestamp', recordingTimestamp)
          ..add('song', song)
          ..add('artist', artist))
        .toString();
  }
}

class UIStateBuilder implements Builder<UIState, UIStateBuilder> {
  _$UIState? _$v;

  int? _selectedTabIndex;
  int? get selectedTabIndex => _$this._selectedTabIndex;
  set selectedTabIndex(int? selectedTabIndex) =>
      _$this._selectedTabIndex = selectedTabIndex;

  int? _recordingTimestamp;
  int? get recordingTimestamp => _$this._recordingTimestamp;
  set recordingTimestamp(int? recordingTimestamp) =>
      _$this._recordingTimestamp = recordingTimestamp;

  SongEntityBuilder? _song;
  SongEntityBuilder get song => _$this._song ??= new SongEntityBuilder();
  set song(SongEntityBuilder? song) => _$this._song = song;

  ArtistEntityBuilder? _artist;
  ArtistEntityBuilder get artist =>
      _$this._artist ??= new ArtistEntityBuilder();
  set artist(ArtistEntityBuilder? artist) => _$this._artist = artist;

  UIStateBuilder();

  UIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _selectedTabIndex = $v.selectedTabIndex;
      _recordingTimestamp = $v.recordingTimestamp;
      _song = $v.song?.toBuilder();
      _artist = $v.artist?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UIState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UIState;
  }

  @override
  void update(void Function(UIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UIState build() => _build();

  _$UIState _build() {
    _$UIState _$result;
    try {
      _$result = _$v ??
          new _$UIState._(
              selectedTabIndex: selectedTabIndex,
              recordingTimestamp: recordingTimestamp,
              song: _song?.build(),
              artist: _artist?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'song';
        _song?.build();
        _$failedField = 'artist';
        _artist?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UIState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
