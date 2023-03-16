// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

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
  Iterable<Object> serialize(Serializers serializers, SongEntity object,
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
      'width',
      serializers.serialize(object.width, specifiedType: const FullType(int)),
      'height',
      serializers.serialize(object.height, specifiedType: const FullType(int)),
      'duration',
      serializers.serialize(object.duration,
          specifiedType: const FullType(int)),
      'is_flagged',
      serializers.serialize(object.isFlagged,
          specifiedType: const FullType(bool)),
      'is_public',
      serializers.serialize(object.isPublic,
          specifiedType: const FullType(bool)),
      'is_approved',
      serializers.serialize(object.isApproved,
          specifiedType: const FullType(bool)),
      'is_featured',
      serializers.serialize(object.isFeatured,
          specifiedType: const FullType(bool)),
      'video_url',
      serializers.serialize(object.videoUrl,
          specifiedType: const FullType(String)),
      'thumbnail_url',
      serializers.serialize(object.thumbnailUrl,
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
      'is_rendered',
      serializers.serialize(object.isRendered,
          specifiedType: const FullType(bool)),
    ];
    Object value;
    value = object.color;
    if (value != null) {
      result
        ..add('color')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.artistId;
    if (value != null) {
      result
        ..add('user_id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.artist;
    if (value != null) {
      result
        ..add('user')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(ArtistEntity)));
    }
    value = object.genreId;
    if (value != null) {
      result
        ..add('genre_id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.parentId;
    if (value != null) {
      result
        ..add('parent_id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.blurhash;
    if (value != null) {
      result
        ..add('blurhash')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.countPlay;
    if (value != null) {
      result
        ..add('count_play')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.countLike;
    if (value != null) {
      result
        ..add('count_like')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.trackVideoUrl;
    if (value != null) {
      result
        ..add('track_video_url')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.youTubeId;
    if (value != null) {
      result
        ..add('youtube_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.twitterId;
    if (value != null) {
      result
        ..add('twitter_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.joinedArtists;
    if (value != null) {
      result
        ..add('joined_users')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                BuiltList, const [const FullType(ArtistEntity)])));
    }
    value = object.sharingKey;
    if (value != null) {
      result
        ..add('sharing_key')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.deletedAt;
    if (value != null) {
      result
        ..add('deleted_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.updatedAt;
    if (value != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  SongEntity deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SongEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
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
        case 'width':
          result.width = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'height':
          result.height = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'color':
          result.color = serializers.deserialize(value,
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
        case 'blurhash':
          result.blurhash = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
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
        case 'is_approved':
          result.isApproved = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'is_featured':
          result.isFeatured = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'video_url':
          result.videoUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'track_video_url':
          result.trackVideoUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'youtube_id':
          result.youTubeId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'twitter_id':
          result.twitterId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'thumbnail_url':
          result.thumbnailUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'song_videos':
          result.tracks.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(TrackEntity)]))
              as BuiltList<Object>);
          break;
        case 'joined_users':
          result.joinedArtists.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ArtistEntity)]))
              as BuiltList<Object>);
          break;
        case 'comments':
          result.comments.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(CommentEntity)]))
              as BuiltList<Object>);
          break;
        case 'layout':
          result.layout = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'is_rendered':
          result.isRendered = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'sharing_key':
          result.sharingKey = serializers.deserialize(value,
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
  Iterable<Object> serialize(Serializers serializers, TrackEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'video',
      serializers.serialize(object.video,
          specifiedType: const FullType(VideoEntity)),
    ];
    Object value;
    value = object.isIncluded;
    if (value != null) {
      result
        ..add('is_included')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.delay;
    if (value != null) {
      result
        ..add('delay')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.volume;
    if (value != null) {
      result
        ..add('volume')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.orderId;
    if (value != null) {
      result
        ..add('order_id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.deletedAt;
    if (value != null) {
      result
        ..add('deleted_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.updatedAt;
    if (value != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  TrackEntity deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TrackEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
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
  Iterable<Object> serialize(Serializers serializers, CommentEntity object,
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
    Object value;
    value = object.deletedAt;
    if (value != null) {
      result
        ..add('deleted_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.updatedAt;
    if (value != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  CommentEntity deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CommentEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
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
  Iterable<Object> serialize(Serializers serializers, SongLikeEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'user_id',
      serializers.serialize(object.userId, specifiedType: const FullType(int)),
      'song_id',
      serializers.serialize(object.songId, specifiedType: const FullType(int)),
    ];
    Object value;
    value = object.deletedAt;
    if (value != null) {
      result
        ..add('deleted_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.updatedAt;
    if (value != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  SongLikeEntity deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SongLikeEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
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
  Iterable<Object> serialize(Serializers serializers, SongFlagEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'user_id',
      serializers.serialize(object.userId, specifiedType: const FullType(int)),
      'song_id',
      serializers.serialize(object.songId, specifiedType: const FullType(int)),
    ];
    Object value;
    value = object.deletedAt;
    if (value != null) {
      result
        ..add('deleted_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.updatedAt;
    if (value != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  SongFlagEntity deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SongFlagEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
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
  Iterable<Object> serialize(Serializers serializers, ArtistFlagEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'user_id',
      serializers.serialize(object.artistId,
          specifiedType: const FullType(int)),
    ];
    Object value;
    value = object.deletedAt;
    if (value != null) {
      result
        ..add('deleted_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.updatedAt;
    if (value != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  ArtistFlagEntity deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ArtistFlagEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
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
  Iterable<Object> serialize(Serializers serializers, VideoEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'user_id',
      serializers.serialize(object.userId, specifiedType: const FullType(int)),
    ];
    Object value;
    value = object.timestamp;
    if (value != null) {
      result
        ..add('timestamp')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.url;
    if (value != null) {
      result
        ..add('url')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.recognitions;
    if (value != null) {
      result
        ..add('recognitions')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.thumbnailUrl;
    if (value != null) {
      result
        ..add('thumbnail_url')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.remoteVideoId;
    if (value != null) {
      result
        ..add('remote_video_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.volumeData;
    if (value != null) {
      result
        ..add('volume_data')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltMap,
                const [const FullType(String), const FullType(double)])));
    }
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.duration;
    if (value != null) {
      result
        ..add('duration')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.deletedAt;
    if (value != null) {
      result
        ..add('deleted_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.updatedAt;
    if (value != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  VideoEntity deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new VideoEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
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
        case 'recognitions':
          result.recognitions = serializers.deserialize(value,
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
        case 'volume_data':
          result.volumeData.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(String), const FullType(double)])));
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
  Iterable<Object> serialize(Serializers serializers, SongListResponse object,
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
  SongListResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SongListResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(SongEntity)]))
              as BuiltList<Object>);
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
  Iterable<Object> serialize(Serializers serializers, SongItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(SongEntity)),
    ];

    return result;
  }

  @override
  SongItemResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SongItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
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
  Iterable<Object> serialize(
      Serializers serializers, CommentItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(CommentEntity)),
    ];

    return result;
  }

  @override
  CommentItemResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CommentItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
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
  Iterable<Object> serialize(Serializers serializers, LikeSongResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(SongLikeEntity)),
    ];

    return result;
  }

  @override
  LikeSongResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LikeSongResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
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
  Iterable<Object> serialize(Serializers serializers, FlagSongResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(SongFlagEntity)),
    ];

    return result;
  }

  @override
  FlagSongResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FlagSongResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
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
  Iterable<Object> serialize(Serializers serializers, VideoItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(VideoEntity)),
    ];

    return result;
  }

  @override
  VideoItemResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new VideoItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
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
  final int width;
  @override
  final int height;
  @override
  final String color;
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
  final String blurhash;
  @override
  final int countPlay;
  @override
  final int countLike;
  @override
  final bool isFlagged;
  @override
  final bool isPublic;
  @override
  final bool isApproved;
  @override
  final bool isFeatured;
  @override
  final String videoUrl;
  @override
  final String trackVideoUrl;
  @override
  final String youTubeId;
  @override
  final String twitterId;
  @override
  final String thumbnailUrl;
  @override
  final BuiltList<TrackEntity> tracks;
  @override
  final BuiltList<ArtistEntity> joinedArtists;
  @override
  final BuiltList<CommentEntity> comments;
  @override
  final String layout;
  @override
  final bool isRendered;
  @override
  final String sharingKey;
  @override
  final int id;
  @override
  final String deletedAt;
  @override
  final String updatedAt;

  factory _$SongEntity([void Function(SongEntityBuilder) updates]) =>
      (new SongEntityBuilder()..update(updates))._build();

  _$SongEntity._(
      {this.title,
      this.description,
      this.url,
      this.width,
      this.height,
      this.color,
      this.artistId,
      this.artist,
      this.genreId,
      this.parentId,
      this.duration,
      this.blurhash,
      this.countPlay,
      this.countLike,
      this.isFlagged,
      this.isPublic,
      this.isApproved,
      this.isFeatured,
      this.videoUrl,
      this.trackVideoUrl,
      this.youTubeId,
      this.twitterId,
      this.thumbnailUrl,
      this.tracks,
      this.joinedArtists,
      this.comments,
      this.layout,
      this.isRendered,
      this.sharingKey,
      this.id,
      this.deletedAt,
      this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'SongEntity', 'title');
    BuiltValueNullFieldError.checkNotNull(
        description, r'SongEntity', 'description');
    BuiltValueNullFieldError.checkNotNull(url, r'SongEntity', 'url');
    BuiltValueNullFieldError.checkNotNull(width, r'SongEntity', 'width');
    BuiltValueNullFieldError.checkNotNull(height, r'SongEntity', 'height');
    BuiltValueNullFieldError.checkNotNull(duration, r'SongEntity', 'duration');
    BuiltValueNullFieldError.checkNotNull(
        isFlagged, r'SongEntity', 'isFlagged');
    BuiltValueNullFieldError.checkNotNull(isPublic, r'SongEntity', 'isPublic');
    BuiltValueNullFieldError.checkNotNull(
        isApproved, r'SongEntity', 'isApproved');
    BuiltValueNullFieldError.checkNotNull(
        isFeatured, r'SongEntity', 'isFeatured');
    BuiltValueNullFieldError.checkNotNull(videoUrl, r'SongEntity', 'videoUrl');
    BuiltValueNullFieldError.checkNotNull(
        thumbnailUrl, r'SongEntity', 'thumbnailUrl');
    BuiltValueNullFieldError.checkNotNull(tracks, r'SongEntity', 'tracks');
    BuiltValueNullFieldError.checkNotNull(comments, r'SongEntity', 'comments');
    BuiltValueNullFieldError.checkNotNull(layout, r'SongEntity', 'layout');
    BuiltValueNullFieldError.checkNotNull(
        isRendered, r'SongEntity', 'isRendered');
  }

  @override
  SongEntity rebuild(void Function(SongEntityBuilder) updates) =>
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
        width == other.width &&
        height == other.height &&
        color == other.color &&
        artistId == other.artistId &&
        artist == other.artist &&
        genreId == other.genreId &&
        parentId == other.parentId &&
        duration == other.duration &&
        blurhash == other.blurhash &&
        countPlay == other.countPlay &&
        countLike == other.countLike &&
        isFlagged == other.isFlagged &&
        isPublic == other.isPublic &&
        isApproved == other.isApproved &&
        isFeatured == other.isFeatured &&
        videoUrl == other.videoUrl &&
        trackVideoUrl == other.trackVideoUrl &&
        youTubeId == other.youTubeId &&
        twitterId == other.twitterId &&
        thumbnailUrl == other.thumbnailUrl &&
        tracks == other.tracks &&
        joinedArtists == other.joinedArtists &&
        comments == other.comments &&
        layout == other.layout &&
        isRendered == other.isRendered &&
        sharingKey == other.sharingKey &&
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
                                                                            $jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc(0, title.hashCode), description.hashCode), url.hashCode), width.hashCode), height.hashCode), color.hashCode), artistId.hashCode), artist.hashCode), genreId.hashCode), parentId.hashCode), duration.hashCode), blurhash.hashCode), countPlay.hashCode),
                                                                                countLike.hashCode),
                                                                            isFlagged.hashCode),
                                                                        isPublic.hashCode),
                                                                    isApproved.hashCode),
                                                                isFeatured.hashCode),
                                                            videoUrl.hashCode),
                                                        trackVideoUrl.hashCode),
                                                    youTubeId.hashCode),
                                                twitterId.hashCode),
                                            thumbnailUrl.hashCode),
                                        tracks.hashCode),
                                    joinedArtists.hashCode),
                                comments.hashCode),
                            layout.hashCode),
                        isRendered.hashCode),
                    sharingKey.hashCode),
                id.hashCode),
            deletedAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SongEntity')
          ..add('title', title)
          ..add('description', description)
          ..add('url', url)
          ..add('width', width)
          ..add('height', height)
          ..add('color', color)
          ..add('artistId', artistId)
          ..add('artist', artist)
          ..add('genreId', genreId)
          ..add('parentId', parentId)
          ..add('duration', duration)
          ..add('blurhash', blurhash)
          ..add('countPlay', countPlay)
          ..add('countLike', countLike)
          ..add('isFlagged', isFlagged)
          ..add('isPublic', isPublic)
          ..add('isApproved', isApproved)
          ..add('isFeatured', isFeatured)
          ..add('videoUrl', videoUrl)
          ..add('trackVideoUrl', trackVideoUrl)
          ..add('youTubeId', youTubeId)
          ..add('twitterId', twitterId)
          ..add('thumbnailUrl', thumbnailUrl)
          ..add('tracks', tracks)
          ..add('joinedArtists', joinedArtists)
          ..add('comments', comments)
          ..add('layout', layout)
          ..add('isRendered', isRendered)
          ..add('sharingKey', sharingKey)
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

  int _width;
  int get width => _$this._width;
  set width(int width) => _$this._width = width;

  int _height;
  int get height => _$this._height;
  set height(int height) => _$this._height = height;

  String _color;
  String get color => _$this._color;
  set color(String color) => _$this._color = color;

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

  String _blurhash;
  String get blurhash => _$this._blurhash;
  set blurhash(String blurhash) => _$this._blurhash = blurhash;

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

  bool _isApproved;
  bool get isApproved => _$this._isApproved;
  set isApproved(bool isApproved) => _$this._isApproved = isApproved;

  bool _isFeatured;
  bool get isFeatured => _$this._isFeatured;
  set isFeatured(bool isFeatured) => _$this._isFeatured = isFeatured;

  String _videoUrl;
  String get videoUrl => _$this._videoUrl;
  set videoUrl(String videoUrl) => _$this._videoUrl = videoUrl;

  String _trackVideoUrl;
  String get trackVideoUrl => _$this._trackVideoUrl;
  set trackVideoUrl(String trackVideoUrl) =>
      _$this._trackVideoUrl = trackVideoUrl;

  String _youTubeId;
  String get youTubeId => _$this._youTubeId;
  set youTubeId(String youTubeId) => _$this._youTubeId = youTubeId;

  String _twitterId;
  String get twitterId => _$this._twitterId;
  set twitterId(String twitterId) => _$this._twitterId = twitterId;

  String _thumbnailUrl;
  String get thumbnailUrl => _$this._thumbnailUrl;
  set thumbnailUrl(String thumbnailUrl) => _$this._thumbnailUrl = thumbnailUrl;

  ListBuilder<TrackEntity> _tracks;
  ListBuilder<TrackEntity> get tracks =>
      _$this._tracks ??= new ListBuilder<TrackEntity>();
  set tracks(ListBuilder<TrackEntity> tracks) => _$this._tracks = tracks;

  ListBuilder<ArtistEntity> _joinedArtists;
  ListBuilder<ArtistEntity> get joinedArtists =>
      _$this._joinedArtists ??= new ListBuilder<ArtistEntity>();
  set joinedArtists(ListBuilder<ArtistEntity> joinedArtists) =>
      _$this._joinedArtists = joinedArtists;

  ListBuilder<CommentEntity> _comments;
  ListBuilder<CommentEntity> get comments =>
      _$this._comments ??= new ListBuilder<CommentEntity>();
  set comments(ListBuilder<CommentEntity> comments) =>
      _$this._comments = comments;

  String _layout;
  String get layout => _$this._layout;
  set layout(String layout) => _$this._layout = layout;

  bool _isRendered;
  bool get isRendered => _$this._isRendered;
  set isRendered(bool isRendered) => _$this._isRendered = isRendered;

  String _sharingKey;
  String get sharingKey => _$this._sharingKey;
  set sharingKey(String sharingKey) => _$this._sharingKey = sharingKey;

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
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _description = $v.description;
      _url = $v.url;
      _width = $v.width;
      _height = $v.height;
      _color = $v.color;
      _artistId = $v.artistId;
      _artist = $v.artist?.toBuilder();
      _genreId = $v.genreId;
      _parentId = $v.parentId;
      _duration = $v.duration;
      _blurhash = $v.blurhash;
      _countPlay = $v.countPlay;
      _countLike = $v.countLike;
      _isFlagged = $v.isFlagged;
      _isPublic = $v.isPublic;
      _isApproved = $v.isApproved;
      _isFeatured = $v.isFeatured;
      _videoUrl = $v.videoUrl;
      _trackVideoUrl = $v.trackVideoUrl;
      _youTubeId = $v.youTubeId;
      _twitterId = $v.twitterId;
      _thumbnailUrl = $v.thumbnailUrl;
      _tracks = $v.tracks.toBuilder();
      _joinedArtists = $v.joinedArtists?.toBuilder();
      _comments = $v.comments.toBuilder();
      _layout = $v.layout;
      _isRendered = $v.isRendered;
      _sharingKey = $v.sharingKey;
      _id = $v.id;
      _deletedAt = $v.deletedAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SongEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SongEntity;
  }

  @override
  void update(void Function(SongEntityBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  SongEntity build() => _build();

  _$SongEntity _build() {
    _$SongEntity _$result;
    try {
      _$result = _$v ??
          new _$SongEntity._(
              title: BuiltValueNullFieldError.checkNotNull(
                  title, r'SongEntity', 'title'),
              description: BuiltValueNullFieldError.checkNotNull(
                  description, r'SongEntity', 'description'),
              url: BuiltValueNullFieldError.checkNotNull(
                  url, r'SongEntity', 'url'),
              width: BuiltValueNullFieldError.checkNotNull(
                  width, r'SongEntity', 'width'),
              height: BuiltValueNullFieldError.checkNotNull(
                  height, r'SongEntity', 'height'),
              color: color,
              artistId: artistId,
              artist: _artist?.build(),
              genreId: genreId,
              parentId: parentId,
              duration: BuiltValueNullFieldError.checkNotNull(
                  duration, r'SongEntity', 'duration'),
              blurhash: blurhash,
              countPlay: countPlay,
              countLike: countLike,
              isFlagged: BuiltValueNullFieldError.checkNotNull(
                  isFlagged, r'SongEntity', 'isFlagged'),
              isPublic: BuiltValueNullFieldError.checkNotNull(
                  isPublic, r'SongEntity', 'isPublic'),
              isApproved: BuiltValueNullFieldError.checkNotNull(
                  isApproved, r'SongEntity', 'isApproved'),
              isFeatured: BuiltValueNullFieldError.checkNotNull(
                  isFeatured, r'SongEntity', 'isFeatured'),
              videoUrl: BuiltValueNullFieldError.checkNotNull(videoUrl, r'SongEntity', 'videoUrl'),
              trackVideoUrl: trackVideoUrl,
              youTubeId: youTubeId,
              twitterId: twitterId,
              thumbnailUrl: BuiltValueNullFieldError.checkNotNull(thumbnailUrl, r'SongEntity', 'thumbnailUrl'),
              tracks: tracks.build(),
              joinedArtists: _joinedArtists?.build(),
              comments: comments.build(),
              layout: BuiltValueNullFieldError.checkNotNull(layout, r'SongEntity', 'layout'),
              isRendered: BuiltValueNullFieldError.checkNotNull(isRendered, r'SongEntity', 'isRendered'),
              sharingKey: sharingKey,
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
        _$failedField = 'joinedArtists';
        _joinedArtists?.build();
        _$failedField = 'comments';
        comments.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SongEntity', _$failedField, e.toString());
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

  factory _$TrackEntity([void Function(TrackEntityBuilder) updates]) =>
      (new TrackEntityBuilder()..update(updates))._build();

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
    BuiltValueNullFieldError.checkNotNull(video, r'TrackEntity', 'video');
  }

  @override
  TrackEntity rebuild(void Function(TrackEntityBuilder) updates) =>
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
    return (newBuiltValueToStringHelper(r'TrackEntity')
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
    final $v = _$v;
    if ($v != null) {
      _isIncluded = $v.isIncluded;
      _delay = $v.delay;
      _volume = $v.volume;
      _orderId = $v.orderId;
      _video = $v.video.toBuilder();
      _deletedAt = $v.deletedAt;
      _updatedAt = $v.updatedAt;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrackEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TrackEntity;
  }

  @override
  void update(void Function(TrackEntityBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  TrackEntity build() => _build();

  _$TrackEntity _build() {
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
            r'TrackEntity', _$failedField, e.toString());
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

  factory _$CommentEntity([void Function(CommentEntityBuilder) updates]) =>
      (new CommentEntityBuilder()..update(updates))._build();

  _$CommentEntity._(
      {this.artist,
      this.artistId,
      this.songId,
      this.description,
      this.deletedAt,
      this.updatedAt,
      this.id})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(artist, r'CommentEntity', 'artist');
    BuiltValueNullFieldError.checkNotNull(
        artistId, r'CommentEntity', 'artistId');
    BuiltValueNullFieldError.checkNotNull(songId, r'CommentEntity', 'songId');
    BuiltValueNullFieldError.checkNotNull(
        description, r'CommentEntity', 'description');
  }

  @override
  CommentEntity rebuild(void Function(CommentEntityBuilder) updates) =>
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
    return (newBuiltValueToStringHelper(r'CommentEntity')
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
    final $v = _$v;
    if ($v != null) {
      _artist = $v.artist.toBuilder();
      _artistId = $v.artistId;
      _songId = $v.songId;
      _description = $v.description;
      _deletedAt = $v.deletedAt;
      _updatedAt = $v.updatedAt;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommentEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CommentEntity;
  }

  @override
  void update(void Function(CommentEntityBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  CommentEntity build() => _build();

  _$CommentEntity _build() {
    _$CommentEntity _$result;
    try {
      _$result = _$v ??
          new _$CommentEntity._(
              artist: artist.build(),
              artistId: BuiltValueNullFieldError.checkNotNull(
                  artistId, r'CommentEntity', 'artistId'),
              songId: BuiltValueNullFieldError.checkNotNull(
                  songId, r'CommentEntity', 'songId'),
              description: BuiltValueNullFieldError.checkNotNull(
                  description, r'CommentEntity', 'description'),
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
            r'CommentEntity', _$failedField, e.toString());
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

  factory _$SongLikeEntity([void Function(SongLikeEntityBuilder) updates]) =>
      (new SongLikeEntityBuilder()..update(updates))._build();

  _$SongLikeEntity._(
      {this.id, this.userId, this.songId, this.deletedAt, this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'SongLikeEntity', 'id');
    BuiltValueNullFieldError.checkNotNull(userId, r'SongLikeEntity', 'userId');
    BuiltValueNullFieldError.checkNotNull(songId, r'SongLikeEntity', 'songId');
  }

  @override
  SongLikeEntity rebuild(void Function(SongLikeEntityBuilder) updates) =>
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
    return (newBuiltValueToStringHelper(r'SongLikeEntity')
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
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _songId = $v.songId;
      _deletedAt = $v.deletedAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SongLikeEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SongLikeEntity;
  }

  @override
  void update(void Function(SongLikeEntityBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  SongLikeEntity build() => _build();

  _$SongLikeEntity _build() {
    final _$result = _$v ??
        new _$SongLikeEntity._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'SongLikeEntity', 'id'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'SongLikeEntity', 'userId'),
            songId: BuiltValueNullFieldError.checkNotNull(
                songId, r'SongLikeEntity', 'songId'),
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

  factory _$SongFlagEntity([void Function(SongFlagEntityBuilder) updates]) =>
      (new SongFlagEntityBuilder()..update(updates))._build();

  _$SongFlagEntity._(
      {this.id, this.userId, this.songId, this.deletedAt, this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'SongFlagEntity', 'id');
    BuiltValueNullFieldError.checkNotNull(userId, r'SongFlagEntity', 'userId');
    BuiltValueNullFieldError.checkNotNull(songId, r'SongFlagEntity', 'songId');
  }

  @override
  SongFlagEntity rebuild(void Function(SongFlagEntityBuilder) updates) =>
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
    return (newBuiltValueToStringHelper(r'SongFlagEntity')
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
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _songId = $v.songId;
      _deletedAt = $v.deletedAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SongFlagEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SongFlagEntity;
  }

  @override
  void update(void Function(SongFlagEntityBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  SongFlagEntity build() => _build();

  _$SongFlagEntity _build() {
    final _$result = _$v ??
        new _$SongFlagEntity._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'SongFlagEntity', 'id'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'SongFlagEntity', 'userId'),
            songId: BuiltValueNullFieldError.checkNotNull(
                songId, r'SongFlagEntity', 'songId'),
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

  factory _$ArtistFlagEntity(
          [void Function(ArtistFlagEntityBuilder) updates]) =>
      (new ArtistFlagEntityBuilder()..update(updates))._build();

  _$ArtistFlagEntity._({this.id, this.artistId, this.deletedAt, this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'ArtistFlagEntity', 'id');
    BuiltValueNullFieldError.checkNotNull(
        artistId, r'ArtistFlagEntity', 'artistId');
  }

  @override
  ArtistFlagEntity rebuild(void Function(ArtistFlagEntityBuilder) updates) =>
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
    return (newBuiltValueToStringHelper(r'ArtistFlagEntity')
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
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _artistId = $v.artistId;
      _deletedAt = $v.deletedAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArtistFlagEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ArtistFlagEntity;
  }

  @override
  void update(void Function(ArtistFlagEntityBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  ArtistFlagEntity build() => _build();

  _$ArtistFlagEntity _build() {
    final _$result = _$v ??
        new _$ArtistFlagEntity._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ArtistFlagEntity', 'id'),
            artistId: BuiltValueNullFieldError.checkNotNull(
                artistId, r'ArtistFlagEntity', 'artistId'),
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
  final String recognitions;
  @override
  final String thumbnailUrl;
  @override
  final String remoteVideoId;
  @override
  final BuiltMap<String, double> volumeData;
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

  factory _$VideoEntity([void Function(VideoEntityBuilder) updates]) =>
      (new VideoEntityBuilder()..update(updates))._build();

  _$VideoEntity._(
      {this.userId,
      this.timestamp,
      this.url,
      this.recognitions,
      this.thumbnailUrl,
      this.remoteVideoId,
      this.volumeData,
      this.description,
      this.duration,
      this.deletedAt,
      this.updatedAt,
      this.id})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(userId, r'VideoEntity', 'userId');
  }

  @override
  VideoEntity rebuild(void Function(VideoEntityBuilder) updates) =>
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
        recognitions == other.recognitions &&
        thumbnailUrl == other.thumbnailUrl &&
        remoteVideoId == other.remoteVideoId &&
        volumeData == other.volumeData &&
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
                                    $jc(
                                        $jc(
                                            $jc($jc(0, userId.hashCode),
                                                timestamp.hashCode),
                                            url.hashCode),
                                        recognitions.hashCode),
                                    thumbnailUrl.hashCode),
                                remoteVideoId.hashCode),
                            volumeData.hashCode),
                        description.hashCode),
                    duration.hashCode),
                deletedAt.hashCode),
            updatedAt.hashCode),
        id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VideoEntity')
          ..add('userId', userId)
          ..add('timestamp', timestamp)
          ..add('url', url)
          ..add('recognitions', recognitions)
          ..add('thumbnailUrl', thumbnailUrl)
          ..add('remoteVideoId', remoteVideoId)
          ..add('volumeData', volumeData)
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

  String _recognitions;
  String get recognitions => _$this._recognitions;
  set recognitions(String recognitions) => _$this._recognitions = recognitions;

  String _thumbnailUrl;
  String get thumbnailUrl => _$this._thumbnailUrl;
  set thumbnailUrl(String thumbnailUrl) => _$this._thumbnailUrl = thumbnailUrl;

  String _remoteVideoId;
  String get remoteVideoId => _$this._remoteVideoId;
  set remoteVideoId(String remoteVideoId) =>
      _$this._remoteVideoId = remoteVideoId;

  MapBuilder<String, double> _volumeData;
  MapBuilder<String, double> get volumeData =>
      _$this._volumeData ??= new MapBuilder<String, double>();
  set volumeData(MapBuilder<String, double> volumeData) =>
      _$this._volumeData = volumeData;

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
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _timestamp = $v.timestamp;
      _url = $v.url;
      _recognitions = $v.recognitions;
      _thumbnailUrl = $v.thumbnailUrl;
      _remoteVideoId = $v.remoteVideoId;
      _volumeData = $v.volumeData?.toBuilder();
      _description = $v.description;
      _duration = $v.duration;
      _deletedAt = $v.deletedAt;
      _updatedAt = $v.updatedAt;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VideoEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$VideoEntity;
  }

  @override
  void update(void Function(VideoEntityBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  VideoEntity build() => _build();

  _$VideoEntity _build() {
    _$VideoEntity _$result;
    try {
      _$result = _$v ??
          new _$VideoEntity._(
              userId: BuiltValueNullFieldError.checkNotNull(
                  userId, r'VideoEntity', 'userId'),
              timestamp: timestamp,
              url: url,
              recognitions: recognitions,
              thumbnailUrl: thumbnailUrl,
              remoteVideoId: remoteVideoId,
              volumeData: _volumeData?.build(),
              description: description,
              duration: duration,
              deletedAt: deletedAt,
              updatedAt: updatedAt,
              id: id);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'volumeData';
        _volumeData?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'VideoEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SongListResponse extends SongListResponse {
  @override
  final BuiltList<SongEntity> data;

  factory _$SongListResponse(
          [void Function(SongListResponseBuilder) updates]) =>
      (new SongListResponseBuilder()..update(updates))._build();

  _$SongListResponse._({this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'SongListResponse', 'data');
  }

  @override
  SongListResponse rebuild(void Function(SongListResponseBuilder) updates) =>
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
    return (newBuiltValueToStringHelper(r'SongListResponse')..add('data', data))
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
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SongListResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SongListResponse;
  }

  @override
  void update(void Function(SongListResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  SongListResponse build() => _build();

  _$SongListResponse _build() {
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
            r'SongListResponse', _$failedField, e.toString());
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

  factory _$SongItemResponse(
          [void Function(SongItemResponseBuilder) updates]) =>
      (new SongItemResponseBuilder()..update(updates))._build();

  _$SongItemResponse._({this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'SongItemResponse', 'data');
  }

  @override
  SongItemResponse rebuild(void Function(SongItemResponseBuilder) updates) =>
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
    return (newBuiltValueToStringHelper(r'SongItemResponse')..add('data', data))
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
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SongItemResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SongItemResponse;
  }

  @override
  void update(void Function(SongItemResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  SongItemResponse build() => _build();

  _$SongItemResponse _build() {
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
            r'SongItemResponse', _$failedField, e.toString());
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

  factory _$CommentItemResponse(
          [void Function(CommentItemResponseBuilder) updates]) =>
      (new CommentItemResponseBuilder()..update(updates))._build();

  _$CommentItemResponse._({this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'CommentItemResponse', 'data');
  }

  @override
  CommentItemResponse rebuild(
          void Function(CommentItemResponseBuilder) updates) =>
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
    return (newBuiltValueToStringHelper(r'CommentItemResponse')
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
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommentItemResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CommentItemResponse;
  }

  @override
  void update(void Function(CommentItemResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  CommentItemResponse build() => _build();

  _$CommentItemResponse _build() {
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
            r'CommentItemResponse', _$failedField, e.toString());
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

  factory _$LikeSongResponse(
          [void Function(LikeSongResponseBuilder) updates]) =>
      (new LikeSongResponseBuilder()..update(updates))._build();

  _$LikeSongResponse._({this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'LikeSongResponse', 'data');
  }

  @override
  LikeSongResponse rebuild(void Function(LikeSongResponseBuilder) updates) =>
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
    return (newBuiltValueToStringHelper(r'LikeSongResponse')..add('data', data))
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
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LikeSongResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$LikeSongResponse;
  }

  @override
  void update(void Function(LikeSongResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  LikeSongResponse build() => _build();

  _$LikeSongResponse _build() {
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
            r'LikeSongResponse', _$failedField, e.toString());
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

  factory _$FlagSongResponse(
          [void Function(FlagSongResponseBuilder) updates]) =>
      (new FlagSongResponseBuilder()..update(updates))._build();

  _$FlagSongResponse._({this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'FlagSongResponse', 'data');
  }

  @override
  FlagSongResponse rebuild(void Function(FlagSongResponseBuilder) updates) =>
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
    return (newBuiltValueToStringHelper(r'FlagSongResponse')..add('data', data))
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
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FlagSongResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FlagSongResponse;
  }

  @override
  void update(void Function(FlagSongResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  FlagSongResponse build() => _build();

  _$FlagSongResponse _build() {
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
            r'FlagSongResponse', _$failedField, e.toString());
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

  factory _$VideoItemResponse(
          [void Function(VideoItemResponseBuilder) updates]) =>
      (new VideoItemResponseBuilder()..update(updates))._build();

  _$VideoItemResponse._({this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'VideoItemResponse', 'data');
  }

  @override
  VideoItemResponse rebuild(void Function(VideoItemResponseBuilder) updates) =>
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
    return (newBuiltValueToStringHelper(r'VideoItemResponse')
          ..add('data', data))
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
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VideoItemResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$VideoItemResponse;
  }

  @override
  void update(void Function(VideoItemResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  VideoItemResponse build() => _build();

  _$VideoItemResponse _build() {
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
            r'VideoItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
