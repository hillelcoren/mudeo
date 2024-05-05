// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(AppState.serializer)
      ..add(ArtistEntity.serializer)
      ..add(ArtistFlagEntity.serializer)
      ..add(ArtistFollowingEntity.serializer)
      ..add(ArtistFollowingItemResponse.serializer)
      ..add(ArtistItemResponse.serializer)
      ..add(AuthState.serializer)
      ..add(CommentEntity.serializer)
      ..add(CommentItemResponse.serializer)
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
          const FullType(
              BuiltList, const [const FullType.nullable(SongLikeEntity)]),
          () => new ListBuilder<SongLikeEntity?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(SongFlagEntity)]),
          () => new ListBuilder<SongFlagEntity?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ArtistFlagEntity)]),
          () => new ListBuilder<ArtistFlagEntity>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType.nullable(ArtistFollowingEntity)]),
          () => new ListBuilder<ArtistFollowingEntity?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(TrackEntity)]),
          () => new ListBuilder<TrackEntity?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ArtistEntity)]),
          () => new ListBuilder<ArtistEntity>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(CommentEntity)]),
          () => new ListBuilder<CommentEntity?>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(double)]),
          () => new MapBuilder<String, double>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(int), const FullType(SongEntity)]),
          () => new MapBuilder<int, SongEntity>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(int), const FullType(ArtistEntity)]),
          () => new MapBuilder<int, ArtistEntity>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
