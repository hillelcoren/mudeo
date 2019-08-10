// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_model.dart';

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

Serializer<SongEntity> _$songEntitySerializer = new _$SongEntitySerializer();
Serializer<TrackEntity> _$trackEntitySerializer = new _$TrackEntitySerializer();
Serializer<CommentEntity> _$commentEntitySerializer =
    new _$CommentEntitySerializer();
Serializer<SongLikeEntity> _$songLikeEntitySerializer =
    new _$SongLikeEntitySerializer();
Serializer<SongFlagEntity> _$songFlagEntitySerializer =
    new _$SongFlagEntitySerializer();
Serializer<ArtistFlagEntity> _$artistFlagEntitySerializer =
    new _$ArtistFlagEntitySerializer();
Serializer<VideoEntity> _$videoEntitySerializer = new _$VideoEntitySerializer();
Serializer<SongListResponse> _$songListResponseSerializer =
    new _$SongListResponseSerializer();
Serializer<SongItemResponse> _$songItemResponseSerializer =
    new _$SongItemResponseSerializer();
Serializer<CommentItemResponse> _$commentItemResponseSerializer =
    new _$CommentItemResponseSerializer();
Serializer<LikeSongResponse> _$likeSongResponseSerializer =
    new _$LikeSongResponseSerializer();
Serializer<FlagSongResponse> _$flagSongResponseSerializer =
    new _$FlagSongResponseSerializer();
Serializer<VideoItemResponse> _$videoItemResponseSerializer =
    new _$VideoItemResponseSerializer();

class _$SongEntitySerializer implements StructuredSerializer<SongEntity> {
  @override
  final Iterable<Type> types = const [SongEntity, _$SongEntity];
  @override
  final String wireName = 'SongEntity';

