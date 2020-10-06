import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const String kAppVersion = '0.0.49+49';
const String kDeveloperURL = 'https://twitter.com/hillelcoren';
const String kGitHubURL = 'https://github.com/hillelcoren/mudeo';

const String kMudeoURL = 'https://mudeo.app';
const String kMudeoTwitterURL = 'https://twitter.com/mudeo_app';
const String kMudeoYouTubeURL =
    'https://www.youtube.com/channel/UCX5ONbOAOG3bYe3vTXrWgPA';
const String kMudeoContactEmail = 'contact@mudeo.app';
const String kMudeoAppleStoreUrl =
    'https://itunes.apple.com/us/app/mudeo/id1459106474?mt=8';
const String kMudeoGoogleStoreUrl = 'https://play.google.com/store/apps/details?id=app.mudeo.mudeo';
const String kMudeoGoogleStoreMarketUrl = 'market://details?id=app.mudeo.mudeo';

const String kDanceURL = 'https://dancelikeme.app';
const String kDanceTwitterURL = 'https://twitter.com/dancelikeme_app';
const String kDanceYouTubeURL = 'https://www.youtube.com/channel/';
const String kDanceContactEmail = 'contact@dancelikeme.app';
const String kDanceGoogleStoreUrl = 'https://play.google.com/store/apps/details?id=app.mudeo.dancelikeme';
const String kDanceAppleStoreUrl = 'https://testflight.apple.com/join/JiwFfnH7';

const int kDesktopBreakpoint = 700;
const int kCountCachedPages = 2;
const int kOAuthProviderGoogle = 1;

const String kProductPrivateStorage = 'month_private_storage';

const String kSongFilterFeatured = 'featured';
const String kSongFilterNewest = 'newest';

const String kSharedPrefToken = 'token';
const String kSharedPrefAppVersion = 'app_version';
const String kSharedPrefCameraDirection = 'camera_direction';
const String kSharedPrefGenreId = 'genre_id';
const String kSharedPrefHeadphoneWarning = 'headphone_warning';
const String kSharedPrefShownVideo = 'shown_video';
const String kSharedPrefFullScreen = 'full_screen';
const String kSharedPrefCalibrated = 'calibrated';

const String kCameraDirectionFront = 'front';
const String kCameraDirectionBack = 'back';
const String kCameraDirectionExternal = 'external';

const String kArtistImageHeader = 'header_image';
const String kArtistImageProfile = 'profile_image';

const String kVideoRelationshipParent = 'original';
const String kVideoRelationshipSelf = 'self';
const String kVideoRelationshipChild = 'clone';

const String kVideoLayoutRow = 'row';
const String kVideoLayoutColumn = 'column';
const String kVideoLayoutGrid = 'grid';

const double kDefaultElevation = 6;
const int kDefaultTrackVolume = 100;
const int kUpdatedAtBufferSeconds = 600;
const int kMillisecondsToRefreshData = 1000 * 60 * 15; // 15 minutes
const int kMillisecondsToRetryData = 1000 * 15; // 10 seconds
const int kMaxRecordsPerApiPage = 100;
const int kMaxTracks = 5;
const int kMaxSongDuration = 3 * 60 * 1000; // 3 minutes
const int kFirstWarningOffset = 10 * 1000; // 10 seconds
const int kSecondWarningOffset = 5 * 1000; // 5 seconds
const int kMinLatencyDelay = -1000;
const int kMaxLatencyDelay = 1000;
const int kMaxCommentLength = 300;
const int kRecognitionFrameSpeed = 500;

const double kSongHeight = 380;
const double kSongHeightWithComments = 560;

const List<String> kLanguages = [
  'en',
];

const String kLinkTypeFacebook = 'Facebook';
const String kLinkTypeYouTube = 'YouTube';
const String kLinkTypeInstagram = 'Instagram';
const String kLinkTypeSoundcloud = 'SoundCloud';
const String kLinkTypeTwitch = 'Twitch';
const String kLinkTypeTwitter = 'Twitter';
const String kLinkTypeWebsite = 'Website';
const String kLinkTypeReddit = 'Reddit';
const String kLinkTypeGitHub = 'GitHub';

const int kRecognitionPartNose = 0;
const int kRecognitionPartLeftEye = 1;
const int kRecognitionPartRightEye = 2;
const int kRecognitionPartLeftEar = 3;
const int kRecognitionPartRightEar = 4;
const int kRecognitionPartLeftShoulder = 5;
const int kRecognitionPartRightShoulder = 6;
const int kRecognitionPartLeftElbow = 7;
const int kRecognitionPartRightElbow = 8;
const int kRecognitionPartLeftWrist = 9;
const int kRecognitionPartRightWrist = 10;
const int kRecognitionPartLeftHip = 11;
const int kRecognitionPartRightHip = 12;
const int kRecognitionPartLeftKnee = 13;
const int kRecognitionPartRightKnee = 14;
const int kRecognitionPartLeftAnkle = 15;
const int kRecognitionPartRightAnkle = 16;

