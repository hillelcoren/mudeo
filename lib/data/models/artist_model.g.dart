// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_model.dart';

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

Serializer<ArtistEntity> _$artistEntitySerializer =
    new _$ArtistEntitySerializer();
Serializer<ArtistItemResponse> _$artistItemResponseSerializer =
    new _$ArtistItemResponseSerializer();
Serializer<ArtistFollowingEntity> _$artistFollowingEntitySerializer =
    new _$ArtistFollowingEntitySerializer();
Serializer<ArtistFollowingItemResponse>
    _$artistFollowingItemResponseSerializer =
    new _$ArtistFollowingItemResponseSerializer();

class _$ArtistEntitySerializer implements StructuredSerializer<ArtistEntity> {
  @override
  final Iterable<Type> types = const [ArtistEntity, _$ArtistEntity];
  @override
  final String wireName = 'ArtistEntity';

  @override
  Iterable serialize(Serializers serializers, ArtistEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.handle != null) {
      result
        ..add('handle')
        ..add(serializers.serialize(object.handle,
            specifiedType: const FullType(String)));
    }
    if (object.email != null) {
      result
        ..add('email')
        ..add(serializers.serialize(object.email,
            specifiedType: const FullType(String)));
    }
    if (object.token != null) {
      result
        ..add('token')
        ..add(serializers.serialize(object.token,
            specifiedType: const FullType(String)));
    }
    if (object.description != null) {
      result
        ..add('description')
        ..add(serializers.serialize(object.description,
            specifiedType: const FullType(String)));
    }
    if (object.profileImageUrl != null) {
      result
        ..add('profile_image_url')
        ..add(serializers.serialize(object.profileImageUrl,
            specifiedType: const FullType(String)));
    }
    if (object.headerImageUrl != null) {
      result
        ..add('header_image_url')
        ..add(serializers.serialize(object.headerImageUrl,
            specifiedType: const FullType(String)));
    }
    if (object.twitterURL != null) {
      result
        ..add('twitter_social_url')
        ..add(serializers.serialize(object.twitterURL,
            specifiedType: const FullType(String)));
    }
    if (object.facebookURL != null) {
      result
        ..add('facebook_social_url')
        ..add(serializers.serialize(object.facebookURL,
            specifiedType: const FullType(String)));
    }
    if (object.instagramURL != null) {
      result
        ..add('instagram_social_url')
        ..add(serializers.serialize(object.instagramURL,
            specifiedType: const FullType(String)));
    }
    if (object.youTubeURL != null) {
      result
        ..add('youtube_social_url')
        ..add(serializers.serialize(object.youTubeURL,
            specifiedType: const FullType(String)));
    }
    if (object.twitchURL != null) {
      result
        ..add('twitch_social_url')
        ..add(serializers.serialize(object.twitchURL,
            specifiedType: const FullType(String)));
    }
    if (object.soundCloudURL != null) {
      result
        ..add('soundcloud_social_url')
        ..add(serializers.serialize(object.soundCloudURL,
            specifiedType: const FullType(String)));
    }
    if (object.website != null) {
      result
        ..add('website_social_url')
        ..add(serializers.serialize(object.website,
            specifiedType: const FullType(String)));
    }
    if (object.songLikes != null) {
      result
        ..add('song_likes')
        ..add(serializers.serialize(object.songLikes,
            specifiedType: const FullType(
                BuiltList, const [const FullType(SongLikeEntity)])));
    }
    if (object.songFlags != null) {
      result
        ..add('song_flags')
        ..add(serializers.serialize(object.songFlags,
            specifiedType: const FullType(
                BuiltList, const [const FullType(SongFlagEntity)])));
    }
    if (object.artistFlags != null) {
      result
        ..add('user_flags')
        ..add(serializers.serialize(object.artistFlags,
            specifiedType: const FullType(
                BuiltList, const [const FullType(ArtistFlagEntity)])));
    }
    if (object.following != null) {
      result
        ..add('following')
        ..add(serializers.serialize(object.following,
            specifiedType: const FullType(
                BuiltList, const [const FullType(ArtistFollowingEntity)])));
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
  ArtistEntity deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ArtistEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'handle':
          result.handle = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'token':
          result.token = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'profile_image_url':
          result.profileImageUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'header_image_url':
          result.headerImageUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'twitter_social_url':
          result.twitterURL = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'facebook_social_url':
          result.facebookURL = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'instagram_social_url':
          result.instagramURL = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'youtube_social_url':
          result.youTubeURL = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'twitch_social_url':
          result.twitchURL = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'soundcloud_social_url':
          result.soundCloudURL = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'website_social_url':
          result.website = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'song_likes':
          result.songLikes.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(SongLikeEntity)]))
              as BuiltList);
          break;
        case 'song_flags':
          result.songFlags.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(SongFlagEntity)]))
              as BuiltList);
          break;
        case 'user_flags':
          result.artistFlags.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ArtistFlagEntity)]))
              as BuiltList);
          break;
        case 'following':
          result.following.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ArtistFollowingEntity)]))
              as BuiltList);
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