  @override
  Iterable serialize(Serializers serializers, SongEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(String)),
      'duration',
      serializers.serialize(object.duration,
          specifiedType: const FullType(int)),
      'is_flagged',
      serializers.serialize(object.isFlagged,
          specifiedType: const FullType(bool)),
      'is_public',
      serializers.serialize(object.isPublic,
          specifiedType: const FullType(bool)),
      'video_url',
      serializers.serialize(object.videoUrl,
          specifiedType: const FullType(String)),
      'song_videos',
      serializers.serialize(object.tracks,
          specifiedType:
              const FullType(BuiltList, const [const FullType(TrackEntity)])),
      'comments',
      serializers.serialize(object.comments,
          specifiedType:
              const FullType(BuiltList, const [const FullType(CommentEntity)])),
      'layout',
      serializers.serialize(object.layout,
          specifiedType: const FullType(String)),
    ];
    if (object.artistId != null) {
      result
        ..add('user_id')
        ..add(serializers.serialize(object.artistId,
            specifiedType: const FullType(int)));
    }
    if (object.artist != null) {
      result
        ..add('user')
        ..add(serializers.serialize(object.artist,
            specifiedType: const FullType(ArtistEntity)));
    }
    if (object.genreId != null) {
      result
        ..add('genre_id')
        ..add(serializers.serialize(object.genreId,
            specifiedType: const FullType(int)));
    }
    if (object.parentId != null) {
      result
        ..add('parent_id')
        ..add(serializers.serialize(object.parentId,
            specifiedType: const FullType(int)));
    }
    if (object.countPlay != null) {
      result
        ..add('count_play')
        ..add(serializers.serialize(object.countPlay,
            specifiedType: const FullType(int)));
    }
    if (object.countLike != null) {
      result
        ..add('count_like')
        ..add(serializers.serialize(object.countLike,
            specifiedType: const FullType(int)));
    }
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(int)));
    }
    if (object.deletedAt != null) {
      result
        ..add('deleted_at')
        ..add(serializers.serialize(object.deletedAt,
            specifiedType: const FullType(String)));
    }
    if (object.updatedAt != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(object.updatedAt,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  SongEntity deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SongEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'user_id':
          result.artistId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'user':
          result.artist.replace(serializers.deserialize(value,
              specifiedType: const FullType(ArtistEntity)) as ArtistEntity);
          break;
        case 'genre_id':
          result.genreId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'parent_id':
          result.parentId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'duration':
          result.duration = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'count_play':
          result.countPlay = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'count_like':
          result.countLike = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'is_flagged':
          result.isFlagged = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'is_public':
          result.isPublic = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'video_url':
          result.videoUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'song_videos':
          result.tracks.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(TrackEntity)]))
              as BuiltList);
          break;
        case 'comments':
          result.comments.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(CommentEntity)]))
              as BuiltList);
          break;
        case 'layout':
          result.layout = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'deleted_at':
          result.deletedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$TrackEntitySerializer implements StructuredSerializer<TrackEntity> {
  @override
  final Iterable<Type> types = const [TrackEntity, _$TrackEntity];
  @override
  final String wireName = 'TrackEntity';

  @override
  Iterable serialize(Serializers serializers, TrackEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'video',
      serializers.serialize(object.video,
          specifiedType: const FullType(VideoEntity)),
    ];
    if (object.isIncluded != null) {
      result
        ..add('is_included')
        ..add(serializers.serialize(object.isIncluded,
            specifiedType: const FullType(bool)));
    }
    if (object.delay != null) {
      result
        ..add('delay')
        ..add(serializers.serialize(object.delay,
            specifiedType: const FullType(int)));
    }
    if (object.volume != null) {
      result
        ..add('volume')
        ..add(serializers.serialize(object.volume,
            specifiedType: const FullType(int)));
    }
    if (object.orderId != null) {
      result
        ..add('order_id')
        ..add(serializers.serialize(object.orderId,
            specifiedType: const FullType(int)));
    }
    if (object.deletedAt != null) {
      result
        ..add('deleted_at')
        ..add(serializers.serialize(object.deletedAt,
            specifiedType: const FullType(String)));
    }
    if (object.updatedAt != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(object.updatedAt,
            specifiedType: const FullType(String)));
    }
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(int)));
    }

    return result;
  }

  @override
  TrackEntity deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TrackEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'is_included':
          result.isIncluded = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'delay':
          result.delay = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'volume':
          result.volume = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'order_id':
          result.orderId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'video':
          result.video.replace(serializers.deserialize(value,
              specifiedType: const FullType(VideoEntity)) as VideoEntity);
          break;
        case 'deleted_at':
          result.deletedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$CommentEntitySerializer implements StructuredSerializer<CommentEntity> {
  @override
  final Iterable<Type> types = const [CommentEntity, _$CommentEntity];
  @override
  final String wireName = 'CommentEntity';

  @override
  Iterable serialize(Serializers serializers, CommentEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'user',
      serializers.serialize(object.artist,
          specifiedType: const FullType(ArtistEntity)),
      'user_id',
      serializers.serialize(object.artistId,
          specifiedType: const FullType(int)),
      'song_id',
      serializers.serialize(object.songId, specifiedType: const FullType(int)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
    ];
    if (object.deletedAt != null) {
      result
        ..add('deleted_at')
        ..add(serializers.serialize(object.deletedAt,
            specifiedType: const FullType(String)));
    }
    if (object.updatedAt != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(object.updatedAt,
            specifiedType: const FullType(String)));
    }
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(int)));
    }

    return result;
  }

  @override
  CommentEntity deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CommentEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'user':
          result.artist.replace(serializers.deserialize(value,
              specifiedType: const FullType(ArtistEntity)) as ArtistEntity);
          break;
        case 'user_id':
          result.artistId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'song_id':
          result.songId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'deleted_at':
          result.deletedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$SongLikeEntitySerializer
    implements StructuredSerializer<SongLikeEntity> {
  @override
  final Iterable<Type> types = const [SongLikeEntity, _$SongLikeEntity];
  @override
  final String wireName = 'SongLikeEntity';

  @override
  Iterable serialize(Serializers serializers, SongLikeEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'user_id',
      serializers.serialize(object.userId, specifiedType: const FullType(int)),
      'song_id',
      serializers.serialize(object.songId, specifiedType: const FullType(int)),
    ];
    if (object.deletedAt != null) {
      result
        ..add('deleted_at')
        ..add(serializers.serialize(object.deletedAt,
            specifiedType: const FullType(String)));
    }
    if (object.updatedAt != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(object.updatedAt,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  SongLikeEntity deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SongLikeEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'user_id':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'song_id':
          result.songId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'deleted_at':
          result.deletedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$SongFlagEntitySerializer
    implements StructuredSerializer<SongFlagEntity> {
  @override
  final Iterable<Type> types = const [SongFlagEntity, _$SongFlagEntity];
  @override
  final String wireName = 'SongFlagEntity';

  @override
  Iterable serialize(Serializers serializers, SongFlagEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'user_id',
      serializers.serialize(object.userId, specifiedType: const FullType(int)),
      'song_id',
      serializers.serialize(object.songId, specifiedType: const FullType(int)),
    ];
    if (object.deletedAt != null) {
      result
        ..add('deleted_at')
        ..add(serializers.serialize(object.deletedAt,
            specifiedType: const FullType(String)));
    }
    if (object.updatedAt != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(object.updatedAt,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  SongFlagEntity deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SongFlagEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'user_id':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'song_id':
          result.songId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'deleted_at':
          result.deletedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ArtistFlagEntitySerializer
    implements StructuredSerializer<ArtistFlagEntity> {
  @override
  final Iterable<Type> types = const [ArtistFlagEntity, _$ArtistFlagEntity];
  @override
  final String wireName = 'ArtistFlagEntity';

  @override
  Iterable serialize(Serializers serializers, ArtistFlagEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'user_id',
      serializers.serialize(object.artistId,
          specifiedType: const FullType(int)),
    ];
    if (object.deletedAt != null) {
      result
        ..add('deleted_at')
        ..add(serializers.serialize(object.deletedAt,
            specifiedType: const FullType(String)));
    }
    if (object.updatedAt != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(object.updatedAt,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  ArtistFlagEntity deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ArtistFlagEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'user_id':
          result.artistId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'deleted_at':
          result.deletedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$VideoEntitySerializer implements StructuredSerializer<VideoEntity> {
  @override
  final Iterable<Type> types = const [VideoEntity, _$VideoEntity];
  @override
  final String wireName = 'VideoEntity';

  @override
  Iterable serialize(Serializers serializers, VideoEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'user_id',
      serializers.serialize(object.userId, specifiedType: const FullType(int)),
    ];
    if (object.timestamp != null) {
      result
        ..add('timestamp')
        ..add(serializers.serialize(object.timestamp,
            specifiedType: const FullType(int)));
    }
    if (object.url != null) {
      result
        ..add('url')
        ..add(serializers.serialize(object.url,
            specifiedType: const FullType(String)));
    }
    if (object.thumbnailUrl != null) {
      result
        ..add('thumbnail_url')
        ..add(serializers.serialize(object.thumbnailUrl,
            specifiedType: const FullType(String)));
    }
    if (object.remoteVideoId != null) {
      result
        ..add('remote_video_id')
        ..add(serializers.serialize(object.remoteVideoId,
            specifiedType: const FullType(String)));
    }
    if (object.description != null) {
      result
        ..add('description')
        ..add(serializers.serialize(object.description,
            specifiedType: const FullType(String)));
    }
    if (object.duration != null) {
      result
        ..add('duration')
        ..add(serializers.serialize(object.duration,
            specifiedType: const FullType(int)));
    }
    if (object.deletedAt != null) {
      result
        ..add('deleted_at')
        ..add(serializers.serialize(object.deletedAt,
            specifiedType: const FullType(String)));
    }
    if (object.updatedAt != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(object.updatedAt,
            specifiedType: const FullType(String)));
    }
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(int)));
    }

    return result;
  }

  @override
  VideoEntity deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new VideoEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'user_id':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'timestamp':
          result.timestamp = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'thumbnail_url':
          result.thumbnailUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'remote_video_id':
          result.remoteVideoId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'duration':
          result.duration = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'deleted_at':
          result.deletedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$SongListResponseSerializer
    implements StructuredSerializer<SongListResponse> {
  @override
  final Iterable<Type> types = const [SongListResponse, _$SongListResponse];
  @override
  final String wireName = 'SongListResponse';

  @override
  Iterable serialize(Serializers serializers, SongListResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'data',
      serializers.serialize(object.data,
          specifiedType:
              const FullType(BuiltList, const [const FullType(SongEntity)])),
    ];

    return result;
  }

  @override
  SongListResponse deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SongListResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(
                  BuiltList, const [const FullType(SongEntity)])) as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$SongItemResponseSerializer
    implements StructuredSerializer<SongItemResponse> {
  @override
  final Iterable<Type> types = const [SongItemResponse, _$SongItemResponse];
  @override
  final String wireName = 'SongItemResponse';

  @override
  Iterable serialize(Serializers serializers, SongItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(SongEntity)),
    ];

    return result;
  }

  @override
  SongItemResponse deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SongItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(SongEntity)) as SongEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$CommentItemResponseSerializer
    implements StructuredSerializer<CommentItemResponse> {
  @override
  final Iterable<Type> types = const [
    CommentItemResponse,
    _$CommentItemResponse
  ];
  @override
  final String wireName = 'CommentItemResponse';

  @override
  Iterable serialize(Serializers serializers, CommentItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(CommentEntity)),
    ];

    return result;
  }

  @override
  CommentItemResponse deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CommentItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(CommentEntity)) as CommentEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$LikeSongResponseSerializer
    implements StructuredSerializer<LikeSongResponse> {
  @override
  final Iterable<Type> types = const [LikeSongResponse, _$LikeSongResponse];
  @override
  final String wireName = 'LikeSongResponse';

  @override
  Iterable serialize(Serializers serializers, LikeSongResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(SongLikeEntity)),
    ];

    return result;
  }

  @override
  LikeSongResponse deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LikeSongResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(SongLikeEntity)) as SongLikeEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$FlagSongResponseSerializer
    implements StructuredSerializer<FlagSongResponse> {
  @override
  final Iterable<Type> types = const [FlagSongResponse, _$FlagSongResponse];
  @override
  final String wireName = 'FlagSongResponse';

  @override
  Iterable serialize(Serializers serializers, FlagSongResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(SongFlagEntity)),
    ];

    return result;
  }

  @override
  FlagSongResponse deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FlagSongResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(SongFlagEntity)) as SongFlagEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$VideoItemResponseSerializer
    implements StructuredSerializer<VideoItemResponse> {
  @override
  final Iterable<Type> types = const [VideoItemResponse, _$VideoItemResponse];
  @override
  final String wireName = 'VideoItemResponse';

  @override
  Iterable serialize(Serializers serializers, VideoItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(VideoEntity)),
    ];

    return result;
  }

  @override
  VideoItemResponse deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new VideoItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(VideoEntity)) as VideoEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$SongEntity extends SongEntity {
  @override
  final String title;
  @override
  final String description;
  @override
  final String url;
  @override
  final int artistId;
  @override
  final ArtistEntity artist;
  @override
  final int genreId;
  @override
  final int parentId;
  @override
  final int duration;
  @override
  final int countPlay;
  @override
  final int countLike;
  @override
  final bool isFlagged;
  @override
  final bool isPublic;
  @override
  final String videoUrl;
  @override
  final BuiltList<TrackEntity> tracks;
  @override
  final BuiltList<CommentEntity> comments;
  @override
  final String layout;
  @override
  final int id;
  @override
  final String deletedAt;
  @override
  final String updatedAt;

  factory _$SongEntity([void updates(SongEntityBuilder b)]) =>
      (new SongEntityBuilder()..update(updates)).build();

  _$SongEntity._(
      {this.title,
      this.description,
      this.url,
      this.artistId,
      this.artist,
      this.genreId,
      this.parentId,
      this.duration,
      this.countPlay,
      this.countLike,
      this.isFlagged,
      this.isPublic,
      this.videoUrl,
      this.tracks,
      this.comments,
      this.layout,
      this.id,
      this.deletedAt,
      this.updatedAt})
      : super._() {
    if (title == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'title');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'description');
    }
    if (url == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'url');
    }
    if (duration == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'duration');
    }
    if (isFlagged == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'isFlagged');
    }
    if (isPublic == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'isPublic');
    }
    if (videoUrl == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'videoUrl');
    }
    if (tracks == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'tracks');
    }
    if (comments == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'comments');
    }
    if (layout == null) {
      throw new BuiltValueNullFieldError('SongEntity', 'layout');
    }
  }

  @override
  SongEntity rebuild(void updates(SongEntityBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  SongEntityBuilder toBuilder() => new SongEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SongEntity &&
        title == other.title &&
        description == other.description &&
        url == other.url &&
        artistId == other.artistId &&
        artist == other.artist &&
        genreId == other.genreId &&
        parentId == other.parentId &&
        duration == other.duration &&
        countPlay == other.countPlay &&
        countLike == other.countLike &&
        isFlagged == other.isFlagged &&
        isPublic == other.isPublic &&
        videoUrl == other.videoUrl &&
        tracks == other.tracks &&
        comments == other.comments &&
        layout == other.layout &&
        id == other.id &&
        deletedAt == other.deletedAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    $jc(
                                                                        $jc(
                                                                            $jc(0,
                                                                                title.hashCode),
                                                                            description.hashCode),
                                                                        url.hashCode),
                                                                    artistId.hashCode),
                                                                artist.hashCode),
                                                            genreId.hashCode),
                                                        parentId.hashCode),
                                                    duration.hashCode),
                                                countPlay.hashCode),
                                            countLike.hashCode),
                                        isFlagged.hashCode),
                                    isPublic.hashCode),
                                videoUrl.hashCode),
                            tracks.hashCode),
                        comments.hashCode),
                    layout.hashCode),
                id.hashCode),
            deletedAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SongEntity')
          ..add('title', title)
          ..add('description', description)
          ..add('url', url)
          ..add('artistId', artistId)
          ..add('artist', artist)
          ..add('genreId', genreId)
          ..add('parentId', parentId)
          ..add('duration', duration)
          ..add('countPlay', countPlay)
          ..add('countLike', countLike)
          ..add('isFlagged', isFlagged)
          ..add('isPublic', isPublic)
          ..add('videoUrl', videoUrl)
          ..add('tracks', tracks)
          ..add('comments', comments)
          ..add('layout', layout)
          ..add('id', id)
          ..add('deletedAt', deletedAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class SongEntityBuilder implements Builder<SongEntity, SongEntityBuilder> {
  _$SongEntity _$v;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _url;
  String get url => _$this._url;
  set url(String url) => _$this._url = url;

  int _artistId;
  int get artistId => _$this._artistId;
  set artistId(int artistId) => _$this._artistId = artistId;

  ArtistEntityBuilder _artist;
  ArtistEntityBuilder get artist =>
      _$this._artist ??= new ArtistEntityBuilder();
  set artist(ArtistEntityBuilder artist) => _$this._artist = artist;

  int _genreId;
  int get genreId => _$this._genreId;
  set genreId(int genreId) => _$this._genreId = genreId;

  int _parentId;
  int get parentId => _$this._parentId;
  set parentId(int parentId) => _$this._parentId = parentId;

  int _duration;
  int get duration => _$this._duration;
  set duration(int duration) => _$this._duration = duration;

  int _countPlay;
  int get countPlay => _$this._countPlay;
  set countPlay(int countPlay) => _$this._countPlay = countPlay;

  int _countLike;
  int get countLike => _$this._countLike;
  set countLike(int countLike) => _$this._countLike = countLike;

  bool _isFlagged;
  bool get isFlagged => _$this._isFlagged;
  set isFlagged(bool isFlagged) => _$this._isFlagged = isFlagged;

  bool _isPublic;
  bool get isPublic => _$this._isPublic;
  set isPublic(bool isPublic) => _$this._isPublic = isPublic;

  String _videoUrl;
  String get videoUrl => _$this._videoUrl;
  set videoUrl(String videoUrl) => _$this._videoUrl = videoUrl;

  ListBuilder<TrackEntity> _tracks;
  ListBuilder<TrackEntity> get tracks =>
      _$this._tracks ??= new ListBuilder<TrackEntity>();
  set tracks(ListBuilder<TrackEntity> tracks) => _$this._tracks = tracks;

  ListBuilder<CommentEntity> _comments;
  ListBuilder<CommentEntity> get comments =>
      _$this._comments ??= new ListBuilder<CommentEntity>();
  set comments(ListBuilder<CommentEntity> comments) =>
      _$this._comments = comments;

  String _layout;
  String get layout => _$this._layout;
  set layout(String layout) => _$this._layout = layout;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _deletedAt;
  String get deletedAt => _$this._deletedAt;
  set deletedAt(String deletedAt) => _$this._deletedAt = deletedAt;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  SongEntityBuilder();

  SongEntityBuilder get _$this {
    if (_$v != null) {
      _title = _$v.title;
      _description = _$v.description;
      _url = _$v.url;
      _artistId = _$v.artistId;
      _artist = _$v.artist?.toBuilder();
      _genreId = _$v.genreId;
      _parentId = _$v.parentId;
      _duration = _$v.duration;
      _countPlay = _$v.countPlay;
      _countLike = _$v.countLike;
      _isFlagged = _$v.isFlagged;
      _isPublic = _$v.isPublic;
      _videoUrl = _$v.videoUrl;
      _tracks = _$v.tracks?.toBuilder();
      _comments = _$v.comments?.toBuilder();
      _layout = _$v.layout;
      _id = _$v.id;
      _deletedAt = _$v.deletedAt;
      _updatedAt = _$v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SongEntity other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SongEntity;
  }

  @override
  void update(void updates(SongEntityBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$SongEntity build() {
    _$SongEntity _$result;
    try {
      _$result = _$v ??
          new _$SongEntity._(
              title: title,
              description: description,
              url: url,
              artistId: artistId,
              artist: _artist?.build(),
              genreId: genreId,
              parentId: parentId,
              duration: duration,
              countPlay: countPlay,
              countLike: countLike,
              isFlagged: isFlagged,
              isPublic: isPublic,
              videoUrl: videoUrl,
              tracks: tracks.build(),
              comments: comments.build(),
              layout: layout,
              id: id,
              deletedAt: deletedAt,
              updatedAt: updatedAt);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'artist';
        _artist?.build();

        _$failedField = 'tracks';
        tracks.build();
        _$failedField = 'comments';
        comments.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'SongEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$TrackEntity extends TrackEntity {
  @override
  final bool isIncluded;
  @override
  final int delay;
  @override
  final int volume;
  @override
  final int orderId;
  @override
  final VideoEntity video;
  @override
  final String deletedAt;
  @override
  final String updatedAt;
  @override
  final int id;

  factory _$TrackEntity([void updates(TrackEntityBuilder b)]) =>
      (new TrackEntityBuilder()..update(updates)).build();

  _$TrackEntity._(
      {this.isIncluded,
      this.delay,
      this.volume,
      this.orderId,
      this.video,
      this.deletedAt,
      this.updatedAt,
      this.id})
      : super._() {
    if (video == null) {
      throw new BuiltValueNullFieldError('TrackEntity', 'video');
    }
  }

  @override
  TrackEntity rebuild(void updates(TrackEntityBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  TrackEntityBuilder toBuilder() => new TrackEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrackEntity &&
        isIncluded == other.isIncluded &&
        delay == other.delay &&
        volume == other.volume &&
        orderId == other.orderId &&
        video == other.video &&
        deletedAt == other.deletedAt &&
        updatedAt == other.updatedAt &&
        id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, isIncluded.hashCode), delay.hashCode),
                            volume.hashCode),
                        orderId.hashCode),
                    video.hashCode),
                deletedAt.hashCode),
            updatedAt.hashCode),
        id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TrackEntity')
          ..add('isIncluded', isIncluded)
          ..add('delay', delay)
          ..add('volume', volume)
          ..add('orderId', orderId)
          ..add('video', video)
          ..add('deletedAt', deletedAt)
          ..add('updatedAt', updatedAt)
          ..add('id', id))
        .toString();
  }
}

