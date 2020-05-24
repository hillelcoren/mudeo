import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/entities.dart';
import 'package:mudeo/data/models/song_model.dart';

part 'artist_model.g.dart';

abstract class ArtistEntity extends Object
    with BaseEntity
    implements SelectableEntity, Built<ArtistEntity, ArtistEntityBuilder> {
  factory ArtistEntity({int id}) {
    return _$ArtistEntity._(
      id: id ?? 0,
      name: '',
      handle: '',
      email: '',
      token: '',
      description: '',
      twitterURL: '',
      facebookURL: '',
      youTubeURL: '',
      instagramURL: '',
      soundCloudURL: '',
      twitchURL: '',
      website: '',
      profileImageUrl: '',
      headerImageUrl: '',
      songLikes: BuiltList<SongLikeEntity>(),
      songFlags: BuiltList<SongFlagEntity>(),
      artistFlags: BuiltList<ArtistFlagEntity>(),
      following: BuiltList<ArtistFollowingEntity>(),
    );
  }

  ArtistEntity._();

  @nullable
  @BuiltValueField(wireName: 'name')
  String get name;

  @nullable
  @BuiltValueField(wireName: 'handle')
  String get handle;

  @nullable
  String get email;

  @nullable
  String get token;

  @nullable
  String get description;

  @nullable
  @BuiltValueField(wireName: 'profile_image_url')
  String get profileImageUrl;

  @nullable
  @BuiltValueField(wireName: 'header_image_url')
  String get headerImageUrl;

  @nullable
  @BuiltValueField(wireName: 'twitter_social_url')
  String get twitterURL;

  @nullable
  @BuiltValueField(wireName: 'facebook_social_url')
  String get facebookURL;

  @nullable
  @BuiltValueField(wireName: 'instagram_social_url')
  String get instagramURL;

  @nullable
  @BuiltValueField(wireName: 'youtube_social_url')
  String get youTubeURL;

  @nullable
  @BuiltValueField(wireName: 'twitch_social_url')
  String get twitchURL;

  @nullable
  @BuiltValueField(wireName: 'soundcloud_social_url')
  String get soundCloudURL;

  @nullable
  @BuiltValueField(wireName: 'website_social_url')
  String get website;

  @nullable
  @BuiltValueField(wireName: 'order_id')
  String get orderId;

  @nullable
  @BuiltValueField(wireName: 'order_expires')
  String get orderExpires;

  @nullable
  @BuiltValueField(wireName: 'is_paid')
  bool get isPaid;

  @nullable
  @BuiltValueField(wireName: 'song_likes')
  BuiltList<SongLikeEntity> get songLikes;

  @nullable
  @BuiltValueField(wireName: 'song_flags')
  BuiltList<SongFlagEntity> get songFlags;

  @nullable
  @BuiltValueField(wireName: 'user_flags')
  BuiltList<ArtistFlagEntity> get artistFlags;

  @nullable
  @BuiltValueField(wireName: 'following')
  BuiltList<ArtistFollowingEntity> get following;

  @override
  String get listDisplayName {
    return handle;
  }

  String get displayName =>
      name != null && name.trim().isNotEmpty ? name : handle;

  bool get isNameSet => (name ?? '').trim().isNotEmpty;

  bool ownsSong(SongEntity song) =>
      song.artistId == id ||
      (song.joinedArtists != null &&
          song.joinedArtists.any((artist) => artist.id == id));

  bool get isAdmin => id == 1 || id == 2;

  SongLikeEntity getSongLike(int songId) => songLikes == null
      ? null
      : songLikes.firstWhere((songLike) => songLike.songId == songId,
          orElse: () => null);

  bool likedSong(int songId) => getSongLike(songId) != null;

  SongFlagEntity getSongFlag(int songId) => songFlags == null
      ? null
      : songFlags.firstWhere((songFlag) => songFlag.songId == songId,
          orElse: () => null);

  bool flaggedSong(int songId) => getSongFlag(songId) != null;

  ArtistFlagEntity getArtistFlag(int artistId) => artistFlags == null
      ? null
      : artistFlags.firstWhere((artistFlag) => artistFlag.artistId == artistId,
          orElse: () => null);

  bool flaggedArtist(int artistId) => getArtistFlag(artistId) != null;

  ArtistFollowingEntity getFollowing(int artistId) => following == null
      ? null
      : following.firstWhere(
          (artistFollowing) => artistFollowing.artistFollowingId == artistId,
          orElse: () => null);

  bool isFollowing(int artistId) => getFollowing(artistId) != null;

  bool get hasPrivateStorage {
    if ((orderExpires ?? '').isEmpty) {
      return false;
    }

    final dateExpires = DateTime.tryParse(orderExpires);

    if (dateExpires == null) {
      return false;
    }

    return dateExpires.isAfter(DateTime.now());
  }

  Map<String, String> get socialLinks {
    final data = Map<String, String>();
    if (twitterURL != null && twitterURL.isNotEmpty) {
      data[kLinkTypeTwitter] = twitterURL;
    }
    if (facebookURL != null && facebookURL.isNotEmpty) {
      data[kLinkTypeFacebook] = facebookURL;
    }
    if (youTubeURL != null && youTubeURL.isNotEmpty) {
      data[kLinkTypeYouTube] = youTubeURL;
    }
    if (instagramURL != null && instagramURL.isNotEmpty) {
      data[kLinkTypeInstagram] = instagramURL;
    }
    if (soundCloudURL != null && soundCloudURL.isNotEmpty) {
      data[kLinkTypeSoundcloud] = soundCloudURL;
    }
    if (twitchURL != null && twitchURL.isNotEmpty) {
      data[kLinkTypeTwitch] = twitchURL;
    }

    return data;
  }

  static Serializer<ArtistEntity> get serializer => _$artistEntitySerializer;
}

abstract class ArtistItemResponse
    implements Built<ArtistItemResponse, ArtistItemResponseBuilder> {
  factory ArtistItemResponse([void updates(ArtistItemResponseBuilder b)]) =
      _$ArtistItemResponse;

  ArtistItemResponse._();

  ArtistEntity get data;

  static Serializer<ArtistItemResponse> get serializer =>
      _$artistItemResponseSerializer;
}

abstract class ArtistFollowingEntity extends Object
    with BaseEntity
    implements Built<ArtistFollowingEntity, ArtistFollowingEntityBuilder> {
  factory ArtistFollowingEntity() {
    return _$ArtistFollowingEntity._(artistId: 0, artistFollowingId: 0);
  }

  ArtistFollowingEntity._();

  @BuiltValueField(wireName: 'user_id')
  int get artistId;

  @BuiltValueField(wireName: 'user_following_id')
  int get artistFollowingId;

  @override
  String get listDisplayName {
    return 'Following: $artistFollowingId';
  }

  static Serializer<ArtistFollowingEntity> get serializer =>
      _$artistFollowingEntitySerializer;
}

abstract class ArtistFollowingItemResponse
    implements
        Built<ArtistFollowingItemResponse, ArtistFollowingItemResponseBuilder> {
  factory ArtistFollowingItemResponse(
          [void updates(ArtistFollowingItemResponseBuilder b)]) =
      _$ArtistFollowingItemResponse;

  ArtistFollowingItemResponse._();

  ArtistFollowingEntity get data;

  static Serializer<ArtistFollowingItemResponse> get serializer =>
      _$artistFollowingItemResponseSerializer;
}