class _$ArtistItemResponseSerializer
    implements StructuredSerializer<ArtistItemResponse> {
  @override
  final Iterable<Type> types = const [ArtistItemResponse, _$ArtistItemResponse];
  @override
  final String wireName = 'ArtistItemResponse';

  @override
  Iterable serialize(Serializers serializers, ArtistItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(ArtistEntity)),
    ];

    return result;
  }

  @override
  ArtistItemResponse deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ArtistItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(ArtistEntity)) as ArtistEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$ArtistFollowingEntitySerializer
    implements StructuredSerializer<ArtistFollowingEntity> {
  @override
  final Iterable<Type> types = const [
    ArtistFollowingEntity,
    _$ArtistFollowingEntity
  ];
  @override
  final String wireName = 'ArtistFollowingEntity';

  @override
  Iterable serialize(Serializers serializers, ArtistFollowingEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'user_id',
      serializers.serialize(object.artistId,
          specifiedType: const FullType(int)),
      'user_following_id',
      serializers.serialize(object.artistFollowingId,
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
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(int)));
    }

    return result;
  }

  @override
  ArtistFollowingEntity deserialize(
      Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ArtistFollowingEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'user_id':
          result.artistId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'user_following_id':
          result.artistFollowingId = serializers.deserialize(value,
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

class _$ArtistFollowingItemResponseSerializer
    implements StructuredSerializer<ArtistFollowingItemResponse> {
  @override
  final Iterable<Type> types = const [
    ArtistFollowingItemResponse,
    _$ArtistFollowingItemResponse
  ];
  @override
  final String wireName = 'ArtistFollowingItemResponse';

  @override
  Iterable serialize(
      Serializers serializers, ArtistFollowingItemResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(ArtistFollowingEntity)),
    ];

    return result;
  }

  @override
  ArtistFollowingItemResponse deserialize(
      Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ArtistFollowingItemResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ArtistFollowingEntity))
              as ArtistFollowingEntity);
          break;
      }
    }

    return result.build();
  }
}

class _$ArtistEntity extends ArtistEntity {
  @override
  final String name;
  @override
  final String handle;
  @override
  final String email;
  @override
  final String token;
  @override
  final String description;
  @override
  final String profileImageUrl;
  @override
  final String headerImageUrl;
  @override
  final String twitterURL;
  @override
  final String facebookURL;
  @override
  final String instagramURL;
  @override
  final String youTubeURL;
  @override
  final String twitchURL;
  @override
  final String soundCloudURL;
  @override
  final String website;
  @override
  final BuiltList<SongLikeEntity> songLikes;
  @override
  final BuiltList<SongFlagEntity> songFlags;
  @override
  final BuiltList<ArtistFlagEntity> artistFlags;
  @override
  final BuiltList<ArtistFollowingEntity> following;
  @override
  final int id;
  @override
  final String deletedAt;
  @override
  final String updatedAt;

  factory _$ArtistEntity([void updates(ArtistEntityBuilder b)]) =>
      (new ArtistEntityBuilder()..update(updates)).build();

  _$ArtistEntity._(
      {this.name,
      this.handle,
      this.email,
      this.token,
      this.description,
      this.profileImageUrl,
      this.headerImageUrl,
      this.twitterURL,
      this.facebookURL,
      this.instagramURL,
      this.youTubeURL,
      this.twitchURL,
      this.soundCloudURL,
      this.website,
      this.songLikes,
      this.songFlags,
      this.artistFlags,
      this.following,
      this.id,
      this.deletedAt,
      this.updatedAt})
      : super._();