class TrackEntityBuilder implements Builder<TrackEntity, TrackEntityBuilder> {
  _$TrackEntity _$v;

  bool _isIncluded;
  bool get isIncluded => _$this._isIncluded;
  set isIncluded(bool isIncluded) => _$this._isIncluded = isIncluded;

  int _delay;
  int get delay => _$this._delay;
  set delay(int delay) => _$this._delay = delay;

  int _volume;
  int get volume => _$this._volume;
  set volume(int volume) => _$this._volume = volume;

  int _orderId;
  int get orderId => _$this._orderId;
  set orderId(int orderId) => _$this._orderId = orderId;

  VideoEntityBuilder _video;
  VideoEntityBuilder get video => _$this._video ??= new VideoEntityBuilder();
  set video(VideoEntityBuilder video) => _$this._video = video;

  String _deletedAt;
  String get deletedAt => _$this._deletedAt;
  set deletedAt(String deletedAt) => _$this._deletedAt = deletedAt;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  TrackEntityBuilder();

  TrackEntityBuilder get _$this {
    if (_$v != null) {
      _isIncluded = _$v.isIncluded;
      _delay = _$v.delay;
      _volume = _$v.volume;
      _orderId = _$v.orderId;
      _video = _$v.video?.toBuilder();
      _deletedAt = _$v.deletedAt;
      _updatedAt = _$v.updatedAt;
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrackEntity other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TrackEntity;
  }

  @override
  void update(void updates(TrackEntityBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$TrackEntity build() {
    _$TrackEntity _$result;
    try {
      _$result = _$v ??
          new _$TrackEntity._(
              isIncluded: isIncluded,
              delay: delay,
              volume: volume,
              orderId: orderId,
              video: video.build(),
              deletedAt: deletedAt,
              updatedAt: updatedAt,
              id: id);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'video';
        video.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'TrackEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$CommentEntity extends CommentEntity {
  @override
  final ArtistEntity artist;
  @override
  final int artistId;
  @override
  final int songId;
  @override
  final String description;
  @override
  final String deletedAt;
  @override
  final String updatedAt;
  @override
  final int id;

  factory _$CommentEntity([void updates(CommentEntityBuilder b)]) =>
      (new CommentEntityBuilder()..update(updates)).build();

  _$CommentEntity._(
      {this.artist,
      this.artistId,
      this.songId,
      this.description,
      this.deletedAt,
      this.updatedAt,
      this.id})
      : super._() {
    if (artist == null) {
      throw new BuiltValueNullFieldError('CommentEntity', 'artist');
    }
    if (artistId == null) {
      throw new BuiltValueNullFieldError('CommentEntity', 'artistId');
    }
    if (songId == null) {
      throw new BuiltValueNullFieldError('CommentEntity', 'songId');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('CommentEntity', 'description');
    }
  }

  @override
  CommentEntity rebuild(void updates(CommentEntityBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  CommentEntityBuilder toBuilder() => new CommentEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommentEntity &&
        artist == other.artist &&
        artistId == other.artistId &&
        songId == other.songId &&
        description == other.description &&
        deletedAt == other.deletedAt &&
        updatedAt == other.updatedAt &&
        id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, artist.hashCode), artistId.hashCode),
                        songId.hashCode),
                    description.hashCode),
                deletedAt.hashCode),
            updatedAt.hashCode),
        id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CommentEntity')
          ..add('artist', artist)
          ..add('artistId', artistId)
          ..add('songId', songId)
          ..add('description', description)
          ..add('deletedAt', deletedAt)
          ..add('updatedAt', updatedAt)
          ..add('id', id))
        .toString();
  }
}

