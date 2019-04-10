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
  @BuiltValueField(wireName: 'song_likes')
  BuiltList<SongLikeEntity> get songLikes;

  @nullable
  @BuiltValueField(wireName: 'song_flags')
  BuiltList<SongFlagEntity> get songFlags;

  @override
  String get listDisplayName {
    return handle;
  }

  bool ownsSong(SongEntity song) => song.artistId == id;

  SongLikeEntity songLike(int songId) => songLikes
      .firstWhere((songLike) => songLike.songId == songId, orElse: () => null);

  bool likedSong(int songId) => songLike(songId) != null;

  SongFlagEntity songFlag(int songId) => songFlags
      .firstWhere((songFlag) => songFlag.songId == songId, orElse: () => null);

  bool flaggedSong(int songId) => songFlag(songId) != null;

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