  @override
  ArtistEntity rebuild(void updates(ArtistEntityBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ArtistEntityBuilder toBuilder() => new ArtistEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArtistEntity &&
        name == other.name &&
        handle == other.handle &&
        email == other.email &&
        token == other.token &&
        description == other.description &&
        profileImageUrl == other.profileImageUrl &&
        headerImageUrl == other.headerImageUrl &&
        twitterURL == other.twitterURL &&
        facebookURL == other.facebookURL &&
        instagramURL == other.instagramURL &&
        youTubeURL == other.youTubeURL &&
        twitchURL == other.twitchURL &&
        soundCloudURL == other.soundCloudURL &&
        website == other.website &&
        songLikes == other.songLikes &&
        songFlags == other.songFlags &&
        artistFlags == other.artistFlags &&
        following == other.following &&
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
                                                                            $jc($jc($jc(0, name.hashCode), handle.hashCode),
                                                                                email.hashCode),
                                                                            token.hashCode),
                                                                        description.hashCode),
                                                                    profileImageUrl.hashCode),
                                                                headerImageUrl.hashCode),
                                                            twitterURL.hashCode),
                                                        facebookURL.hashCode),
                                                    instagramURL.hashCode),
                                                youTubeURL.hashCode),
                                            twitchURL.hashCode),
                                        soundCloudURL.hashCode),
                                    website.hashCode),
                                songLikes.hashCode),
                            songFlags.hashCode),
                        artistFlags.hashCode),
                    following.hashCode),
                id.hashCode),
            deletedAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ArtistEntity')
          ..add('name', name)
          ..add('handle', handle)
          ..add('email', email)
          ..add('token', token)
          ..add('description', description)
          ..add('profileImageUrl', profileImageUrl)
          ..add('headerImageUrl', headerImageUrl)
          ..add('twitterURL', twitterURL)
          ..add('facebookURL', facebookURL)
          ..add('instagramURL', instagramURL)
          ..add('youTubeURL', youTubeURL)
          ..add('twitchURL', twitchURL)
          ..add('soundCloudURL', soundCloudURL)
          ..add('website', website)
          ..add('songLikes', songLikes)
          ..add('songFlags', songFlags)
          ..add('artistFlags', artistFlags)
          ..add('following', following)
          ..add('id', id)
          ..add('deletedAt', deletedAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ArtistEntityBuilder
    implements Builder<ArtistEntity, ArtistEntityBuilder> {
  _$ArtistEntity _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _handle;
  String get handle => _$this._handle;
  set handle(String handle) => _$this._handle = handle;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _token;
  String get token => _$this._token;
  set token(String token) => _$this._token = token;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _profileImageUrl;
  String get profileImageUrl => _$this._profileImageUrl;
  set profileImageUrl(String profileImageUrl) =>
      _$this._profileImageUrl = profileImageUrl;

  String _headerImageUrl;
  String get headerImageUrl => _$this._headerImageUrl;
  set headerImageUrl(String headerImageUrl) =>
      _$this._headerImageUrl = headerImageUrl;

  String _twitterURL;
  String get twitterURL => _$this._twitterURL;
  set twitterURL(String twitterURL) => _$this._twitterURL = twitterURL;

  String _facebookURL;
  String get facebookURL => _$this._facebookURL;
  set facebookURL(String facebookURL) => _$this._facebookURL = facebookURL;

  String _instagramURL;
  String get instagramURL => _$this._instagramURL;
  set instagramURL(String instagramURL) => _$this._instagramURL = instagramURL;

  String _youTubeURL;
  String get youTubeURL => _$this._youTubeURL;
  set youTubeURL(String youTubeURL) => _$this._youTubeURL = youTubeURL;

  String _twitchURL;
  String get twitchURL => _$this._twitchURL;
  set twitchURL(String twitchURL) => _$this._twitchURL = twitchURL;

  String _soundCloudURL;
  String get soundCloudURL => _$this._soundCloudURL;
  set soundCloudURL(String soundCloudURL) =>
      _$this._soundCloudURL = soundCloudURL;

  String _website;
  String get website => _$this._website;
  set website(String website) => _$this._website = website;

  ListBuilder<SongLikeEntity> _songLikes;
  ListBuilder<SongLikeEntity> get songLikes =>
      _$this._songLikes ??= new ListBuilder<SongLikeEntity>();
  set songLikes(ListBuilder<SongLikeEntity> songLikes) =>
      _$this._songLikes = songLikes;

  ListBuilder<SongFlagEntity> _songFlags;
  ListBuilder<SongFlagEntity> get songFlags =>
      _$this._songFlags ??= new ListBuilder<SongFlagEntity>();
  set songFlags(ListBuilder<SongFlagEntity> songFlags) =>
      _$this._songFlags = songFlags;

  ListBuilder<ArtistFlagEntity> _artistFlags;
  ListBuilder<ArtistFlagEntity> get artistFlags =>
      _$this._artistFlags ??= new ListBuilder<ArtistFlagEntity>();
  set artistFlags(ListBuilder<ArtistFlagEntity> artistFlags) =>
      _$this._artistFlags = artistFlags;

  ListBuilder<ArtistFollowingEntity> _following;
  ListBuilder<ArtistFollowingEntity> get following =>
      _$this._following ??= new ListBuilder<ArtistFollowingEntity>();
  set following(ListBuilder<ArtistFollowingEntity> following) =>
      _$this._following = following;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _deletedAt;
  String get deletedAt => _$this._deletedAt;
  set deletedAt(String deletedAt) => _$this._deletedAt = deletedAt;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  ArtistEntityBuilder();

  ArtistEntityBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _handle = _$v.handle;
      _email = _$v.email;
      _token = _$v.token;
      _description = _$v.description;
      _profileImageUrl = _$v.profileImageUrl;
      _headerImageUrl = _$v.headerImageUrl;
      _twitterURL = _$v.twitterURL;
      _facebookURL = _$v.facebookURL;
      _instagramURL = _$v.instagramURL;
      _youTubeURL = _$v.youTubeURL;
      _twitchURL = _$v.twitchURL;
      _soundCloudURL = _$v.soundCloudURL;
      _website = _$v.website;
      _songLikes = _$v.songLikes?.toBuilder();
      _songFlags = _$v.songFlags?.toBuilder();
      _artistFlags = _$v.artistFlags?.toBuilder();
      _following = _$v.following?.toBuilder();
      _id = _$v.id;
      _deletedAt = _$v.deletedAt;
      _updatedAt = _$v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArtistEntity other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ArtistEntity;
  }

  @override
  void update(void updates(ArtistEntityBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$ArtistEntity build() {
    _$ArtistEntity _$result;
    try {
      _$result = _$v ??
          new _$ArtistEntity._(
              name: name,
              handle: handle,
              email: email,
              token: token,
              description: description,
              profileImageUrl: profileImageUrl,
              headerImageUrl: headerImageUrl,
              twitterURL: twitterURL,
              facebookURL: facebookURL,
              instagramURL: instagramURL,
              youTubeURL: youTubeURL,
              twitchURL: twitchURL,
              soundCloudURL: soundCloudURL,
              website: website,
              songLikes: _songLikes?.build(),
              songFlags: _songFlags?.build(),
              artistFlags: _artistFlags?.build(),
              following: _following?.build(),
              id: id,
              deletedAt: deletedAt,
              updatedAt: updatedAt);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'songLikes';
        _songLikes?.build();
        _$failedField = 'songFlags';
        _songFlags?.build();
        _$failedField = 'artistFlags';
        _artistFlags?.build();
        _$failedField = 'following';
        _following?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ArtistEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ArtistItemResponse extends ArtistItemResponse {
  @override
  final ArtistEntity data;

  factory _$ArtistItemResponse([void updates(ArtistItemResponseBuilder b)]) =>
      (new ArtistItemResponseBuilder()..update(updates)).build();

  _$ArtistItemResponse._({this.data}) : super._() {
    if (data == null) {
      throw new BuiltValueNullFieldError('ArtistItemResponse', 'data');
    }
  }

  @override
  ArtistItemResponse rebuild(void updates(ArtistItemResponseBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ArtistItemResponseBuilder toBuilder() =>
      new ArtistItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArtistItemResponse && data == other.data;
  }

  @override
  int get hashCode {
    return $jf($jc(0, data.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ArtistItemResponse')
          ..add('data', data))
        .toString();
  }
}

class ArtistItemResponseBuilder
    implements Builder<ArtistItemResponse, ArtistItemResponseBuilder> {
  _$ArtistItemResponse _$v;

  ArtistEntityBuilder _data;
  ArtistEntityBuilder get data => _$this._data ??= new ArtistEntityBuilder();
  set data(ArtistEntityBuilder data) => _$this._data = data;

  ArtistItemResponseBuilder();

  ArtistItemResponseBuilder get _$this {
    if (_$v != null) {
      _data = _$v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArtistItemResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ArtistItemResponse;
  }

  @override
  void update(void updates(ArtistItemResponseBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$ArtistItemResponse build() {
    _$ArtistItemResponse _$result;
    try {
      _$result = _$v ?? new _$ArtistItemResponse._(data: data.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ArtistItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ArtistFollowingEntity extends ArtistFollowingEntity {
  @override
  final int artistId;
  @override
  final int artistFollowingId;
  @override
  final String deletedAt;
  @override
  final String updatedAt;
  @override
  final int id;

  factory _$ArtistFollowingEntity(
          [void updates(ArtistFollowingEntityBuilder b)]) =>
      (new ArtistFollowingEntityBuilder()..update(updates)).build();

  _$ArtistFollowingEntity._(
      {this.artistId,
      this.artistFollowingId,
      this.deletedAt,
      this.updatedAt,
      this.id})
      : super._() {
    if (artistId == null) {
      throw new BuiltValueNullFieldError('ArtistFollowingEntity', 'artistId');
    }
    if (artistFollowingId == null) {
      throw new BuiltValueNullFieldError(
          'ArtistFollowingEntity', 'artistFollowingId');
    }
  }

  @override
  ArtistFollowingEntity rebuild(void updates(ArtistFollowingEntityBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ArtistFollowingEntityBuilder toBuilder() =>
      new ArtistFollowingEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArtistFollowingEntity &&
        artistId == other.artistId &&
        artistFollowingId == other.artistFollowingId &&
        deletedAt == other.deletedAt &&
        updatedAt == other.updatedAt &&
        id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, artistId.hashCode), artistFollowingId.hashCode),
                deletedAt.hashCode),
            updatedAt.hashCode),
        id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ArtistFollowingEntity')
          ..add('artistId', artistId)
          ..add('artistFollowingId', artistFollowingId)
          ..add('deletedAt', deletedAt)
          ..add('updatedAt', updatedAt)
          ..add('id', id))
        .toString();
  }
}

class ArtistFollowingEntityBuilder
    implements Builder<ArtistFollowingEntity, ArtistFollowingEntityBuilder> {
  _$ArtistFollowingEntity _$v;

  int _artistId;
  int get artistId => _$this._artistId;
  set artistId(int artistId) => _$this._artistId = artistId;

  int _artistFollowingId;
  int get artistFollowingId => _$this._artistFollowingId;
  set artistFollowingId(int artistFollowingId) =>
      _$this._artistFollowingId = artistFollowingId;

  String _deletedAt;
  String get deletedAt => _$this._deletedAt;
  set deletedAt(String deletedAt) => _$this._deletedAt = deletedAt;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  ArtistFollowingEntityBuilder();

  ArtistFollowingEntityBuilder get _$this {
    if (_$v != null) {
      _artistId = _$v.artistId;
      _artistFollowingId = _$v.artistFollowingId;
      _deletedAt = _$v.deletedAt;
      _updatedAt = _$v.updatedAt;
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArtistFollowingEntity other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ArtistFollowingEntity;
  }

  @override
  void update(void updates(ArtistFollowingEntityBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$ArtistFollowingEntity build() {
    final _$result = _$v ??
        new _$ArtistFollowingEntity._(
            artistId: artistId,
            artistFollowingId: artistFollowingId,
            deletedAt: deletedAt,
            updatedAt: updatedAt,
            id: id);
    replace(_$result);
    return _$result;
  }
}

class _$ArtistFollowingItemResponse extends ArtistFollowingItemResponse {
  @override
  final ArtistFollowingEntity data;

  factory _$ArtistFollowingItemResponse(
          [void updates(ArtistFollowingItemResponseBuilder b)]) =>
      (new ArtistFollowingItemResponseBuilder()..update(updates)).build();

  _$ArtistFollowingItemResponse._({this.data}) : super._() {
    if (data == null) {
      throw new BuiltValueNullFieldError('ArtistFollowingItemResponse', 'data');
    }
  }

  @override
  ArtistFollowingItemResponse rebuild(
          void updates(ArtistFollowingItemResponseBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ArtistFollowingItemResponseBuilder toBuilder() =>
      new ArtistFollowingItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArtistFollowingItemResponse && data == other.data;
  }

  @override
  int get hashCode {
    return $jf($jc(0, data.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ArtistFollowingItemResponse')
          ..add('data', data))
        .toString();
  }
}

class ArtistFollowingItemResponseBuilder
    implements
        Builder<ArtistFollowingItemResponse,
            ArtistFollowingItemResponseBuilder> {
  _$ArtistFollowingItemResponse _$v;

  ArtistFollowingEntityBuilder _data;
  ArtistFollowingEntityBuilder get data =>
      _$this._data ??= new ArtistFollowingEntityBuilder();
  set data(ArtistFollowingEntityBuilder data) => _$this._data = data;

  ArtistFollowingItemResponseBuilder();

  ArtistFollowingItemResponseBuilder get _$this {
    if (_$v != null) {
      _data = _$v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArtistFollowingItemResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ArtistFollowingItemResponse;
  }

  @override
  void update(void updates(ArtistFollowingItemResponseBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$ArtistFollowingItemResponse build() {
    _$ArtistFollowingItemResponse _$result;
    try {
      _$result = _$v ?? new _$ArtistFollowingItemResponse._(data: data.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ArtistFollowingItemResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}