class CommentEntityBuilder
    implements Builder<CommentEntity, CommentEntityBuilder> {
  _$CommentEntity _$v;

  ArtistEntityBuilder _artist;
  ArtistEntityBuilder get artist =>
      _$this._artist ??= new ArtistEntityBuilder();
  set artist(ArtistEntityBuilder artist) => _$this._artist = artist;

  int _artistId;
  int get artistId => _$this._artistId;
  set artistId(int artistId) => _$this._artistId = artistId;

  int _songId;
  int get songId => _$this._songId;
  set songId(int songId) => _$this._songId = songId;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _deletedAt;
  String get deletedAt => _$this._deletedAt;
  set deletedAt(String deletedAt) => _$this._deletedAt = deletedAt;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  CommentEntityBuilder();

  CommentEntityBuilder get _$this {
    if (_$v != null) {
      _artist = _$v.artist?.toBuilder();
      _artistId = _$v.artistId;
      _songId = _$v.songId;
      _description = _$v.description;
      _deletedAt = _$v.deletedAt;
      _updatedAt = _$v.updatedAt;
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommentEntity other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CommentEntity;
  }

  @override
  void update(void updates(CommentEntityBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$CommentEntity build() {
    _$CommentEntity _$result;
    try {
      _$result = _$v ??
          new _$CommentEntity._(
              artist: artist.build(),
              artistId: artistId,
              songId: songId,
              description: description,
              deletedAt: deletedAt,
              updatedAt: updatedAt,
              id: id);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'artist';
        artist.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'CommentEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SongLikeEntity extends SongLikeEntity {
  @override
  final int id;
  @override
  final int userId;
  @override
  final int songId;
  @override
  final String deletedAt;
  @override
  final String updatedAt;

  factory _$SongLikeEntity([void updates(SongLikeEntityBuilder b)]) =>
      (new SongLikeEntityBuilder()..update(updates)).build();

  _$SongLikeEntity._(
      {this.id, this.userId, this.songId, this.deletedAt, this.updatedAt})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('SongLikeEntity', 'id');
    }
    if (userId == null) {
      throw new BuiltValueNullFieldError('SongLikeEntity', 'userId');
    }
    if (songId == null) {
      throw new BuiltValueNullFieldError('SongLikeEntity', 'songId');
    }
  }

  @override
  SongLikeEntity rebuild(void updates(SongLikeEntityBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  SongLikeEntityBuilder toBuilder() =>
      new SongLikeEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SongLikeEntity &&
        id == other.id &&
        userId == other.userId &&
        songId == other.songId &&
        deletedAt == other.deletedAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, id.hashCode), userId.hashCode), songId.hashCode),
            deletedAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SongLikeEntity')
          ..add('id', id)
          ..add('userId', userId)
          ..add('songId', songId)
          ..add('deletedAt', deletedAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class SongLikeEntityBuilder
    implements Builder<SongLikeEntity, SongLikeEntityBuilder> {
  _$SongLikeEntity _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  int _userId;
  int get userId => _$this._userId;
  set userId(int userId) => _$this._userId = userId;

  int _songId;
  int get songId => _$this._songId;
  set songId(int songId) => _$this._songId = songId;

  String _deletedAt;
  String get deletedAt => _$this._deletedAt;
  set deletedAt(String deletedAt) => _$this._deletedAt = deletedAt;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  SongLikeEntityBuilder();

  SongLikeEntityBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _userId = _$v.userId;
      _songId = _$v.songId;
      _deletedAt = _$v.deletedAt;
      _updatedAt = _$v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SongLikeEntity other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SongLikeEntity;
  }

  @override
  void update(void updates(SongLikeEntityBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$SongLikeEntity build() {
    final _$result = _$v ??
        new _$SongLikeEntity._(
            id: id,
            userId: userId,
            songId: songId,
            deletedAt: deletedAt,
            updatedAt: updatedAt);
    replace(_$result);
    return _$result;
  }
}

class _$SongFlagEntity extends SongFlagEntity {
  @override
  final int id;
  @override
  final int userId;
  @override
  final int songId;
  @override
  final String deletedAt;
  @override
  final String updatedAt;

  factory _$SongFlagEntity([void updates(SongFlagEntityBuilder b)]) =>
      (new SongFlagEntityBuilder()..update(updates)).build();

  _$SongFlagEntity._(
      {this.id, this.userId, this.songId, this.deletedAt, this.updatedAt})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('SongFlagEntity', 'id');
    }
    if (userId == null) {
      throw new BuiltValueNullFieldError('SongFlagEntity', 'userId');
    }
    if (songId == null) {
      throw new BuiltValueNullFieldError('SongFlagEntity', 'songId');
    }
  }

  @override
  SongFlagEntity rebuild(void updates(SongFlagEntityBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  SongFlagEntityBuilder toBuilder() =>
      new SongFlagEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SongFlagEntity &&
        id == other.id &&
        userId == other.userId &&
        songId == other.songId &&
        deletedAt == other.deletedAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, id.hashCode), userId.hashCode), songId.hashCode),
            deletedAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SongFlagEntity')
          ..add('id', id)
          ..add('userId', userId)
          ..add('songId', songId)
          ..add('deletedAt', deletedAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class SongFlagEntityBuilder
    implements Builder<SongFlagEntity, SongFlagEntityBuilder> {
  _$SongFlagEntity _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  int _userId;
  int get userId => _$this._userId;
  set userId(int userId) => _$this._userId = userId;

  int _songId;
  int get songId => _$this._songId;
  set songId(int songId) => _$this._songId = songId;

  String _deletedAt;
  String get deletedAt => _$this._deletedAt;
  set deletedAt(String deletedAt) => _$this._deletedAt = deletedAt;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  SongFlagEntityBuilder();

  SongFlagEntityBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _userId = _$v.userId;
      _songId = _$v.songId;
      _deletedAt = _$v.deletedAt;
      _updatedAt = _$v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SongFlagEntity other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SongFlagEntity;
  }

  @override
  void update(void updates(SongFlagEntityBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$SongFlagEntity build() {
    final _$result = _$v ??
        new _$SongFlagEntity._(
            id: id,
            userId: userId,
            songId: songId,
            deletedAt: deletedAt,
            updatedAt: updatedAt);
    replace(_$result);
    return _$result;
  }
}

class _$ArtistFlagEntity extends ArtistFlagEntity {
  @override
  final int id;
  @override
  final int artistId;
  @override
  final String deletedAt;
  @override
  final String updatedAt;

  factory _$ArtistFlagEntity([void updates(ArtistFlagEntityBuilder b)]) =>
      (new ArtistFlagEntityBuilder()..update(updates)).build();

  _$ArtistFlagEntity._({this.id, this.artistId, this.deletedAt, this.updatedAt})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('ArtistFlagEntity', 'id');
    }
    if (artistId == null) {
      throw new BuiltValueNullFieldError('ArtistFlagEntity', 'artistId');
    }
  }

  @override
  ArtistFlagEntity rebuild(void updates(ArtistFlagEntityBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ArtistFlagEntityBuilder toBuilder() =>
      new ArtistFlagEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArtistFlagEntity &&
        id == other.id &&
        artistId == other.artistId &&
        deletedAt == other.deletedAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, id.hashCode), artistId.hashCode), deletedAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ArtistFlagEntity')
          ..add('id', id)
          ..add('artistId', artistId)
          ..add('deletedAt', deletedAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ArtistFlagEntityBuilder
    implements Builder<ArtistFlagEntity, ArtistFlagEntityBuilder> {
  _$ArtistFlagEntity _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  int _artistId;
  int get artistId => _$this._artistId;
  set artistId(int artistId) => _$this._artistId = artistId;

  String _deletedAt;
  String get deletedAt => _$this._deletedAt;
  set deletedAt(String deletedAt) => _$this._deletedAt = deletedAt;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  ArtistFlagEntityBuilder();

  ArtistFlagEntityBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _artistId = _$v.artistId;
      _deletedAt = _$v.deletedAt;
      _updatedAt = _$v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArtistFlagEntity other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ArtistFlagEntity;
  }

  @override
  void update(void updates(ArtistFlagEntityBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$ArtistFlagEntity build() {
    final _$result = _$v ??
        new _$ArtistFlagEntity._(
            id: id,
            artistId: artistId,
            deletedAt: deletedAt,
            updatedAt: updatedAt);
    replace(_$result);
    return _$result;
  }
}

class _$VideoEntity extends VideoEntity {
  @override
  final int userId;
  @override
  final int timestamp;
  @override
  final String url;
  @override
  final String thumbnailUrl;
  @override
  final String remoteVideoId;
  @override
  final String description;
  @override
  final int duration;
  @override
  final String deletedAt;
  @override
  final String updatedAt;
  @override
  final int id;

  factory _$VideoEntity([void updates(VideoEntityBuilder b)]) =>
      (new VideoEntityBuilder()..update(updates)).build();

  _$VideoEntity._(
      {this.userId,
      this.timestamp,
      this.url,
      this.thumbnailUrl,
      this.remoteVideoId,
      this.description,
      this.duration,
      this.deletedAt,
      this.updatedAt,
      this.id})
      : super._() {
    if (userId == null) {
      throw new BuiltValueNullFieldError('VideoEntity', 'userId');
    }
  }

  @override
  VideoEntity rebuild(void updates(VideoEntityBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  VideoEntityBuilder toBuilder() => new VideoEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VideoEntity &&
        userId == other.userId &&
        timestamp == other.timestamp &&
        url == other.url &&
        thumbnailUrl == other.thumbnailUrl &&
        remoteVideoId == other.remoteVideoId &&
        description == other.description &&
        duration == other.duration &&
        deletedAt == other.deletedAt &&
        updatedAt == other.updatedAt &&
        id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc($jc(0, userId.hashCode),
                                        timestamp.hashCode),
                                    url.hashCode),
                                thumbnailUrl.hashCode),
                            remoteVideoId.hashCode),
                        description.hashCode),
                    duration.hashCode),
                deletedAt.hashCode),
            updatedAt.hashCode),
        id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('VideoEntity')
          ..add('userId', userId)
          ..add('timestamp', timestamp)
          ..add('url', url)
          ..add('thumbnailUrl', thumbnailUrl)
          ..add('remoteVideoId', remoteVideoId)
          ..add('description', description)
          ..add('duration', duration)
          ..add('deletedAt', deletedAt)
          ..add('updatedAt', updatedAt)
          ..add('id', id))
        .toString();
  }
}

