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
      ..add(ArtistFlagEntity.serializer)
      ..add(ArtistFollowingEntity.serializer)
      ..add(ArtistFollowingItemResponse.serializer)
      ..add(ArtistItemResponse.serializer)
      ..add(AuthState.serializer)
      ..add(DataState.serializer)
      ..add(ErrorMessage.serializer)
      ..add(FlagSongResponse.serializer)
      ..add(LikeSongResponse.serializer)
      ..add(LoginResponse.serializer)
      ..add(LoginResponseData.serializer)
      ..add(SongEntity.serializer)
      ..add(SongFlagEntity.serializer)
      ..add(SongItemResponse.serializer)
      ..add(SongLikeEntity.serializer)
      ..add(SongListResponse.serializer)
      ..add(TrackEntity.serializer)
      ..add(UIState.serializer)
      ..add(VideoEntity.serializer)
      ..add(VideoItemResponse.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(SongEntity)]),
          () => new ListBuilder<SongEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(SongLikeEntity)]),
          () => new ListBuilder<SongLikeEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(SongFlagEntity)]),
          () => new ListBuilder<SongFlagEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ArtistFlagEntity)]),
          () => new ListBuilder<ArtistFlagEntity>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ArtistFollowingEntity)]),
          () => new ListBuilder<ArtistFollowingEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TrackEntity)]),
          () => new ListBuilder<TrackEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(int), const FullType(SongEntity)]),
          () => new MapBuilder<int, SongEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(int), const FullType(ArtistEntity)]),
          () => new MapBuilder<int, ArtistEntity>()))
    .build();