const List<int> kRecognitionParts = [
  kRecognitionPartNose,
  kRecognitionPartLeftEye,
  kRecognitionPartRightEye,
  kRecognitionPartLeftEar,
  kRecognitionPartRightEar,
  kRecognitionPartLeftShoulder,
  kRecognitionPartRightShoulder,
  kRecognitionPartLeftElbow,
  kRecognitionPartRightElbow,
  kRecognitionPartLeftWrist,
  kRecognitionPartRightWrist,
  kRecognitionPartLeftHip,
  kRecognitionPartRightHip,
  kRecognitionPartLeftKnee,
  kRecognitionPartRightKnee,
  kRecognitionPartLeftAnkle,
  kRecognitionPartRightAnkle,
];

const String kGenreAfrican = 'african';
const String kGenreArabic = 'arabic';
const String kGenreAsian = 'asian';
const String kGenreAvantGarde = 'avant_garde';
const String kGenreBlues = 'blues';
const String kGenreCaribbean = 'caribbean';
const String kGenreClassicalMusic = 'classical_music';
const String kGenreComedy = 'comedy';
const String kGenreCountry = 'country';
const String kGenreEasyListening = 'easy_listening';
const String kGenreElectronic = 'electronic';
const String kGenreFolk = 'folk';
const String kGenreHipHop = 'hip_hop';
const String kGenreJazz = 'jazz';
const String kGenreLatin = 'latin';
const String kGenrePop = 'pop';
const String kGenreRBAndSoul = 'rb_and_soul';
const String kGenreRock = 'rock';
const String kGenreOther = 'other';

const Map<int, String> kGenres = {
  1: kGenreAfrican,
  2: kGenreArabic,
  3: kGenreAsian,
  4: kGenreAvantGarde,
  5: kGenreBlues,
  6: kGenreCaribbean,
  7: kGenreClassicalMusic,
  8: kGenreComedy,
  9: kGenreCountry,
  10: kGenreEasyListening,
  11: kGenreElectronic,
  12: kGenreFolk,
  13: kGenreHipHop,
  14: kGenreJazz,
  15: kGenreLatin,
  16: kGenrePop,
  17: kGenreRBAndSoul,
  18: kGenreRock,
  19: kGenreOther,
};

const String kStyleBallet = 'ballet';
const String kStyleTap = 'tap';
const String kStyleJazz = 'jazz';
const String kStyleModern = 'modern';
const String kStyleLyrical = 'lyrical';
const String kStyleHipHop = 'hipHop';
const String kStyleContemporary = 'contemporary';
const String kStyleOther = 'other';

const Map<int, String> kStyles = {
  1: kStyleBallet,
  2: kStyleContemporary,
  3: kStyleHipHop,
  4: kStyleJazz,
  5: kStyleLyrical,
  6: kStyleModern,
  7: kStyleTap,
  8: kStyleOther,
};

const Map<int, MaterialAccentColor> kGenreColors = {
  1: Colors.redAccent,
  2: Colors.blueAccent,
  3: Colors.amberAccent,
  4: Colors.cyanAccent,
  5: Colors.blueAccent,
  6: Colors.deepPurpleAccent,
  7: Colors.greenAccent,
  8: Colors.indigoAccent,
  9: Colors.lightBlueAccent,
  10: Colors.lightGreenAccent,
  11: Colors.limeAccent,
  12: Colors.orangeAccent,
  13: Colors.yellowAccent,
  14: Colors.tealAccent,
  15: Colors.pinkAccent,
  16: Colors.tealAccent,
  17: Colors.deepPurpleAccent,
  18: Colors.lightBlueAccent,
  19: Colors.tealAccent,
};

const Map<String, IconData> socialIcons = {
  kLinkTypeFacebook: FontAwesomeIcons.facebook,
  kLinkTypeYouTube: FontAwesomeIcons.youtube,
  kLinkTypeInstagram: FontAwesomeIcons.instagram,
  kLinkTypeTwitch: FontAwesomeIcons.twitch,
  kLinkTypeTwitter: FontAwesomeIcons.twitter,
  kLinkTypeSoundcloud: FontAwesomeIcons.soundcloud,
  kLinkTypeWebsite: FontAwesomeIcons.globe,
};