class VideoEntityBuilder implements Builder<VideoEntity, VideoEntityBuilder> {
  _$VideoEntity _$v;

  int _userId;
  int get userId => _$this._userId;
  set userId(int userId) => _$this._userId = userId;

  int _timestamp;
  int get timestamp => _$this._timestamp;
  set timestamp(int timestamp) => _$this._timestamp = timestamp;

  String _url;
  String get url => _$this._url;
  set url(String url) => _$this._url = url;

  String _thumbnailUrl;
  String get thumbnailUrl => _$this._thumbnailUrl;
  set thumbnailUrl(String thumbnailUrl) => _$this._thumbnailUrl = thumbnailUrl;

  String _remoteVideoId;
  String get remoteVideoId => _$this._remoteVideoId;
  set remoteVideoId(String remoteVideoId) =>
      _$this._remoteVideoId = remoteVideoId;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  int _duration;
  int get duration => _$this._duration;
  set duration(int duration) => _$this._duration = duration;

  String _deletedAt;
  String get deletedAt => _$this._deletedAt;
  set deletedAt(String deletedAt) => _$this._deletedAt = deletedAt;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  VideoEntityBuilder();

  VideoEntityBuilder get _$this {
    if (_$v != null) {
      _userId = _$v.userId;
      _timestamp = _$v.timestamp;
      _url = _$v.url;
      _thumbnailUrl = _$v.thumbnailUrl;
      _remoteVideoId = _$v.remoteVideoId;
      _description = _$v.description;
      _duration = _$v.duration;
      _deletedAt = _$v.deletedAt;
      _updatedAt = _$v.updatedAt;
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VideoEntity other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$VideoEntity;
  }

  @override
  void update(void updates(VideoEntityBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$VideoEntity build() {
    final _$result = _$v ??
        new _$VideoEntity._(
            userId: userId,
            timestamp: timestamp,
            url: url,
            thumbnailUrl: thumbnailUrl,
            remoteVideoId: remoteVideoId,
            description: description,
            duration: duration,
            deletedAt: deletedAt,
            updatedAt: updatedAt,
            id: id);
    replace(_$result);
    return _$result;
  }
}

class _$SongListResponse extends SongListResponse {
  @override
  final BuiltList<SongEntity> data;

  factory _$SongListResponse([void updates(SongListResponseBuilder b)]) =>
      (new SongListResponseBuilder()..update(updates)).build();

  _$SongListResponse._({this.data}) : super._() {
    if (data == null) {
      throw new BuiltValueNullFieldError('SongListResponse', 'data');
    }
  }

  @override
  SongListResponse rebuild(void updates(SongListResponseBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  SongListResponseBuilder toBuilder() =>
      new SongListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SongListResponse && data == other.data;
  }

  @override
  int get hashCode {
    return $jf($jc(0, data.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SongListResponse')..add('data', data))
        .toString();
  }
}

class SongListResponseBuilder
    implements Builder<SongListResponse, SongListResponseBuilder> {
  _$SongListResponse _$v;

  ListBuilder<SongEntity> _data;
  ListBuilder<SongEntity> get data =>
      _$this._data ??= new ListBuilder<SongEntity>();
  set data(ListBuilder<SongEntity> data) => _$this._data = data;

  SongListResponseBuilder();

  SongListResponseBuilder get _$this {
    if (_$v != null) {
      _data = _$v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SongListResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SongListResponse;
  }

  @override
  void update(void updates(SongListResponseBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$SongListResponse build() {
    _$SongListResponse _$result;
    try {
      _$result = _$v ?? new _$SongListResponse._(data: data.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'SongListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SongItemResponse extends SongItemResponse {
  @override
  final SongEntity data;

  factory _$SongItemResponse([void updates(SongItemResponseBuilder b)]) =>
      (new SongItemResponseBuilder()..update(updates)).build();

  _$SongItemResponse._({this.data}) : super._() {
    if (data == null) {
      throw new BuiltValueNullFieldError('SongItemResponse', 'data');
    }
  }

  @override
  SongItemResponse rebuild(void updates(SongItemResponseBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  SongItemResponseBuilder toBuilder() =>
      new SongItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SongItemResponse && data == other.data;
  }

  @override
  int get hashCode {
    return $jf($jc(0, data.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SongItemResponse')..add('data', data))
        .toString();
  }
}

class SongItemResponseBuilder
    implements Builder<SongItemResponse, SongItemResponseBuilder> {
  _$SongItemResponse _$v;

  SongEntityBuilder _data;
  SongEntityBuilder get data => _$this._data ??= new SongEntityBuilder();
  set data(SongEntityBuilder data) => _$this._data = data;

  SongItemResponseBuilder();

  SongItemResponseBuilder get _$this {
    if (_$v != null) {
      _data = _$v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SongItemResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SongItemResponse;
  }

  @override
  void update(void updates(SongItemResponseBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$SongItemResponse build() {
    _$SongItemResponse _$result;
    try {
      _$result = _$v ?? new _$SongItemResponse._(data: data.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'SongItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$CommentItemResponse extends CommentItemResponse {
  @override
  final CommentEntity data;

  factory _$CommentItemResponse([void updates(CommentItemResponseBuilder b)]) =>
      (new CommentItemResponseBuilder()..update(updates)).build();

  _$CommentItemResponse._({this.data}) : super._() {
    if (data == null) {
      throw new BuiltValueNullFieldError('CommentItemResponse', 'data');
    }
  }

  @override
  CommentItemResponse rebuild(void updates(CommentItemResponseBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  CommentItemResponseBuilder toBuilder() =>
      new CommentItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommentItemResponse && data == other.data;
  }

  @override
  int get hashCode {
    return $jf($jc(0, data.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CommentItemResponse')
          ..add('data', data))
        .toString();
  }
}

class CommentItemResponseBuilder
    implements Builder<CommentItemResponse, CommentItemResponseBuilder> {
  _$CommentItemResponse _$v;

  CommentEntityBuilder _data;
  CommentEntityBuilder get data => _$this._data ??= new CommentEntityBuilder();
  set data(CommentEntityBuilder data) => _$this._data = data;

  CommentItemResponseBuilder();

  CommentItemResponseBuilder get _$this {
    if (_$v != null) {
      _data = _$v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommentItemResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CommentItemResponse;
  }

  @override
  void update(void updates(CommentItemResponseBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$CommentItemResponse build() {
    _$CommentItemResponse _$result;
    try {
      _$result = _$v ?? new _$CommentItemResponse._(data: data.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'CommentItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$LikeSongResponse extends LikeSongResponse {
  @override
  final SongLikeEntity data;

  factory _$LikeSongResponse([void updates(LikeSongResponseBuilder b)]) =>
      (new LikeSongResponseBuilder()..update(updates)).build();

  _$LikeSongResponse._({this.data}) : super._() {
    if (data == null) {
      throw new BuiltValueNullFieldError('LikeSongResponse', 'data');
    }
  }

  @override
  LikeSongResponse rebuild(void updates(LikeSongResponseBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  LikeSongResponseBuilder toBuilder() =>
      new LikeSongResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LikeSongResponse && data == other.data;
  }

  @override
  int get hashCode {
    return $jf($jc(0, data.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LikeSongResponse')..add('data', data))
        .toString();
  }
}

class LikeSongResponseBuilder
    implements Builder<LikeSongResponse, LikeSongResponseBuilder> {
  _$LikeSongResponse _$v;

  SongLikeEntityBuilder _data;
  SongLikeEntityBuilder get data =>
      _$this._data ??= new SongLikeEntityBuilder();
  set data(SongLikeEntityBuilder data) => _$this._data = data;

  LikeSongResponseBuilder();

  LikeSongResponseBuilder get _$this {
    if (_$v != null) {
      _data = _$v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LikeSongResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$LikeSongResponse;
  }

  @override
  void update(void updates(LikeSongResponseBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$LikeSongResponse build() {
    _$LikeSongResponse _$result;
    try {
      _$result = _$v ?? new _$LikeSongResponse._(data: data.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'LikeSongResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$FlagSongResponse extends FlagSongResponse {
  @override
  final SongFlagEntity data;

  factory _$FlagSongResponse([void updates(FlagSongResponseBuilder b)]) =>
      (new FlagSongResponseBuilder()..update(updates)).build();

  _$FlagSongResponse._({this.data}) : super._() {
    if (data == null) {
      throw new BuiltValueNullFieldError('FlagSongResponse', 'data');
    }
  }

  @override
  FlagSongResponse rebuild(void updates(FlagSongResponseBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  FlagSongResponseBuilder toBuilder() =>
      new FlagSongResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FlagSongResponse && data == other.data;
  }

  @override
  int get hashCode {
    return $jf($jc(0, data.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FlagSongResponse')..add('data', data))
        .toString();
  }
}

class FlagSongResponseBuilder
    implements Builder<FlagSongResponse, FlagSongResponseBuilder> {
  _$FlagSongResponse _$v;

  SongFlagEntityBuilder _data;
  SongFlagEntityBuilder get data =>
      _$this._data ??= new SongFlagEntityBuilder();
  set data(SongFlagEntityBuilder data) => _$this._data = data;

  FlagSongResponseBuilder();

  FlagSongResponseBuilder get _$this {
    if (_$v != null) {
      _data = _$v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FlagSongResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FlagSongResponse;
  }

  @override
  void update(void updates(FlagSongResponseBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$FlagSongResponse build() {
    _$FlagSongResponse _$result;
    try {
      _$result = _$v ?? new _$FlagSongResponse._(data: data.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'FlagSongResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$VideoItemResponse extends VideoItemResponse {
  @override
  final VideoEntity data;

  factory _$VideoItemResponse([void updates(VideoItemResponseBuilder b)]) =>
      (new VideoItemResponseBuilder()..update(updates)).build();

  _$VideoItemResponse._({this.data}) : super._() {
    if (data == null) {
      throw new BuiltValueNullFieldError('VideoItemResponse', 'data');
    }
  }

  @override
  VideoItemResponse rebuild(void updates(VideoItemResponseBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  VideoItemResponseBuilder toBuilder() =>
      new VideoItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VideoItemResponse && data == other.data;
  }

  @override
  int get hashCode {
    return $jf($jc(0, data.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('VideoItemResponse')..add('data', data))
        .toString();
  }
}

class VideoItemResponseBuilder
    implements Builder<VideoItemResponse, VideoItemResponseBuilder> {
  _$VideoItemResponse _$v;

  VideoEntityBuilder _data;
  VideoEntityBuilder get data => _$this._data ??= new VideoEntityBuilder();
  set data(VideoEntityBuilder data) => _$this._data = data;

  VideoItemResponseBuilder();

  VideoItemResponseBuilder get _$this {
    if (_$v != null) {
      _data = _$v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VideoItemResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$VideoItemResponse;
  }

  @override
  void update(void updates(VideoItemResponseBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$VideoItemResponse build() {
    _$VideoItemResponse _$result;
    try {
      _$result = _$v ?? new _$VideoItemResponse._(data: data.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'VideoItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}
