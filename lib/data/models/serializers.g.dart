// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

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

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(AppState.serializer)
      ..add(ArtistEntity.serializer)
      ..add(AuthState.serializer)
      ..add(DataState.serializer)
      ..add(ErrorMessage.serializer)
      ..add(LoginResponse.serializer)
      ..add(LoginResponseData.serializer)
      ..add(SongEntity.serializer)
      ..add(TrackEntity.serializer)
      ..add(UIState.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TrackEntity)]),
          () => new ListBuilder<TrackEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(int), const FullType(SongEntity)]),
          () => new MapBuilder<int, SongEntity>()))
    .build();
