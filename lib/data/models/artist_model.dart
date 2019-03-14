import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/entities.dart';

part 'artist_model.g.dart';

abstract class ArtistEntity extends Object
    with BaseEntity
    implements SelectableEntity, Built<ArtistEntity, ArtistEntityBuilder> {
  factory ArtistEntity({int id}) {
    return _$ArtistEntity._(
      id: id ?? 0,
      firstName: '',
      lastName: '',
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
    );
  }

  ArtistEntity._();

  @nullable
  @BuiltValueField(wireName: 'first_name')
  String get firstName;

  @nullable
  @BuiltValueField(wireName: 'last_name')
  String get lastName;

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
  @BuiltValueField(wireName: 'twitter_url')
  String get twitterURL;

  @nullable
  @BuiltValueField(wireName: 'facebook_url')
  String get facebookURL;

  @nullable
  @BuiltValueField(wireName: 'instagram_url')
  String get instagramURL;

  @nullable
  @BuiltValueField(wireName: 'youTube_url')
  String get youTubeURL;

  @nullable
  @BuiltValueField(wireName: 'twitch_url')
  String get twitchURL;

  @nullable
  @BuiltValueField(wireName: 'soundCloud_url')
  String get soundCloudURL;

  @nullable
  String get website;

  @override
  String get listDisplayName {
    return handle;
  }

  String get fullName => '$firstName $lastName';

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
